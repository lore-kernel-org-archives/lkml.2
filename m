Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208Ab2EIGV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:21:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38990 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756320Ab2EIFxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:20 -0400
Message-Id: <20120509055046.786220811@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:33 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 124/167] [PATCH] ARM: 7398/1: l2x0: only write to debug registers on PL310
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

commit ab4d536890853ab6675ede65db40e2c0980cb0ea upstream.

PL310 errata #588369 and #727915 require writes to the debug registers
of the cache controller to work around known problems. Writing these
registers on L220 may cause deadlock, so ensure that we only perform
this operation when we identify a PL310 at probe time.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mm/cache-l2x0.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index a8d02c0..2a8e380 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -81,10 +81,13 @@ static inline void l2x0_inv_line(unsigned long addr)
 }
 
 #if defined(CONFIG_PL310_ERRATA_588369) || defined(CONFIG_PL310_ERRATA_727915)
+static inline void debug_writel(unsigned long val)
+{
+	if (outer_cache.set_debug)
+		outer_cache.set_debug(val);
+}
 
-#define debug_writel(val)	outer_cache.set_debug(val)
-
-static void l2x0_set_debug(unsigned long val)
+static void pl310_set_debug(unsigned long val)
 {
 	writel_relaxed(val, l2x0_base + L2X0_DEBUG_CTRL);
 }
@@ -94,7 +97,7 @@ static inline void debug_writel(unsigned long val)
 {
 }
 
-#define l2x0_set_debug	NULL
+#define pl310_set_debug	NULL
 #endif
 
 #ifdef CONFIG_PL310_ERRATA_588369
@@ -331,6 +334,7 @@ void __init l2x0_init(void __iomem *base, u32 aux_val, u32 aux_mask)
 		/* Unmapped register. */
 		sync_reg_offset = L2X0_DUMMY_REG;
 #endif
+		outer_cache.set_debug = pl310_set_debug;
 		break;
 	case L2X0_CACHE_ID_PART_L210:
 		ways = (aux >> 13) & 0xf;
@@ -379,7 +383,6 @@ void __init l2x0_init(void __iomem *base, u32 aux_val, u32 aux_mask)
 	outer_cache.flush_all = l2x0_flush_all;
 	outer_cache.inv_all = l2x0_inv_all;
 	outer_cache.disable = l2x0_disable;
-	outer_cache.set_debug = l2x0_set_debug;
 
 	printk(KERN_INFO "%s cache controller enabled\n", type);
 	printk(KERN_INFO "l2x0: %d ways, CACHE_ID 0x%08x, AUX_CTRL 0x%08x, Cache size: %d B\n",
-- 
1.7.10



