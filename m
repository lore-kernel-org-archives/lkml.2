Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab1AFWXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:23:44 -0500
Received: from kroah.org ([198.145.64.141]:55641 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab1AFWXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:41 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>, "Dr. Werner Fink" <werner@suse.de>,
        Al Viro <viro@ZenIV.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/36] console: add /proc/consoles
Date: Thu,  6 Jan 2011 14:23:00 -0800
Message-Id: <1294352605-31906-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

It allows users to see what consoles are currently known to the system
and with what flags.

It is based on Werner's patch, the part about traversing fds was
removed, the code was moved to kernel/printk.c, where consoles are
handled and it makes more sense to me.

Signed-off-by: Jiri Slaby <jslaby@suse.cz> [cleanups]
Signed-off-by: "Dr. Werner Fink" <werner@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/filesystems/proc.txt |   24 ++++++++
 fs/proc/Makefile                   |    1 +
 fs/proc/proc_console.c             |  114 ++++++++++++++++++++++++++++++++++++
 3 files changed, 139 insertions(+), 0 deletions(-)
 create mode 100644 fs/proc/proc_console.c

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index e73df27..9471225 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1181,6 +1181,30 @@ Table 1-12: Files in /proc/fs/ext4/<devname>
  mb_groups       details of multiblock allocator buddy cache of free blocks
 ..............................................................................
 
+2.0 /proc/consoles
+------------------
+Shows registered system console lines.
+
+To see which character device lines are currently used for the system console
+/dev/console, you may simply look into the file /proc/consoles:
+
+  > cat /proc/consoles
+  tty0                 -WU (ECp)       4:7
+  ttyS0                -W- (Ep)        4:64
+
+The columns are:
+
+  device               name of the device
+  operations           R = can do read operations
+                       W = can do write operations
+                       U = can do unblank
+  flags                E = it is enabled
+                       C = it is prefered console
+                       B = it is primary boot console
+                       p = it is used for printk buffer
+                       b = it is not a TTY but a Braille device
+                       a = it is safe to use when cpu is offline
+  major:minor          major and minor number of the device separated by a colon
 
 ------------------------------------------------------------------------------
 Summary
diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index 2758e2a..288a49e 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -15,6 +15,7 @@ proc-y	+= devices.o
 proc-y	+= interrupts.o
 proc-y	+= loadavg.o
 proc-y	+= meminfo.o
+proc-y	+= proc_console.o
 proc-y	+= stat.o
 proc-y	+= uptime.o
 proc-y	+= version.o
diff --git a/fs/proc/proc_console.c b/fs/proc/proc_console.c
new file mode 100644
index 0000000..8a70760
--- /dev/null
+++ b/fs/proc/proc_console.c
@@ -0,0 +1,114 @@
+/*
+ * Copyright (c) 2010 Werner Fink, Jiri Slaby
+ *
+ * Licensed under GPLv2
+ */
+
+#include <linux/console.h>
+#include <linux/kernel.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/tty_driver.h>
+
+/*
+ * This is handler for /proc/consoles
+ */
+static int show_console_dev(struct seq_file *m, void *v)
+{
+	static const struct {
+		short flag;
+		char name;
+	} con_flags[] = {
+		{ CON_ENABLED,		'E' },
+		{ CON_CONSDEV,		'C' },
+		{ CON_BOOT,		'B' },
+		{ CON_PRINTBUFFER,	'p' },
+		{ CON_BRL,		'b' },
+		{ CON_ANYTIME,		'a' },
+	};
+	char flags[ARRAY_SIZE(con_flags) + 1];
+	struct console *con = v;
+	unsigned int a;
+	int len;
+	dev_t dev = 0;
+
+	if (con->device) {
+		const struct tty_driver *driver;
+		int index;
+		driver = con->device(con, &index);
+		if (driver) {
+			dev = MKDEV(driver->major, driver->minor_start);
+			dev += index;
+		}
+	}
+
+	for (a = 0; a < ARRAY_SIZE(con_flags); a++)
+		flags[a] = (con->flags & con_flags[a].flag) ?
+			con_flags[a].name : ' ';
+	flags[a] = 0;
+
+	seq_printf(m, "%s%d%n", con->name, con->index, &len);
+	len = 21 - len;
+	if (len < 1)
+		len = 1;
+	seq_printf(m, "%*c%c%c%c (%s)", len, ' ', con->read ? 'R' : '-',
+			con->write ? 'W' : '-', con->unblank ? 'U' : '-',
+			flags);
+	if (dev)
+		seq_printf(m, " %4d:%d", MAJOR(dev), MINOR(dev));
+
+	seq_printf(m, "\n");
+
+	return 0;
+}
+
+static void *c_start(struct seq_file *m, loff_t *pos)
+{
+	struct console *con;
+	loff_t off = 0;
+
+	acquire_console_sem();
+	for_each_console(con)
+		if (off++ == *pos)
+			break;
+
+	return con;
+}
+
+static void *c_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct console *con = v;
+	++*pos;
+	return con->next;
+}
+
+static void c_stop(struct seq_file *m, void *v)
+{
+	release_console_sem();
+}
+
+static const struct seq_operations consoles_op = {
+	.start	= c_start,
+	.next	= c_next,
+	.stop	= c_stop,
+	.show	= show_console_dev
+};
+
+static int consoles_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &consoles_op);
+}
+
+static const struct file_operations proc_consoles_operations = {
+	.open		= consoles_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int register_proc_consoles(void)
+{
+	proc_create("consoles", 0, NULL, &proc_consoles_operations);
+	return 0;
+}
+module_init(register_proc_consoles);
-- 
1.7.3.2

