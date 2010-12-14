Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507Ab0LNKK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:10:58 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:57550 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab0LNKKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:10:54 -0500
Date: Tue, 14 Dec 2010 15:41:04 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [Patch 10/21] Create /proc/pid/core entry
Message-ID: <20101214154104.1a7bc8ae@suzukikp>
In-Reply-To: <20101214152259.67896960@suzukikp>
References: <20101214152259.67896960@suzukikp>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create the /proc/PID/core entry.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Signed-off-by: Ananth N.Mavinakayanahalli <ananth@in.ibm.com>
---
 fs/proc/Makefile   |    1 +
 fs/proc/base.c     |    1 +
 fs/proc/gencore.c  |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/proc/internal.h |    1 +
 4 files changed, 51 insertions(+)

Index: linux-2.6.36-rc7/fs/proc/Makefile
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/Makefile
+++ linux-2.6.36-rc7/fs/proc/Makefile
@@ -19,6 +19,7 @@ proc-y	+= stat.o
 proc-y	+= uptime.o
 proc-y	+= version.o
 proc-y	+= softirqs.o
+proc-$(CONFIG_ELF_CORE)	+= gencore.o
 proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
 proc-$(CONFIG_NET)		+= proc_net.o
 proc-$(CONFIG_PROC_KCORE)	+= kcore.o
Index: linux-2.6.36-rc7/fs/proc/base.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/base.c
+++ linux-2.6.36-rc7/fs/proc/base.c
@@ -2735,6 +2735,7 @@ static const struct pid_entry tgid_base_
 #endif
 #ifdef CONFIG_ELF_CORE
 	REG("coredump_filter", S_IRUGO|S_IWUSR, proc_coredump_filter_operations),
+	REG("core", S_IRUSR, proc_gen_core_operations),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	INF("io",	S_IRUGO, proc_tgid_io_accounting),
Index: linux-2.6.36-rc7/fs/proc/gencore.c
===================================================================
--- /dev/null
+++ linux-2.6.36-rc7/fs/proc/gencore.c
@@ -0,0 +1,48 @@
+/*
+ * Application core dump
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2010
+ *
+ * Authors:
+ * 	 Ananth N.Mavinakayanahalli <ananth@in.ibm.com>
+ *	 Suzuki K. Poulose <suzuki@in.ibm.com>
+ */
+
+#include <linux/seq_file.h>
+#include "internal.h"
+
+static ssize_t read_gencore(struct file *file, char __user *buffer,
+		size_t buflen, loff_t *fpos)
+{
+	return 0;
+}
+
+static int release_gencore(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static int open_gencore(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+
+const struct file_operations proc_gen_core_operations = {
+	.open		= open_gencore,
+	.read		= read_gencore,
+	.release	= release_gencore,
+};
Index: linux-2.6.36-rc7/fs/proc/internal.h
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/internal.h
+++ linux-2.6.36-rc7/fs/proc/internal.h
@@ -60,6 +60,7 @@ extern const struct file_operations proc
 extern const struct file_operations proc_pagemap_operations;
 extern const struct file_operations proc_net_operations;
 extern const struct inode_operations proc_net_inode_operations;
+extern const struct file_operations proc_gen_core_operations;
 
 void proc_init_inodecache(void);
 
