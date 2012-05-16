Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933427Ab2EPM56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:57:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46187 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab2EPM5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:57:55 -0400
Date: Wed, 16 May 2012 05:56:25 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 1/6] pstore: Add console log messages support
Message-ID: <20120516125625.GA20475@lizard>
References: <20120516125330.GA15460@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120516125330.GA15460@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pstore doesn't support logging kernel messages in run-time, it only
dumps dmesg when kernel oopses/panics. This makes pstore useless for
debugging hangs caused by HW issues or improper use of HW (e.g.
weird device inserted -> driver tried to write a reserved bits ->
SoC hanged. In that case we don't get any messages in the pstore.

Therefore, let's add a runtime logging support: PSTORE_TYPE_CONSOLE.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/Kconfig      |    7 +++++++
 fs/pstore/inode.c      |    3 +++
 fs/pstore/platform.c   |   25 +++++++++++++++++++++++++
 include/linux/pstore.h |    1 +
 4 files changed, 36 insertions(+)

diff --git a/fs/pstore/Kconfig b/fs/pstore/Kconfig
index 23ade26..d044de6 100644
--- a/fs/pstore/Kconfig
+++ b/fs/pstore/Kconfig
@@ -12,6 +12,13 @@ config PSTORE
 	   If you don't have a platform persistent store driver,
 	   say N.
 
+config PSTORE_CONSOLE
+	bool "Log kernel console messages"
+	depends on PSTORE
+	help
+	  When the option is enabled, pstore will log all kernel
+	  messages, even if no oops or panic happened.
+
 config PSTORE_RAM
 	tristate "Log panic/oops to a RAM buffer"
 	depends on PSTORE
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 1950788..97d35ee 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -212,6 +212,9 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id,
 	case PSTORE_TYPE_DMESG:
 		sprintf(name, "dmesg-%s-%lld", psname, id);
 		break;
+	case PSTORE_TYPE_CONSOLE:
+		sprintf(name, "console-%s", psname);
+		break;
 	case PSTORE_TYPE_MCE:
 		sprintf(name, "mce-%s-%lld", psname, id);
 		break;
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 82c585f..3a384c8 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -1,6 +1,7 @@
 /*
  * Persistent Storage - platform driver interface parts.
  *
+ * Copyright (C) 2007-2008 Google, Inc.
  * Copyright (C) 2010 Intel Corporation <tony.luck@intel.com>
  *
  *  This program is free software; you can redistribute it and/or modify
@@ -22,6 +23,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/kmsg_dump.h>
+#include <linux/console.h>
 #include <linux/module.h>
 #include <linux/pstore.h>
 #include <linux/string.h>
@@ -156,6 +158,28 @@ static struct kmsg_dumper pstore_dumper = {
 	.dump = pstore_dump,
 };
 
+#ifdef CONFIG_PSTORE_CONSOLE
+static void pstore_console_write(struct console *con, const char *s, unsigned c)
+{
+	strncpy(psinfo->buf, s, c);
+	psinfo->write(PSTORE_TYPE_CONSOLE, 0, NULL, 0, c, psinfo);
+}
+
+static struct console pstore_console = {
+	.name	= "pstore",
+	.write	= pstore_console_write,
+	.flags	= CON_PRINTBUFFER | CON_ENABLED | CON_ANYTIME,
+	.index	= -1,
+};
+
+static void pstore_register_console(void)
+{
+	register_console(&pstore_console);
+}
+#else
+static void pstore_register_console(void) {}
+#endif
+
 /*
  * platform specific persistent storage driver registers with
  * us here. If pstore is already mounted, call the platform
@@ -193,6 +217,7 @@ int pstore_register(struct pstore_info *psi)
 		pstore_get_records(0);
 
 	kmsg_dump_register(&pstore_dumper);
+	pstore_register_console();
 
 	pstore_timer.expires = jiffies + PSTORE_INTERVAL;
 	add_timer(&pstore_timer);
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index e1461e1..1bd014b 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -29,6 +29,7 @@
 enum pstore_type_id {
 	PSTORE_TYPE_DMESG	= 0,
 	PSTORE_TYPE_MCE		= 1,
+	PSTORE_TYPE_CONSOLE	= 2,
 	PSTORE_TYPE_UNKNOWN	= 255
 };
 
-- 
1.7.9.2

