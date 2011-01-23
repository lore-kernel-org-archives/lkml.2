Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab1AWESO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 23:18:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab1AWESN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 23:18:13 -0500
Date: Sun, 23 Jan 2011 05:18:01 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: werner <w.landgraf@ru.ru>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, idryomov@gmail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: 2.6.38-rc1 and -rc2 problems with khugepaged
Message-ID: <20110123041801.GY9506@random.random>
References: <web-444846021@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <web-444846021@zbackend1.aha.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Werner,

On Sat, Jan 22, 2011 at 10:56:16PM -0400, werner wrote:
> -rc2 hang up itself, still
> Again compiled with khugepaged enabled, so I suppose thats 
> the reason, still.
> First, the initialisation of KDE stops,  if then switching 
> with CTRL-ALT-F1 to the text system, one can log in, but 
> soon after comes the kernel error message, and it sticks 
> also on the text screen, going nothing else, only press 
> the reboot button ...

You need to apply this below patch on top of rc2 to be stable on
x86_32 with PARAVIRT=y and HIGHMEM64G=n. It's in -mm already. Can you
confirm that this fixes your problem? Thanks.

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
 
