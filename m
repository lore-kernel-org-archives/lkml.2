Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab1EBXJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:09:44 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:54332 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758023Ab1EBXJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:09:33 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 19:09:25 EDT
Message-Id: <201105022254.p42MsQlr030357@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 2 May 2011 15:54:32 -0400
Subject: [PATCH] arch/tile: disable GX prefetcher during cache flush
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 02 May 2011 22:54:27.0002 (UTC) FILETIME=[E35A61A0:01CC091B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, it's possible to end up with the prefetcher pulling
data into cache that the code believes has been flushed.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/lib/cacheflush.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/tile/lib/cacheflush.c b/arch/tile/lib/cacheflush.c
index 35c1d8c..8928aac 100644
--- a/arch/tile/lib/cacheflush.c
+++ b/arch/tile/lib/cacheflush.c
@@ -15,6 +15,7 @@
 #include <asm/page.h>
 #include <asm/cacheflush.h>
 #include <arch/icache.h>
+#include <arch/spr_def.h>
 
 
 void __flush_icache_range(unsigned long start, unsigned long end)
@@ -39,6 +40,18 @@ void finv_buffer_remote(void *buffer, size_t size, int hfh)
 	char *p, *base;
 	size_t step_size, load_count;
 	const unsigned long STRIPE_WIDTH = 8192;
+#ifdef __tilegx__
+	/*
+	 * On TILE-Gx, we must disable the dstream prefetcher before doing
+	 * a cache flush; otherwise, we could end up with data in the cache
+	 * that we don't want there.  Note that normally we'd do an mf
+	 * after the SPR write to disabling the prefetcher, but we do one
+	 * below, before any further loads, so there's no need to do it
+	 * here.
+	 */
+	uint_reg_t old_dstream_pf = __insn_mfspr(SPR_DSTREAM_PF);
+	__insn_mtspr(SPR_DSTREAM_PF, 0);
+#endif
 
 	/*
 	 * Flush and invalidate the buffer out of the local L1/L2
@@ -122,4 +135,9 @@ void finv_buffer_remote(void *buffer, size_t size, int hfh)
 
 	/* Wait for the load+inv's (and thus finvs) to have completed. */
 	__insn_mf();
+
+#ifdef __tilegx__
+	/* Reenable the prefetcher. */
+	__insn_mtspr(SPR_DSTREAM_PF, old_dstream_pf);
+#endif
 }
-- 
1.6.5.2

