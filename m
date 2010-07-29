Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab0G2S4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 14:56:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659Ab0G2S4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 14:56:23 -0400
Date: Thu, 29 Jul 2010 20:55:29 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
Message-ID: <20100729185529.GW16655@random.random>
References: <201007282334.08063.rjw@sisk.pl>
 <20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
 <20100729142245.4AA5.A69D9226@jp.fujitsu.com>
 <20100729142429.58b49dce.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On Thu, Jul 29, 2010 at 11:44:31AM -0700, Hugh Dickins wrote:
> I've CC'ed Andrea because we were having an offline conversation about
> whether ksmd (and his khugepaged) need to set_freezable(); and I wonder
> if this swap bug underlies his interest, though he was mainly worrying
> about I/O in progress.

My opinion is that with current freezer model it is needed for suspend
to disk. The kthread_should_stop seems useless for kswapd/ksmd, but
I'm afraid it might get useful in the future so just to stay on the
safe side I added it to khugepaged as well, but it's contributing to
the pollution.

I've no idea why the freezing isn't preemptive (through the scheduler,
all these kernel threads are obviously lowlatency beasts) by default
(if kthread doesn't run set_freezable) and instead it requires
cooperative freezing. Now I can imagine a kernel thread not being
happy about preemptive freezing, and I also can imagine a kernel
thread not being happy about being frozen. But I think the default
shall be "preempting freezing by default" (removing all those
set_freezable/try_to_freeze and furthermore reducing the latency it
takes to freeze the task without having to add !freezing(current)
checks in the loops, by taking advantage of the existing cond_resched
or preempt=Y) and then introduce a set_freezable_cooperative() if it
wants to call try_to_freeze in a cooperative way in a well defined
point of the code, or set_not_freezable() if it doesn't want to
be frozen.

But for now I'm afraid the below is needed (only ksm.c part applies to
upstream).

------
Subject: freeze khugepaged and ksmd

From: Andrea Arcangeli <aarcange@redhat.com>

It's unclear why schedule friendly kernel threads can't be taken away by the
CPU through the scheduler itself. It's safer to stop them as they can trigger
memory allocation, if kswapd also freezes itself to avoid generating I/O they
have too.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -15,6 +15,7 @@
 #include <linux/mm_inline.h>
 #include <linux/kthread.h>
 #include <linux/khugepaged.h>
+#include <linux/freezer.h>
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
 #include "internal.h"
@@ -2053,6 +2054,9 @@ static void khugepaged_do_scan(struct pa
 			break;
 #endif
 
+		if (unlikely(kthread_should_stop() || freezing(current)))
+			break;
+
 		spin_lock(&khugepaged_mm_lock);
 		if (!khugepaged_scan.mm_slot)
 			pass_through_head++;
@@ -2115,6 +2119,9 @@ static void khugepaged_loop(void)
 		if (hpage)
 			put_page(hpage);
 #endif
+		try_to_freeze();
+		if (unlikely(kthread_should_stop()))
+			break;
 		if (khugepaged_has_work()) {
 			DEFINE_WAIT(wait);
 			if (!khugepaged_scan_sleep_millisecs)
@@ -2134,6 +2141,7 @@ static int khugepaged(void *none)
 {
 	struct mm_slot *mm_slot;
 
+	set_freezable();
 	set_user_nice(current, 19);
 
 	/* serialize with start_khugepaged() */
@@ -2148,6 +2156,8 @@ static int khugepaged(void *none)
 		mutex_lock(&khugepaged_mutex);
 		if (!khugepaged_enabled())
 			break;
+		if (unlikely(kthread_should_stop()))
+			break;
 	}
 
 	spin_lock(&khugepaged_mm_lock);
diff --git a/mm/ksm.c b/mm/ksm.c
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -33,6 +33,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/swap.h>
 #include <linux/ksm.h>
+#include <linux/freezer.h>
 
 #include <asm/tlbflush.h>
 #include "internal.h"
@@ -1386,7 +1387,7 @@ static void ksm_do_scan(unsigned int sca
 	struct rmap_item *rmap_item;
 	struct page *uninitialized_var(page);
 
-	while (scan_npages--) {
+	while (scan_npages-- && likely(!freezing(current))) {
 		cond_resched();
 		rmap_item = scan_get_next_rmap_item(&page);
 		if (!rmap_item)
@@ -1412,6 +1413,8 @@ static int ksm_scan_thread(void *nothing
 			ksm_do_scan(ksm_thread_pages_to_scan);
 		mutex_unlock(&ksm_thread_mutex);
 
+		try_to_freeze();
+
 		if (ksmd_should_run()) {
 			schedule_timeout_interruptible(
 				msecs_to_jiffies(ksm_thread_sleep_millisecs));
@@ -1953,6 +1956,7 @@ static int __init ksm_init(void)
 	struct task_struct *ksm_thread;
 	int err;
 
+	set_freezable();
 	err = ksm_slab_init();
 	if (err)
 		goto out;
