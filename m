Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab0IHOXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 10:23:07 -0400
Received: from gw1.transmode.se ([213.115.205.20]:58819 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab0IHOXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 10:23:05 -0400
In-Reply-To: <alpine.LFD.2.00.1009081551510.2477@localhost6.localdomain6>
References: <OF71DD00AE.26643E4D-ONC1257798.00250630-C1257798.002A9748@transmode.se>  <1283932600.2880.1.camel@edumazet-laptop>  <OF5074952F.1B97B2B8-ONC1257798.002C51D7-C1257798.002C63A4@transmode.se>  <1283934289.2880.12.camel@edumazet-laptop>  <OF2B75FA7C.7064BC41-ONC1257798.00318FDA-C1257798.00329AEF@transmode.se>  <alpine.LFD.2.00.1009081143200.2477@localhost6.localdomain6>  <OF82705D74.3C13AE80-ONC1257798.00427DAB-C1257798.0042F243@transmode.se>  <alpine.LFD.2.00.1009081442390.2477@localhost6.localdomain6> <1283950818.23762.20.camel@laptop> <OFA5A9E9D0.0B55FA15-ONC1257798.004A7BB3-C1257798.004B86F2@transmode.se> <alpine.LFD.2.00.1009081551510.2477@localhost6.localdomain6>
Subject: Re: slow nanosleep?
X-KeepSent: 58F81314:CCA2DE14-C1257798:004E57E1;
 type=4; name=$KeepSent
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
X-Mailer: Lotus Notes Release 8.5.2 August 10, 2010
Message-ID: <OF58F81314.CCA2DE14-ONC1257798.004E57E1-C1257798.004EA9E9@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 8 Sep 2010 16:19:13 +0200
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.1FP3|May 23, 2010) at
 2010-09-08 16:23:03
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Thomas Gleixner <tglx@linutronix.de> wrote on 2010/09/08 15:52:23:

> From: Thomas Gleixner <tglx@linutronix.de>
> To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
> Cc: Peter Zijlstra <peterz@infradead.org>, Eric Dumazet
> <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
> Date: 2010/09/08 15:52
> Subject: Re: slow nanosleep?
>
> On Wed, 8 Sep 2010, Joakim Tjernlund wrote:
>
> > Peter Zijlstra <peterz@infradead.org> wrote on 2010/09/08 15:00:18:
> > >
> > > On Wed, 2010-09-08 at 14:43 +0200, Thomas Gleixner wrote:
> > > > > However nanosleep with 1 ns and prctl(PR_SET_TIMERSLACK, 1) takes
> > > > > about 8 us on x86(Intel(R) Core(TM)2 Duo CPU E8500  @ 3.16GHz)
> > > > > and 20 us on my slower ppc board. Is that system call overhead
> > > > > or possibly some error?
> > > >
> > > > That's overhead I fear. We go way up to enqueue/arm the timer until we
> > > > figure out that the timeout already happened.
> > >
> > > Well, there's also the fact that his ppc board is simply dead slow,
> > > using the freq ratio: 3166/266 you'd expect (at a similar ins/clock
> > > ratio) the ppc to take 95us.
> > >
> > > So in fact the pcc taking 20us is actually quite good.
> >
> > Actually, it takes 120 us. The 20 us was when I had Thomas
> > timeout == 0 fast path patch applied(forgot to remove it).
> > Without that patch it takes about 115 us. So it seems it takes
> > 115-20=95 us to turn the timer wheel on my ppc.
>
> You might fire up the tracer to look where it spends that time.

This helps for short(1 ns) nanosleeps, sleeps for 25 us. No idea
if this is any good, just tossing it out for you to tear apart :)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 5c69e99..e612016 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1545,6 +1545,9 @@ long __sched hrtimer_nanosleep_restart(struct restart_block *restart)
 				HRTIMER_MODE_ABS);
 	hrtimer_set_expires_tv64(&t.timer, restart->nanosleep.expires);

+	if (!hrtimer_active(&t.timer))
+		goto out;
+
 	if (do_nanosleep(&t, HRTIMER_MODE_ABS))
 		goto out;

@@ -1576,6 +1579,9 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,

 	hrtimer_init_on_stack(&t.timer, clockid, mode);
 	hrtimer_set_expires_range_ns(&t.timer, timespec_to_ktime(*rqtp), slack);
+	if (!hrtimer_active(&t.timer))
+		goto out;
+
 	if (do_nanosleep(&t, mode))
 		goto out;



