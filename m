Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030648Ab2CGWAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:00:37 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51063 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563Ab2CGV6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:58:42 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Colin Cross <ccross@android.com>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 11/13] android: persistent_trace: ftrace into persistent_ram
Date: Wed,  7 Mar 2012 13:58:21 -0800
Message-Id: <1331157503-3413-12-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030721-7182-0000-0000-000000FDF953
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

persistent_trace uses the ftrace infrastructure, but traces
into a persistent_ram buffer instead of the regular ftrace
ringbuffer.  After a reset or panic, the trace can be
decoded with cat /sys/kernel/debug/persistent_trace.

CC: Greg KH <gregkh@linuxfoundation.org>
CC: Android Kernel Team <kernel-team@android.com>
Change-Id: Ia6025ccc323599c7844e0783af0386d32ed7419e
Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/Kconfig            |   14 ++
 drivers/staging/android/Makefile           |    3 +
 drivers/staging/android/trace_persistent.c |  242 ++++++++++++++++++++++++++++
 3 files changed, 259 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/android/trace_persistent.c

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index 08a3b11..bc33ab9 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -37,6 +37,20 @@ config ANDROID_RAM_CONSOLE
 	select ANDROID_PERSISTENT_RAM
 	default n
 
+config PERSISTENT_TRACER
+	bool "Persistent function tracer"
+	depends on HAVE_FUNCTION_TRACER
+	select FUNCTION_TRACER
+	select ANDROID_PERSISTENT_RAM
+	help
+	  persistent_trace traces function calls into a persistent ram
+	  buffer that can be decoded and dumped after reboot through
+	  /sys/kernel/debug/persistent_trace.  It can be used to
+	  determine what function was last called before a reset or
+	  panic.
+
+	  If unsure, say N.
+
 config ANDROID_TIMED_OUTPUT
 	bool "Timed output class driver"
 	default y
diff --git a/drivers/staging/android/Makefile b/drivers/staging/android/Makefile
index 9b6c9ed..35ffdfe 100644
--- a/drivers/staging/android/Makefile
+++ b/drivers/staging/android/Makefile
@@ -9,3 +9,6 @@ obj-$(CONFIG_ANDROID_LOW_MEMORY_KILLER)	+= lowmemorykiller.o
 obj-$(CONFIG_ANDROID_SWITCH)		+= switch/
 obj-$(CONFIG_ANDROID_INTF_ALARM)	+= alarm.o
 obj-$(CONFIG_ANDROID_INTF_ALARM_DEV)	+= alarm-dev.o
+obj-$(CONFIG_PERSISTENT_TRACER)		+= trace_persistent.o
+
+CFLAGS_REMOVE_trace_persistent.o = -pg
diff --git a/drivers/staging/android/trace_persistent.c b/drivers/staging/android/trace_persistent.c
new file mode 100644
index 0000000..176b4ff
--- /dev/null
+++ b/drivers/staging/android/trace_persistent.c
@@ -0,0 +1,242 @@
+/*
+ * Copyright (C) 2012 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/debugfs.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+
+#include "persistent_ram.h"
+#include "../../../kernel/trace/trace.h"
+
+struct persistent_trace_record {
+	unsigned long ip;
+	unsigned long parent_ip;
+};
+
+#define REC_SIZE sizeof(struct persistent_trace_record)
+
+static struct persistent_ram_zone *persistent_trace;
+
+static int persistent_trace_enabled;
+
+static struct trace_array *persistent_trace_array;
+
+static struct ftrace_ops trace_ops;
+
+static int persistent_tracer_init(struct trace_array *tr)
+{
+	persistent_trace_array = tr;
+	tr->cpu = get_cpu();
+	put_cpu();
+
+	tracing_start_cmdline_record();
+
+	persistent_trace_enabled = 0;
+	smp_wmb();
+
+	register_ftrace_function(&trace_ops);
+
+	smp_wmb();
+	persistent_trace_enabled = 1;
+
+	return 0;
+}
+
+static void persistent_trace_reset(struct trace_array *tr)
+{
+	persistent_trace_enabled = 0;
+	smp_wmb();
+
+	unregister_ftrace_function(&trace_ops);
+
+	tracing_stop_cmdline_record();
+}
+
+static void persistent_trace_start(struct trace_array *tr)
+{
+	tracing_reset_online_cpus(tr);
+}
+
+static void persistent_trace_call(unsigned long ip, unsigned long parent_ip)
+{
+	struct trace_array *tr = persistent_trace_array;
+	struct trace_array_cpu *data;
+	long disabled;
+	struct persistent_trace_record rec;
+	unsigned long flags;
+	int cpu;
+
+	smp_rmb();
+	if (unlikely(!persistent_trace_enabled))
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
+		rec.ip = ip;
+		rec.parent_ip = parent_ip;
+		rec.ip |= cpu;
+		persistent_ram_write(persistent_trace, &rec, sizeof(rec));
+	}
+
+	atomic_dec(&data->disabled);
+	local_irq_restore(flags);
+}
+
+static struct ftrace_ops trace_ops __read_mostly = {
+	.func = persistent_trace_call,
+	.flags = FTRACE_OPS_FL_GLOBAL,
+};
+
+static struct tracer persistent_tracer __read_mostly = {
+	.name		= "persistent",
+	.init		= persistent_tracer_init,
+	.reset		= persistent_trace_reset,
+	.start		= persistent_trace_start,
+	.wait_pipe	= poll_wait_pipe,
+};
+
+struct persistent_trace_seq_data {
+	const void *ptr;
+	size_t off;
+	size_t size;
+};
+
+void *persistent_trace_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct persistent_trace_seq_data *data;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return NULL;
+
+	data->ptr = persistent_ram_old(persistent_trace);
+	data->size = persistent_ram_old_size(persistent_trace);
+	data->off = data->size % REC_SIZE;
+
+	data->off += *pos * REC_SIZE;
+
+	if (data->off + REC_SIZE > data->size) {
+		kfree(data);
+		return NULL;
+	}
+
+	return data;
+
+}
+void persistent_trace_seq_stop(struct seq_file *s, void *v)
+{
+	kfree(v);
+}
+
+void *persistent_trace_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct persistent_trace_seq_data *data = v;
+
+	data->off += REC_SIZE;
+
+	if (data->off + REC_SIZE > data->size)
+		return NULL;
+
+	(*pos)++;
+
+	return data;
+}
+
+int persistent_trace_seq_show(struct seq_file *s, void *v)
+{
+	struct persistent_trace_seq_data *data = v;
+	struct persistent_trace_record *rec;
+
+	rec = (struct persistent_trace_record *)(data->ptr + data->off);
+
+	seq_printf(s, "%ld %08lx  %08lx  %pf <- %pF\n",
+		rec->ip & 3, rec->ip, rec->parent_ip,
+		(void *)rec->ip, (void *)rec->parent_ip);
+
+	return 0;
+}
+
+static const struct seq_operations persistent_trace_seq_ops = {
+	.start = persistent_trace_seq_start,
+	.next = persistent_trace_seq_next,
+	.stop = persistent_trace_seq_stop,
+	.show = persistent_trace_seq_show,
+};
+
+static int persistent_trace_old_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &persistent_trace_seq_ops);
+}
+
+static const struct file_operations persistent_trace_old_fops = {
+	.open		= persistent_trace_old_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int persistent_trace_probe(struct platform_device *pdev)
+{
+	struct dentry *d;
+	int ret;
+
+	persistent_trace = persistent_ram_init_ringbuffer(&pdev->dev, false);
+	if (IS_ERR(persistent_trace)) {
+		pr_err("persistent_trace: failed to init ringbuffer: %ld\n",
+				PTR_ERR(persistent_trace));
+		return PTR_ERR(persistent_trace);
+	}
+
+	ret = register_tracer(&persistent_tracer);
+	if (ret)
+		pr_err("persistent_trace: failed to register tracer");
+
+	if (persistent_ram_old_size(persistent_trace) > 0) {
+		d = debugfs_create_file("persistent_trace", S_IRUGO, NULL,
+			NULL, &persistent_trace_old_fops);
+		if (IS_ERR_OR_NULL(d))
+			pr_err("persistent_trace: failed to create old file\n");
+	}
+
+	return 0;
+}
+
+static struct platform_driver persistent_trace_driver  = {
+	.probe = persistent_trace_probe,
+	.driver		= {
+		.name	= "persistent_trace",
+	},
+};
+
+static int __init persistent_trace_init(void)
+{
+	return platform_driver_register(&persistent_trace_driver);
+}
+core_initcall(persistent_trace_init);
-- 
1.7.3.2.146.gca209

