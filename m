Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1AOUY1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 15:24:27 -0500
Received: from adelie.canonical.com ([91.189.90.139]:47401 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab1AOUYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 15:24:19 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Dmitry Torokhov <dtor@mail.ru>
Cc: Andy Whitcroft <apw@canonical.com>, linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] Input: sysrq -- ensure sysrq_enabled and __sysrq_enabled are consistent
Date: Sat, 15 Jan 2011 20:23:57 +0000
Message-Id: <1295123037-2649-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295123037-2649-1-git-send-email-apw@canonical.com>
References: <1295123037-2649-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently sysrq_enabled and __sysrq_enabled are initialised separatly
and inconsitantly, leading to sysrq being actually enabled by reported
as not enabled in sysfs.  The first change to the sysfs configurable
synchronises these two:

    static int __read_mostly sysrq_enabled = 1;
    static int __sysrq_enabled;

Add a new configuration value which sets the default for these preventing
them becoming out of sync again.  Default this to 1 to mirror previous
behaviour.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/tty/sysrq.c |    2 +-
 kernel/sysctl.c     |    3 ++-
 lib/Kconfig.debug   |    9 +++++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index c556ed9..ba8cf87 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -46,7 +46,7 @@
 #include <asm/irq_regs.h>
 
 /* Whether we react on sysrq keys or just ignore them */
-static int __read_mostly sysrq_enabled = 1;
+static int __read_mostly sysrq_enabled = CONFIG_MAGIC_SYSRQ_DEFAULT;
 static bool __read_mostly sysrq_always_enabled;
 
 static bool sysrq_on(void)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index bc86bb3..85fd935 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -170,7 +170,8 @@ static int proc_taint(struct ctl_table *table, int write,
 #endif
 
 #ifdef CONFIG_MAGIC_SYSRQ
-static int __sysrq_enabled; /* Note: sysrq code ises it's own private copy */
+/* Note: sysrq code uses it's own private copy */
+static int __sysrq_enabled = CONFIG_MAGIC_SYSRQ_DEFAULT;
 
 static int sysrq_sysctl_handler(ctl_table *table, int write,
 				void __user *buffer, size_t *lenp,
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2d05adb..459105e 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -50,6 +50,15 @@ config MAGIC_SYSRQ
 	  keys are documented in <file:Documentation/sysrq.txt>. Don't say Y
 	  unless you really know what this hack does.
 
+config MAGIC_SYSRQ_DEFAULT
+	int "Magic SysRq key default"
+	default 1
+        range 0 1
+	help
+	  Set the default value for the sysrq sysfs control to this value.
+	  Setting this to 1 will enable sysrq on boot, to 0 will disable
+	  sysrq on boot.
+
 config STRIP_ASM_SYMS
 	bool "Strip assembler-generated symbols during link"
 	default n
-- 
1.7.2.3

