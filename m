Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab2GKP4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:56:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37553 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab2GKP4u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:56:50 -0400
Message-ID: <1342022185.3462.176.camel@twins>
Subject: Re: [PATCH 1/6] hrtimer: Provide clock_was_set_delayed()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>, John Stultz <johnstul@us.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org
Date: Wed, 11 Jul 2012 17:56:25 +0200
In-Reply-To: <alpine.LFD.2.02.1207111539060.32033@ionos>
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
	  <1341960205-56738-2-git-send-email-johnstul@us.ibm.com>
	  <4FFD6E5A.9060206@redhat.com> <alpine.LFD.2.02.1207111425260.32033@ionos>
	 <1342011904.3462.152.camel@twins>
	 <alpine.LFD.2.02.1207111539060.32033@ionos>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 17:18 +0200, Thomas Gleixner wrote:

> Right. I think with the atomic update of the offset in the timer
> interrupt we are on the safe side. The main problem of timers expiring
> early forever is covered by this.
> 
> Thinking more about it.
> 
> If time goes backwards, then the IPI is pointless. The already armed
> clockevent device will fire too early, hrtimer_interrupt will update
> and just rearm it. That's one "spurious" event.
> 
> So we only need it in the case of time going forward. 
> 
> Though with the leap second the maximum observable delay is 1 second
> on a completely idle core. Surely nothing to worry about for an event
> which happens rarely. So we could safely avoid the whole delayed
> business and just do the timerfd notification, though I wonder if even
> that is necessary in the leap second case.
> 
> On NOHZ=n systems the IPI is pointless as well. The maximum lateness
> will be 10ms for HZ=100. Nothing we should worry about.
> 
> That leaves NOHZ enabled systems and there we might be clever and
> avoid the IPIs to those cores which are not idle and let the tick
> interrupt deal with it. And we can make the calls async and just let
> them raise the hrtimer softirq on those cores, which will run the
> hrtimer interrupt code and take care of everything.
> 
> Thoughts?


static void nohz_hrtimer_softirq(void *unused)
{
	raise_softirq(HRTIMER_SOFTIRQ);
}

static void kick_nohz_cpus(void)
{
	smp_call_function_many(nohz.idle_cpus_mask, nohz_hrtimer_softirq, NULL, 0);
}

Same problem as before though, can't be sending IPIs while in hardirq
context.. 

And you cannot do the same trick with a CFD as with the CSD, some CPUs
might need it again while others are still pending.

