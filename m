Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab2BMOsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:48:32 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:53156 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2BMOsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:48:30 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
Subject: [PATCH] staging: fix powerpc linux-next break on zsmalloc
Date: Mon, 13 Feb 2012 08:47:49 -0600
Message-Id: <1329144469-8575-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021314-6148-0000-0000-000003654144
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/vmalloc.h added to zsmalloc-main.c to resolve implicit
declaration errors.

X86 dependency added to zsmalloc and dependent drivers zcache and zram.

This X86 only requirement is not ideal.  Working to find portable
functions for __flush_tlb_one and set_pte.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zcache/Kconfig           |    4 +++-
 drivers/staging/zram/Kconfig             |    4 +++-
 drivers/staging/zsmalloc/Kconfig         |    5 ++++-
 drivers/staging/zsmalloc/zsmalloc-main.c |    1 +
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
index 94e48aa..5a36fcf 100644
--- a/drivers/staging/zcache/Kconfig
+++ b/drivers/staging/zcache/Kconfig
@@ -1,6 +1,8 @@
 config ZCACHE
 	tristate "Dynamic compression of swap pages and clean pagecache pages"
-	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO
+	# X86 dependency is because zsmalloc uses non-portable pte/tlb
+	# functions
+	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO && X86
 	select ZSMALLOC
 	select CRYPTO_LZO
 	default n
diff --git a/drivers/staging/zram/Kconfig b/drivers/staging/zram/Kconfig
index ee23a86..9d11a4c 100644
--- a/drivers/staging/zram/Kconfig
+++ b/drivers/staging/zram/Kconfig
@@ -1,6 +1,8 @@
 config ZRAM
 	tristate "Compressed RAM block device support"
-	depends on BLOCK && SYSFS
+	# X86 dependency is because zsmalloc uses non-portable pte/tlb
+	# functions
+	depends on BLOCK && SYSFS && X86
 	select ZSMALLOC
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
diff --git a/drivers/staging/zsmalloc/Kconfig b/drivers/staging/zsmalloc/Kconfig
index 3e7a8d4..8e2c6a0 100644
--- a/drivers/staging/zsmalloc/Kconfig
+++ b/drivers/staging/zsmalloc/Kconfig
@@ -1,6 +1,9 @@
 config ZSMALLOC
 	tristate "Memory allocator for compressed pages"
-	depends on SPARSEMEM
+	# X86 dependency is because of the use of __flush_tlb_one and set_pte
+	# in zsmalloc-main.c.
+	# TODO: convert these to portable functions
+	depends on SPARSEMEM && X86
 	default n
 	help
 	  zsmalloc is a slab-based memory allocator designed to store
diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 189fb42..455fc2f 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -26,6 +26,7 @@
 #include <asm/pgtable.h>
 #include <linux/cpumask.h>
 #include <linux/cpu.h>
+#include <linux/vmalloc.h>
 
 #include "zsmalloc.h"
 #include "zsmalloc_int.h"
-- 
1.7.5.4

