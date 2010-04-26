Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab0DZQbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 12:31:11 -0400
Received: from lazybastard.de ([212.112.238.170]:35501 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab0DZQbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 12:31:09 -0400
Date: Mon, 26 Apr 2010 18:30:51 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Paolo Minazzi <paolo.minazzi@gmail.com>
Subject: [PATCH 1/2] [MTD] Move mtd_bdi_*mappable to mtdcore.c
Message-ID: <20100426163050.GC4364@logfs.org>
References: <alpine.LFD.2.00.1004220724170.9086@i5.linux-foundation.org> <alpine.LFD.2.00.1004220730280.9086@i5.linux-foundation.org> <20100422162709.GJ27497@kernel.dk> <20100422203358.GB30749@logfs.org> <20100423100532.GN27497@kernel.dk> <20100423205518.GB7008@logfs.org> <20100426094810.GE27497@kernel.dk> <20100426143253.GB4364@logfs.org> <20100426143803.GM27497@kernel.dk> <20100426144532.GN27497@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100426144532.GN27497@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 April 2010 16:45:32 +0200, Jens Axboe wrote:
> 
> Took a quick look, and you want bdi_setup_and_register() for the three
> bdis listed in mtdbdi.c in mtdcore.c:init_mtd(). Or manual bdi_init()
> and bdi_register(). I'll take a look post-dinner. Either is workable,
> but since the flags are already setup, the latter may be cleaner.

Ok, here are two patches that appear to solve the problem for me.

Jörn

-- 
Courage is not the absence of fear, but rather the judgement that
something else is more important than fear.
-- Ambrose Redmoon

Removes one .h and one .c file that are never used outside of
mtdcore.c.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/mtd/Makefile        |    2 +-
 drivers/mtd/devices/drais.c |    2 +-
 drivers/mtd/internal.h      |   17 -----------------
 drivers/mtd/mtdbdi.c        |   43 -------------------------------------------
 drivers/mtd/mtdcore.c       |   33 ++++++++++++++++++++++++++++++++-
 5 files changed, 34 insertions(+), 63 deletions(-)

diff --git a/drivers/mtd/Makefile b/drivers/mtd/Makefile
index 82d1e4d..4521b1e 100644
--- a/drivers/mtd/Makefile
+++ b/drivers/mtd/Makefile
@@ -4,7 +4,7 @@
 
 # Core functionality.
 obj-$(CONFIG_MTD)		+= mtd.o
-mtd-y				:= mtdcore.o mtdsuper.o mtdbdi.o
+mtd-y				:= mtdcore.o mtdsuper.o
 mtd-$(CONFIG_MTD_PARTITIONS)	+= mtdpart.o
 
 obj-$(CONFIG_MTD_CONCAT)	+= mtdconcat.o
diff --git a/drivers/mtd/devices/drais.c b/drivers/mtd/devices/drais.c
index b93ff3f..6f81b28 100644
--- a/drivers/mtd/devices/drais.c
+++ b/drivers/mtd/devices/drais.c
@@ -33,7 +33,7 @@
 #include <linux/sched.h>
 #include "drais.h"
 
-#undef DEBUG_ERASE
+#define DEBUG_ERASE
 
 #define DRAIS_BB_MAGIC		0x3911b26ba5a931d8ull
 
diff --git a/drivers/mtd/internal.h b/drivers/mtd/internal.h
index c658fe7..e69de29 100644
--- a/drivers/mtd/internal.h
+++ b/drivers/mtd/internal.h
@@ -1,17 +0,0 @@
-/* Internal MTD definitions
- *
- * Copyright © 2006 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-/*
- * mtdbdi.c
- */
-extern struct backing_dev_info mtd_bdi_unmappable;
-extern struct backing_dev_info mtd_bdi_ro_mappable;
-extern struct backing_dev_info mtd_bdi_rw_mappable;
diff --git a/drivers/mtd/mtdbdi.c b/drivers/mtd/mtdbdi.c
index 5ca5aed..e69de29 100644
--- a/drivers/mtd/mtdbdi.c
+++ b/drivers/mtd/mtdbdi.c
@@ -1,43 +0,0 @@
-/* MTD backing device capabilities
- *
- * Copyright © 2006 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#include <linux/backing-dev.h>
-#include <linux/mtd/mtd.h>
-#include "internal.h"
-
-/*
- * backing device capabilities for non-mappable devices (such as NAND flash)
- * - permits private mappings, copies are taken of the data
- */
-struct backing_dev_info mtd_bdi_unmappable = {
-	.capabilities	= BDI_CAP_MAP_COPY,
-};
-
-/*
- * backing device capabilities for R/O mappable devices (such as ROM)
- * - permits private mappings, copies are taken of the data
- * - permits non-writable shared mappings
- */
-struct backing_dev_info mtd_bdi_ro_mappable = {
-	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
-			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP),
-};
-
-/*
- * backing device capabilities for writable mappable devices (such as RAM)
- * - permits private mappings, copies are taken of the data
- * - permits non-writable shared mappings
- */
-struct backing_dev_info mtd_bdi_rw_mappable = {
-	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
-			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP |
-			   BDI_CAP_WRITE_MAP),
-};
diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 05b9577..cb4858b 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -2,6 +2,9 @@
  * Core registration and callback routines for MTD
  * drivers and users.
  *
+ * bdi bits are:
+ * Copyright © 2006 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
  */
 
 #include <linux/module.h>
@@ -16,11 +19,39 @@
 #include <linux/init.h>
 #include <linux/mtd/compatmac.h>
 #include <linux/proc_fs.h>
+#include <linux/backing-dev.h>
 
 #include <linux/mtd/mtd.h>
-#include "internal.h"
 
 #include "mtdcore.h"
+/*
+ * backing device capabilities for non-mappable devices (such as NAND flash)
+ * - permits private mappings, copies are taken of the data
+ */
+struct backing_dev_info mtd_bdi_unmappable = {
+	.capabilities	= BDI_CAP_MAP_COPY,
+};
+
+/*
+ * backing device capabilities for R/O mappable devices (such as ROM)
+ * - permits private mappings, copies are taken of the data
+ * - permits non-writable shared mappings
+ */
+struct backing_dev_info mtd_bdi_ro_mappable = {
+	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
+			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP),
+};
+
+/*
+ * backing device capabilities for writable mappable devices (such as RAM)
+ * - permits private mappings, copies are taken of the data
+ * - permits non-writable shared mappings
+ */
+struct backing_dev_info mtd_bdi_rw_mappable = {
+	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
+			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP |
+			   BDI_CAP_WRITE_MAP),
+};
 
 static int mtd_cls_suspend(struct device *dev, pm_message_t state);
 static int mtd_cls_resume(struct device *dev);
-- 
1.6.2.1

