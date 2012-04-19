Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab2DSMvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:51:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:39066 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab2DSMvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:51:32 -0400
Date: Thu, 19 Apr 2012 14:51:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Prarit Bhargava <prarit@redhat.com>
cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Salman Qazi <sqazi@google.com>, stable@kernel.org
Subject: Re: [PATCH] clocksource, prevent overflow in clocksource_cyc2ns
In-Reply-To: <alpine.LFD.2.02.1204191416130.2542@ionos>
Message-ID: <alpine.LFD.2.02.1204191451060.2542@ionos>
References: <1333552260-1170-1-git-send-email-prarit@redhat.com> <4F7C8C3E.1020203@us.ibm.com> <4F7C9402.3090602@redhat.com> <4F7CF094.5020201@us.ibm.com> <4F7D8FA1.1010107@redhat.com> <4F8F4C31.7010209@linaro.org> <4F8F555F.7040404@redhat.com>
 <alpine.LFD.2.02.1204191416130.2542@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2012, Thomas Gleixner wrote:

> On Wed, 18 Apr 2012, Prarit Bhargava wrote:
> > There's also some additional information that I've been gathering on this issue;
> > I have seen *idle* systems switch to the hpet because the clocksource watchdog
> > hits the overflow comparison.  As expected it happens much less frequently on
> > newer kernels (linux.git top of tree) than older stable kernels (2.6.32 based)
> > due to the difference in shift values but it is happening in both cases.
> > 
> > The odd thing about this behaviour is that I would expect it to occur with the
> > same frequency on small systems as it does on large systems with linux.git as
> > the watchdog fires once/second.  AFAICT I do not see this on small systems but
> > see it only on systems with greater than 24 cpus (both Intel and AMD).
> >
> > Using debug code similar to the dump code I previously provided, I can see that
> > every so often these large systems can hit a case where the tsc wraps and the
> > hpet is still monotonically increasing.  When the unstable calculation is
> > performed the result is obviously affected by the overflow.  Sometimes this
> > comparison overflow happens within 18 minutes, other times it can take hours or
> > days.
> 
> You are describing symptoms, but the root cause is obviously that the
> watchdog does not get invoked in time. The question is why.
> 
> Can you please add the patch below and enable scheduler, timer and irq
> events in the tracer. Tracing will stop once the watchdog triggers.
> 
> Please provide the traces. We need to understand the root cause of
> this idle wreckage.
> 
> Thanks,
> 
> 	tglx

-ENOPATCH :) 

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c958338..2214323 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -287,11 +287,15 @@ static void clocksource_watchdog(unsigned long data)
 		cs->cs_last = csnow;
 		cs->wd_last = wdnow;
 
+		trace_printk("wd %lld %lld cs %lld %lld\n" , wdnow, wd_nsec,
+			     csnow, cs_nsec);
+
 		if (atomic_read(&watchdog_reset_pending))
 			continue;
 
 		/* Check the deviation from the watchdog clocksource. */
 		if ((abs(cs_nsec - wd_nsec) > WATCHDOG_THRESHOLD)) {
+			tracing_off();
 			clocksource_unstable(cs, cs_nsec - wd_nsec);
 			continue;
 		}
