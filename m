Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652Ab2FGNbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:31:20 -0400
Received: from relay3.sgi.com ([192.48.152.1]:45567 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758129Ab2FGNbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:31:19 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: UV2 BAU legacy mode
Cc: mingo@elte.hu, x86@kernel.org
Message-Id: <E1SccoO-0002Lh-Cb@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 07 Jun 2012 08:31:40 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

The SGI Altix UV2 BAU (Broadcast Assist Unit) as used for tlb-shootdown
(selective broadcast mode) always uses UV2 broadcast descriptor format.
There is no need to clear the 'legacy' (UV1) mode, because the hardware
always uses UV2 mode for selective broadcast.

But the BIOS uses general broadcast and legacy mode, and the hardware
pays attention to the legacy mode bit for general broadcast.
So the kernel must not clear that mode bit.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/include/asm/uv/uv_bau.h |    1 -
 arch/x86/platform/uv/tlb_uv.c    |    1 -
 2 files changed, 2 deletions(-)

Index: linus.current/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- linus.current.orig/arch/x86/include/asm/uv/uv_bau.h
+++ linus.current/arch/x86/include/asm/uv/uv_bau.h
@@ -149,7 +149,6 @@
 /* 4 bits of software ack period */
 #define UV2_ACK_MASK			0x7UL
 #define UV2_ACK_UNITS_SHFT		3
-#define UV2_LEG_SHFT UV2H_LB_BAU_MISC_CONTROL_USE_LEGACY_DESCRIPTOR_FORMATS_SHFT
 #define UV2_EXT_SHFT UV2H_LB_BAU_MISC_CONTROL_ENABLE_EXTENDED_SB_STATUS_SHFT
 
 /*
Index: linus.current/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linus.current.orig/arch/x86/platform/uv/tlb_uv.c
+++ linus.current/arch/x86/platform/uv/tlb_uv.c
@@ -1295,7 +1295,6 @@ static void __init enable_timeouts(void)
 		 */
 		mmr_image |= (1L << SOFTACK_MSHIFT);
 		if (is_uv2_hub()) {
-			mmr_image &= ~(1L << UV2_LEG_SHFT);
 			mmr_image |= (1L << UV2_EXT_SHFT);
 		}
 		write_mmr_misc_control(pnode, mmr_image);
