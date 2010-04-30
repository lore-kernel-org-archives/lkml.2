Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab0D3RAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:00:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:59790 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758211Ab0D3RAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:00:20 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       stable@kernel.org, Wufei <fei.wu@windriver.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/1] kgdb: don't needlessly skip PAGE_USER test for Fsl booke
Date: Thu, 29 Apr 2010 21:56:37 -0500
Message-Id: <1272596197-27909-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1272596197-27909-1-git-send-email-jason.wessel@windriver.com>
References: <1272596197-27909-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 30 Apr 2010 02:56:46.0341 (UTC) FILETIME=[C5757350:01CAE810]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wufei <fei.wu@windriver.com>

The bypassing of this test is a leftover from 2.4 vintage
kernels, and is no longer appropriate, or even used by KGDB.
Currently KGDB uses probe_kernel_write() for all access to
memory via the KGDB core, so it can simply be deleted.

This fixes CVE-2010-1446.

CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Wufei <fei.wu@windriver.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/powerpc/mm/fsl_booke_mmu.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/mm/fsl_booke_mmu.c b/arch/powerpc/mm/fsl_booke_mmu.c
index c539472..1ce9dd5 100644
--- a/arch/powerpc/mm/fsl_booke_mmu.c
+++ b/arch/powerpc/mm/fsl_booke_mmu.c
@@ -155,15 +155,10 @@ static void settlbcam(int index, unsigned long virt, phys_addr_t phys,
 	if (cur_cpu_spec->cpu_features & MMU_FTR_BIG_PHYS)
 		TLBCAM[index].MAS7 = (u64)phys >> 32;
 
-#ifndef CONFIG_KGDB /* want user access for breakpoints */
 	if (flags & _PAGE_USER) {
 	   TLBCAM[index].MAS3 |= MAS3_UX | MAS3_UR;
 	   TLBCAM[index].MAS3 |= ((flags & _PAGE_RW) ? MAS3_UW : 0);
 	}
-#else
-	TLBCAM[index].MAS3 |= MAS3_UX | MAS3_UR;
-	TLBCAM[index].MAS3 |= ((flags & _PAGE_RW) ? MAS3_UW : 0);
-#endif
 
 	tlbcam_addrs[index].start = virt;
 	tlbcam_addrs[index].limit = virt + size - 1;
-- 
1.6.3.3

