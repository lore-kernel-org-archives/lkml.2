Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab1DHJgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 05:36:49 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:10427 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754554Ab1DHJgs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 05:36:48 -0400
From: <oskar.andero@sonyericsson.com>
To: <u.kleine-koenig@pengutronix.de>, <nicolas.pitre@linaro.org>
CC: <nbowler@elliptictech.com>, <pebolle@tiscali.nl>, <linux@arm.linux.org.uk>,
        <catalin.marinas@arm.com>, <will.deacon@arm.com>,
        <linux-kernel@vger.kernel.org>, <eric.y.miao@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Victor Boivie <victor.boivie@sonyericsson.com>,
        Oskar Andero <oskar.andero@sonyericsson.com>
Subject: [PATCH] ARM: Allow for kernel command line concatenation
Date: Fri, 8 Apr 2011 11:36:23 +0200
Message-ID: <1302255383-12375-1-git-send-email-oskar.andero@sonyericsson.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Victor Boivie <victor.boivie@sonyericsson.com>

This patch allows the provided CONFIG_CMDLINE to be concatenated
with the one provided by the boot loader. This is useful to
merge the static values defined in CONFIG_CMDLINE with the
boot loader's (possibly) more dynamic values, such as startup
reasons and more.

Signed-off-by: Victor Boivie <victor.boivie@sonyericsson.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@sonyericsson.com>
Signed-off-by: Oskar Andero <oskar.andero@sonyericsson.com>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/Kconfig        |   21 ++++++++++++++++++---
 arch/arm/kernel/setup.c |   13 +++++++++----
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5b9f78b..fe34ed7 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1743,16 +1743,31 @@ config CMDLINE
 	  time by entering them here. As a minimum, you should specify the
 	  memory size and the root device (e.g., mem=64M root=/dev/nfs).
 
+choice
+	prompt "Kernel command line type" if CMDLINE != ""
+	default CMDLINE_FROM_BOOTLOADER
+
+config CMDLINE_FROM_BOOTLOADER
+	bool "Use bootloader kernel arguments if available"
+	help
+	  Uses the command-line options passed by the boot loader. If
+	  the boot loader doesn't provide any, the default kernel command
+	  string provided in CMDLINE will be used.
+
+config CMDLINE_EXTEND
+	bool "Extend bootloader kernel arguments"
+	help
+	  The command-line arguments provided by the boot loader will be
+	  appended to the default kernel command string.
+
 config CMDLINE_FORCE
 	bool "Always use the default kernel command string"
-	depends on CMDLINE != ""
 	help
 	  Always use the default kernel command string, even if the boot
 	  loader passes other arguments to the kernel.
 	  This is useful if you cannot or don't want to change the
 	  command-line options your boot loader passes to the kernel.
-
-	  If unsure, say N.
+endchoice
 
 config XIP_KERNEL
 	bool "Kernel Execute-In-Place from ROM"
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 006c1e8..6dce209 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -672,11 +672,16 @@ __tagtable(ATAG_REVISION, parse_tag_revision);
 
 static int __init parse_tag_cmdline(const struct tag *tag)
 {
-#ifndef CONFIG_CMDLINE_FORCE
-	strlcpy(default_command_line, tag->u.cmdline.cmdline, COMMAND_LINE_SIZE);
-#else
+#if defined(CONFIG_CMDLINE_EXTEND)
+	strlcat(default_command_line, " ", COMMAND_LINE_SIZE);
+	strlcat(default_command_line, tag->u.cmdline.cmdline,
+		COMMAND_LINE_SIZE);
+#elif defined(CONFIG_CMDLINE_FORCE)
 	pr_warning("Ignoring tag cmdline (using the default kernel command line)\n");
-#endif /* CONFIG_CMDLINE_FORCE */
+#else
+	strlcpy(default_command_line, tag->u.cmdline.cmdline,
+		COMMAND_LINE_SIZE);
+#endif
 	return 0;
 }
 
-- 
1.7.4.2

