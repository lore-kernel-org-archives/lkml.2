Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab1G1Ios (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 04:44:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:37098 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab1G1Iol convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 04:44:41 -0400
Subject: Re: [ANNOUNCE] 3.0-rt4
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jason Wessel <jason.wessel@windriver.com>, lasaine@lvk.cs.msu.su
In-Reply-To: <alpine.LFD.2.02.1107280945080.2660@ionos>
References: <alpine.LFD.2.02.1107272222420.2660@ionos>
	 <201107281133.09107@zigzag.lvk.cs.msu.su>
	 <alpine.LFD.2.02.1107280945080.2660@ionos>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 28 Jul 2011 10:43:51 +0200
Message-ID: <1311842631.5890.208.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 10:06 +0200, Thomas Gleixner wrote:
> On Thu, 28 Jul 2011, Nikita V. Youshchenko wrote:
> 
> > > The list of disabled config option is now:
> > >
> > >  - CONFIG_HIGHMEM [ see the mess it created in 33-rt ]
> > 
> > Could someone please point me to information on this?
> > 
> > In our setup, we do use PREEMPT_RT + HIGHMEM, on .33 for now (but want to 
> > upgrade because of new hardware support issues with .33).  Up to now, we 
> > did not face any issues related to PREEMPT_RT + HIGHMEM combination.
> 
> Yes, it works in 33-rt, but the way it's implemented is a horrible
> hack. I had not enough capacity to implement that cleanly for 3.0-rt,
> so I simply dropped it for now. The preliminary patches are there
> (mainly distangling the disable_pagefault logic), so it should not be
> that hard.

In fact, with migrate_disable() existing one could play games with
kmap_atomic. You could save/restore the kmap_atomic slots on context
switch (if there are any in use of course), this should be esp easy now
that we have a kmap_atomic stack.

Something like the below.. it wants replacing all the preempt_disable()
stuff with pagefault_disable() && migrate_disable() of course, but then
you can flip kmaps around like below.

---
 arch/x86/kernel/process_32.c |   35 +++++++++++++++++++++++++++++++++++
 include/linux/sched.h        |    4 ++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index a3d0dc5..5ad6a02 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -348,6 +348,41 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		     task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT))
 		__switch_to_xtra(prev_p, next_p, tss);
 
+#if defined PREEMPT_RT_FULL && defined CONFIG_HIGHMEM
+	/*
+	 * Save @prev's kmap_atomic stack
+	 */
+	prev_p->kmap_idx = __this_cpu_read(__kmap_atomic_idx);
+	if (unlikely(prev_p->kmap_idx)) {
+		int i;
+
+		for (i = 0; i < prev_p->kmap_idx; i++) {
+			int idx = i + KM_TYPE_NR * smp_processor_id();
+
+			pte_t *ptep = kmap_pte - idx;
+			prev_p->kmap_pte[i] = *ptep;
+			kpte_clear_flush(ptep, __fix_to_virt(FIX_KMAP_BEGIN + idx));
+		}
+
+		__this_cpu_write(__kmap_atomic_idx, 0);
+	}
+
+	/* 
+	 * Restore @next_p's kmap_atomic stack
+	 */
+	if (unlikely(next_p->kmap_idx)) {
+		int i;
+
+		__this_cpu_write(__kmap_atomic_idx, next_p->kmap_idx);
+
+		for (i = 0; i < next_p->kmap_idx; i++) {
+			int idx = i + KM_TYPE_NR * smp_processor_id();
+
+			set_pte(kmap_ptr - idx, next_p->kmap_pte[i]);
+		}
+	}
+#endif
+
 	/* If we're going to preload the fpu context, make sure clts
 	   is run while we're batching the cpu state updates. */
 	if (preload_fpu)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 341a4d7..2db2701 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1570,6 +1570,10 @@ struct task_struct {
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 	atomic_t ptrace_bp_refcnt;
 #endif
+#if defined PREEMPT_RT_FULL && defined CONFIG_HIGHMEM
+	int kmap_idx;
+	pte_t kmap_pte[KM_TYPE_NR];
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */

