Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908Ab2C3OLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 10:11:04 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:34804 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760272Ab2C3OKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 10:10:49 -0400
Message-ID: <4F75BED4.9050005@linux.vnet.ibm.com>
Date: Fri, 30 Mar 2012 19:40:28 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, a.p.zijlstra@chello.nl,
        mingo@kernel.org, "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        vapier@gentoo.org, srivatsa.bhat@linux.vnet.ibm.com,
        rusty@rustcorp.com.au
Subject: Re: sched: WARNING: at include/linux/cpumask.h:108 select_fallback_rq+0x241/0x280()
References: <CA+1xoqcf6qJOouKXGEHsjWSBJdA7qtMnuVopq+hoHS+TX8fvSg@mail.gmail.com> <CA+1xoqcJAwgTgQG=nZPsH_SLkPFkGt2rUiVWGn5SO5JOAC1RAA@mail.gmail.com>
In-Reply-To: <CA+1xoqcJAwgTgQG=nZPsH_SLkPFkGt2rUiVWGn5SO5JOAC1RAA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12033014-4790-0000-0000-0000020392FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2012 02:02 AM, Sasha Levin wrote:

> (and now with lkml)
> 
> Hi all,
> 
> I got the following spew using trinity in a kvm tools guest on the
> latest linux-next kernel.
> 
> This is the result of trying to offline CPU1. I'm not sure how to
> reproduce it easily besides putting some pressure on the system and
> shutting down CPUs until it happens.
> 
> [  317.238839] Cannot set affinity for irq 0
> [  317.238839] ------------[ cut here ]------------
> [  317.238839] WARNING: at include/linux/cpumask.h:108
> select_fallback_rq+0x241/0x280()
> [  317.238839] Pid: 13, comm: migration/1 Not tainted
> 3.3.0-next-20120329-sasha #4
> [  317.238839] Call Trace:
> [  317.238839]  [<ffffffff810b26b5>] warn_slowpath_common+0x75/0xb0
> [  317.238839]  [<ffffffff810b2705>] warn_slowpath_null+0x15/0x20
> [  317.238839]  [<ffffffff810e5991>] select_fallback_rq+0x241/0x280
> [  317.238839]  [<ffffffff810f1a40>] ? dequeue_task_fair+0x100/0x100
> [  317.238839]  [<ffffffff810f1a40>] ? dequeue_task_fair+0x100/0x100
> [  317.238839]  [<ffffffff810ecd20>] migrate_tasks+0x80/0xf0
> [  317.238839]  [<ffffffff826fe03a>] ? migration_call+0xae/0x16b
> [  317.238839]  [<ffffffff826fe073>] migration_call+0xe7/0x16b
> [  317.238839]  [<ffffffff810ddebf>] notifier_call_chain+0x5f/0x150
> [  317.238839]  [<ffffffff810ddfb9>] __raw_notifier_call_chain+0x9/0x10
> [  317.238839]  [<ffffffff810b489b>] __cpu_notify+0x1b/0x30
> [  317.238839]  [<ffffffff826c3fbd>] take_cpu_down+0x2d/0x40
> [  317.238839]  [<ffffffff811357fa>] stop_machine_cpu_stop+0xda/0x1a0
> [  317.238839]  [<ffffffff81135720>] ? queue_stop_cpus_work+0x190/0x190
> [  317.238839]  [<ffffffff811352ae>] cpu_stopper_thread+0xee/0x200
> [  317.238839]  [<ffffffff82705c1a>] ? __schedule+0x49a/0x860
> [  317.238839]  [<ffffffff811351c0>] ? res_counter_init+0x50/0x50
> [  317.238839]  [<ffffffff810d715e>] kthread+0xbe/0xd0
> [  317.238839]  [<ffffffff82709e74>] kernel_thread_helper+0x4/0x10
> [  317.238839]  [<ffffffff810e3ee0>] ? finish_task_switch+0x80/0x110
> [  317.238839]  [<ffffffff82708174>] ? retint_restore_args+0x13/0x13
> [  317.238839]  [<ffffffff810d70a0>] ? __init_kthread_worker+0x70/0x70
> [  317.238839]  [<ffffffff82709e70>] ? gs_change+0x13/0x13
> [  317.238839] ---[ end trace 79079cf527253aab ]---
> [  317.250645] [sched_delayed] process 2267 (trinity) no longer affine to cpu1
> [  317.323711] CPU 1 is now offline
> [  317.591059] [sched_delayed] process 1956 (trinity) no longer affine to cpu1
> [  317.812110] [sched_delayed] process 2004 (trinity) no longer affine to cpu1
> [  318.401016] [sched_delayed] process 2228 (trinity) no longer affine to cpu1
> [  318.581015] [sched_delayed] process 2099 (trinity) no longer affine to cpu1
> --



Does this patch help?

---

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: sched: Fix incorrect usage of for_each_cpu_mask() in select_fallback_rq()

The function for_each_cpu_mask() expects a *pointer* to struct cpumask
as its second argument, whereas select_fallback_rq() passes the value
itself. And moreover, for_each_cpu_mask() has been marked as obselete
in include/linux/cpumask.h. So move to the more appropriate for_each_cpu()
variant.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/sched/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e3ed0ec..e85046d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1270,7 +1270,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 	int dest_cpu;
 
 	/* Look for allowed, online CPU in same node. */
-	for_each_cpu_mask(dest_cpu, *nodemask) {
+	for_each_cpu(dest_cpu, nodemask) {
 		if (!cpu_online(dest_cpu))
 			continue;
 		if (!cpu_active(dest_cpu))
@@ -1281,7 +1281,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 
 	for (;;) {
 		/* Any allowed, online CPU? */
-		for_each_cpu_mask(dest_cpu, *tsk_cpus_allowed(p)) {
+		for_each_cpu(dest_cpu, tsk_cpus_allowed(p)) {
 			if (!cpu_online(dest_cpu))
 				continue;
 			if (!cpu_active(dest_cpu))


