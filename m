Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1LBUDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 15:03:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:40966 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744Ab1LBUCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 15:02:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="82325065"
From: Andi Kleen <andi@firstfloor.org>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/3] DEBUGFS: Add per cpu counters
Date: Fri,  2 Dec 2011 12:02:47 -0800
Message-Id: <1322856167-23030-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1322856167-23030-1-git-send-email-andi@firstfloor.org>
References: <1322856167-23030-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a simple way to export per cpu counters in debugfs.

This is done using a section, so that they can be declared using
a simple macro with minimal typing.

OPEN: modules are not supported yet.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/debugfs/Makefile               |    2 +-
 fs/debugfs/counter.c              |   73 +++++++++++++++++++++++++++++++++++++
 include/asm-generic/vmlinux.lds.h |    6 +++
 include/linux/debugfs.h           |   27 ++++++++++++++
 4 files changed, 107 insertions(+), 1 deletions(-)
 create mode 100644 fs/debugfs/counter.c

diff --git a/fs/debugfs/Makefile b/fs/debugfs/Makefile
index 840c456..21be8d3 100644
--- a/fs/debugfs/Makefile
+++ b/fs/debugfs/Makefile
@@ -1,4 +1,4 @@
-debugfs-objs	:= inode.o file.o
+debugfs-objs	:= inode.o file.o counter.o
 
 obj-$(CONFIG_DEBUG_FS)	+= debugfs.o
 
diff --git a/fs/debugfs/counter.c b/fs/debugfs/counter.c
new file mode 100644
index 0000000..2372faf
--- /dev/null
+++ b/fs/debugfs/counter.c
@@ -0,0 +1,73 @@
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/percpu.h>
+#include <linux/kernel.h>
+
+/* OPEN: implement module support */
+
+extern struct debugfs_counter __start___debugfs[], __stop___debugfs[];
+
+static unsigned sum_counter(unsigned __percpu *counter)
+{
+	int cpu;
+	unsigned sum = 0;
+
+	for_each_online_cpu (cpu)
+		sum += per_cpu(*counter, cpu);
+	return sum;
+}
+
+static int
+dump_counters(struct seq_file *m,
+	      struct debugfs_counter *cnt, struct debugfs_counter *stop,
+	      char *fn)
+{
+	int n = 0;
+	for (; cnt < stop; cnt++)
+		if (fn[0] == cnt->fn[0] && !strcmp(cnt->fn, fn))
+			n += seq_printf(m, "%s: %u\n",
+					cnt->name, sum_counter(cnt->ptr));
+	return n;
+}
+
+static int show_debugfs_counter(struct seq_file *m, void *arg)
+{
+	int n;
+	n = dump_counters(m, __start___debugfs, __stop___debugfs, m->private);
+	return n;
+}
+
+static int debugfs_counter_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_debugfs_counter, inode->i_private);
+}
+
+static const struct file_operations debugfs_counter_fops = {
+	.open = debugfs_counter_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release
+};
+
+static void
+init_counters(struct debugfs_counter *cnt, struct debugfs_counter *stop)
+{
+	const char *last = NULL;
+
+	for (; cnt < stop; cnt++) {
+		if (cnt->fn == last)
+			continue;
+		last = cnt->fn;
+
+		/* Ignore error. Nothing we can do. */
+		debugfs_create_file(cnt->fn, 0444, NULL, (void *)cnt->fn,
+				    &debugfs_counter_fops);
+	}
+}
+
+static int init_debugfs_counters(void)
+{
+	init_counters(__start___debugfs, __stop___debugfs);
+	return 0;
+}
+module_init(init_debugfs_counters);
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index b5e2e4c..fbfb95b 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -272,6 +272,12 @@
 									\
 	TRACEDATA							\
 									\
+	__debugfs  	: AT(ADDR(__debugfs) - LOAD_OFFSET) {		\
+		VMLINUX_SYMBOL(__start___debugfs) = .;			\
+		*(__debugfs)						\
+		VMLINUX_SYMBOL(__stop___debugfs) = .;			\
+	}								\
+									\
 	/* Kernel symbol table: Normal symbols */			\
 	__ksymtab         : AT(ADDR(__ksymtab) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start___ksymtab) = .;			\
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index e7d9b20..a243b05 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -18,6 +18,7 @@
 #include <linux/fs.h>
 
 #include <linux/types.h>
+#include <linux/percpu.h>
 
 struct file_operations;
 
@@ -76,6 +77,24 @@ struct dentry *debugfs_create_blob(const char *name, mode_t mode,
 
 bool debugfs_initialized(void);
 
+struct debugfs_counter {
+	unsigned __percpu *ptr;
+	const char *fn;
+	const char *name;
+} __attribute__((aligned(sizeof(char *))));
+
+/* Note: static doesn't work unlike DEFINE_PERCPU. Sorry. */
+#define DEFINE_DEBUGFS_COUNTER(name_, file)				\
+	DEFINE_PER_CPU(unsigned, name_ ## _counter);			\
+	struct debugfs_counter name_ ## _pcpu_counter __used		\
+	__attribute__((aligned(sizeof(char *)),section("__debugfs"),unused)) \
+	= { .ptr = &name_ ## _counter, .fn = file, .name = #name_ }; \
+
+#define DECLARE_DEBUGFS_COUNTER(name)			\
+	struct debugfs_counter name ## _pcpu_counter
+
+#define debugfs_counter_inc(name) this_cpu_inc(name ## _counter)
+
 #else
 
 #include <linux/err.h>
@@ -193,6 +212,14 @@ static inline bool debugfs_initialized(void)
 	return false;
 }
 
+
+struct debugfs_counter {
+};
+
+#define DEFINE_DEBUGFS_COUNTER(name, file)
+#define DECLARE_DEBUGFS_COUNTER(name)
+#define debugfs_counter_inc(name) do {} while(0)
+
 #endif
 
 #endif
-- 
1.7.4.4

