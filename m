Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab1EUTjj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 15:39:39 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:41896 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024Ab1EUTj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 15:39:29 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-m68k@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/4] m68k/amiga: Chip RAM - Use lookup_resource()
Date: Sat, 21 May 2011 21:39:15 +0200
Message-Id: <1306006756-32009-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1306006756-32009-1-git-send-email-geert@linux-m68k.org>
References: <1306006756-32009-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a custom implementation (which doesn't lock the resource tree) by a
call to lookup_resource()

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/chipram.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/m68k/amiga/chipram.c b/arch/m68k/amiga/chipram.c
index cfd3b7a..9d53417 100644
--- a/arch/m68k/amiga/chipram.c
+++ b/arch/m68k/amiga/chipram.c
@@ -93,21 +93,21 @@ void *amiga_chip_alloc_res(unsigned long size, struct resource *res)
 void amiga_chip_free(void *ptr)
 {
 	unsigned long start = ZTWO_PADDR(ptr);
-	struct resource **p, *res;
+	struct resource *res;
 	unsigned long size;
 
-	for (p = &chipram_res.child; (res = *p); p = &res->sibling) {
-		if (res->start != start)
-			continue;
-		*p = res->sibling;
-		size = resource_size(res);
-		pr_debug("amiga_chip_free: free %lu bytes at %p\n", size, ptr);
-		atomic_add(size, &chipavail);
-		kfree(res);
+	res = lookup_resource(&chipram_res, start);
+	if (!res) {
+		pr_err("amiga_chip_free: trying to free nonexistent region at "
+		       "%p\n", ptr);
 		return;
 	}
-	pr_err("amiga_chip_free: trying to free nonexistent region at %p\n",
-	       ptr);
+
+	size = resource_size(res);
+	pr_debug("amiga_chip_free: free %lu bytes at %p\n", size, ptr);
+	atomic_add(size, &chipavail);
+	release_resource(res);
+	kfree(res);
 }
 EXPORT_SYMBOL(amiga_chip_free);
 
-- 
1.7.0.4

