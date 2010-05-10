Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab0EJKhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 06:37:46 -0400
Received: from smtp.nokia.com ([192.100.122.230]:61260 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab0EJKg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 06:36:57 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
       Linux-OMAP <linux-omap@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       ext Tony Lindgren <tony@atomide.com>,
       ext Kevin Hilman <khilman@deeprootsystems.com>,
       Peter De-Schrijver <Peter.De-Schrijver@nokia.com>,
       santosh.shilimkar@ti.com, Ambresh <a0393775@ti.com>,
       felipe.balbi@nokia.com, Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv4 1/4] procfs: Introduce socinfo under /proc
Date: Mon, 10 May 2010 13:37:34 +0300
Message-Id: <1273487857-32281-2-git-send-email-eduardo.valentin@nokia.com>
X-Mailer: git-send-email 1.7.0.4.361.g8b5fe.dirty
In-Reply-To: <1273487857-32281-1-git-send-email-eduardo.valentin@nokia.com>
References: <1273487857-32281-1-git-send-email-eduardo.valentin@nokia.com>
X-OriginalArrivalTime: 10 May 2010 10:35:36.0259 (UTC) FILETIME=[86B31130:01CAF02C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Valentin <eduardo.valentin@nokia.com>

This patch introduce the /proc/socinfo node. Its purpose is to
export System on Chip information and specific bits.

The way it is done is basically same structure which is used to build
/proc/cpuinfo. Thus, it relies on the existence of socinfo_op seq_operation
structure. This structure must be provided by soc core code.

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 Documentation/filesystems/proc.txt |    1 +
 fs/proc/Kconfig                    |    7 +++++++
 fs/proc/Makefile                   |    1 +
 fs/proc/socinfo.c                  |   33 +++++++++++++++++++++++++++++++++
 4 files changed, 42 insertions(+), 0 deletions(-)
 create mode 100644 fs/proc/socinfo.c

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index a4f30fa..039bcb7 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -415,6 +415,7 @@ Table 1-5: Kernel info in /proc
  bus         Directory containing bus specific information     
  cmdline     Kernel command line                               
  cpuinfo     Info about the CPU                                
+ socinfo     Info about the System on Chip                     
  devices     Available devices (block and character)           
  dma         Used DMS channels                                 
  filesystems Supported filesystems                             
diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
index 50f8f06..e683d62 100644
--- a/fs/proc/Kconfig
+++ b/fs/proc/Kconfig
@@ -67,3 +67,10 @@ config PROC_PAGE_MONITOR
 	  /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
 	  /proc/kpagecount, and /proc/kpageflags. Disabling these
           interfaces will reduce the size of the kernel by approximately 4kb.
+
+config PROC_SOCINFO
+ 	default y
+	depends on PROC_FS
+	bool "Enable /proc/socinfo" if EMBEDDED
+ 	help
+	  Say Y here if you need to see information about the your System on Chip.
diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index 11a7b5c..7757d44 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -26,3 +26,4 @@ proc-$(CONFIG_PROC_VMCORE)	+= vmcore.o
 proc-$(CONFIG_PROC_DEVICETREE)	+= proc_devtree.o
 proc-$(CONFIG_PRINTK)	+= kmsg.o
 proc-$(CONFIG_PROC_PAGE_MONITOR)	+= page.o
+proc-$(CONFIG_PROC_SOCINFO)	+= socinfo.o
diff --git a/fs/proc/socinfo.c b/fs/proc/socinfo.c
new file mode 100644
index 0000000..05bfc4f
--- /dev/null
+++ b/fs/proc/socinfo.c
@@ -0,0 +1,33 @@
+/*
+ *  fs/proc/socinfo.c
+ *
+ *  Copyright (C) 2010 Nokia Corporation
+ *
+ *  Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
+ *
+ *  proc socinfo file
+ */
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+
+extern const struct seq_operations socinfo_op;
+static int socinfo_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &socinfo_op);
+}
+
+static const struct file_operations proc_socinfo_operations = {
+	.open		= socinfo_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int __init proc_socinfo_init(void)
+{
+	proc_create("socinfo", 0, NULL, &proc_socinfo_operations);
+	return 0;
+}
+module_init(proc_socinfo_init);
-- 
1.7.0.4.361.g8b5fe.dirty

