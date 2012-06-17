Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab2FQSWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:22:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50111 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757949Ab2FQSWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:13 -0400
Message-Id: <20120617175942.199514663@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 18:59:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Cliff Wickman <cpw@sgi.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 06/69] x86/uv: Fix UV2 BAU legacy mode
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cliff Wickman <cpw@sgi.com>

commit d5d2d2eea84b0d8450b082edbc3dbde41fb8bfd8 upstream.

The SGI Altix UV2 BAU (Broadcast Assist Unit) as used for
tlb-shootdown (selective broadcast mode) always uses UV2
broadcast descriptor format. There is no need to clear the
'legacy' (UV1) mode, because the hardware always uses UV2 mode
for selective broadcast.

But the BIOS uses general broadcast and legacy mode, and the
hardware pays attention to the legacy mode bit for general
broadcast. So the kernel must not clear that mode bit.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Link: http://lkml.kernel.org/r/E1SccoO-0002Lh-Cb@eag09.americas.sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/uv/uv_bau.h |    1 -
 arch/x86/platform/uv/tlb_uv.c    |    1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index becf47b..6149b47 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -149,7 +149,6 @@
 /* 4 bits of software ack period */
 #define UV2_ACK_MASK			0x7UL
 #define UV2_ACK_UNITS_SHFT		3
-#define UV2_LEG_SHFT UV2H_LB_BAU_MISC_CONTROL_USE_LEGACY_DESCRIPTOR_FORMATS_SHFT
 #define UV2_EXT_SHFT UV2H_LB_BAU_MISC_CONTROL_ENABLE_EXTENDED_SB_STATUS_SHFT
 
 /*
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 3ae0e61..59880af 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1295,7 +1295,6 @@ static void __init enable_timeouts(void)
 		 */
 		mmr_image |= (1L << SOFTACK_MSHIFT);
 		if (is_uv2_hub()) {
-			mmr_image &= ~(1L << UV2_LEG_SHFT);
 			mmr_image |= (1L << UV2_EXT_SHFT);
 		}
 		write_mmr_misc_control(pnode, mmr_image);


