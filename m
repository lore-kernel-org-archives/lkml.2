Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab0JVSZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:25:27 -0400
Received: from kroah.org ([198.145.64.141]:37755 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758901Ab0JVSZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:20 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, linux-acpi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/31] Dynamic Debug: Initialize dynamic debug earlier via arch_initcall
Date: Fri, 22 Oct 2010 11:24:48 -0700
Message-Id: <1287771916-15016-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Renninger <trenn@suse.de>

Having the ddebug_query= boot parameter it makes sense to set up
dynamic debug as soon as possible.

I expect sysfs files cannot be set up via an arch_initcall, because
this one is even before fs_initcall. Therefore I splitted the
dynamic_debug_init function into an early one and a later one providing
/sys/../dynamic_debug/control file.

Possibly dynamic_debug can be initialized even earlier, not sure whether
this still makes sense then. I picked up arch_initcall as it covers
quite a lot already.

Dynamic debug needs to allocate memory, therefore it's not easily possible to
set it up even before the command line gets parsed.
Therefore the boot param query string is stored in a temp string which is
applied when dynamic debug gets set up.

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
Acked-by: jbaron@redhat.com
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
CC: linux-acpi@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/dynamic_debug.c |   33 +++++++++++++++++++++++----------
 1 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 44ce66b..a687d90 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -748,13 +748,14 @@ static void ddebug_remove_all_tables(void)
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
@@ -765,6 +766,16 @@ static int __init dynamic_debug_init(void)
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
@@ -795,11 +806,13 @@ static int __init dynamic_debug_init(void)
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
-- 
1.7.2

