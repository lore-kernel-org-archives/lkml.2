Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab1JYJtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:49:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40772 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab1JYJtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:49:00 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: <akpm@linux-foundation.org>, Brian Swetland <swetland@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ohad Ben-Cohen <ohad@wizery.com>, Greg KH <greg@kroah.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 2/7] amp/remoteproc: add debugfs entries
Date: Tue, 25 Oct 2011 11:48:21 +0200
Message-Id: <1319536106-25802-3-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319536106-25802-1-git-send-email-ohad@wizery.com>
References: <1319536106-25802-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose several remote processor properties (name, state, trace buffer)
that are helpful for debugging.

This part is extracted to a separate patch just to keep the review load
down.

Designed with Brian Swetland <swetland@google.com>.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Brian Swetland <swetland@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/amp/remoteproc/Makefile             |    1 +
 drivers/amp/remoteproc/remoteproc_debugfs.c |  182 +++++++++++++++++++++++++++
 2 files changed, 183 insertions(+), 0 deletions(-)
 create mode 100644 drivers/amp/remoteproc/remoteproc_debugfs.c

diff --git a/drivers/amp/remoteproc/Makefile b/drivers/amp/remoteproc/Makefile
index 2a5fd79..b888c37 100644
--- a/drivers/amp/remoteproc/Makefile
+++ b/drivers/amp/remoteproc/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_REMOTEPROC)		+= remoteproc.o
 remoteproc-y				:= remoteproc_core.o
+remoteproc-y				+= remoteproc_debugfs.o
\ No newline at end of file
diff --git a/drivers/amp/remoteproc/remoteproc_debugfs.c b/drivers/amp/remoteproc/remoteproc_debugfs.c
new file mode 100644
index 0000000..4c849db
--- /dev/null
+++ b/drivers/amp/remoteproc/remoteproc_debugfs.c
@@ -0,0 +1,182 @@
+/*
+ * Remote Processor Framework
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ * Copyright (C) 2011 Google, Inc.
+ *
+ * Ohad Ben-Cohen <ohad@wizery.com>
+ * Mark Grosen <mgrosen@ti.com>
+ * Brian Swetland <swetland@google.com>
+ * Fernando Guzman Lugo <fernando.lugo@ti.com>
+ * Suman Anna <s-anna@ti.com>
+ * Robert Tivy <rtivy@ti.com>
+ * Armando Uribe De Leon <x0095078@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt)    "%s: " fmt, __func__
+
+#include <linux/kernel.h>
+#include <linux/debugfs.h>
+#include <linux/amp/remoteproc.h>
+#include <linux/device.h>
+
+/* remoteproc debugfs parent dir */
+static struct dentry *rproc_dbg;
+
+/*
+ * Some remote processors may support dumping trace logs into a shared
+ * memory buffer. We expose this trace buffer using debugfs, so users
+ * can easily tell what's going on remotely.
+ *
+ * We will most probably improve the rproc tracing facilities later on,
+ * but this kind of lightweight and simple mechanism is always good to have,
+ * as it provides very early tracing with little to no dependencies at all.
+ */
+static ssize_t rproc_trace_read(struct file *filp, char __user *userbuf,
+						size_t count, loff_t *ppos)
+{
+	struct rproc_mem_entry *trace = filp->private_data;
+	int len = strnlen(trace->va, trace->len);
+
+	return simple_read_from_buffer(userbuf, count, ppos, trace->va, len);
+}
+
+static int rproc_open_generic(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+
+	return 0;
+}
+
+static const struct file_operations trace_rproc_ops = {
+	.read = rproc_trace_read,
+	.open = rproc_open_generic,
+	.llseek	= generic_file_llseek,
+};
+
+/*
+ * A state-to-string lookup table, for exposing a human readable state
+ * via debugfs. Always keep in sync with enum rproc_state
+ */
+static const char * const rproc_state_string[] = {
+	"offline",
+	"suspended",
+	"running",
+	"crashed",
+	"invalid",
+};
+
+/* expose the state of the remote processor via debugfs */
+static ssize_t rproc_state_read(struct file *filp, char __user *userbuf,
+						size_t count, loff_t *ppos)
+{
+	struct rproc *rproc = filp->private_data;
+	unsigned int state;
+	char buf[30];
+	int i;
+
+	state = rproc->state > RPROC_LAST ? RPROC_LAST : rproc->state;
+
+	i = snprintf(buf, 30, "%.28s (%d)\n", rproc_state_string[state],
+							rproc->state);
+
+	return simple_read_from_buffer(userbuf, count, ppos, buf, i);
+}
+
+static const struct file_operations rproc_state_ops = {
+	.read = rproc_state_read,
+	.open = rproc_open_generic,
+	.llseek	= generic_file_llseek,
+};
+
+/* expose the name of the remote processor via debugfs */
+static ssize_t rproc_name_read(struct file *filp, char __user *userbuf,
+						size_t count, loff_t *ppos)
+{
+	struct rproc *rproc = filp->private_data;
+	/* need room for the name, a newline and a terminating null */
+	char buf[100];
+	int i;
+
+	i = snprintf(buf, sizeof(buf), "%.98s\n", rproc->name);
+
+	return simple_read_from_buffer(userbuf, count, ppos, buf, i);
+}
+
+static const struct file_operations rproc_name_ops = {
+	.read = rproc_name_read,
+	.open = rproc_open_generic,
+	.llseek	= generic_file_llseek,
+};
+
+void rproc_remove_trace_file(struct dentry *tfile)
+{
+	debugfs_remove(tfile);
+}
+
+struct dentry *rproc_create_trace_file(const char *name, struct rproc *rproc,
+					struct rproc_mem_entry *trace)
+{
+	struct dentry *tfile;
+
+	tfile = debugfs_create_file(name, 0400, rproc->dbg_dir,
+						trace, &trace_rproc_ops);
+	if (!tfile) {
+		dev_err(rproc->dev, "failed to create debugfs trace entry\n");
+		return NULL;
+	}
+
+	return tfile;
+}
+
+void rproc_delete_debug_dir(struct rproc *rproc)
+{
+	if (!rproc->dbg_dir)
+		return;
+
+	debugfs_remove_recursive(rproc->dbg_dir);
+}
+
+void rproc_create_debug_dir(struct rproc *rproc)
+{
+	struct device *dev = rproc->dev;
+
+	if (!rproc_dbg)
+		return;
+
+	rproc->dbg_dir = debugfs_create_dir(dev_name(dev), rproc_dbg);
+	if (!rproc->dbg_dir)
+		return;
+
+	debugfs_create_file("name", 0400, rproc->dbg_dir,
+					rproc, &rproc_name_ops);
+	debugfs_create_file("state", 0400, rproc->dbg_dir,
+					rproc, &rproc_state_ops);
+}
+
+void __init rproc_init_debugfs(void)
+{
+	if (debugfs_initialized()) {
+		rproc_dbg = debugfs_create_dir(KBUILD_MODNAME, NULL);
+		if (!rproc_dbg)
+			pr_err("can't create debugfs dir\n");
+	}
+}
+
+void __exit rproc_exit_debugfs(void)
+{
+	if (rproc_dbg)
+		debugfs_remove(rproc_dbg);
+}
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Generic Remote Processor Framework");
-- 
1.7.5.4

