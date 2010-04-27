Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0D0IQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 04:16:42 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35545 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab0D0IQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 04:16:39 -0400
Date: Tue, 27 Apr 2010 10:16:37 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Paolo Minazzi <paolo.minazzi@gmail.com>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] [MTD] Call bdi_init() and bdi_register()
Message-ID: <20100427081636.GD27497@kernel.dk>
References: <20100426094810.GE27497@kernel.dk> <20100426143253.GB4364@logfs.org> <20100426143803.GM27497@kernel.dk> <20100426144532.GN27497@kernel.dk> <20100426163050.GC4364@logfs.org> <20100426163126.GD4364@logfs.org> <20100426170247.GP27497@kernel.dk> <20100426171236.GG4364@logfs.org> <20100427075229.GB27497@kernel.dk> <z2g4aa525de1004270111r8a9a475fna8715219551a889d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <z2g4aa525de1004270111r8a9a475fna8715219551a889d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27 2010, Paolo Minazzi wrote:
> I Jens,
> I'm Paolo Minazzi and I have a problem with logfs and 2.6.34rc5.
> Can I apply the patch to rc5 and make a test on my ARM board ?
> Paolo

Yes please do, below are the collected fixes for mtd in this area. It
should apply to recent -git just fine.

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
index 5b38b17..b177e75 100644
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
@@ -628,20 +659,55 @@ done:
 /*====================================================================*/
 /* Init code */
 
+static int __init mtd_bdi_init(struct backing_dev_info *bdi, const char *name)
+{
+	int ret;
+
+	ret = bdi_init(bdi);
+	if (!ret)
+		ret = bdi_register(bdi, NULL, name);
+
+	if (ret)
+		bdi_destroy(bdi);
+
+	return ret;
+}
+
 static int __init init_mtd(void)
 {
 	int ret;
+
 	ret = class_register(&mtd_class);
+	if (ret)
+		goto err_reg;
+
+	ret = mtd_bdi_init(&mtd_bdi_unmappable, "mtd-unmap");
+	if (ret)
+		goto err_bdi1;
+
+	ret = mtd_bdi_init(&mtd_bdi_ro_mappable, "mtd-romap");
+	if (ret)
+		goto err_bdi2;
+
+	ret = mtd_bdi_init(&mtd_bdi_rw_mappable, "mtd-rwmap");
+	if (ret)
+		goto err_bdi3;
 
-	if (ret) {
-		pr_err("Error registering mtd class: %d\n", ret);
-		return ret;
-	}
 #ifdef CONFIG_PROC_FS
 	if ((proc_mtd = create_proc_entry( "mtd", 0, NULL )))
 		proc_mtd->read_proc = mtd_read_proc;
 #endif /* CONFIG_PROC_FS */
 	return 0;
+
+err_bdi3:
+	bdi_destroy(&mtd_bdi_ro_mappable);
+err_bdi2:
+	bdi_destroy(&mtd_bdi_unmappable);
+err_bdi1:
+	class_unregister(&mtd_class);
+err_reg:
+	pr_err("Error registering mtd class or bdi: %d\n", ret);
+	return ret;
 }
 
 static void __exit cleanup_mtd(void)
@@ -651,6 +717,9 @@ static void __exit cleanup_mtd(void)
 		remove_proc_entry( "mtd", NULL);
 #endif /* CONFIG_PROC_FS */
 	class_unregister(&mtd_class);
+	bdi_destroy(&mtd_bdi_unmappable);
+	bdi_destroy(&mtd_bdi_ro_mappable);
+	bdi_destroy(&mtd_bdi_rw_mappable);
 }
 
 module_init(init_mtd);
diff --git a/drivers/mtd/mtdsuper.c b/drivers/mtd/mtdsuper.c
index af8b42e..7c00319 100644
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -13,6 +13,7 @@
 #include <linux/mtd/super.h>
 #include <linux/namei.h>
 #include <linux/ctype.h>
+#include <linux/slab.h>
 
 /*
  * compare superblocks to see if they're equivalent
@@ -44,6 +45,7 @@ static int get_sb_mtd_set(struct super_block *sb, void *_mtd)
 
 	sb->s_mtd = mtd;
 	sb->s_dev = MKDEV(MTD_BLOCK_MAJOR, mtd->index);
+	sb->s_bdi = mtd->backing_dev_info;
 	return 0;
 }
 


-- 
Jens Axboe

