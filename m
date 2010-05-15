Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab0EOBmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 21:42:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57074 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab0EOBmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 21:42:16 -0400
From: Will Drewry <wad@chromium.org>
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: agk@redhat.com, snitzer@redhat.com, Will Drewry <wad@chromium.org>
Subject: [RFC PATCH v2 2/2] init: boot to device-mapper targets without an initr*
Date: Fri, 14 May 2010 20:41:41 -0500
Message-Id: <1273887701-2152-2-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20100514035347.GA20636@redhat.com>
References: <20100514035347.GA20636@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dm= kernel parameter modeled after the md= parameter from
do_mounts_md.  It allows for device-mapper targets to be configured at
boot time for use early in the boot process (as the root device or
otherwise).

The format is dm="name uuid ro,table line 1,table line 2,...".  The
parser expects the comma to be safe to use as a newline substitute but,
otherwise, uses the normal separator of space.  Some attempt has been
made to make it forgiving of additional spaces (using skip_spaces()).

A mapped device created during boot will be assigned a minor of 0 and
may be access via /dev/dm-0.

An example dm-linear root with no uuid may look like:

  root=/dev/dm-0  dm="lroot none 0, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 0"

Once udev is started, /dev/dm-0 will become /dev/mapper/lroot.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 init/Makefile       |    1 +
 init/do_mounts.c    |    1 +
 init/do_mounts.h    |   10 ++
 init/do_mounts_dm.c |  353 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 365 insertions(+), 0 deletions(-)
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
index 0000000..7b188e2
--- /dev/null
+++ b/init/do_mounts_dm.c
@@ -0,0 +1,353 @@
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
+#define DM_MAX_NAME 32
+#define DM_MAX_UUID 129
+#define DM_NO_UUID "none"
+
+#define DM_MSG_PREFIX "init"
+
+/* Separators used for parsing the dm= argument. */
+#define DM_FIELD_SEP ' '
+#define DM_LINE_SEP ','
+
+/*
+ * When the device-mapper and any targets are compiled into the kernel
+ * (not a module), one target may be created and used as the root device at
+ * boot time with the parameters given with the boot line dm=...
+ * The code for that is here.
+ */
+
+struct dm_setup_target {
+	sector_t begin;
+	sector_t length;
+	char *type;
+	char *params;
+	/* simple singly linked list */
+	struct dm_setup_target *next;
+};
+
+static struct {
+	int minor;
+	int ro;
+	char name[DM_MAX_NAME];
+	char uuid[DM_MAX_UUID];
+	char *targets;
+	struct dm_setup_target *target;
+	int target_count;
+} dm_setup_args __initdata;
+
+static __initdata int dm_early_setup = 0;
+
+static size_t __init get_dm_option(char *str, char **next, char sep)
+{
+	size_t len = 0;
+	char *endp = NULL;
+
+	if (!str)
+		return 0;
+
+	endp = strchr(str, sep);
+	if (!endp) {  /* act like strchrnul */
+		len = strlen(str);
+		endp = str + len;
+	} else {
+		len = endp - str;
+	}
+
+	if (endp == str)
+		return 0;
+
+	if (!next)
+		return len;
+
+	if (*endp == 0) {
+		/* Don't advance past the nul. */
+		*next = endp;
+	} else {
+		*next = endp + 1;
+	}
+	return len;
+}
+
+static int __init dm_setup_args_init(void)
+{
+	dm_setup_args.minor = 0;
+	dm_setup_args.ro = 0;
+	dm_setup_args.target = NULL;
+	dm_setup_args.target_count = 0;
+	return 0;
+}
+
+static int __init dm_setup_cleanup(void)
+{
+	struct dm_setup_target *target = dm_setup_args.target;
+	struct dm_setup_target *old_target = NULL;
+	while (target) {
+		if (target->type)
+			kfree(target->type);
+		if (target->params)
+			kfree(target->params);
+		old_target = target;
+		target = target->next;
+		kfree(old_target);
+		dm_setup_args.target_count--;
+	}
+	BUG_ON(dm_setup_args.target_count);
+	return 0;
+}
+
+static char * __init dm_setup_parse_device_args(char *str)
+{
+	char *next = NULL;
+	size_t len = 0;
+
+	/* Grab the logical name of the device to be exported to udev */
+	len = get_dm_option(str, &next, DM_FIELD_SEP);
+	if (!len) {
+		DMERR("failed to parse device name");
+		goto parse_fail;
+	}
+	len = min(len + 1, sizeof(dm_setup_args.name));
+	strlcpy(dm_setup_args.name, str, len + 1);  /* includes nul */
+	str = skip_spaces(next);
+
+	/* Grab the UUID value or "none" */
+	len = get_dm_option(str, &next, DM_FIELD_SEP);
+	if (!len) {
+		DMERR("failed to parse device uuid");
+		goto parse_fail;
+	}
+	len = min(len + 1, sizeof(dm_setup_args.uuid));
+	strlcpy(dm_setup_args.uuid, str, len);
+	str = skip_spaces(next);
+
+	/* If ro is non-zero, the table will be create FMODE_READ. */
+	if (*str++ != '0')
+		dm_setup_args.ro = 1;
+	if (*str++ != ',') {
+		DMERR("failed to parse table mode");
+		goto parse_fail;
+	}
+	str = skip_spaces(str);
+
+	return str;
+
+parse_fail:
+	return NULL;
+}
+
+static int __init dm_setup_parse_targets(char *str)
+{
+	char *next = NULL;
+	size_t len = 0;
+	struct dm_setup_target **target = NULL;
+
+	/* Targets are defined as per the table format but with a
+	 * comma as a newline separator. */
+	target = &dm_setup_args.target;
+	while (str && *str) {
+		*target = kzalloc(sizeof(struct dm_setup_target), GFP_KERNEL);
+		if (!*target) {
+			DMERR("failed to allocate memory for target %d",
+			      dm_setup_args.target_count);
+			goto parse_fail;
+		}
+		dm_setup_args.target_count++;
+
+		(*target)->begin = simple_strtoull(str, &next, 10);
+		if (!next || *next != DM_FIELD_SEP) {
+			DMERR("failed to parse starting sector for target %d",
+			      dm_setup_args.target_count - 1);
+			goto parse_fail;
+		}
+		str = skip_spaces(next + 1);
+
+		(*target)->length = simple_strtoull(str, &next, 10);
+		if (!next || *next != DM_FIELD_SEP) {
+			DMERR("failed to parse length for target %d",
+			      dm_setup_args.target_count - 1);
+			goto parse_fail;
+		}
+		str = skip_spaces(next + 1);
+
+		len = get_dm_option(str, &next, DM_FIELD_SEP);
+		if (!len ||
+		    !((*target)->type = kstrndup(str, len, GFP_KERNEL))) {
+			DMERR("failed to parse type for target %d",
+			      dm_setup_args.target_count - 1);
+			goto parse_fail;
+		}
+		str = skip_spaces(next);
+
+		len = get_dm_option(str, &next, DM_LINE_SEP);
+		if (!len ||
+		    !((*target)->params = kstrndup(str, len, GFP_KERNEL))) {
+			DMERR("failed to parse params for target %d",
+			      dm_setup_args.target_count - 1);
+			goto parse_fail;
+		}
+		str = skip_spaces(next);
+
+		target = &((*target)->next);
+	}
+	DMDEBUG("parsed %d targets", dm_setup_args.target_count);
+
+	return 0;
+
+parse_fail:
+	return 1;
+}
+
+/*
+ * Parse the command-line parameters given our kernel, but do not
+ * actually try to invoke the DM device now; that is handled by
+ * dm_setup_drive after the low-level disk drivers have initialised.
+ * dm format is as follows:
+ *  dm="name uuid fmode,[table line 1],[table line 2],..."
+ * May be used with root=/dev/dm-0 as it always uses the first dm minor.
+ */
+
+static int __init dm_setup(char *str)
+{
+	dm_setup_args_init();
+
+	str = dm_setup_parse_device_args(str);
+	if (!str) {
+		DMDEBUG("str is NULL");
+		goto parse_fail;
+	}
+
+	/* Target parsing is delayed until we have dynamic memory */
+	dm_setup_args.targets = str;
+
+	printk(KERN_INFO "dm: will configure '%s' on dm-%d\n",
+	       dm_setup_args.name, dm_setup_args.minor);
+
+	dm_early_setup = 1;
+	return 1;
+
+parse_fail:
+	printk(KERN_WARNING "dm: Invalid arguments supplied to dm=.\n");
+	return 0;
+}
+
+
+static void __init dm_setup_drive(void)
+{
+	struct mapped_device *md = NULL;
+	struct dm_table *table = NULL;
+	struct dm_setup_target *target;
+	char *uuid = dm_setup_args.uuid;
+	fmode_t fmode = FMODE_READ;
+
+	/* Finish parsing the targets. */
+	if (dm_setup_parse_targets(dm_setup_args.targets)) {
+		goto parse_fail;
+	}
+
+	if (dm_create(dm_setup_args.minor, &md)) {
+		DMDEBUG("failed to create the device");
+		goto dm_create_fail;
+	}
+	DMDEBUG("created device '%s'", dm_device_name(md));
+
+	/* In addition to flagging the table below, the disk must be
+	 * set explicitly ro/rw. */
+	if (dm_setup_args.ro) {
+		set_disk_ro(dm_disk(md), 1);
+	} else {
+		set_disk_ro(dm_disk(md), 0);
+	}
+
+	fmode |= (dm_setup_args.ro ? 0 : FMODE_WRITE);
+	if (dm_table_create(&table, fmode, dm_setup_args.target_count, md)) {
+		DMDEBUG("failed to create the table");
+		goto dm_table_create_fail;
+	}
+
+	target = dm_setup_args.target;
+	while (target) {
+		DMINFO("adding target '%llu %llu %s %s'",
+		       (unsigned long long) target->begin,
+		       (unsigned long long) target->length, target->type,
+		       target->params);
+		if (dm_table_add_target(table, target->type, target->begin,
+					target->length, target->params)) {
+			DMDEBUG("failed to add the target to the table");
+			goto add_target_fail;
+		}
+		target = target->next;
+	}
+
+	if (dm_table_complete(table)) {
+		DMDEBUG("failed to complete the table");
+		goto table_complete_fail;
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
+	if (dm_swap_table(md, table)) {  /* should return NULL. */
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
+	/* Export the dm device via the ioctl interface */
+	if (!strcmp(DM_NO_UUID, dm_setup_args.uuid))
+		uuid = NULL;
+	if (dm_ioctl_export(md, dm_setup_args.name, uuid)) {
+		DMDEBUG("failed to export device with given name and uuid");
+		goto export_fail;
+	}
+	printk(KERN_INFO "dm: dm-%d is ready\n", dm_setup_args.minor);
+
+	dm_setup_cleanup();
+	return;
+
+export_fail:
+resume_fail:
+table_bind_fail:
+suspend_fail:
+table_complete_fail:
+add_target_fail:
+	dm_table_put(table);
+dm_table_create_fail:
+	dm_put(md);
+dm_create_fail:
+	dm_setup_cleanup();
+parse_fail:
+	printk(KERN_WARNING "dm: starting dm-%d (%s) failed\n",
+	       dm_setup_args.minor, dm_setup_args.name);
+}
+
+__setup("dm=", dm_setup);
+
+void __init dm_run_setup(void)
+{
+	if (!dm_early_setup)
+		return;
+	printk(KERN_INFO "dm: attempting early device configuration.\n");
+	dm_setup_drive();
+}
-- 
1.7.0.4

