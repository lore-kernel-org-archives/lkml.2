Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab0JAHGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:06:34 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:54805 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab0JAHG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:06:29 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org
Cc: paulus@samba.org, Ian Munsie <imunsie@au1.ibm.com>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Torez Smith <lnxtorez@linux.vnet.ibm.com>
Subject: [PATCH 12/18] powerpc 44x: Handle TLB miss regardless of endianness
Date: Fri,  1 Oct 2010 17:06:05 +1000
Message-Id: <1285916771-18033-13-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

On the 44x we use 64bit page table entries, but the CPU is only 32bit.
When a PTE is loaded during a TLB miss each half is loaded into
different registers, so we need to reverse the offsets if the CPU is
running in little endian mode.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/kernel/head_44x.S |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/head_44x.S b/arch/powerpc/kernel/head_44x.S
index 6198733..d4c144f 100644
--- a/arch/powerpc/kernel/head_44x.S
+++ b/arch/powerpc/kernel/head_44x.S
@@ -258,8 +258,8 @@ interrupt_base:
 
 	/* Compute pte address */
 	rlwimi  r12, r10, PPC44x_PTE_ADD_SHIFT, PPC44x_PTE_ADD_MASK_BIT, 28
-	lwz	r11, 0(r12)		/* Get high word of pte entry */
-	lwz	r12, 4(r12)		/* Get low word of pte entry */
+	lwz	r11, p64h(r12)		/* Get high word of pte entry */
+	lwz	r12, p64l(r12)		/* Get low word of pte entry */
 
 	lis	r10,tlb_44x_index@ha
 
@@ -354,8 +354,8 @@ tlb_44x_patch_hwater_D:
 
 	/* Compute pte address */
 	rlwimi	r12, r10, PPC44x_PTE_ADD_SHIFT, PPC44x_PTE_ADD_MASK_BIT, 28
-	lwz	r11, 0(r12)		/* Get high word of pte entry */
-	lwz	r12, 4(r12)		/* Get low word of pte entry */
+	lwz	r11, p64h(r12)		/* Get high word of pte entry */
+	lwz	r12, p64l(r12)		/* Get low word of pte entry */
 
 	lis	r10,tlb_44x_index@ha
 
-- 
1.7.1

