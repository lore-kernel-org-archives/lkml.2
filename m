Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab2EZNlY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:41:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62287 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab2EZNlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:41:21 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
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
Subject: [PATCH 3/5] pstore: Add persistent function tracing
Date: Sat, 26 May 2012 06:39:07 -0700
Message-Id: <1338039549-24498-3-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120526133412.GA18001@lizard>
References: <20120526133412.GA18001@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this support kernel can save function call chain log into a
persistent ram buffer that can be decoded and dumped after reboot
through pstore filesystem. It can be used to determine what function
was last called before a reset or panic.

We store the log in a binary format and then decode it at read time.

p.s.
Mostly the code comes from trace_persistent.c driver found in the
Android git tree, written by Colin Cross <ccross@android.com>
(according to sign-off history). I reworked the driver a little bit,
and ported it to pstore.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/Kconfig      |   12 +++++
 fs/pstore/Makefile     |    6 +++
 fs/pstore/ftrace.c     |  122 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/pstore/inode.c      |  111 +++++++++++++++++++++++++++++++++++++++++--
 fs/pstore/internal.h   |   49 +++++++++++++++++++
 fs/pstore/platform.c   |    3 +-
 include/linux/pstore.h |    1 +
 7 files changed, 299 insertions(+), 5 deletions(-)
 create mode 100644 fs/pstore/ftrace.c

diff --git a/fs/pstore/Kconfig b/fs/pstore/Kconfig
index d044de6..d39bb5c 100644
--- a/fs/pstore/Kconfig
+++ b/fs/pstore/Kconfig
@@ -19,6 +19,18 @@ config PSTORE_CONSOLE
 	  When the option is enabled, pstore will log all kernel
 	  messages, even if no oops or panic happened.
 
+config PSTORE_FTRACE
+	bool "Persistent function tracer"
+	depends on PSTORE
+	depends on FUNCTION_TRACER
+	help
+	  With this option kernel traces function calls into a persistent
+	  ram buffer that can be decoded and dumped after reboot through
+	  pstore filesystem. It can be used to determine what function
+	  was last called before a reset or panic.
+
+	  If unsure, say N.
+
 config PSTORE_RAM
 	tristate "Log panic/oops to a RAM buffer"
 	depends on PSTORE
diff --git a/fs/pstore/Makefile b/fs/pstore/Makefile
index 278a44e..cc6aa3d 100644
--- a/fs/pstore/Makefile
+++ b/fs/pstore/Makefile
@@ -7,4 +7,10 @@ obj-y += pstore.o
 pstore-objs += inode.o platform.o
 
 ramoops-objs += ram.o ram_core.o
+
+ifeq ($(CONFIG_PSTORE_FTRACE),y)
+ramoops-objs += ftrace.o
+CFLAGS_REMOVE_ftrace.o = -pg
+endif
+
 obj-$(CONFIG_PSTORE_RAM)	+= ramoops.o
diff --git a/fs/pstore/ftrace.c b/fs/pstore/ftrace.c
new file mode 100644
index 0000000..eb16773
--- /dev/null
+++ b/fs/pstore/ftrace.c
@@ -0,0 +1,122 @@
+/*
+ * Copyright 2012  Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/compiler.h>
+#include <linux/irqflags.h>
+#include <linux/smp.h>
+#include <linux/atomic.h>
+#include <asm/barrier.h>
+#include "../../../kernel/trace/trace.h"
+#include "internal.h"
+
+static int pstore_ftrace_enabled;
+static struct trace_array *pstore_ftrace_array;
+
+static void pstore_ftrace_call(unsigned long ip, unsigned long parent_ip)
+{
+	struct trace_array *tr = pstore_ftrace_array;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int cpu;
+
+	smp_rmb();
+	if (unlikely(!pstore_ftrace_enabled))
+		return;
+
+	if (unlikely(oops_in_progress))
+		return;
+
+	/*
+	 * Need to use raw, since this must be called before the
+	 * recursive protection is performed.
+	 */
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+
+	if (likely(disabled == 1)) {
+		struct pstore_ftrace_record rec = {};
+
+		rec.ip = ip;
+		rec.parent_ip = parent_ip;
+		pstore_ftrace_encode_cpu(&rec, cpu);
+		psinfo->write_buf(PSTORE_TYPE_FTRACE, 0, NULL, 0, (void *)&rec,
+				  sizeof(rec), psinfo);
+	}
+
+	atomic_dec(&data->disabled);
+	local_irq_restore(flags);
+}
+
+static struct ftrace_ops pstore_ftrace_ops __read_mostly = {
+	.func = pstore_ftrace_call,
+	.flags = FTRACE_OPS_FL_GLOBAL,
+};
+
+static int pstore_ftracer_init(struct trace_array *tr)
+{
+	if (!psinfo->write_buf) {
+		pr_info("%s: write_buf required, fix your backend\n", __func__);
+		return -ENOSYS;
+	}
+
+	pstore_ftrace_array = tr;
+	tr->cpu = get_cpu();
+	put_cpu();
+
+	tracing_start_cmdline_record();
+
+	pstore_ftrace_enabled = 0;
+	smp_wmb();
+
+	register_ftrace_function(&pstore_ftrace_ops);
+
+	smp_wmb();
+	pstore_ftrace_enabled = 1;
+	return 0;
+}
+
+static void pstore_ftrace_reset(struct trace_array *tr)
+{
+	pstore_ftrace_enabled = 0;
+	smp_wmb();
+
+	unregister_ftrace_function(&pstore_ftrace_ops);
+
+	tracing_stop_cmdline_record();
+}
+
+static void pstore_ftrace_start(struct trace_array *tr)
+{
+	tracing_reset_online_cpus(tr);
+}
+
+static struct tracer pstore_ftracer __read_mostly = {
+	.name		= "persistent",
+	.init		= pstore_ftracer_init,
+	.reset		= pstore_ftrace_reset,
+	.start		= pstore_ftrace_start,
+	.wait_pipe	= poll_wait_pipe,
+};
+
+void pstore_register_ftrace(void)
+{
+	int err;
+
+	err = register_tracer(&pstore_ftracer);
+	if (err)
+		pr_err("%s: failed to register tracer: %d\n", __func__, err);
+}
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index fda1331..5368b6d 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -27,6 +27,7 @@
 #include <linux/list.h>
 #include <linux/string.h>
 #include <linux/mount.h>
+#include <linux/seq_file.h>
 #include <linux/ramfs.h>
 #include <linux/parser.h>
 #include <linux/sched.h>
@@ -52,18 +53,117 @@ struct pstore_private {
 	char	data[];
 };
 
+struct pstore_ftrace_seq_data {
+	const void *ptr;
+	size_t off;
+	size_t size;
+};
+
+#define REC_SIZE sizeof(struct pstore_ftrace_record)
+
+static void *pstore_ftrace_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct pstore_private *ps = s->private;
+	struct pstore_ftrace_seq_data *data;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return NULL;
+
+	data->off = ps->size % REC_SIZE;
+	data->off += *pos * REC_SIZE;
+	if (data->off + REC_SIZE > ps->size) {
+		kfree(data);
+		return NULL;
+	}
+
+	return data;
+
+}
+
+static void pstore_ftrace_seq_stop(struct seq_file *s, void *v)
+{
+	kfree(v);
+}
+
+static void *pstore_ftrace_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct pstore_private *ps = s->private;
+	struct pstore_ftrace_seq_data *data = v;
+
+	data->off += REC_SIZE;
+	if (data->off + REC_SIZE > ps->size)
+		return NULL;
+
+	(*pos)++;
+	return data;
+}
+
+static int pstore_ftrace_seq_show(struct seq_file *s, void *v)
+{
+	struct pstore_private *ps = s->private;
+	struct pstore_ftrace_seq_data *data = v;
+	struct pstore_ftrace_record *rec = (void *)(ps->data + data->off);
+
+	seq_printf(s, "%d %08lx  %08lx  %pf <- %pF\n",
+		pstore_ftrace_decode_cpu(rec), rec->ip, rec->parent_ip,
+		(void *)rec->ip, (void *)rec->parent_ip);
+
+	return 0;
+}
+
+static const struct seq_operations pstore_ftrace_seq_ops = {
+	.start	= pstore_ftrace_seq_start,
+	.next	= pstore_ftrace_seq_next,
+	.stop	= pstore_ftrace_seq_stop,
+	.show	= pstore_ftrace_seq_show,
+};
+
 static ssize_t pstore_file_read(struct file *file, char __user *userbuf,
 						size_t count, loff_t *ppos)
 {
-	struct pstore_private *ps = file->private_data;
+	struct seq_file *sf = file->private_data;
+	struct pstore_private *ps = sf->private;
 
+	if (ps->type == PSTORE_TYPE_FTRACE)
+		return seq_read(file, userbuf, count, ppos);
 	return simple_read_from_buffer(userbuf, count, ppos, ps->data, ps->size);
 }
 
+static int pstore_file_open(struct inode *inode, struct file *file)
+{
+	struct pstore_private *ps = inode->i_private;
+	struct seq_file *sf;
+	int err;
+	const struct seq_operations *sops = NULL;
+
+	if (ps->type == PSTORE_TYPE_FTRACE)
+		sops = &pstore_ftrace_seq_ops;
+
+	err = seq_open(file, sops);
+	if (err < 0)
+		return err;
+
+	sf = file->private_data;
+	sf->private = ps;
+
+	return 0;
+}
+
+static loff_t pstore_file_llseek(struct file *file, loff_t off, int origin)
+{
+	struct seq_file *sf = file->private_data;
+
+	if (sf->op)
+		return seq_lseek(file, off, origin);
+	return default_llseek(file, off, origin);
+}
+
 static const struct file_operations pstore_file_operations = {
-	.open	= simple_open,
-	.read	= pstore_file_read,
-	.llseek	= default_llseek,
+	.open		= pstore_file_open,
+	.read		= pstore_file_read,
+	.llseek		= pstore_file_llseek,
+	.release	= seq_release,
 };
 
 /*
@@ -215,6 +315,9 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id,
 	case PSTORE_TYPE_CONSOLE:
 		sprintf(name, "console-%s", psname);
 		break;
+	case PSTORE_TYPE_FTRACE:
+		sprintf(name, "ftrace-%s", psname);
+		break;
 	case PSTORE_TYPE_MCE:
 		sprintf(name, "mce-%s-%lld", psname, id);
 		break;
diff --git a/fs/pstore/internal.h b/fs/pstore/internal.h
index 3bde461..6e09673 100644
--- a/fs/pstore/internal.h
+++ b/fs/pstore/internal.h
@@ -1,6 +1,55 @@
+#ifndef __PSTORE_INTERNAL_H__
+#define __PSTORE_INTERNAL_H__
+
+#include <linux/pstore.h>
+
+#if NR_CPUS <= 2 && defined(CONFIG_ARM_THUMB)
+#define PSTORE_CPU_IN_IP 0x1
+#elif NR_CPUS <= 4 && defined(CONFIG_ARM)
+#define PSTORE_CPU_IN_IP 0x3
+#endif
+
+struct pstore_ftrace_record {
+	unsigned long ip;
+	unsigned long parent_ip;
+#ifndef PSTORE_CPU_IN_IP
+	unsigned int cpu;
+#endif
+};
+
+static inline void
+pstore_ftrace_encode_cpu(struct pstore_ftrace_record *rec, unsigned int cpu)
+{
+#ifndef PSTORE_CPU_IN_IP
+	rec->cpu = cpu;
+#else
+	rec->ip |= cpu;
+#endif
+}
+
+static inline unsigned int
+pstore_ftrace_decode_cpu(struct pstore_ftrace_record *rec)
+{
+#ifndef PSTORE_CPU_IN_IP
+	return rec->cpu;
+#else
+	return rec->ip & PSTORE_CPU_IN_IP;
+#endif
+}
+
+#ifdef CONFIG_PSTORE_FTRACE
+extern void pstore_register_ftrace(void);
+#else
+static inline void pstore_register_ftrace(void) {}
+#endif
+
+extern struct pstore_info *psinfo;
+
 extern void	pstore_set_kmsg_bytes(int);
 extern void	pstore_get_records(int);
 extern int	pstore_mkfile(enum pstore_type_id, char *psname, u64 id,
 			      char *data, size_t size,
 			      struct timespec time, struct pstore_info *psi);
 extern int	pstore_is_mounted(void);
+
+#endif
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index e7c0a52..89995da 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -61,7 +61,7 @@ static DECLARE_WORK(pstore_work, pstore_dowork);
  * calls to pstore_register()
  */
 static DEFINE_SPINLOCK(pstore_lock);
-static struct pstore_info *psinfo;
+struct pstore_info *psinfo;
 
 static char *backend;
 
@@ -246,6 +246,7 @@ int pstore_register(struct pstore_info *psi)
 
 	kmsg_dump_register(&pstore_dumper);
 	pstore_register_console();
+	pstore_register_ftrace();
 
 	if (pstore_update_ms >= 0) {
 		pstore_timer.expires = jiffies +
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index b107484..23afffe 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -30,6 +30,7 @@ enum pstore_type_id {
 	PSTORE_TYPE_DMESG	= 0,
 	PSTORE_TYPE_MCE		= 1,
 	PSTORE_TYPE_CONSOLE	= 2,
+	PSTORE_TYPE_FTRACE	= 3,
 	PSTORE_TYPE_UNKNOWN	= 255
 };
 
-- 
1.7.9.2

