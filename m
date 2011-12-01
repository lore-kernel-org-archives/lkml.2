Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab1LAQhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 11:37:46 -0500
Received: from relay2.sgi.com ([192.48.179.30]:43397 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755251Ab1LAQhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 11:37:45 -0500
Date: Thu, 1 Dec 2011 10:37:40 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
Message-ID: <20111201163740.GA11693@sgi.com>
References: <20111108191149.GA7236@sgi.com>
 <20111122160802.e99d6218.akpm@linux-foundation.org>
 <20111130152959.GA19205@sgi.com>
 <20111130161131.31cdccff.akpm@linux-foundation.org>
 <20111130161610.69c516f7.akpm@linux-foundation.org>
 <20111201020727.GB30097@sgi.com>
 <20111130181318.38f4659d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111130181318.38f4659d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 06:13:18PM -0800, Andrew Morton wrote:
> On Wed, 30 Nov 2011 20:07:27 -0600 Dimitri Sivanich <sivanich@sgi.com> wrote:
> 
> > > And the whole thing is racy, isn't it?  The "new" CPU can go offline a
> > > nanosecond after we performed that test, so why perform it at all?
> > 
> > See my email concerning the panic in cpu_online().
> 
> That doesn't address my question.
> 
> What's the point in checking cpu_online() when we have no locks to
> prevent the online map from changing?
> 
> What happens if this cpu goes offline immediately after that check has
> passed?

Yes, there is some raciness here, and I see your point.

I've changed the patch to protect the operation.  The version below should
resolve this with get/put_online_cpus.  It also checks input against
nr_cpu_ids before checking cpu_online(), which is what
for_each_present_cpu()->for_each_cpu() uses, and makes checkpatch.pl happy.




Show and modify the tick_do_timer_cpu via sysfs.  This determines the cpu
on which global time (jiffies) updates occur.  Modification can only be
done on systems with nohz mode turned off.

While not necessarily harmful, doing jiffies updates on an application cpu
does cause some extra overhead that HPC benchmarking people notice.  They
prefer to have OS activity isolated to certain cpus.  They like reproducibility
of results, and having jiffies updates bouncing around introduces variability.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
---
 Documentation/ABI/testing/sysfs-devices-system-timekeeping |   16 ++
 drivers/base/sys.c                                         |   10 -
 include/linux/sysdev.h                                     |    2 
 kernel/time/tick-sched.c                                   |   67 ++++++++++
 4 files changed, 89 insertions(+), 6 deletions(-)

Index: linux/include/linux/sysdev.h
===================================================================
--- linux.orig/include/linux/sysdev.h
+++ linux/include/linux/sysdev.h
@@ -132,6 +132,8 @@ struct sysdev_ext_attribute {
 	void *var;
 };
 
+#define SYSDEV_TO_EXT_ATTR(x) container_of(x, struct sysdev_ext_attribute, attr)
+
 /*
  * Support for simple variable sysdev attributes.
  * The pointer to the variable is stored in a sysdev_ext_attribute
Index: linux/drivers/base/sys.c
===================================================================
--- linux.orig/drivers/base/sys.c
+++ linux/drivers/base/sys.c
@@ -339,13 +339,11 @@ int __init system_bus_init(void)
 	return 0;
 }
 
-#define to_ext_attr(x) container_of(x, struct sysdev_ext_attribute, attr)
-
 ssize_t sysdev_store_ulong(struct sys_device *sysdev,
 			   struct sysdev_attribute *attr,
 			   const char *buf, size_t size)
 {
-	struct sysdev_ext_attribute *ea = to_ext_attr(attr);
+	struct sysdev_ext_attribute *ea = SYSDEV_TO_EXT_ATTR(attr);
 	char *end;
 	unsigned long new = simple_strtoul(buf, &end, 0);
 	if (end == buf)
@@ -360,7 +358,7 @@ ssize_t sysdev_show_ulong(struct sys_dev
 			  struct sysdev_attribute *attr,
 			  char *buf)
 {
-	struct sysdev_ext_attribute *ea = to_ext_attr(attr);
+	struct sysdev_ext_attribute *ea = SYSDEV_TO_EXT_ATTR(attr);
 	return snprintf(buf, PAGE_SIZE, "%lx\n", *(unsigned long *)(ea->var));
 }
 EXPORT_SYMBOL_GPL(sysdev_show_ulong);
@@ -369,7 +367,7 @@ ssize_t sysdev_store_int(struct sys_devi
 			   struct sysdev_attribute *attr,
 			   const char *buf, size_t size)
 {
-	struct sysdev_ext_attribute *ea = to_ext_attr(attr);
+	struct sysdev_ext_attribute *ea = SYSDEV_TO_EXT_ATTR(attr);
 	char *end;
 	long new = simple_strtol(buf, &end, 0);
 	if (end == buf || new > INT_MAX || new < INT_MIN)
@@ -384,7 +382,7 @@ ssize_t sysdev_show_int(struct sys_devic
 			  struct sysdev_attribute *attr,
 			  char *buf)
 {
-	struct sysdev_ext_attribute *ea = to_ext_attr(attr);
+	struct sysdev_ext_attribute *ea = SYSDEV_TO_EXT_ATTR(attr);
 	return snprintf(buf, PAGE_SIZE, "%d\n", *(int *)(ea->var));
 }
 EXPORT_SYMBOL_GPL(sysdev_show_int);
Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c
+++ linux/kernel/time/tick-sched.c
@@ -834,6 +834,73 @@ void tick_cancel_sched_timer(int cpu)
 }
 #endif
 
+#ifdef CONFIG_SYSFS
+/*
+ * Allow modification of tick_do_timer_cpu when nohz mode is off.
+ */
+static ssize_t sysfs_store_do_timer_cpu(struct sys_device *dev,
+						struct sysdev_attribute *attr,
+						const char *buf, size_t size)
+{
+	struct sysdev_ext_attribute *ea = SYSDEV_TO_EXT_ATTR(attr);
+	unsigned int new;
+	int rv;
+
+#ifdef CONFIG_NO_HZ
+	/* nohz mode not supported */
+	if (tick_nohz_enabled)
+		return -EINVAL;
+#endif
+
+	rv = kstrtouint(buf, 0, &new);
+	if (rv)
+		return rv;
+
+	/* Protect against cpu-hotplug */
+	get_online_cpus();
+
+	if (new >= nr_cpu_ids || !cpu_online(new)) {
+		put_online_cpus();
+		return -ERANGE;
+	}
+
+	*(unsigned int *)(ea->var) = new;
+
+	put_online_cpus();
+
+	return size;
+}
+
+static struct sysdev_ext_attribute attr_jiffies_cpu = {
+			_SYSDEV_ATTR(jiffies_cpu, 0644, sysdev_show_int,
+					sysfs_store_do_timer_cpu),
+			&tick_do_timer_cpu };
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
+				&attr_jiffies_cpu.attr);
+	return error;
+}
+
+device_initcall(init_timekeeping_sysfs);
+#endif /* SYSFS */
+
 /**
  * Async notification about clocksource changes
  */
Index: linux/Documentation/ABI/testing/sysfs-devices-system-timekeeping
===================================================================
--- /dev/null
+++ linux/Documentation/ABI/testing/sysfs-devices-system-timekeeping
@@ -0,0 +1,16 @@
+What:		/sys/devices/system/timekeeping/
+Date:		November 2011
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Timekeeping attributes
+
+
+What:		/sys/devices/system/timekeeping/timekeeping0/jiffies_cpu
+Date:		November 2011
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Show and modify the kernel's tick_do_timer_cpu.  This
+		determines the cpu on which global time (jiffies) updates
+		occur.  This can only be modified on systems running with
+		the nohz mode turned off (nohz=off).
+
+		Possible values are:
+			0 - <num online cpus>
