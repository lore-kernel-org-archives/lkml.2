Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab0ELUbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 16:31:23 -0400
Received: from mail-qy0-f171.google.com ([209.85.221.171]:39556 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183Ab0ELUbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 16:31:21 -0400
Date: Wed, 12 May 2010 15:30:54 -0500
From: Will Drewry <wad@chromium.org>
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH] init: boot to device-mapper targets without an initr*
Message-ID: <20100512203054.GA22104@z600>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds a dm= kernel parameter modeled after the md=
parameter from do_mounts_md.  It allows for simple device-mapper
targets to be configured at boot time for use early in the boot
process (as the root device or otherwise).

The format is dm=minor,rwmode,begin,length,target,target,params,with,commas
And may be used as root with dm.major=MAJOR root=MAJOR:minor.

Ideally, the prototypes from dm.h in do_mounts_dm.c could reside in
include/linux/device-mapper.h, or do_mounts_dm.c could pull in
drivers/md/dm.h.  Any preferences there or thoughts on how likely this
is to be an acceptable addition to the boot path are appreciated.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 init/Makefile       |    1 +
 init/do_mounts.c    |    1 +
 init/do_mounts.h    |   10 +++
 init/do_mounts_dm.c |  203 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 215 insertions(+), 0 deletions(-)
 create mode 100644 init/do_mounts_dm.c

diff --git a/init/Makefile b/init/Makefile
index 0bf677a..1677baa 100644
--- a/init/Makefile
+++ b/init/Makefile
@@ -14,6 +14,7 @@ mounts-y			:= do_mounts.o
 mounts-$(CONFIG_BLK_DEV_RAM)	+= do_mounts_rd.o
 mounts-$(CONFIG_BLK_DEV_INITRD)	+= do_mounts_initrd.o
 mounts-$(CONFIG_BLK_DEV_MD)	+= do_mounts_md.o
+mounts-$(CONFIG_BLK_DEV_DM)	+= do_mounts_dm.o
 
 # dependencies on generated files need to be listed explicitly
 $(obj)/version.o: include/generated/compile.h
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 02e3ca4..0848a5b 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -383,6 +383,7 @@ void __init prepare_namespace(void)
 	wait_for_device_probe();
 
 	md_run_setup();
+	dm_run_setup();
 
 	if (saved_root_name[0]) {
 		root_device_name = saved_root_name;
diff --git a/init/do_mounts.h b/init/do_mounts.h
index f5b978a..09d2286 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -74,3 +74,13 @@ void md_run_setup(void);
 static inline void md_run_setup(void) {}
 
 #endif
+
+#ifdef CONFIG_BLK_DEV_DM
+
+void dm_run_setup(void);
+
+#else
+
+static inline void dm_run_setup(void) {}
+
+#endif
diff --git a/init/do_mounts_dm.c b/init/do_mounts_dm.c
new file mode 100644
index 0000000..3db4219
--- /dev/null
+++ b/init/do_mounts_dm.c
@@ -0,0 +1,203 @@
+/* do_mounts_dm.c
+ * Copyright (C) 2010 The Chromium OS Authors <chromium-os-dev@chromium.org>
+ *                    All Rights Reserved.
+ * Based on do_mounts_md.c
+ *
+ * This file is released under the GPL.
+ */
+#include <linux/device-mapper.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+
+#include "do_mounts.h"
+
+/*
+ * When the device-mapper and any targets are compiled into the kernel
+ * (not a module), one target may be created and used as the root device at
+ * boot time with the parameters given with the boot line dm=...
+ * The code for that is here.
+ */
+
+static struct {
+	int minor;
+	int rw;
+	sector_t begin;
+	sector_t length;
+	char target[24];
+	char target_params[256];
+} dm_setup_args __initdata;
+
+static __initdata int dm_root = 0;
+
+
+/*
+ * Parse the command-line parameters given our kernel, but do not
+ * actually try to invoke the DM device now; that is handled by
+ * dm_setup_drive after the low-level disk drivers have initialised.
+ * dm format is as follows:
+ *    dm=dev_minor,rw,start,length,target,comma,separated,target,params
+ * May be used with dm.major=X root=X:minor
+ */
+
+static int __init dm_setup(char *str)
+{
+	char *endp = NULL;
+	if (get_option(&str, &dm_setup_args.minor) != 2)  /* DM Number */
+		goto parse_fail;
+
+	if (get_option(&str, &dm_setup_args.rw) != 2)  /* rw or ro */
+		goto parse_fail;
+
+	dm_setup_args.begin = simple_strtoull(str, &endp, 10);
+	if (!endp || *endp == 0)
+		goto parse_fail;
+	str = endp + 1;	 /* consume the comma */
+
+	dm_setup_args.length = simple_strtoull(str, &endp, 10);
+	if (!endp || *endp == 0)
+		goto parse_fail;
+
+	str = endp + 1;	 /* consume the comma */
+
+	endp = strchr(str, ',');
+
+	/* May be NULL if the target takes no parameters */
+	if (endp)
+		*endp = '\0';
+	if (strlcpy(dm_setup_args.target, str, sizeof(dm_setup_args.target)) ==
+	    sizeof(dm_setup_args.target) - 1) {
+		printk(KERN_WARNING "dm: Target name may be truncated.\n");
+		/* Continue anyway */
+	}
+	/* If no trailing comma was found, that's it. */
+	if (!endp)
+		goto parsed;
+	str = endp + 1;
+
+	/* The remainder will be the target parameters. */
+	if (strlcpy(dm_setup_args.target_params, str,
+		    sizeof(dm_setup_args.target_params)) ==
+		    sizeof(dm_setup_args.target_params) - 1) {
+		printk(KERN_WARNING
+		       "dm: Target parameters may be truncated.\n");
+		/* Continue anyway */
+	}
+
+	/* Replace all commas with spaces to match the expected format */
+	str = dm_setup_args.target_params;
+	while (str && *str) {
+		endp = strchr(str, ',');
+		if (endp)
+			*endp++ = ' ';
+		str = endp;
+	}
+
+parsed:
+	printk(KERN_INFO "dm: Will configure '%s' on dm-%d using params '%s'\n",
+	       dm_setup_args.target, dm_setup_args.minor,
+	       dm_setup_args.target_params);
+
+	dm_root = 1;
+	return 1;
+
+parse_fail:
+	printk(KERN_WARNING "dm: Too few arguments supplied to dm=.\n");
+	return 0;
+}
+
+/* From drivers/md/dm.h */
+#define DM_SUSPEND_NOFLUSH_FLAG         (1 << 1)
+int dm_table_alloc_md_mempools(struct dm_table *t);
+int dm_table_set_type(struct dm_table *t);
+
+static void __init dm_setup_drive(void)
+{
+	struct mapped_device *md = NULL;
+	struct dm_table *table = NULL;
+	fmode_t fmode;
+
+	if (dm_create(dm_setup_args.minor, &md)) {
+		DMDEBUG("failed to create the device");
+		goto dm_create_fail;
+	}
+	DMDEBUG("created device '%s'", dm_device_name(md));
+
+	fmode = (dm_setup_args.rw ? FMODE_READ|FMODE_WRITE : FMODE_READ);
+	if (dm_table_create(&table, fmode, 1, md)) {
+		DMDEBUG("failed to create the table");
+		goto dm_table_create_fail;
+	}
+
+	if (dm_table_add_target(table, dm_setup_args.target,
+				dm_setup_args.begin, dm_setup_args.length,
+				dm_setup_args.target_params)) {
+		DMDEBUG("failed to add the target to the table");
+		goto add_target_fail;
+	}
+
+	if (dm_table_complete(table)) {
+		DMDEBUG("failed to complete the table");
+		goto table_complete_fail;
+	}
+
+	/* Set the type (request v bio) based on the target */
+	if (dm_table_set_type(table)) {
+		DMDEBUG("failed to set table type");
+		goto set_type_fail;
+	}
+
+	/* Allocate pools for handling incoming requests */
+	if (dm_table_alloc_md_mempools(table)) {
+		DMDEBUG("failed to alloc mempools");
+		goto mempool_fail;
+	}
+
+	/* Suspend the device so that we can bind it to the table. */
+	if (dm_suspend(md, DM_SUSPEND_NOFLUSH_FLAG)) {
+		DMDEBUG("failed to suspend the device pre-bind");
+		goto suspend_fail;
+	}
+
+	/* Bind the table to the device. This is the only way to associate
+	 * md->map with the table and set the disk capacity directly. */
+	if (dm_swap_table(md, table)) {
+		DMDEBUG("failed to bind the device to the table");
+		goto table_bind_fail;
+	}
+	
+	/* Finally, resume and the device should be ready. */
+	if (dm_resume(md)) {
+		DMDEBUG("failed to resume the device");
+		goto resume_fail;
+	}
+	
+	printk(KERN_INFO "dm: target '%s' of size %llu on dm-%d is ready\n",
+	       dm_setup_args.target, dm_table_get_size(table),
+	       dm_setup_args.minor);
+
+	return;
+
+resume_fail:
+table_bind_fail:
+suspend_fail:
+mempool_fail:
+set_type_fail:
+table_complete_fail:
+add_target_fail:
+	dm_table_put(table);
+dm_table_create_fail:
+	dm_put(md);
+dm_create_fail:
+	printk(KERN_WARNING "dm: starting dm-%d (%s) failed\n",
+	       dm_setup_args.minor, dm_setup_args.target);
+}
+
+__setup("dm=", dm_setup);
+
+void __init dm_run_setup(void)
+{
+	if (!dm_root)
+		return;
+	printk(KERN_INFO "dm: attempting configuration as root device\n");
+	dm_setup_drive();
+}
-- 
1.6.6.1

