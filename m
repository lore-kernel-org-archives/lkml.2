Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab1AHRfe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 12:35:34 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59726 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab1AHRfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 12:35:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=A8xEJNi+DintlPnvRRhwkOuUA7Mp9Y6m/OaWcrkL1VZo/8gQt9KVyYUGwy+s8MNWM8
         KqFxpRfTEBuGvPgMu5DHi/mNCnEw986GWdcKK0AVCjK+to+9HgKKzGlBh1PXG4dQJ/Mr
         otowUr64s5iNIbYYIDwYwZXAjNxvkSrrDNc+o=
Date: Sat, 8 Jan 2011 19:35:26 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: jslaby@suse.cz, werner@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH] proc: move proc_console.c to fs/proc/consoles.c
Message-ID: <20110108173526.GA21042@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Filename is supposed to match procfile name for random junk.

Add __init while I'm at it.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/Makefile       |    2 
 fs/proc/consoles.c     |  114 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/proc/proc_console.c |  114 -------------------------------------------------
 3 files changed, 115 insertions(+), 115 deletions(-)

--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -10,12 +10,12 @@ proc-$(CONFIG_MMU)	:= mmu.o task_mmu.o
 proc-y       += inode.o root.o base.o generic.o array.o \
 		proc_tty.o
 proc-y	+= cmdline.o
+proc-y	+= consoles.o
 proc-y	+= cpuinfo.o
 proc-y	+= devices.o
 proc-y	+= interrupts.o
 proc-y	+= loadavg.o
 proc-y	+= meminfo.o
-proc-y	+= proc_console.o
 proc-y	+= stat.o
 proc-y	+= uptime.o
 proc-y	+= version.o
new file mode 100644
--- /dev/null
+++ b/fs/proc/consoles.c
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
+static int __init proc_consoles_init(void)
+{
+	proc_create("consoles", 0, NULL, &proc_consoles_operations);
+	return 0;
+}
+module_init(proc_consoles_init);
deleted file mode 100644
--- a/fs/proc/proc_console.c
+++ /dev/null
@@ -1,114 +0,0 @@
-/*
- * Copyright (c) 2010 Werner Fink, Jiri Slaby
- *
- * Licensed under GPLv2
- */
-
-#include <linux/console.h>
-#include <linux/kernel.h>
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
-#include <linux/tty_driver.h>
-
-/*
- * This is handler for /proc/consoles
- */
-static int show_console_dev(struct seq_file *m, void *v)
-{
-	static const struct {
-		short flag;
-		char name;
-	} con_flags[] = {
-		{ CON_ENABLED,		'E' },
-		{ CON_CONSDEV,		'C' },
-		{ CON_BOOT,		'B' },
-		{ CON_PRINTBUFFER,	'p' },
-		{ CON_BRL,		'b' },
-		{ CON_ANYTIME,		'a' },
-	};
-	char flags[ARRAY_SIZE(con_flags) + 1];
-	struct console *con = v;
-	unsigned int a;
-	int len;
-	dev_t dev = 0;
-
-	if (con->device) {
-		const struct tty_driver *driver;
-		int index;
-		driver = con->device(con, &index);
-		if (driver) {
-			dev = MKDEV(driver->major, driver->minor_start);
-			dev += index;
-		}
-	}
-
-	for (a = 0; a < ARRAY_SIZE(con_flags); a++)
-		flags[a] = (con->flags & con_flags[a].flag) ?
-			con_flags[a].name : ' ';
-	flags[a] = 0;
-
-	seq_printf(m, "%s%d%n", con->name, con->index, &len);
-	len = 21 - len;
-	if (len < 1)
-		len = 1;
-	seq_printf(m, "%*c%c%c%c (%s)", len, ' ', con->read ? 'R' : '-',
-			con->write ? 'W' : '-', con->unblank ? 'U' : '-',
-			flags);
-	if (dev)
-		seq_printf(m, " %4d:%d", MAJOR(dev), MINOR(dev));
-
-	seq_printf(m, "\n");
-
-	return 0;
-}
-
-static void *c_start(struct seq_file *m, loff_t *pos)
-{
-	struct console *con;
-	loff_t off = 0;
-
-	acquire_console_sem();
-	for_each_console(con)
-		if (off++ == *pos)
-			break;
-
-	return con;
-}
-
-static void *c_next(struct seq_file *m, void *v, loff_t *pos)
-{
-	struct console *con = v;
-	++*pos;
-	return con->next;
-}
-
-static void c_stop(struct seq_file *m, void *v)
-{
-	release_console_sem();
-}
-
-static const struct seq_operations consoles_op = {
-	.start	= c_start,
-	.next	= c_next,
-	.stop	= c_stop,
-	.show	= show_console_dev
-};
-
-static int consoles_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &consoles_op);
-}
-
-static const struct file_operations proc_consoles_operations = {
-	.open		= consoles_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
-static int register_proc_consoles(void)
-{
-	proc_create("consoles", 0, NULL, &proc_consoles_operations);
-	return 0;
-}
-module_init(register_proc_consoles);
