Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab1IBTaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 15:30:05 -0400
Received: from relay3.sgi.com ([192.48.152.1]:53975 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754875Ab1IBTaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 15:30:00 -0400
Date: Fri, 2 Sep 2011 14:29:58 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
Message-ID: <20110902192958.GB30665@sgi.com>
References: <20110817160759.GA3482@sgi.com>
 <alpine.LFD.2.02.1108171819120.2807@ionos>
 <20110823195628.GB4533@sgi.com>
 <alpine.LFD.2.02.1109021015290.2723@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1109021015290.2723@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 10:19:36AM +0200, Thomas Gleixner wrote:
> On Tue, 23 Aug 2011, Dimitri Sivanich wrote:
> > On Wed, Aug 17, 2011 at 06:47:43PM +0200, Thomas Gleixner wrote:
> > > On Wed, 17 Aug 2011, Dimitri Sivanich wrote:
> > While not necessarily harmful, doing jiffies updates on an application cpu
> > does cause some extra overhead that HPC benchmarking people notice.  They
> > prefer to have OS activity isolated to certain cpus.  They like reproducibility
> > of results, and having jiffies updates bouncing around introduces variability.
> > 
> > Maybe this is useful for other folks as well?  It does give an indication
> > of which cpu is currently doing jiffies updates.
> > 
> > The patch below puts the file in /proc/sys/kernel, but if you think it should be in
> > /sys, please let me know where you'd like to see it.
> 
> /sys/devices/system/timekeeping/timekeeping0/....
>  
> Please
>

/sys/devices/system/timekeeping/timekeeping0/jiffies_cpu

 
Allow manual override of the tick_do_timer_cpu.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
---
 kernel/time/tick-sched.c |   98 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c
+++ linux/kernel/time/tick-sched.c
@@ -815,6 +815,104 @@ void tick_cancel_sched_timer(int cpu)
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
