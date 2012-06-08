Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724Ab2FHOxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:53:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59637 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757735Ab2FHOxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:53:51 -0400
Date: Fri, 8 Jun 2012 07:53:41 -0700
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Message-ID: <tip-d5d2d2eea84b0d8450b082edbc3dbde41fb8bfd8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stable@kernel.org, cpw@sgi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, cpw@sgi.com, tglx@linutronix.de
In-Reply-To: <E1SccoO-0002Lh-Cb@eag09.americas.sgi.com>
References: <E1SccoO-0002Lh-Cb@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/uv: Fix UV2 BAU legacy mode
Git-Commit-ID: d5d2d2eea84b0d8450b082edbc3dbde41fb8bfd8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 08 Jun 2012 07:53:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d5d2d2eea84b0d8450b082edbc3dbde41fb8bfd8
Gitweb:     http://git.kernel.org/tip/d5d2d2eea84b0d8450b082edbc3dbde41fb8bfd8
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Thu, 7 Jun 2012 08:31:40 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 8 Jun 2012 11:48:28 +0200

x86/uv: Fix UV2 BAU legacy mode

The SGI Altix UV2 BAU (Broadcast Assist Unit) as used for
tlb-shootdown (selective broadcast mode) always uses UV2
broadcast descriptor format. There is no need to clear the
'legacy' (UV1) mode, because the hardware always uses UV2 mode
for selective broadcast.

But the BIOS uses general broadcast and legacy mode, and the
hardware pays attention to the legacy mode bit for general
broadcast. So the kernel must not clear that mode bit.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/E1SccoO-0002Lh-Cb@eag09.americas.sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/uv/uv_bau.h |    1 -
 arch/x86/platform/uv/tlb_uv.c    |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

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
