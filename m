Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab0GTNrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 09:47:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:58292 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695Ab0GTNrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 09:47:31 -0400
Message-Id: <20100720134730.081078353@ett.arch.suse.de>
User-Agent: quilt/0.47-15.10
Date: Tue, 20 Jul 2010 15:44:50 +0200
From: trenn@suse.de
To: jbaron@redhat.com
Cc: trenn@suse.de, linux-kernel@vger.kernel.org, yehuda@hq.newdream.net,
        astarikovskiy@novell.com
Subject: [patch 3/3] Dynamic Debug: Initialize dynamic debug earlier via arch_initcall
References: <20100720134447.983521886@ett.arch.suse.de>
Content-Disposition: inline; filename=patches.drivers/dynamic_debug_make_arch_initcall.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having the ddebug_query= boot parameter it makes sense to set up
dynamic debug as soon as possible.

I expect sysfs files cannot be set up via an arch_initcall, because
this one is even before fs_initcall. Therefore I splitted the
dynamic_debug_init function into an early one and a later one providing
/sys/../dynamic_debug/control file.

Possibly dynamic_debug can be initialized even earlier, not sure whether
this still makes sense then. I picked up arch_initcall as it covers
quite a lot already.

Dynamic debug seem to not need memory (kmalloc) set up yet.
If it is possible to move initialization even before __setup boot
parameter processing, the temporary variable to copy away the boot paramter
and later use it in dynamic_debug_init() is not needed anymore.

This has been tested with ddebug_query="file ec.c +p"
and I could retrieve pr_debug() messages early at boot during ACPI setup:
ACPI: EC: Look up EC in DSDT
ACPI: EC: ---> status = 0x08
ACPI: EC: transaction start
ACPI: EC: <--- command = 0x80
ACPI: EC: ~~~> interrupt
ACPI: EC: ---> status = 0x08
ACPI: EC: <--- data = 0xa4
...
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: ---> status = 0x00
ACPI: EC: transaction start
ACPI: EC: <--- command = 0x80


Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: jbaron@redhat.com
CC: linux-kernel@vger.kernel.org
CC: yehuda@hq.newdream.net
CC: astarikovskiy@novell.com


---
 lib/dynamic_debug.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

Index: linux-2.6.34-master/lib/dynamic_debug.c
===================================================================
--- linux-2.6.34-master.orig/lib/dynamic_debug.c
+++ linux-2.6.34-master/lib/dynamic_debug.c
@@ -748,13 +748,14 @@ static void ddebug_remove_all_tables(voi
 	mutex_unlock(&ddebug_lock);
 }
 
-static int __init dynamic_debug_init(void)
+static __initdata int ddebug_init_success;
+
+static int __init dynamic_debug_init_debugfs(void)
 {
 	struct dentry *dir, *file;
-	struct _ddebug *iter, *iter_start;
-	const char *modname = NULL;
-	int ret = 0;
-	int n = 0;
+
+	if (!ddebug_init_success)
+		return -ENODEV;
 
 	dir = debugfs_create_dir("dynamic_debug", NULL);
 	if (!dir)
@@ -765,6 +766,16 @@ static int __init dynamic_debug_init(voi
 		debugfs_remove(dir);
 		return -ENOMEM;
 	}
+	return 0;
+}
+
+static int __init dynamic_debug_init(void)
+{
+	struct _ddebug *iter, *iter_start;
+	const char *modname = NULL;
+	int ret = 0;
+	int n = 0;
+
 	if (__start___verbose != __stop___verbose) {
 		iter = __start___verbose;
 		modname = iter->modname;
@@ -795,11 +806,13 @@ static int __init dynamic_debug_init(voi
 	}
 
 out_free:
-	if (ret) {
+	if (ret)
 		ddebug_remove_all_tables();
-		debugfs_remove(dir);
-		debugfs_remove(file);
-	}
+	else
+		ddebug_init_success = 1;
 	return 0;
 }
-module_init(dynamic_debug_init);
+/* Allow early initialization for boot messages via boot param */
+arch_initcall(dynamic_debug_init);
+/* Debugfs setup must be done later */
+module_init(dynamic_debug_init_debugfs);

