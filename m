Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab1GMSZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 14:25:10 -0400
Received: from lo.gmane.org ([80.91.229.12]:34764 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab1GMSZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 14:25:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alex Neronskiy <zakmagnus@google.com>
Subject: Re: [PATCH] Track hard and soft "short lockups" or "stalls."
Date: Wed, 13 Jul 2011 18:18:24 +0000 (UTC)
Message-ID: <loom.20110713T194432-269@post.gmane.org>
References: <1310510811-12564-1-git-send-email-zakmagnus@google.com> <20110713134336.GK2938@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 216.239.45.4 (Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.41 Safari/535.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Zickus <dzickus <at> redhat.com> writes:


> I understand what you are trying to do, but I am not sure this way is the
> right way.  Most people I talk with want to shrink the time from 10
> seconds to something like 2 seconds with the idea that a system shouldn't
> have interrupts disabled for more than 2 seconds without knowing it and
> calling touch_watchdog().  But because there is so many false positives it
> is just safer to keep it at 10 seconds.
> 
> I am not sure your algorithm accomplishes that by checking to see if only
> one interrupt happened over the 10 second period.  Then again I would be
> curious if your testing uncovered anything.
There's precious little space between a completely normal scenario and a "hard 
lockup," in terms of how the detector calculates the severity of the situation. 
This causes the dubious nature of my proposed solution. It's just a very simple 
approach that tries to exploit the work the detector is already doing. I would 
be happy to try alternatives.

> It seems we would want to start the hardlockup sample period at a minimum
> watermark that would trigger possible stalls and declare a hardlockup at
> some maximum watermark.  But I am not sure how to properly increment it
> such that we don't get repeated stalls or if that is even the right
> approach.
Oh, this is something I hadn't considered. So, rather than making the existing 
check sensitive to sub-threshold "severities," change the frequency of the 
check. I guess it would start out as some fraction of the sample period and grow 
from there? One unfortunate side effect here, in my opinion, is that is a hard 
lockup really does occur quickly, it will instead be noted as a series of stalls 
before the period reaches the maximum watermark and it's considered a lockup. Is 
it possible that, by then, it will resolve itself and not end up setting off the 
detector, even though it should have? Maybe it's possible to make the hard 
lockup check work more like the soft lockup check: multiple successive checks 
would have to "fail" before it is considered a lockup. The intermediate checks 
could report stalls.

> >  	/* Warn about unreasonable delays: */
> > -	if (time_after(now, touch_ts + get_softlockup_thresh()))
> > +	if (time_after(now, touch_ts + 1000 * get_softlockup_thresh()))
> >  		return now - touch_ts;
> Should this chunk be moved above the 'stall' stuff otherwise you would
> wind up with two stack traces, one for the new 'worse_stall' and the
> actual softlockup.  Then again the actual softlockup is technically your
> new worse_stall.
Stalls should just be sub-threshold lockups. If they are beyond the threshold, 
they will be noted anyway. So yes, this should definitely be above the stall-
checking code.

> > @@ -289,14 +360,19 @@ static enum hrtimer_restart watchdog_timer_fn(struct 
hrtimer *hrtimer)
> >  	 * indicate it is getting cpu time.  If it hasn't then
> >  	 * this is a good indication some task is hogging the cpu
> >  	 */
> > -	duration = is_softlockup(touch_ts);
> > +	duration = is_softlockup(touch_ts, this_cpu);
> > +	if (this_cpu == softstall_cpu && old_stall != worst_softstall) {
> > +		printk(KERN_WARNING "new worst soft stall seen on CPU#%d: 
%lums\n",
> > +			this_cpu, worst_softstall);
> > +		dump_stack();
> > +	}
> 
> I was a little worried about this, you write to softstall_cpu and
> worst_softstall with the spinlock protected but you read them without
> spinlocks.  This is always the possibility that another cpu might
> overwrite those variables while you are reading them.
> 
> Would it make sense to put this printk inside the is_softlockup() code and
> just use the local variables to print this info out?
Okay. At that point, I suppose the stall-checking logic should be factored out 
into their own functions which are called from within is_*lockup(). The 
is_*lockup() functions are already doing some unintuitive things, given their 
names, and this would at least make it clear that something different is being 
done in there.

> >  	if (unlikely(duration)) {
> >  		/* only warn once */
> >  		if (__this_cpu_read(soft_watchdog_warn) == true)
> >  			return HRTIMER_RESTART;
> >  
> > -		printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %us! 
[%s:%d]\n",
> > -			smp_processor_id(), duration,
> > +		printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %ums! 
[%s:%d]\n",
> > +			this_cpu, duration,
> 
> Was wondering if the change to ms would confuse end users.  Perhaps we
> should just keep seconds and divide duration by a 1000?
Okay, if you think that might be the case. I had added some extra precision so I 
just figured, why not use it? But if it could be confusing then I'll just switch 
it back to seconds.

