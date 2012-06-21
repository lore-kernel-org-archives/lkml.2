Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024Ab2FUI50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:57:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43119 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758943Ab2FUI5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:57:22 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] ARM: zImage: Allow DTB command line concatenation with ATAG_CMDLINE
Date: Thu, 21 Jun 2012 10:56:57 +0200
Message-Id: <1340269017-11701-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows the ATAG_CMDLINE provided by the bootloader to be
concatenated to the bootargs property of the device tree.

This is useful to merge static values defined in the device tree with the
boot loader's (possibly) more dynamic values, such as startup reasons and more.

The bootloader should use the device tree to pass those values to the kernel,
but that's not always simple (old bootloader or very small one).

The behaviour is the same as the one introduced by Victor Boivie in
4394c1244249198c6b85093d46935b761b36ae05 by extending the CONFIG_CMDLINE.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 arch/arm/Kconfig                        |   19 +++++++++
 arch/arm/boot/compressed/atags_to_fdt.c |   62 ++++++++++++++++++++++++++++++-
 2 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 84449dd..ff4b6e6 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1959,6 +1959,25 @@ config ARM_ATAG_DTB_COMPAT
 	  bootloaders, this option allows zImage to extract the information
 	  from the ATAG list and store it at run time into the appended DTB.
 
+choice
+	prompt "Kernel command line type" if ARM_ATAG_DTB_COMPAT
+	default ARM_ATAG_DTB_COMPAT_CMDLINE_FROM_BOOTLOADER
+
+config ARM_ATAG_DTB_COMPAT_CMDLINE_FROM_BOOTLOADER
+	bool "Use bootloader kernel arguments if available"
+	help
+	  Uses the command-line options passed by the boot loader instead of
+	  the device tree bootargs property. If the boot loader doesn't provide
+	  any, the device tree bootargs property will be used.
+
+config ARM_ATAG_DTB_COMPAT_CMDLINE_EXTEND
+	bool "Extend with bootloader kernel arguments"
+	help
+	  The command-line arguments provided by the boot loader will be
+	  appended to the the device tree bootargs property.
+
+endchoice
+
 config CMDLINE
 	string "Default kernel command string"
 	default ""
diff --git a/arch/arm/boot/compressed/atags_to_fdt.c b/arch/arm/boot/compressed/atags_to_fdt.c
index 797f04b..aabc02a 100644
--- a/arch/arm/boot/compressed/atags_to_fdt.c
+++ b/arch/arm/boot/compressed/atags_to_fdt.c
@@ -1,6 +1,12 @@
 #include <asm/setup.h>
 #include <libfdt.h>
 
+#if defined(CONFIG_ARM_ATAG_DTB_COMPAT_CMDLINE_EXTEND)
+#define do_extend_cmdline 1
+#else
+#define do_extend_cmdline 0
+#endif
+
 static int node_offset(void *fdt, const char *node_path)
 {
 	int offset = fdt_path_offset(fdt, node_path);
@@ -36,6 +42,48 @@ static int setprop_cell(void *fdt, const char *node_path,
 	return fdt_setprop_cell(fdt, offset, property, val);
 }
 
+static const void *getprop(const void *fdt, const char *node_path,
+			   const char *property, int *len)
+{
+	int offset = fdt_path_offset(fdt, node_path);
+
+	if (offset == -FDT_ERR_NOTFOUND)
+		return NULL;
+
+	return fdt_getprop(fdt, offset, property, len);
+}
+
+static void merge_fdt_bootargs(void *fdt, const char *fdt_cmdline)
+{
+	char cmdline[COMMAND_LINE_SIZE];
+	const char *fdt_bootargs;
+	char *ptr = cmdline;
+	int len = 0;
+
+	/* copy the fdt command line into the buffer */
+	fdt_bootargs = getprop(fdt, "/chosen", "bootargs", &len);
+	if (fdt_bootargs)
+		if (len < COMMAND_LINE_SIZE) {
+			memcpy(ptr, fdt_bootargs, len);
+			/* len is the length of the string
+			 * including the NULL terminator */
+			ptr += len - 1;
+		}
+
+	/* and append the ATAG_CMDLINE */
+	if (fdt_cmdline) {
+		len = strlen(fdt_cmdline);
+		if (ptr - cmdline + len + 2 < COMMAND_LINE_SIZE) {
+			*ptr++ = ' ';
+			memcpy(ptr, fdt_cmdline, len);
+			ptr += len;
+		}
+	}
+	*ptr = '\0';
+
+	setprop_string(fdt, "/chosen", "bootargs", cmdline);
+}
+
 /*
  * Convert and fold provided ATAGs into the provided FDT.
  *
@@ -72,8 +120,18 @@ int atags_to_fdt(void *atag_list, void *fdt, int total_space)
 
 	for_each_tag(atag, atag_list) {
 		if (atag->hdr.tag == ATAG_CMDLINE) {
-			setprop_string(fdt, "/chosen", "bootargs",
-					atag->u.cmdline.cmdline);
+			/* Append the ATAGS command line to the device tree
+			 * command line.
+			 * NB: This means that if the same parameter is set in
+			 * the device tree and in the tags, the one from the
+			 * tags will be chosen.
+			 */
+			if (do_extend_cmdline)
+				merge_fdt_bootargs(fdt,
+						   atag->u.cmdline.cmdline);
+			else
+				setprop_string(fdt, "/chosen", "bootargs",
+					       atag->u.cmdline.cmdline);
 		} else if (atag->hdr.tag == ATAG_MEM) {
 			if (memcount >= sizeof(mem_reg_property)/4)
 				continue;
-- 
1.7.2.5

