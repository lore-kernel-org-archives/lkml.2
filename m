Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab2APW2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 17:28:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab2APW2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 17:28:48 -0500
Date: Mon, 16 Jan 2012 14:28:35 -0800
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Sergei Trofimovich <slyich@gmail.com>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com
Subject: Re: 3.2.0-07927-gc49c41a: s2ram: Device 'machinecheck1' does not
 have a release() function, it is broken and must be fixed
Message-ID: <20120116222835.GA4869@suse.de>
References: <Pine.LNX.4.44L0.1201161645490.11125-100000@netrider.rowland.org>
 <201201162308.49530.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201162308.49530.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 11:08:49PM +0100, Rafael J. Wysocki wrote:
> On Monday, January 16, 2012, Alan Stern wrote:
> > On Mon, 16 Jan 2012, Rafael J. Wysocki wrote:
> > 
> > > On Monday, January 16, 2012, Srivatsa S. Bhat wrote:
> > 
> > > > Just to re-instate, an end-user need not really worry about this warning
> > > > too much since this was there before (at a different place, and hidden)
> > > > when things were working fine... Hence it would be worthwhile to fix
> > > > this warning "correctly" if possible, than just do a quick and dirty
> > > > "silence the warning" kind of workaround. 
> > > 
> > > Well, since there's nothing to release in there, I really see only two
> > > possible "fixes": either silence the warning the way you describe, or
> > > remove it from the core.
> > 
> > No, the right fix is to release something.  The device structures
> > should be allocated dynamically, not statically.  Greg's suggestion of
> > using a set of per-cpu pointers to dynamically-allocated structures
> > sounds right.
> 
> OK, so the source of the problem is that the device structure is statically
> allocated, right?

Yes, the patch below is what I am currently testing (my laptop is taking
a while to rebuild.)  It shows the general idea here...

thanks,

greg k-h

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index f35ce43..6aefb14 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -151,7 +151,7 @@ static inline void enable_p5_mce(void) {}
 
 void mce_setup(struct mce *m);
 void mce_log(struct mce *m);
-DECLARE_PER_CPU(struct device, mce_device);
+extern struct device *mce_device[CONFIG_NR_CPUS];
 
 /*
  * Maximum banks number.
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 29ba329..5a11ae2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1859,7 +1859,7 @@ static struct bus_type mce_subsys = {
 	.dev_name	= "machinecheck",
 };
 
-DEFINE_PER_CPU(struct device, mce_device);
+struct device *mce_device[CONFIG_NR_CPUS];
 
 __cpuinitdata
 void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
@@ -2001,19 +2001,27 @@ static struct device_attribute *mce_device_attrs[] = {
 
 static cpumask_var_t mce_device_initialized;
 
+static void mce_device_release(struct device *dev)
+{
+	kfree(dev);
+}
+
 /* Per cpu device init. All of the cpus still share the same ctrl bank: */
 static __cpuinit int mce_device_create(unsigned int cpu)
 {
-	struct device *dev = &per_cpu(mce_device, cpu);
+	struct device *dev;
 	int err;
 	int i, j;
 
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 
-	memset(dev, 0, sizeof(struct device));
+	dev = kzalloc(sizeof *dev, GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
 	dev->id  = cpu;
 	dev->bus = &mce_subsys;
+	dev->release = &mce_device_release;
 
 	err = device_register(dev);
 	if (err)
@@ -2030,6 +2038,7 @@ static __cpuinit int mce_device_create(unsigned int cpu)
 			goto error2;
 	}
 	cpumask_set_cpu(cpu, mce_device_initialized);
+	mce_device[cpu] = dev;
 
 	return 0;
 error2:
@@ -2046,7 +2055,7 @@ error:
 
 static __cpuinit void mce_device_remove(unsigned int cpu)
 {
-	struct device *dev = &per_cpu(mce_device, cpu);
+	struct device *dev = mce_device[cpu];
 	int i;
 
 	if (!cpumask_test_cpu(cpu, mce_device_initialized))
@@ -2060,6 +2069,7 @@ static __cpuinit void mce_device_remove(unsigned int cpu)
 
 	device_unregister(dev);
 	cpumask_clear_cpu(cpu, mce_device_initialized);
+	mce_device[cpu] = NULL;
 }
 
 /* Make sure there are no machine checks on offlined CPUs. */
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index ba0b94a..786e76a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -523,6 +523,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 {
 	int i, err = 0;
 	struct threshold_bank *b = NULL;
+	struct device *dev = mce_device[cpu];
 	char name[32];
 
 	sprintf(name, "threshold_bank%i", bank);
@@ -543,8 +544,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		if (!b)
 			goto out;
 
-		err = sysfs_create_link(&per_cpu(mce_device, cpu).kobj,
-					b->kobj, name);
+		err = sysfs_create_link(&dev->kobj, b->kobj, name);
 		if (err)
 			goto out;
 
@@ -565,7 +565,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		goto out;
 	}
 
-	b->kobj = kobject_create_and_add(name, &per_cpu(mce_device, cpu).kobj);
+	b->kobj = kobject_create_and_add(name, &dev->kobj);
 	if (!b->kobj)
 		goto out_free;
 
@@ -585,8 +585,9 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		if (i == cpu)
 			continue;
 
-		err = sysfs_create_link(&per_cpu(mce_device, i).kobj,
-					b->kobj, name);
+		dev = mce_device[i];
+		if (dev)
+			err = sysfs_create_link(&dev->kobj,b->kobj, name);
 		if (err)
 			goto out;
 
@@ -649,6 +650,7 @@ static void deallocate_threshold_block(unsigned int cpu,
 static void threshold_remove_bank(unsigned int cpu, int bank)
 {
 	struct threshold_bank *b;
+	struct device *dev;
 	char name[32];
 	int i = 0;
 
@@ -663,7 +665,7 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 #ifdef CONFIG_SMP
 	/* sibling symlink */
 	if (shared_bank[bank] && b->blocks->cpu != cpu) {
-		sysfs_remove_link(&per_cpu(mce_device, cpu).kobj, name);
+		sysfs_remove_link(&mce_device[cpu]->kobj, name);
 		per_cpu(threshold_banks, cpu)[bank] = NULL;
 
 		return;
@@ -675,7 +677,9 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 		if (i == cpu)
 			continue;
 
-		sysfs_remove_link(&per_cpu(mce_device, i).kobj, name);
+		dev = mce_device[i];
+		if (dev)
+			sysfs_remove_link(&dev->kobj, name);
 		per_cpu(threshold_banks, i)[bank] = NULL;
 	}
 
