Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab0GUUNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 16:13:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab0GUUNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 16:13:31 -0400
Date: Wed, 21 Jul 2010 16:13:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, czoccolo@gmail.com
Subject: Re: [PATCH 2/3] cfq-iosched: Implement a tunable group_idle
Message-ID: <20100721201318.GH20458@redhat.com>
References: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
 <1279739181-24482-3-git-send-email-vgoyal@redhat.com>
 <x49bpa0d3nn.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49bpa0d3nn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 03:40:44PM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > o Implement a new tunable group_idle, which allows idling on the group
> >   instead of a cfq queue. Hence one can set slice_idle = 0 and not idle
> >   on the individual queues but idle on the group. This way on fast storage
> >   we can get fairness between groups at the same time overall throughput
> >   improves.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> [snip]
> > @@ -1929,13 +1941,21 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
> >  		return;
> >  	}
> >  
> > +	/* There are other queues in the group, don't do group idle */
> > +	if (group_idle && cfqq->cfqg->nr_cfqq > 1)
> > +		return;
> > +
> >  	cfq_mark_cfqq_wait_request(cfqq);
> >  
> > -	sl = cfqd->cfq_slice_idle;
> > +	if (group_idle)
> > +		sl = cfqd->cfq_group_idle;
> > +	else
> > +		sl = cfqd->cfq_slice_idle;
> 
> What happens when both group_idle and slice_idle are set?

slice_idle prevails. Notice that "group_idle" is a local variable which
is set to 1 only if we decide not to idle on the cfq queue.


>  Is that a
> sane thing to do from a user's perspective?

In fact by default both slice_idle=8 and group_idle=8. Just that in this
mode group_idle never kicks in as slice_idle logic kicks in always before
group_idle logic gets any chance.

> If not, please protect
> against it in the configuration code.  If so, then explain why we prefer
> group_idle here, but slice_idle in completed request for the extend_sl:
> 

In both the places we first prefer slice_idle. Just noticed the value of
"group_idle" in the beginning of arm_time() function and notice in what
circumstances do we set group_idle=1

Thanks
Vivek

> > @@ -3425,7 +3458,10 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
> >  		 * the queue.
> >  		 */
> >  		if (cfq_should_wait_busy(cfqd, cfqq)) {
> > -			cfqq->slice_end = jiffies + cfqd->cfq_slice_idle;
> > +			unsigned long extend_sl = cfqd->cfq_slice_idle;
> > +			if (!cfqd->cfq_slice_idle)
> > +				extend_sl = cfqd->cfq_group_idle;
> > +			cfqq->slice_end = jiffies + extend_sl;
> 
> Also, you'll need to add documentation for this new tunable.
> 
> Cheers,
> Jeff
