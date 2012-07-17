Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab2GQPdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 11:33:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8531 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab2GQPcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 11:32:47 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=eOt7VUWXjrMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=t7CeM3EgAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=rUGnjwGbVWCaevYykVgA:9 a=2e6ZYRoF4I4A:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120717153244.051644274@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 17 Jul 2012 11:31:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH RT 07/12] perf: Make swevent hrtimer run in irq instead of softirq
References: <20120717153115.606116459@goodmis.org>
Content-Disposition: inline; filename=0007-perf-Make-swevent-hrtimer-run-in-irq-instead-of-soft.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

Otherwise we get a deadlock like below:

[ 1044.042749] BUG: scheduling while atomic: ksoftirqd/21/141/0x00010003
[ 1044.042752] INFO: lockdep is turned off.
[ 1044.042754] Modules linked in:
[ 1044.042757] Pid: 141, comm: ksoftirqd/21 Tainted: G        W    3.4.0-rc2-rt3-23676-ga723175-dirty #29
[ 1044.042759] Call Trace:
[ 1044.042761]  <IRQ>  [<ffffffff8107d8e5>] __schedule_bug+0x65/0x80
[ 1044.042770]  [<ffffffff8168978c>] __schedule+0x83c/0xa70
[ 1044.042775]  [<ffffffff8106bdd2>] ? prepare_to_wait+0x32/0xb0
[ 1044.042779]  [<ffffffff81689a5e>] schedule+0x2e/0xa0
[ 1044.042782]  [<ffffffff81071ebd>] hrtimer_wait_for_timer+0x6d/0xb0
[ 1044.042786]  [<ffffffff8106bb30>] ? wake_up_bit+0x40/0x40
[ 1044.042790]  [<ffffffff81071f20>] hrtimer_cancel+0x20/0x40
[ 1044.042794]  [<ffffffff8111da0c>] perf_swevent_cancel_hrtimer+0x3c/0x50
[ 1044.042798]  [<ffffffff8111da31>] task_clock_event_stop+0x11/0x40
[ 1044.042802]  [<ffffffff8111da6e>] task_clock_event_del+0xe/0x10
[ 1044.042805]  [<ffffffff8111c568>] event_sched_out+0x118/0x1d0
[ 1044.042809]  [<ffffffff8111c649>] group_sched_out+0x29/0x90
[ 1044.042813]  [<ffffffff8111ed7e>] __perf_event_disable+0x18e/0x200
[ 1044.042817]  [<ffffffff8111c343>] remote_function+0x63/0x70
[ 1044.042821]  [<ffffffff810b0aae>] generic_smp_call_function_single_interrupt+0xce/0x120
[ 1044.042826]  [<ffffffff81022bc7>] smp_call_function_single_interrupt+0x27/0x40
[ 1044.042831]  [<ffffffff8168d50c>] call_function_single_interrupt+0x6c/0x80
[ 1044.042833]  <EOI>  [<ffffffff811275b0>] ? perf_event_overflow+0x20/0x20
[ 1044.042840]  [<ffffffff8168b970>] ? _raw_spin_unlock_irq+0x30/0x70
[ 1044.042844]  [<ffffffff8168b976>] ? _raw_spin_unlock_irq+0x36/0x70
[ 1044.042848]  [<ffffffff810702e2>] run_hrtimer_softirq+0xc2/0x200
[ 1044.042853]  [<ffffffff811275b0>] ? perf_event_overflow+0x20/0x20
[ 1044.042857]  [<ffffffff81045265>] __do_softirq_common+0xf5/0x3a0
[ 1044.042862]  [<ffffffff81045c3d>] __thread_do_softirq+0x15d/0x200
[ 1044.042865]  [<ffffffff81045dda>] run_ksoftirqd+0xfa/0x210
[ 1044.042869]  [<ffffffff81045ce0>] ? __thread_do_softirq+0x200/0x200
[ 1044.042873]  [<ffffffff81045ce0>] ? __thread_do_softirq+0x200/0x200
[ 1044.042877]  [<ffffffff8106b596>] kthread+0xb6/0xc0
[ 1044.042881]  [<ffffffff8168b97b>] ? _raw_spin_unlock_irq+0x3b/0x70
[ 1044.042886]  [<ffffffff8168d994>] kernel_thread_helper+0x4/0x10
[ 1044.042889]  [<ffffffff8107d98c>] ? finish_task_switch+0x8c/0x110
[ 1044.042894]  [<ffffffff8168b97b>] ? _raw_spin_unlock_irq+0x3b/0x70
[ 1044.042897]  [<ffffffff8168bd5d>] ? retint_restore_args+0xe/0xe
[ 1044.042900]  [<ffffffff8106b4e0>] ? kthreadd+0x1e0/0x1e0
[ 1044.042902]  [<ffffffff8168d990>] ? gs_change+0xb/0xb

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1341476476-5666-1-git-send-email-yong.zhang0@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/events/core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index fd126f8..451d452 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5403,6 +5403,7 @@ static void perf_swevent_init_hrtimer(struct perf_event *event)
 
 	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hwc->hrtimer.function = perf_swevent_hrtimer;
+	hwc->hrtimer.irqsafe = 1;
 
 	/*
 	 * Since hrtimers have a fixed rate, we can do a static freq->period
-- 
1.7.10.4


