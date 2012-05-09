Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab2EIGR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:17:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38991 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756341Ab2EIFx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:27 -0400
Message-Id: <20120509055046.652004232@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:32 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 123/167] [PATCH] ARM: 7397/1: l2x0: only apply workaround for erratum #753970
 on PL310
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit f154fe9b806574437b47f08e924ad10c0e240b23 upstream.

The workaround for PL310 erratum #753970 can lead to deadlock on systems
with an L220 cache controller.

This patch makes the workaround effective only when the cache controller
is identified as a PL310 at probe time.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mm/cache-l2x0.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux.orig/arch/arm/mm/cache-l2x0.c
+++ linux/arch/arm/mm/cache-l2x0.c
@@ -32,6 +32,7 @@
 static DEFINE_RAW_SPINLOCK(l2x0_lock);
 static uint32_t l2x0_way_mask;	/* Bitmask of active ways */
 static uint32_t l2x0_size;
+static unsigned long sync_reg_offset = L2X0_CACHE_SYNC;
 
 struct l2x0_regs l2x0_saved_regs;
 
@@ -61,12 +62,7 @@
 {
 	void __iomem *base = l2x0_base;
 
-#ifdef CONFIG_PL310_ERRATA_753970
-	/* write to an unmmapped register */
-	writel_relaxed(0, base + L2X0_DUMMY_REG);
-#else
-	writel_relaxed(0, base + L2X0_CACHE_SYNC);
-#endif
+	writel_relaxed(0, base + sync_reg_offset);
 	cache_wait(base + L2X0_CACHE_SYNC, 1);
 }
 
@@ -331,6 +327,10 @@
 		else
 			ways = 8;
 		type = "L310";
+#ifdef CONFIG_PL310_ERRATA_753970
+		/* Unmapped register. */
+		sync_reg_offset = L2X0_DUMMY_REG;
+#endif
 		break;
 	case L2X0_CACHE_ID_PART_L210:
 		ways = (aux >> 13) & 0xf;


