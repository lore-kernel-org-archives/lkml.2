Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab1EKA2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 20:28:34 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:50387 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab1EKA2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 20:28:32 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kvm: Fix kvm mmu_notifier initialization order
Date: Wed, 11 May 2011 09:28:28 +0900
Message-ID: <87fwomozbn.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Like the following, mmu_notifier can be called after registering
immediately. So, kvm have to initialize kvm->mmu_lock before it.

BUG: spinlock bad magic on CPU#0, kswapd0/342
 lock: ffff8800af8c4000, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
Pid: 342, comm: kswapd0 Not tainted 2.6.39-rc5+ #1
Call Trace:
 [<ffffffff8118ce61>] spin_bug+0x9c/0xa3
 [<ffffffff8118ce91>] do_raw_spin_lock+0x29/0x13c
 [<ffffffff81024923>] ? flush_tlb_others_ipi+0xaf/0xfd
 [<ffffffff812e22f3>] _raw_spin_lock+0x9/0xb
 [<ffffffffa0582325>] kvm_mmu_notifier_clear_flush_young+0x2c/0x66 [kvm]
 [<ffffffff810d3ff3>] __mmu_notifier_clear_flush_young+0x2b/0x57
 [<ffffffff810c8761>] page_referenced_one+0x88/0xea
 [<ffffffff810c89bf>] page_referenced+0x1fc/0x256
 [<ffffffff810b2771>] shrink_page_list+0x187/0x53a
 [<ffffffff810b2ed7>] shrink_inactive_list+0x1e0/0x33d
 [<ffffffff810acf95>] ? determine_dirtyable_memory+0x15/0x27
 [<ffffffff812e90ee>] ? call_function_single_interrupt+0xe/0x20
 [<ffffffff810b3356>] shrink_zone+0x322/0x3de
 [<ffffffff810a9587>] ? zone_watermark_ok_safe+0xe2/0xf1
 [<ffffffff810b3928>] kswapd+0x516/0x818
 [<ffffffff810b3412>] ? shrink_zone+0x3de/0x3de
 [<ffffffff81053d17>] kthread+0x7d/0x85
 [<ffffffff812e9394>] kernel_thread_helper+0x4/0x10
 [<ffffffff81053c9a>] ? __init_kthread_worker+0x37/0x37
 [<ffffffff812e9390>] ? gs_change+0xb/0xb

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 virt/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN virt/kvm/kvm_main.c~kvm-mmu_notifier-lock-fix virt/kvm/kvm_main.c
--- linux-2.6/virt/kvm/kvm_main.c~kvm-mmu_notifier-lock-fix	2011-05-11 09:21:52.000000000 +0900
+++ linux-2.6-hirofumi/virt/kvm/kvm_main.c	2011-05-11 09:22:04.000000000 +0900
@@ -467,6 +467,7 @@ static struct kvm *kvm_create_vm(void)
 		if (!kvm->buses[i])
 			goto out_err;
 	}
+	spin_lock_init(&kvm->mmu_lock);
 
 	r = kvm_init_mmu_notifier(kvm);
 	if (r)
@@ -474,7 +475,6 @@ static struct kvm *kvm_create_vm(void)
 
 	kvm->mm = current->mm;
 	atomic_inc(&kvm->mm->mm_count);
-	spin_lock_init(&kvm->mmu_lock);
 	kvm_eventfd_init(kvm);
 	mutex_init(&kvm->lock);
 	mutex_init(&kvm->irq_lock);
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
