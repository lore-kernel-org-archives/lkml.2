Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab1BJVAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:00:16 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47217 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757027Ab1BJVAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:00:15 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Allow sharing xvmalloc for zram and zcache
Date: Thu, 10 Feb 2011 16:00:46 -0500
Message-Id: <1297371646-11604-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both zram and zcache use xvmalloc allocator. If xvmalloc
is compiled separately for both of them, we will get linker
error if they are both selected as "built-in". We can also
get linker error regarding missing xvmalloc symbols if zram
is not built.

So, we now compile xvmalloc separately and export its symbols
which are then used by both of zram and zcache.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/Makefile        |    1 +
 drivers/staging/zcache/Makefile |    4 +++-
 drivers/staging/zram/Kconfig    |    5 +++++
 drivers/staging/zram/Makefile   |    3 ++-
 drivers/staging/zram/xvmalloc.c |    8 ++++++++
 5 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 9edbfec..f7ab035 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_DX_SEP)            += sep/
 obj-$(CONFIG_IIO)		+= iio/
 obj-$(CONFIG_CS5535_GPIO)	+= cs5535_gpio/
 obj-$(CONFIG_ZRAM)		+= zram/
+obj-$(CONFIG_XVMALLOC)		+= zram/
 obj-$(CONFIG_ZCACHE)		+= zcache/
 obj-$(CONFIG_WLAGS49_H2)	+= wlags49_h2/
 obj-$(CONFIG_WLAGS49_H25)	+= wlags49_h25/
diff --git a/drivers/staging/zcache/Makefile b/drivers/staging/zcache/Makefile
index 7f64de4..f5ec64f 100644
--- a/drivers/staging/zcache/Makefile
+++ b/drivers/staging/zcache/Makefile
@@ -1 +1,3 @@
-obj-$(CONFIG_ZCACHE)	+=	zcache.o tmem.o
+zcache-y	:=	tmem.o
+
+obj-$(CONFIG_ZCACHE)	+=	zcache.o
diff --git a/drivers/staging/zram/Kconfig b/drivers/staging/zram/Kconfig
index da079f8..1516ea4 100644
--- a/drivers/staging/zram/Kconfig
+++ b/drivers/staging/zram/Kconfig
@@ -1,6 +1,11 @@
+config XVMALLOC
+	bool
+	default n
+
 config ZRAM
 	tristate "Compressed RAM block device support"
 	depends on BLOCK
+	select XVMALLOC
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	default n
diff --git a/drivers/staging/zram/Makefile b/drivers/staging/zram/Makefile
index b1709c5..2a6d321 100644
--- a/drivers/staging/zram/Makefile
+++ b/drivers/staging/zram/Makefile
@@ -1,3 +1,4 @@
-zram-y	:=	zram_drv.o zram_sysfs.o xvmalloc.o
+zram-y	:=	zram_drv.o zram_sysfs.o
 
 obj-$(CONFIG_ZRAM)	+=	zram.o
+obj-$(CONFIG_XVMALLOC)	+=	xvmalloc.o
\ No newline at end of file
diff --git a/drivers/staging/zram/xvmalloc.c b/drivers/staging/zram/xvmalloc.c
index b644067..aa6fcd8 100644
--- a/drivers/staging/zram/xvmalloc.c
+++ b/drivers/staging/zram/xvmalloc.c
@@ -10,6 +10,8 @@
  * Released under the terms of GNU General Public License Version 2.0
  */
 
+#include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/highmem.h>
@@ -320,11 +322,13 @@ struct xv_pool *xv_create_pool(void)
 
 	return pool;
 }
+EXPORT_SYMBOL_GPL(xv_create_pool);
 
 void xv_destroy_pool(struct xv_pool *pool)
 {
 	kfree(pool);
 }
+EXPORT_SYMBOL_GPL(xv_destroy_pool);
 
 /**
  * xv_malloc - Allocate block of given size from pool.
@@ -413,6 +417,7 @@ int xv_malloc(struct xv_pool *pool, u32 size, struct page **page,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(xv_malloc);
 
 /*
  * Free block identified with <page, offset>
@@ -489,6 +494,7 @@ void xv_free(struct xv_pool *pool, struct page *page, u32 offset)
 	put_ptr_atomic(page_start, KM_USER0);
 	spin_unlock(&pool->lock);
 }
+EXPORT_SYMBOL_GPL(xv_free);
 
 u32 xv_get_object_size(void *obj)
 {
@@ -497,6 +503,7 @@ u32 xv_get_object_size(void *obj)
 	blk = (struct block_header *)((char *)(obj) - XV_ALIGN);
 	return blk->size;
 }
+EXPORT_SYMBOL_GPL(xv_get_object_size);
 
 /*
  * Returns total memory used by allocator (userdata + metadata)
@@ -505,3 +512,4 @@ u64 xv_get_total_size_bytes(struct xv_pool *pool)
 {
 	return pool->total_pages << PAGE_SHIFT;
 }
+EXPORT_SYMBOL_GPL(xv_get_total_size_bytes);
-- 
1.7.3.5

