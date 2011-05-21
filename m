Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab1EUTSl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 15:18:41 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:59914 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab1EUTS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 15:18:29 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/5] m68k/amiga: Chip RAM - Always allocate from the start of memory
Date: Sat, 21 May 2011 21:18:18 +0200
Message-Id: <1306005500-29259-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1306005500-29259-1-git-send-email-geert@linux-m68k.org>
References: <1306005500-29259-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit 5df1abdbd37af2ae317a1c5b5944173284dc55d6 ('m68k/amiga: Fix
"debug=mem"'), "debug=mem" no longer uses amiga_chip_alloc_res(), so we
can remove the hack to prefer memory at the safe end.

This allows to simplify the code and make amiga_chip_alloc() just call
amiga_chip_alloc_res() internally.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/chipram.c |   35 +++++++++++++++--------------------
 1 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/arch/m68k/amiga/chipram.c b/arch/m68k/amiga/chipram.c
index 9005fa0..e5a8dbc 100644
--- a/arch/m68k/amiga/chipram.c
+++ b/arch/m68k/amiga/chipram.c
@@ -43,24 +43,20 @@ void __init amiga_chip_init(void)
 void *amiga_chip_alloc(unsigned long size, const char *name)
 {
 	struct resource *res;
+	void *p;
 
-	/* round up */
-	size = PAGE_ALIGN(size);
-
-	pr_debug("amiga_chip_alloc: allocate %lu bytes\n", size);
 	res = kzalloc(sizeof(struct resource), GFP_KERNEL);
 	if (!res)
 		return NULL;
-	res->name = name;
 
-	if (allocate_resource(&chipram_res, res, size, 0, UINT_MAX, PAGE_SIZE,
-			      NULL, NULL) < 0) {
+	res->name = name;
+	p = amiga_chip_alloc_res(size, res);
+	if (!p) {
 		kfree(res);
 		return NULL;
 	}
-	chipavail -= size;
-	pr_debug("amiga_chip_alloc: returning %pR\n", res);
-	return (void *)ZTWO_VADDR(res->start);
+
+	return p;
 }
 EXPORT_SYMBOL(amiga_chip_alloc);
 
@@ -72,23 +68,22 @@ EXPORT_SYMBOL(amiga_chip_alloc);
 	 *  those drivers must not free that Chip RAM afterwards.
 	 */
 
-void * __init amiga_chip_alloc_res(unsigned long size, struct resource *res)
+void *amiga_chip_alloc_res(unsigned long size, struct resource *res)
 {
-	unsigned long start;
+	int error;
 
 	/* round up */
 	size = PAGE_ALIGN(size);
-	/* dmesg into chipmem prefers memory at the safe end */
-	start = CHIP_PHYSADDR + chipavail - size;
 
 	pr_debug("amiga_chip_alloc_res: allocate %lu bytes\n", size);
-	if (allocate_resource(&chipram_res, res, size, start, UINT_MAX,
-			      PAGE_SIZE, NULL, NULL) < 0) {
-		pr_err("amiga_chip_alloc_res: first alloc failed!\n");
-		if (allocate_resource(&chipram_res, res, size, 0, UINT_MAX,
-				      PAGE_SIZE, NULL, NULL) < 0)
-			return NULL;
+	error = allocate_resource(&chipram_res, res, size, 0, UINT_MAX,
+				  PAGE_SIZE, NULL, NULL);
+	if (error < 0) {
+		pr_err("amiga_chip_alloc_res: allocate_resource() failed %d!\n",
+		       error);
+		return NULL;
 	}
+
 	chipavail -= size;
 	pr_debug("amiga_chip_alloc_res: returning %pR\n", res);
 	return (void *)ZTWO_VADDR(res->start);
-- 
1.7.0.4

