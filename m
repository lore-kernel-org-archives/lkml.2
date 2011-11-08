Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072Ab1KHTLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:11:52 -0500
Received: from relay3.sgi.com ([192.48.152.1]:36795 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752940Ab1KHTLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:11:51 -0500
Date: Tue, 8 Nov 2011 13:11:49 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] specific do_timer_cpu value for nohz off mode
Message-ID: <20111108191149.GA7236@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending this.


Allow manual override of the tick_do_timer_cpu.

While not necessarily harmful, doing jiffies updates on an application cpu
does cause some extra overhead that HPC benchmarking people notice.  They
prefer to have OS activity isolated to certain cpus.  They like reproducibility
of results, and having jiffies updates bouncing around introduces variability.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
---
 kernel/time/tick-sched.c |   98 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c
+++ linux/kernel/time/tick-sched.c
@@ -834,6 +834,104 @@ void tick_cancel_sched_timer(int cpu)
 }
 #endif
 
+
+#ifdef CONFIG_SYSFS
+/**
+ * sysfs_show_do_timer_cpu - sysfs interface for tick_do_timer_cpu
+ * @dev:        unused
+ * @buf:        char buffer where value of tick_do_timer_cpu is copied
+ *
+ * Provides sysfs interface for showing the current tick_do_timer_cpu.
+ */
+static ssize_t
+sysfs_show_do_timer_cpu(struct sys_device *dev,
+				struct sysdev_attribute *attr, char *buf)
+{
+	ssize_t count = 0;
+
+	count = snprintf(buf, PAGE_SIZE, "%d\n", tick_do_timer_cpu);
+
+	return count;
+}
+
+/**
+ * sysfs_override_do_timer_cpu - manually override tick_do_timer_cpu
+ * @dev:        unused
+ * @buf:        cpu number of desired tick_do_timer_cpu
+ * @count:      length of buffer
+ *
+ * Takes input from sysfs interface for manually overriding the selected
+ * tick_do_timer_cpu.  Only applicable when not running in nohz mode.
+ */
+static ssize_t
+sysfs_override_do_timer_cpu(struct sys_device *dev,
+					struct sysdev_attribute *attr,
+					const char *buf, size_t count)
+{
+	char b[16];
+	size_t ret = count;
+	int c;
+
+#ifdef CONFIG_NO_HZ
+	/* nohz mode not supported */
+	if (tick_nohz_enabled)
+		return -EINVAL;
+#endif
+	/* strings from sysfs write are not 0 terminated! */
+	if (count >= sizeof(b))
+		return -EINVAL;
+
+	/* strip off \n: */
+	if (buf[count-1] == '\n')
+		count--;
+	if (count < 1)
+		return -EINVAL;
+
+	memcpy(b, buf, count);
+	b[count] = 0;
+
+	if (sscanf(b, "%d", &c) != 1)
+		return -EINVAL;
+
+	if (!cpu_online(c))
+		return -EINVAL;
+
+	tick_do_timer_cpu = c;
+
+	return ret;
+}
+
+/*
+ * Sysfs setup bits:
+ */
+static SYSDEV_ATTR(jiffies_cpu, 0644, sysfs_show_do_timer_cpu,
+		   sysfs_override_do_timer_cpu);
+
+static struct sysdev_class timekeeping_sysclass = {
+	.name = "timekeeping",
+};
+
+static struct sys_device device_timekeeping = {
+	.id     = 0,
+	.cls    = &timekeeping_sysclass,
+};
+
+static int __init init_timekeeping_sysfs(void)
+{
+	int error = sysdev_class_register(&timekeeping_sysclass);
+
+	if (!error)
+		error = sysdev_register(&device_timekeeping);
+	if (!error)
+		error = sysdev_create_file(
+				&device_timekeeping,
+				&attr_jiffies_cpu);
+	return error;
+}
+
+device_initcall(init_timekeeping_sysfs);
+#endif /* SYSFS */
+
 /**
  * Async notification about clocksource changes
  */
