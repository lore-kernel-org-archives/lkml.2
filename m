Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab1EUTSf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 15:18:35 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:52979 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab1EUTS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 15:18:28 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/5] m68k/amiga: Chip RAM - Change chipavail to an atomic_t
Date: Sat, 21 May 2011 21:18:19 +0200
Message-Id: <1306005500-29259-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1306005500-29259-1-git-send-email-geert@linux-m68k.org>
References: <1306005500-29259-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the core resource handling code is safe, our global counter must
still be protected against concurrent modifications.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/chipram.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/m68k/amiga/chipram.c b/arch/m68k/amiga/chipram.c
index e5a8dbc..c3fe451 100644
--- a/arch/m68k/amiga/chipram.c
+++ b/arch/m68k/amiga/chipram.c
@@ -16,6 +16,7 @@
 #include <linux/string.h>
 #include <linux/module.h>
 
+#include <asm/atomic.h>
 #include <asm/page.h>
 #include <asm/amigahw.h>
 
@@ -25,7 +26,7 @@ EXPORT_SYMBOL(amiga_chip_size);
 static struct resource chipram_res = {
 	.name = "Chip RAM", .start = CHIP_PHYSADDR
 };
-static unsigned long chipavail;
+static atomic_t chipavail;
 
 
 void __init amiga_chip_init(void)
@@ -36,7 +37,7 @@ void __init amiga_chip_init(void)
 	chipram_res.end = amiga_chip_size-1;
 	request_resource(&iomem_resource, &chipram_res);
 
-	chipavail = amiga_chip_size;
+	atomic_set(&chipavail, amiga_chip_size);
 }
 
 
@@ -84,7 +85,7 @@ void *amiga_chip_alloc_res(unsigned long size, struct resource *res)
 		return NULL;
 	}
 
-	chipavail -= size;
+	atomic_sub(size, &chipavail);
 	pr_debug("amiga_chip_alloc_res: returning %pR\n", res);
 	return (void *)ZTWO_VADDR(res->start);
 }
@@ -101,7 +102,7 @@ void amiga_chip_free(void *ptr)
 		*p = res->sibling;
 		size = res->end-start;
 		pr_debug("amiga_chip_free: free %lu bytes at %p\n", size, ptr);
-		chipavail += size;
+		atomic_add(size, &chipavail);
 		kfree(res);
 		return;
 	}
@@ -113,8 +114,10 @@ EXPORT_SYMBOL(amiga_chip_free);
 
 unsigned long amiga_chip_avail(void)
 {
-	pr_debug("amiga_chip_avail : %lu bytes\n", chipavail);
-	return chipavail;
+	unsigned long n = atomic_read(&chipavail);
+
+	pr_debug("amiga_chip_avail : %lu bytes\n", n);
+	return n;
 }
 EXPORT_SYMBOL(amiga_chip_avail);
 
-- 
1.7.0.4

