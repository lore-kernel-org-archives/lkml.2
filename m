Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab1K3PaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 10:30:05 -0500
Received: from relay1.sgi.com ([192.48.179.29]:53622 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756867Ab1K3PaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 10:30:01 -0500
Date: Wed, 30 Nov 2011 09:29:59 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
Message-ID: <20111130152959.GA19205@sgi.com>
References: <20111108191149.GA7236@sgi.com>
 <20111122160802.e99d6218.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122160802.e99d6218.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 04:08:02PM -0800, Andrew Morton wrote:
> On Tue, 8 Nov 2011 13:11:49 -0600
> Dimitri Sivanich <sivanich@sgi.com> wrote:
> > Allow manual override of the tick_do_timer_cpu.
> > 
> > While not necessarily harmful, doing jiffies updates on an application cpu
> > does cause some extra overhead that HPC benchmarking people notice.  They
> > prefer to have OS activity isolated to certain cpus.  They like reproducibility
> > of results, and having jiffies updates bouncing around introduces variability.
> 
> This doesn't really explain what the patch does.  "override" with what?
> What effects can the user expect to see from doing
> the-action-which-you-didn't-describe?

Hopefully my new description and documentation are acceptable.

> > +sysfs_show_do_timer_cpu(struct sys_device *dev,
> > +				struct sysdev_attribute *attr, char *buf)
> > +{
> > +	ssize_t count = 0;
> > +
> > +	count = snprintf(buf, PAGE_SIZE, "%d\n", tick_do_timer_cpu);
> > +
> > +	return count;
> 
> Save some trees:
> 
> 	return snprintf(buf, PAGE_SIZE, "%d\n", tick_do_timer_cpu);

The new patch below should address this by using the already existing
'sysdev_show_int' function.

> > +
> > +	if (sscanf(b, "%d", &c) != 1)
> > +		return -EINVAL;
> 
> You should be able to use strim() in here, and eliminate b[].  Not that
> the \n needed to be removed anyway!  I think it's OK to modify the
> incoming memory for sysfs write handlers.
> 
> Also, kstrto*() should be used to detect and reject input of the form
> "42foo".

Using kstrtouint, see patch below.

> 
> But surely we have a helper function somewhere to read an integer out
> of a sysfs-written buffer.  If not, we should!

Here I need more strict input checking for online cpu values.

> 
> > +	if (!cpu_online(c))
> > +		return -EINVAL;
> > +
> > +	tick_do_timer_cpu = c;
> > +
> > +	return ret;
> > +}
> > +
> > +/*
> > + * Sysfs setup bits:
> > + */
> > +static SYSDEV_ATTR(jiffies_cpu, 0644, sysfs_show_do_timer_cpu,
> > +		   sysfs_override_do_timer_cpu);
> > +
> > +static struct sysdev_class timekeeping_sysclass = {
> > +	.name = "timekeeping",
> > +};
> 
> The patch shouod add some user-facing documentation for the user-facing
> feature.

Hopefully documenting this in Documentation/ABI/testing is acceptable at this
point(?).  See patch below.




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
 kernel/time/tick-sched.c                                   |   59 ++++++++++
 4 files changed, 81 insertions(+), 6 deletions(-)

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
@@ -834,6 +834,65 @@ void tick_cancel_sched_timer(int cpu)
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
+	if (new >= NR_CPUS || !cpu_online(new))
+		return -ERANGE;
+
+	*(unsigned int *)(ea->var) = new;
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
