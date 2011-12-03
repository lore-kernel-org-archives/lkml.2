Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1LCVHN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 16:07:13 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47816 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab1LCVHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 16:07:09 -0500
X-Originating-IP: 217.70.178.146
X-Originating-IP: 50.43.15.19
Date: Sat, 3 Dec 2011 13:06:50 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 6/7] driver-core/cpu: Add
 cpu_is_hotpluggable() for rcutorture error analysis
Message-ID: <20111203210650.GA17377@leaf>
References: <20111203183417.GA18914@linux.vnet.ibm.com>
 <1322937282-19846-6-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322937282-19846-6-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 03, 2011 at 10:34:41AM -0800, Paul E. McKenney wrote:
> The rcutorture test now can automatically exercise CPU hotplug and
> collect success statistics, which can be correlated with other rcutorture
> activity.  This permits rcutorture to completely exercise RCU regardless
> of what sort of userspace and filesystem layout is in use.  Unfortunately,
> rcutorture is happy to attempt to offline CPUs that cannot be offlined,
> for example, CPU 0 in both the x86 and ARM architectures.  Although this
> allows rcutorture testing to proceed normally, it confounds attempts at
> error analysis due to the resulting flood of spurious CPU-hotplug errors.
> 
> Therefore, this commit creates a cpu_is_hotpluggable() function that
> allows rcutorture to avoid attempting to offline CPUs that are not
> hotpluggable, which in turn allows rcutorture to avoid reporting spurious
> CPU-hotplug errors.  Note that this function is EXPORT_SYMBOL_GPL()
> to allow rcutorture to use it when compiled as a kernel module.
> This commit also includes modifications to rcutorture to use this
> new function.

I'd suggest writing this as a two-patch series: add the API, then use
it.

I'd also suggest making the more general case for this API, beyond just
rcutorture.

> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -23,6 +23,7 @@ struct sysdev_class cpu_sysdev_class = {
>  EXPORT_SYMBOL(cpu_sysdev_class);
>  
>  static DEFINE_PER_CPU(struct sys_device *, cpu_sys_devices);
> +static DEFINE_PER_CPU(bool, is_hotpluggable);
[...]
> @@ -224,8 +226,10 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
>  
>  	error = sysdev_register(&cpu->sysdev);
>  
> -	if (!error && cpu->hotpluggable)
> +	if (!error && cpu->hotpluggable) {
>  		register_cpu_control(cpu);
> +		per_cpu(is_hotpluggable, num) = 1;
> +	}

This information already exists in the ->hotpluggable field of "struct
cpu".  I'd suggest an alternate approach (included as a patch below),
which avoids the need to add a new per_cpu property redundant with
->hotpluggable.

Note that you can get to the patch below via "git am --scissors", or
just by copy/pasting it.

---8<---
From: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH] driver-core/cpu: Expose hotpluggability to the rest of the kernel

When architectures register CPUs, they indicate whether the CPU allows
hotplugging; notably, x86 and ARM don't allow hotplugging CPU 0.
Userspace can easily query the hotpluggability of a CPU via sysfs;
however, the kernel has no convenient way of accessing that property in
an architecture-independent way.  While the kernel can simply try it and
see, some code needs to distinguish between "hotplug failed" and
"hotplug has no hope of working on this CPU"; for example, rcutorture's
CPU hotplug tests want to avoid drowning out real hotplug failures with
expected failures.

Expose this property via a new cpu_is_hotpluggable function, so that the
rest of the kernel can access it in an architecture-independent way.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/base/cpu.c  |    7 +++++++
 include/linux/cpu.h |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 251acea..3991502 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -247,6 +247,13 @@ struct sys_device *get_cpu_sysdev(unsigned cpu)
 }
 EXPORT_SYMBOL_GPL(get_cpu_sysdev);
 
+bool cpu_is_hotpluggable(unsigned cpu)
+{
+	struct sys_device *dev = get_cpu_sysdev(cpu);
+	return dev && container_of(dev, struct cpu, sysdev)->hotpluggable;
+}
+EXPORT_SYMBOL_GPL(cpu_is_hotpluggable);
+
 int __init cpu_dev_init(void)
 {
 	int err;
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 6cb60fd..305c263 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -27,6 +27,7 @@ struct cpu {
 
 extern int register_cpu(struct cpu *cpu, int num);
 extern struct sys_device *get_cpu_sysdev(unsigned cpu);
+extern bool cpu_is_hotpluggable(unsigned cpu);
 
 extern int cpu_add_sysdev_attr(struct sysdev_attribute *attr);
 extern void cpu_remove_sysdev_attr(struct sysdev_attribute *attr);
-- 
1.7.7.3
