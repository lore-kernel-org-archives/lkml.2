Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab1AVCMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 21:12:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab1AVCMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 21:12:43 -0500
Date: Sat, 22 Jan 2011 03:12:26 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: werner <w.landgraf@ru.ru>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, idryomov@gmail.com,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>
Subject: [PATCH] thp: fix PARAVIRT x86 32bit noPAE
Message-ID: <20110122021226.GQ9506@random.random>
References: <web-444048714@zbackend1.aha.ru>
 <20110121191757.GO9506@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110121191757.GO9506@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I reproduced your 32bit x86 problem with an initramfs with a hugepage
benchmark placed as /init inside KVM (not exactly an extensive test
but it was trivial to reproduce). I tested below fix with HIGHMEM4G
and HIGHMEM64G with PARAVIRT=y (and verified setting PARAVIRT=n fixed
it, in other email Minchan also verified that setting HIGHMEM64G=y
also fixed it, to confirm my theory the problem was the below #ifdef).

The stress test reaches exit() successfully now (before the fix it
crashed in out_of_memory() instead of do_exit as expected):

NMI watchdog disabled for cpu0: unable to create perf event: -2
�Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: init Not tainted 2.6.37+ #17
Call Trace:
 [<c14351d2>] ? panic+0x57/0x161
 [<c107439b>] ? trace_hardirqs_on+0xb/0x10
 [<c1045321>] ? do_exit+0x6b1/0x6e0
 [<c10728ab>] ? trace_hardirqs_off+0xb/0x10
 [<c1045389>] ? do_group_exit+0x39/0xa0
 [<c1045403>] ? sys_exit_group+0x13/0x20
 [<c1002d9c>] ? sysenter_do_call+0x12/0x3c
QEMU 0.12.1 monitor - type 'help' for more information
(qemu) quit

====
Subject: thp: fix PARAVIRT x86 32bit noPAE

From: Andrea Arcangeli <aarcange@redhat.com>

This fixes TRANSPARENT_HUGEPAGE=y with PARAVIRT=y and HIGHMEM64=n.

The #ifdef that this patch removes was erratically introduced to fix a build
error for noPAE (where pmd.pmd doesn't exist). So then the kernel built but it
failed at runtime because set_pmd_at was a noop. This will correct it by
enabling set_pmd_at for noPAE mode too.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 2071a8b..ebbc4d8 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -558,13 +558,12 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t pmd)
 {
-#if PAGETABLE_LEVELS >= 3
 	if (sizeof(pmdval_t) > sizeof(long))
 		/* 5 arg words */
 		pv_mmu_ops.set_pmd_at(mm, addr, pmdp, pmd);
 	else
-		PVOP_VCALL4(pv_mmu_ops.set_pmd_at, mm, addr, pmdp, pmd.pmd);
-#endif
+		PVOP_VCALL4(pv_mmu_ops.set_pmd_at, mm, addr, pmdp,
+			    native_pmd_val(pmd));
 }
 #endif
 
