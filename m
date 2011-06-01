Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161666Ab1FAMnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 08:43:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42446 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab1FAMnb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 08:43:31 -0400
X-Greylist: delayed 4620 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jun 2011 08:43:31 EDT
Subject: Re: [tip:sched/urgent] sched: Fix cross-cpu clock sync on remote
 wakeups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@amd64.org>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, markus@trippelsdorf.de,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20110601070547.GB3368@liondog.tnic>
References: <1306835745.2353.3.camel@twins>
	 <tip-f01114cb59d670e9b4f2c335930dd57db96e9360@git.kernel.org>
	 <20110531125621.GA24439@gere.osrc.amd.com> <1306847516.2353.80.camel@twins>
	 <20110601070547.GB3368@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Jun 2011 12:36:52 +0200
Message-ID: <1306924612.2353.176.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 09:05 +0200, Borislav Petkov wrote:
> On Tue, May 31, 2011 at 03:11:56PM +0200, Peter Zijlstra wrote:
> > Well, I don't have a modern AMD system to verify on, but the only
> > explanation is sched_clock weirdness (different code from the GTOD tsc
> > stuff). I could not reproduce on an Intel Westmere machine, but could on
> > a Core2.
> > 
> > The sched_clock_cpu stuff basically takes a GTOD timestamp every tick
> > and uses sched_clock() (tsc + cyc2ns) to provide delta increments, when
> > TSCs are synced every cpu should return the same value and the patch is
> > a nop.
> > 
> > If they aren't synced the per-cpu sched_clock_cpu() values can drift up
> > to about 2 jiffies (when the ticks drift about 1 and the slower of the
> > two has a stuck tsc while the faster of the two does progress at the
> > normal rate). In that case doing a clock update cross-cpu will ensure
> > time monotonicity between those two cpus.
> 
> Hmm, could it be that the sched_clock_tick() could be seeing different
> TSC values due to propagation delays of IPIs and TSCs? Or, it could be
> also that some TSCs don't start at the same moment after powerup but
> still run synchronized though?
> 
> How can we trace this, do you do trace_printk() in the scheduler? I'm
> asking because I remember reading somewhere that tracing the scheduler
> is not that trivial like say a driver :). I could do that on a couple of
> machines I have here and see what happens.

trace_printk() can go pretty much anywhere, you want to start with
something like the below and go from there, either up into
arch/x86/kernel/tsc.c:native_sched_clock() or down into the scheduler
and instrument rq->clock (although you most likely already get most of
that through the sched_clock_cpu() trace_printk).

Also, it might be good to check on the sched_clock_stable logic in
general and on your platform in particular, if that's set we forgo all
the fancy bits and return sched_clock() directly.

---
 kernel/sched_clock.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 9d8af0b..873f50f 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -167,6 +167,9 @@ static u64 sched_clock_local(struct sched_clock_data *scd)
 	if (cmpxchg64(&scd->clock, old_clock, clock) != old_clock)
 		goto again;
 
+	trace_printk("now: %llu, gtod: %llu, delta: %llu, old_clock: %llu, clock: %llu\n",
+			now, scd->tick_gtod, delta, old_clock, clock);
+
 	return clock;
 }
 
@@ -203,6 +206,9 @@ static u64 sched_clock_remote(struct sched_clock_data *scd)
 	if (cmpxchg64(ptr, old_val, val) != old_val)
 		goto again;
 
+	trace_printk("this: %llu, remote: %llu, clock: %llu\n",
+			thid_clock, remote_clock, val);
+
 	return val;
 }
 
@@ -231,6 +237,8 @@ u64 sched_clock_cpu(int cpu)
 	else
 		clock = sched_clock_local(scd);
 
+	trace_printk("clock: %llu\n", clock);
+
 	return clock;
 }
 
@@ -251,6 +259,8 @@ void sched_clock_tick(void)
 	now_gtod = ktime_to_ns(ktime_get());
 	now = sched_clock();
 
+	trace_printk("gtod: %llu, now: %llu\n", now_gtod, now);
+
 	scd->tick_raw = now;
 	scd->tick_gtod = now_gtod;
 	sched_clock_local(scd);

