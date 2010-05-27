Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab0E0UVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:21:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:55963 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab0E0UVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:21:01 -0400
Date: Thu, 27 May 2010 20:19:40 GMT
Message-Id: <201005272019.o4RKJeI0013656@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for 2.6.35
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <jbohac@novell.com>, <stable@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Gabor Gombas <gombasg@digikabel.hu>,
       "H. Peter Anvin" <hpa@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Jack Steiner <steiner@sgi.com>, Jan Beulich <jbeulich@novell.com>,
       Julia Lawall <julia@diku.dk>,
       Kerstin Jonsson <kerstin.jonsson@ericsson.com>,
       Luca Barbieri <luca@luca-barbieri.com>, Peter Huewe <peterhuewe@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Thomas Renninger <trenn@suse.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Xiaotian Feng <dfeng@redhat.com>, Yinghai Lu <yinghai@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 27 May 2010 20:19:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A bunch of fixes and cleanups for the x86 tree so far in 2.6.35.

	-hpa

The following changes since commit 7e125f7b9cbfce4101191b8076d606c517a73066:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/ide-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Borislav Petkov (1):
      x86, k8: Fix section mismatch for powernowk8_exit()

Gabor Gombas (1):
      x86, setup: Phoenix BIOS fixup is needed on Dell Inspiron Mini 1012

H. Peter Anvin (1):
      x86, cpufeature: Unbreak compile with gcc 3.x

Jan Beulich (1):
      x86: "nosmp" command line option should force the system into UP mode

Julia Lawall (1):
      arch/x86/pci: use kasprintf

Kerstin Jonsson (1):
      x86, apic: ack all pending irqs when crashed/on kexec

Peter Huewe (1):
      lib/atomic64_test: fix missing include of linux/kernel.h

Peter Zijlstra (1):
      x86: remove last traces of quicklist usage

Xiaotian Feng (1):
      x86, pat: Fix memory leak in free_memtype

 arch/x86/include/asm/cpufeature.h         |    7 +++++
 arch/x86/kernel/apic/apic.c               |   41 +++++++++++++++++++++++-----
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    6 ++--
 arch/x86/kernel/setup.c                   |   11 ++++++++
 arch/x86/kernel/smpboot.c                 |   26 ++++++++++++++++--
 arch/x86/mm/pat.c                         |   10 +++++--
 arch/x86/mm/pat_internal.h                |    6 ++--
 arch/x86/mm/pat_rbtree.c                  |    7 +++--
 arch/x86/mm/pgtable_32.c                  |    1 -
 arch/x86/pci/acpi.c                       |    3 +-
 lib/atomic64_test.c                       |    1 +
 11 files changed, 93 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index dca9c54..4681459 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -332,6 +332,7 @@ static __always_inline __pure bool __static_cpu_has(u8 bit)
 #endif
 }
 
+#if __GNUC__ >= 4
 #define static_cpu_has(bit)					\
 (								\
 	__builtin_constant_p(boot_cpu_has(bit)) ?		\
@@ -340,6 +341,12 @@ static __always_inline __pure bool __static_cpu_has(u8 bit)
 		__static_cpu_has(bit) :				\
 		boot_cpu_has(bit)				\
 )
+#else
+/*
+ * gcc 3.x is too stupid to do the static test; fall back to dynamic.
+ */
+#define static_cpu_has(bit) boot_cpu_has(bit)
+#endif
 
 #endif /* defined(__KERNEL__) && !defined(__ASSEMBLY__) */
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index e5a4a1e..c02cc69 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -51,6 +51,7 @@
 #include <asm/smp.h>
 #include <asm/mce.h>
 #include <asm/kvm_para.h>
+#include <asm/tsc.h>
 
 unsigned int num_processors;
 
@@ -1151,8 +1152,13 @@ static void __cpuinit lapic_setup_esr(void)
  */
 void __cpuinit setup_local_APIC(void)
 {
-	unsigned int value;
-	int i, j;
+	unsigned int value, queued;
+	int i, j, acked = 0;
+	unsigned long long tsc = 0, ntsc;
+	long long max_loops = cpu_khz;
+
+	if (cpu_has_tsc)
+		rdtscll(tsc);
 
 	if (disable_apic) {
 		arch_disable_smp_support();
@@ -1204,13 +1210,32 @@ void __cpuinit setup_local_APIC(void)
 	 * the interrupt. Hence a vector might get locked. It was noticed
 	 * for timer irq (vector 0x31). Issue an extra EOI to clear ISR.
 	 */
-	for (i = APIC_ISR_NR - 1; i >= 0; i--) {
-		value = apic_read(APIC_ISR + i*0x10);
-		for (j = 31; j >= 0; j--) {
-			if (value & (1<<j))
-				ack_APIC_irq();
+	do {
+		queued = 0;
+		for (i = APIC_ISR_NR - 1; i >= 0; i--)
+			queued |= apic_read(APIC_IRR + i*0x10);
+
+		for (i = APIC_ISR_NR - 1; i >= 0; i--) {
+			value = apic_read(APIC_ISR + i*0x10);
+			for (j = 31; j >= 0; j--) {
+				if (value & (1<<j)) {
+					ack_APIC_irq();
+					acked++;
+				}
+			}
 		}
-	}
+		if (acked > 256) {
+			printk(KERN_ERR "LAPIC pending interrupts after %d EOI\n",
+			       acked);
+			break;
+		}
+		if (cpu_has_tsc) {
+			rdtscll(ntsc);
+			max_loops = (cpu_khz << 10) - (ntsc - tsc);
+		} else
+			max_loops--;
+	} while (queued && max_loops > 0);
+	WARN_ON(max_loops <= 0);
 
 	/*
 	 * Now that we are all set up, enable the APIC
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 6f3dc8f..7ec2123 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1497,8 +1497,8 @@ static struct cpufreq_driver cpufreq_amd64_driver = {
  * simply keep the boost-disable flag in sync with the current global
  * state.
  */
-static int __cpuinit cpb_notify(struct notifier_block *nb, unsigned long action,
-				void *hcpu)
+static int cpb_notify(struct notifier_block *nb, unsigned long action,
+		      void *hcpu)
 {
 	unsigned cpu = (long)hcpu;
 	u32 lo, hi;
@@ -1528,7 +1528,7 @@ static int __cpuinit cpb_notify(struct notifier_block *nb, unsigned long action,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata cpb_nb = {
+static struct notifier_block cpb_nb = {
 	.notifier_call		= cpb_notify,
 };
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e802989..b4ae4ac 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -676,6 +676,17 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "DG45FC"),
 		},
 	},
+	/*
+	 * The Dell Inspiron Mini 1012 has DMI_BIOS_VENDOR = "Dell Inc.", so
+	 * match on the product name.
+	 */
+	{
+		.callback = dmi_low_memory_corruption,
+		.ident = "Phoenix BIOS",
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1012"),
+		},
+	},
 #endif
 	{}
 };
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 763d815..37462f1 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1215,9 +1215,17 @@ __init void prefill_possible_map(void)
 	if (!num_processors)
 		num_processors = 1;
 
-	if (setup_possible_cpus == -1)
-		possible = num_processors + disabled_cpus;
-	else
+	i = setup_max_cpus ?: 1;
+	if (setup_possible_cpus == -1) {
+		possible = num_processors;
+#ifdef CONFIG_HOTPLUG_CPU
+		if (setup_max_cpus)
+			possible += disabled_cpus;
+#else
+		if (possible > i)
+			possible = i;
+#endif
+	} else
 		possible = setup_possible_cpus;
 
 	total_cpus = max_t(int, possible, num_processors + disabled_cpus);
@@ -1230,11 +1238,23 @@ __init void prefill_possible_map(void)
 		possible = nr_cpu_ids;
 	}
 
+#ifdef CONFIG_HOTPLUG_CPU
+	if (!setup_max_cpus)
+#endif
+	if (possible > i) {
+		printk(KERN_WARNING
+			"%d Processors exceeds max_cpus limit of %u\n",
+			possible, setup_max_cpus);
+		possible = i;
+	}
+
 	printk(KERN_INFO "SMP: Allowing %d CPUs, %d hotplug CPUs\n",
 		possible, max_t(int, possible - num_processors, 0));
 
 	for (i = 0; i < possible; i++)
 		set_cpu_possible(i, true);
+	for (; i < NR_CPUS; i++)
+		set_cpu_possible(i, false);
 
 	nr_cpu_ids = possible;
 }
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index bbe5502..acc15b2 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -336,6 +336,7 @@ int free_memtype(u64 start, u64 end)
 {
 	int err = -EINVAL;
 	int is_range_ram;
+	struct memtype *entry;
 
 	if (!pat_enabled)
 		return 0;
@@ -355,17 +356,20 @@ int free_memtype(u64 start, u64 end)
 	}
 
 	spin_lock(&memtype_lock);
-	err = rbt_memtype_erase(start, end);
+	entry = rbt_memtype_erase(start, end);
 	spin_unlock(&memtype_lock);
 
-	if (err) {
+	if (!entry) {
 		printk(KERN_INFO "%s:%d freeing invalid memtype %Lx-%Lx\n",
 			current->comm, current->pid, start, end);
+		return -EINVAL;
 	}
 
+	kfree(entry);
+
 	dprintk("free_memtype request 0x%Lx-0x%Lx\n", start, end);
 
-	return err;
+	return 0;
 }
 
 
diff --git a/arch/x86/mm/pat_internal.h b/arch/x86/mm/pat_internal.h
index 4f39eef..77e5ba1 100644
--- a/arch/x86/mm/pat_internal.h
+++ b/arch/x86/mm/pat_internal.h
@@ -28,15 +28,15 @@ static inline char *cattr_name(unsigned long flags)
 #ifdef CONFIG_X86_PAT
 extern int rbt_memtype_check_insert(struct memtype *new,
 					unsigned long *new_type);
-extern int rbt_memtype_erase(u64 start, u64 end);
+extern struct memtype *rbt_memtype_erase(u64 start, u64 end);
 extern struct memtype *rbt_memtype_lookup(u64 addr);
 extern int rbt_memtype_copy_nth_element(struct memtype *out, loff_t pos);
 #else
 static inline int rbt_memtype_check_insert(struct memtype *new,
 					unsigned long *new_type)
 { return 0; }
-static inline int rbt_memtype_erase(u64 start, u64 end)
-{ return 0; }
+static inline struct memtype *rbt_memtype_erase(u64 start, u64 end)
+{ return NULL; }
 static inline struct memtype *rbt_memtype_lookup(u64 addr)
 { return NULL; }
 static inline int rbt_memtype_copy_nth_element(struct memtype *out, loff_t pos)
diff --git a/arch/x86/mm/pat_rbtree.c b/arch/x86/mm/pat_rbtree.c
index 07de4cb..f537087 100644
--- a/arch/x86/mm/pat_rbtree.c
+++ b/arch/x86/mm/pat_rbtree.c
@@ -231,16 +231,17 @@ int rbt_memtype_check_insert(struct memtype *new, unsigned long *ret_type)
 	return err;
 }
 
-int rbt_memtype_erase(u64 start, u64 end)
+struct memtype *rbt_memtype_erase(u64 start, u64 end)
 {
 	struct memtype *data;
 
 	data = memtype_rb_exact_match(&memtype_rbroot, start, end);
 	if (!data)
-		return -EINVAL;
+		goto out;
 
 	rb_erase(&data->rb, &memtype_rbroot);
-	return 0;
+out:
+	return data;
 }
 
 struct memtype *rbt_memtype_lookup(u64 addr)
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index 7928540..cac7184 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -9,7 +9,6 @@
 #include <linux/pagemap.h>
 #include <linux/spinlock.h>
 #include <linux/module.h>
-#include <linux/quicklist.h>
 
 #include <asm/system.h>
 #include <asm/pgtable.h>
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 31930fd..7c0ad63 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -207,10 +207,9 @@ get_current_resources(struct acpi_device *device, int busnum,
 	if (!info.res)
 		goto res_alloc_fail;
 
-	info.name = kmalloc(16, GFP_KERNEL);
+	info.name = kasprintf(GFP_KERNEL, "PCI Bus %04x:%02x", domain, busnum);
 	if (!info.name)
 		goto name_alloc_fail;
-	sprintf(info.name, "PCI Bus %04x:%02x", domain, busnum);
 
 	info.res_num = 0;
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, setup_resource,
diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
index 65e482c..9087d71 100644
--- a/lib/atomic64_test.c
+++ b/lib/atomic64_test.c
@@ -9,6 +9,7 @@
  * (at your option) any later version.
  */
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <asm/atomic.h>
 
 #define INIT(c) do { atomic64_set(&v, c); r = c; } while (0)
