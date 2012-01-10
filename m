Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab2AJAy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 19:54:28 -0500
Received: from mail-yx0-f202.google.com ([209.85.213.202]:45303 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab2AJAy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 19:54:27 -0500
From: Doug Anderson <dianders@chromium.org>
To: devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Doug Anderson <dianders@chromium.org>,
        devicetree-discuss@lists-ozlabs.org
Subject: [PATCH] of: Support CONFIG_CMDLINE_EXTEND config option
Date: Mon,  9 Jan 2012 16:54:13 -0800
Message-Id: <1326156853-24840-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old logic assumes CMDLINE_FROM_BOOTLOADER vs. CMDLINE_FORCE and
ignores CMDLINE_EXTEND.  Here's the old logic:

- CONFIG_CMDLINE_FORCE=true
    CONFIG_CMDLINE
- dt bootargs=non-empty:
    dt bootargs
- dt bootargs=empty, @data is non-empty string
    @data is left unchanged
- dt bootargs=empty, @data is empty string
    CONFIG_CMDLINE (or "" if that's not defined)

The old logic would also not honor CONFIG_CMDLINE_FORCE if there was no
"chosen" attribute in the device tree.

The new logic is now documented in of_fdt.h and is copied here for
reference:

- CONFIG_CMDLINE_FORCE=true
    CONFIG_CMDLINE
- CONFIG_CMDLINE_EXTEND=true
    CONFIG_CMDLINE + dt bootargs (even if dt bootargs are empty)
- CMDLINE_FROM_BOOTLOADER=true, dt bootargs=non-empty:
    dt bootargs
- CMDLINE_FROM_BOOTLOADER=true, dt bootargs=empty, @data is non-empty string
    @data is left unchanged
- CMDLINE_FROM_BOOTLOADER=true, dt bootargs=empty, @data is empty string
    CONFIG_CMDLINE (or "" if that's not defined)

Signed-off-by: Doug Anderson <dianders@chromium.org>
CC: devicetree-discuss@lists-ozlabs.org
CC: Grant Likely <grant.likely@secretlab.ca>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 drivers/of/fdt.c       |   56 ++++++++++++++++++++++++++++++++++-------------
 include/linux/of_fdt.h |   19 ++++++++++++++++
 2 files changed, 59 insertions(+), 16 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index ea2bd1b..577f3a9 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -664,6 +664,29 @@ int __init early_init_dt_scan_memory(unsigned long node, const char *uname,
 	return 0;
 }
 
+/*
+ * Convert configs to something easy to use in C code
+ */
+#if defined(CONFIG_CMDLINE_FORCE)
+static const int overwrite_incoming_cmdline = 1;
+static const int read_dt_cmdline;
+static const int concat_cmdline;
+#elif defined(CONFIG_CMDLINE_EXTEND)
+static const int overwrite_incoming_cmdline = 1;
+static const int read_dt_cmdline = 1;
+static const int concat_cmdline = 1;
+#else /* CMDLINE_FROM_BOOTLOADER */
+static const int overwrite_incoming_cmdline;
+static const int read_dt_cmdline = 1;
+static const int concat_cmdline;
+#endif
+
+#ifdef CONFIG_CMDLINE
+static const char *config_cmdline = CONFIG_CMDLINE;
+#else
+static const char *config_cmdline = "";
+#endif
+
 int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 				     int depth, void *data)
 {
@@ -672,28 +695,29 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 
 	pr_debug("search \"chosen\", depth: %d, uname: %s\n", depth, uname);
 
+	/* Make sure cmdline default is set early to handle case of no chosen */
+	if (data && (overwrite_incoming_cmdline || !((char *)data)[0]))
+		strlcpy(data, config_cmdline, COMMAND_LINE_SIZE);
+
 	if (depth != 1 || !data ||
 	    (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
 		return 0;
 
 	early_init_dt_check_for_initrd(node);
 
-	/* Retrieve command line */
-	p = of_get_flat_dt_prop(node, "bootargs", &l);
-	if (p != NULL && l > 0)
-		strlcpy(data, p, min((int)l, COMMAND_LINE_SIZE));
-
-	/*
-	 * CONFIG_CMDLINE is meant to be a default in case nothing else
-	 * managed to set the command line, unless CONFIG_CMDLINE_FORCE
-	 * is set in which case we override whatever was found earlier.
-	 */
-#ifdef CONFIG_CMDLINE
-#ifndef CONFIG_CMDLINE_FORCE
-	if (!((char *)data)[0])
-#endif
-		strlcpy(data, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
-#endif /* CONFIG_CMDLINE */
+	/* Retrieve command line unless forcing */
+	if (read_dt_cmdline) {
+		p = of_get_flat_dt_prop(node, "bootargs", &l);
+		if (p != NULL && l > 0) {
+			if (concat_cmdline) {
+				strlcat(data, " ", COMMAND_LINE_SIZE);
+				strlcat(data, p, min_t(int, (int)l,
+						       COMMAND_LINE_SIZE));
+			} else
+				strlcpy(data, p, min_t(int, (int)l,
+						       COMMAND_LINE_SIZE));
+		}
+	}
 
 	pr_debug("Command line is: %s\n", (char*)data);
 
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index ed136ad..346d6c7 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -91,6 +91,25 @@ extern int of_flat_dt_is_compatible(unsigned long node, const char *name);
 extern int of_flat_dt_match(unsigned long node, const char *const *matches);
 extern unsigned long of_get_flat_dt_root(void);
 
+/*
+ * early_init_dt_scan_chosen - scan the device tree for ramdisk and bootargs
+ *
+ * The boot arguments will be placed into the memory pointed to by @data.
+ * That memory should be COMMAND_LINE_SIZE big and initialized to be a valid
+ * (possibly empty) string.  Logic for what will be in @data after this
+ * function finishes:
+ *
+ * - CONFIG_CMDLINE_FORCE=true
+ *     CONFIG_CMDLINE
+ * - CONFIG_CMDLINE_EXTEND=true
+ *     CONFIG_CMDLINE + dt bootargs (even if dt bootargs are empty)
+ * - CMDLINE_FROM_BOOTLOADER=true, dt bootargs=non-empty:
+ *     dt bootargs
+ * - CMDLINE_FROM_BOOTLOADER=true, dt bootargs=empty, @data is non-empty string
+ *     @data is left unchanged
+ * - CMDLINE_FROM_BOOTLOADER=true, dt bootargs=empty, @data is empty string
+ *     CONFIG_CMDLINE (or "" if that's not defined)
+ */
 extern int early_init_dt_scan_chosen(unsigned long node, const char *uname,
 				     int depth, void *data);
 extern void early_init_dt_check_for_initrd(unsigned long node);
-- 
1.7.3.1

