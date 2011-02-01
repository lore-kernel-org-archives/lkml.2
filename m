Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1BADPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 22:15:47 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:34149 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751789Ab1BADPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 22:15:46 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+s15RlisusR2f9WnRSFAXXKd7rnO50E7eknGfXV2
	kjrsPXAwSsWNAx
Subject: Re: [PATCH] smp_call_function_many: handle concurrent clearing of
 mask
From: Mike Galbraith <efault@gmx.de>
To: Milton Miller <miltonm@bga.com>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
        Anton Blanchard <anton@samba.org>, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu, jaxboe@fusionio.com, npiggin@gmail.com,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <smp-ipi-mike@mdm.bga.com>
References: <20110112150740.77dde58c@kryten>
	 <1295288253.30950.280.camel@laptop>
	 <smp-call-function-peter-reply@mdm.bga.com>
	 <smp-call-function-move-writes@mdm.bga.com>
	 <1296145360.15234.234.camel@laptop>
	 <smp-call-function-list-race@mdm.bga.com>
	 <smp-call-function-list-race-fix@mdm.bga.com>
	 <1296458482.7889.175.camel@marge.simson.net>  <smp-ipi-mike@mdm.bga.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 04:15:36 +0100
Message-ID: <1296530136.7862.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-31 at 14:26 -0600, Milton Miller wrote:
> On Mon, 31 Jan 2011 about 08:21:22 +0100,  Mike Galbraith wrote:
> > Wondering if a final sanity check makes sense.  I've got a perma-spin
> > bug where comment apparently happened.  Another CPU's diddle the mask
> > IPI may make this CPU do horrible things to itself as it's setting up to
> > IPI others with that mask.
> > 
> > ---
> >  kernel/smp.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > Index: linux-2.6.38.git/kernel/smp.c
> > ===================================================================
> > --- linux-2.6.38.git.orig/kernel/smp.c
> > +++ linux-2.6.38.git/kernel/smp.c
> > @@ -490,6 +490,9 @@ void smp_call_function_many(const struct
> >  	cpumask_and(data->cpumask, mask, cpu_online_mask);
> >  	cpumask_clear_cpu(this_cpu, data->cpumask);
> >  
> > +	/* Did you pass me a mask that can be changed/emptied under me? */
> > +	BUG_ON(cpumask_empty(data->cpumask));
> > +
> 
> I was thinking of this as "the ipi cpumask was cleared", but I realize now
> you are saying the caller passed in a cpumask, but between the cpu_first/
> cpu_next calls above and the cpumask_and another cpu cleared all the cpus?
> 
> I could see how that could happen on say a mask of cpus that might have a
> translation context, or cpus that need a push to complete an rcu window.
> Instead of the BUG_ON, we can handle the mask being cleared.
> 
> The arch code to send the IPI must handle an empty mask, as the other
> cpus are racing to clear their bit while its trying to send the IPI.
> In fact that expected race is the cause of the x86 warning in bz 23042
> https://bugzilla.kernel.org/show_bug.cgi?id=23042  that Andrew pointed
> out.
> 
> 
> How about this [untested] patch?
> 
> Mike Galbraith reported finding a lockup where aparently the passed in
> cpumask was cleared on other cpu(s) while this cpu was preparing its
> smp_call_function_many block.   Detect this race and unlock the call
> data block.  Note: arch_send_call_function_ipi_mask must still handle an
> empty mask because the element is globally visable before it is called.
> And obviously there are no guarantees to which cpus are notified if the
> mask is changed during the call.

Yes, that would work.  In my case, it was passed mm_cpumask(mm).  What
is unclear is whether mask at call time was what the programmer needed
action on, ie mask changing may be intolerable information loss/gain.

	-Mike


