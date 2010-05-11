Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab0EKOMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:12:46 -0400
Received: from smtp.nokia.com ([192.100.122.233]:50759 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099Ab0EKOMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:12:41 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
       Linux-OMAP <linux-omap@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       ext Tony Lindgren <tony@atomide.com>,
       ext Kevin Hilman <khilman@deeprootsystems.com>,
       Peter De-Schrijver <Peter.De-Schrijver@nokia.com>,
       santosh.shilimkar@ti.com, Ambresh <a0393775@ti.com>,
       felipe.balbi@nokia.com, Jouni Hogander <jouni.hogander@nokia.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv5 1/3] procfs: Introduce socinfo under /proc
Date: Tue, 11 May 2010 17:15:29 +0300
Message-Id: <1273587331-24604-2-git-send-email-eduardo.valentin@nokia.com>
X-Mailer: git-send-email 1.7.0.4.361.g8b5fe.dirty
In-Reply-To: <1273587331-24604-1-git-send-email-eduardo.valentin@nokia.com>
References: <1273587331-24604-1-git-send-email-eduardo.valentin@nokia.com>
X-OriginalArrivalTime: 11 May 2010 14:12:06.0968 (UTC) FILETIME=[F02DB380:01CAF113]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Valentin <eduardo.valentin@nokia.com>

This patch introduce the /proc/socinfo node. Its purpose is to
export System on Chip information and specific bits.

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 Documentation/filesystems/proc.txt |    1 +
 fs/proc/Kconfig                    |    7 +++
 fs/proc/Makefile                   |    1 +
 fs/proc/socinfo.c                  |   80 ++++++++++++++++++++++++++++++++++++
 include/linux/socinfo.h            |   17 ++++++++
 5 files changed, 106 insertions(+), 0 deletions(-)
 create mode 100644 fs/proc/socinfo.c
 create mode 100644 include/linux/socinfo.h

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
index 0000000..09a889d
--- /dev/null
+++ b/fs/proc/socinfo.c
@@ -0,0 +1,80 @@
+/*
+ *  fs/proc/socinfo.c
+ *
+ *  Copyright (C) 2010 Nokia Corporation
+ *
+ *  Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
+ *
+ *  proc socinfo file
+ */
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/socinfo.h>
+
+/*
+ * Function pointer to soc core code which knows how to grab soc info
+ */
+static int (*socinfo_show)(struct seq_file *, void *);
+static void *socinfo_data;
+static DEFINE_MUTEX(socinfo_mutex);
+
+/**
+ * register_socinfo_show() - register a call back to provide SoC information
+ * @show:	The function callback. It is expected to be in the same format
+ *		as the .show of struct seq_operations.
+ * @data:	A void * which will be passed as argument when show is called.
+ *
+ * This function will store the reference for a function and its data. The show
+ * argument will be called when filling up the seq_file of /proc/socinfo.
+ * Usually, this function should be called just once, while executing the SoC
+ * core initialization code.
+ */
+void register_socinfo_show(int (*show)(struct seq_file *, void *), void *data)
+{
+	mutex_lock(&socinfo_mutex);
+	socinfo_show = show;
+	socinfo_data = data;
+	mutex_unlock(&socinfo_mutex);
+}
+
+static int socinfo_show_local(struct seq_file *sfile, void *data)
+{
+	int r;
+
+	/* Just fall back to those who know how to grab the info */
+	mutex_lock(&socinfo_mutex);
+	if (socinfo_show)
+		r = socinfo_show(sfile, socinfo_data);
+	else
+		r = seq_printf(sfile, "No data\n");
+	mutex_unlock(&socinfo_mutex);
+
+	return r;
+}
+
+static int socinfo_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, socinfo_show_local, NULL);
+}
+
+static const struct file_operations proc_socinfo_operations = {
+	.owner		= THIS_MODULE,
+	.open		= socinfo_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init proc_socinfo_init(void)
+{
+	if (!proc_create("socinfo", 0, NULL, &proc_socinfo_operations)) {
+		pr_info("Failed to create /proc/socinfo\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+module_init(proc_socinfo_init);
diff --git a/include/linux/socinfo.h b/include/linux/socinfo.h
new file mode 100644
index 0000000..aa870f1
--- /dev/null
+++ b/include/linux/socinfo.h
@@ -0,0 +1,17 @@
+/*
+ *  include/linux/socinfo.h
+ *
+ *  Copyright (C) 2010 Nokia Corporation
+ *
+ *  Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
+ *
+ *  proc socinfo file
+ */
+
+#ifndef __SOCINFO_H
+#define __SOCINFO_H
+
+#include <linux/seq_file.h>
+
+void register_socinfo_show(int (*show)(struct seq_file *, void *), void *data);
+#endif
-- 
1.7.0.4.361.g8b5fe.dirty

