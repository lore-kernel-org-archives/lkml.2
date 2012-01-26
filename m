Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab2AZXuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 18:50:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58076 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759Ab2AZXuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 18:50:23 -0500
Date: Thu, 26 Jan 2012 15:49:14 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Sergei Trofimovich <slyich@gmail.com>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>, justinmattock@gmail.com,
        Jeff Chua <jeff.chua.linux@gmail.com>
Subject: MCE: convert static array of pointers to per-cpu variables
Message-ID: <20120126234914.GA13031@suse.de>
References: <20120116224028.GA5072@suse.de>
 <20120117083843.GC13181@elte.hu>
 <20120117155125.GB13778@suse.de>
 <20120118093138.GC5842@elte.hu>
 <20120118144250.GA16288@suse.de>
 <20120119122811.GC3936@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119122811.GC3936@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

When I previously fixed up the mce_device code, I used a static array of
the pointers.  It was (rightfully) pointed out to me that I should be
using the per_cpu code instead.

This patch converts the code over to that structure, moving the variable
back into the per_cpu area, like it used to be for 3.2 and earlier.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 6aefb14..441520e 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -151,7 +151,7 @@ static inline void enable_p5_mce(void) {}
 
 void mce_setup(struct mce *m);
 void mce_log(struct mce *m);
-extern struct device *mce_device[CONFIG_NR_CPUS];
+DECLARE_PER_CPU(struct device *, mce_device);
 
 /*
  * Maximum banks number.
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 5a11ae2..4979a5d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1859,7 +1859,7 @@ static struct bus_type mce_subsys = {
 	.dev_name	= "machinecheck",
 };
 
-struct device *mce_device[CONFIG_NR_CPUS];
+DEFINE_PER_CPU(struct device *, mce_device);
 
 __cpuinitdata
 void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
@@ -2038,7 +2038,7 @@ static __cpuinit int mce_device_create(unsigned int cpu)
 			goto error2;
 	}
 	cpumask_set_cpu(cpu, mce_device_initialized);
-	mce_device[cpu] = dev;
+	per_cpu(mce_device, cpu) = dev;
 
 	return 0;
 error2:
@@ -2055,7 +2055,7 @@ error:
 
 static __cpuinit void mce_device_remove(unsigned int cpu)
 {
-	struct device *dev = mce_device[cpu];
+	struct device *dev = per_cpu(mce_device, cpu);
 	int i;
 
 	if (!cpumask_test_cpu(cpu, mce_device_initialized))
@@ -2069,7 +2069,7 @@ static __cpuinit void mce_device_remove(unsigned int cpu)
 
 	device_unregister(dev);
 	cpumask_clear_cpu(cpu, mce_device_initialized);
-	mce_device[cpu] = NULL;
+	per_cpu(mce_device, cpu) = NULL;
 }
 
 /* Make sure there are no machine checks on offlined CPUs. */
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 786e76a..a4bf9d2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -523,7 +523,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 {
 	int i, err = 0;
 	struct threshold_bank *b = NULL;
-	struct device *dev = mce_device[cpu];
+	struct device *dev = per_cpu(mce_device, cpu);
 	char name[32];
 
 	sprintf(name, "threshold_bank%i", bank);
@@ -585,7 +585,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		if (i == cpu)
 			continue;
 
-		dev = mce_device[i];
+		dev = per_cpu(mce_device, i);
 		if (dev)
 			err = sysfs_create_link(&dev->kobj,b->kobj, name);
 		if (err)
@@ -665,7 +665,8 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 #ifdef CONFIG_SMP
 	/* sibling symlink */
 	if (shared_bank[bank] && b->blocks->cpu != cpu) {
-		sysfs_remove_link(&mce_device[cpu]->kobj, name);
+		dev = per_cpu(mce_device, cpu);
+		sysfs_remove_link(&dev->kobj, name);
 		per_cpu(threshold_banks, cpu)[bank] = NULL;
 
 		return;
@@ -677,7 +678,7 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 		if (i == cpu)
 			continue;
 
-		dev = mce_device[i];
+		dev = per_cpu(mce_device, i);
 		if (dev)
 			sysfs_remove_link(&dev->kobj, name);
 		per_cpu(threshold_banks, i)[bank] = NULL;
