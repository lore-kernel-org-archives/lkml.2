Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab0HDWPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 18:15:52 -0400
Received: from claw.goop.org ([74.207.240.146]:60012 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576Ab0HDWPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 18:15:46 -0400
Message-ID: <4C59E68E.1020606@goop.org>
Date: Wed, 04 Aug 2010 15:15:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [GIT PULL] Xen updates
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Linus,

Here's a set of Xen updates.  The main new feature is added support for 
paravirtualized drivers even in fully virtualized domains (pv-on-hvm), 
as well as a number of smaller bugfixes and improvements.

The only non-Xen files touched are:

kernel-parameters.txt

    We add a new kernel command-line parameter for pv-on-hvm

arch/x86/include/asm/hypervisor.h

    Add Xen hypervisor detection to the hypervisor infrastructure

include/linux/pci_ids.h

    Add ID for our pseudo-PCI device

arch/x86/include/asm/irq_vectors.h
arch/x86/kernel/entry_*.S

    Add a new vector for injecting interrupts into the domain

arch/x86/include/asm/setup.h
include/asm-generic/vmlinux.lds.h

    Avoid a section conflict on newer gccs by adding multiple .discard
    sections for differently typed symbols.


Thanks,
     J

The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:

   Linux 2.6.35 (2010-08-01 15:11:14 -0700)

are available in the git repository at:
   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/xen

Donald Dutile (1):
       Xen: register panic notifier to take crashes of xen guests on panic

Ian Campbell (2):
       xenbus: do not hold transaction_mutex when returning to userspace
       xen/panic: use xen_reboot and fix smp_send_stop

Jeremy Fitzhardinge (9):
       xen: make sure pages are really part of domain before freeing
       xen: Add support for HVM hypercalls.
       xenfs: enable for HVM domains too
       xen/pvhvm: fix build problem when !CONFIG_XEN
       support multiple .discard.* sections to avoid section type conflicts
       xen: drop xen_sched_clock in favour of using plain wallclock time
       Merge branch 'upstream/core' into upstream/xen
       Merge branch 'upstream/pvhvm' into upstream/xen
       Merge branch 'xen/xenbus' into upstream/xen

Miroslav Rezanina (1):
       xen: release unused free memory

Mukesh Rathor (1):
       xen: support large numbers of CPUs with vcpu info placement

Paolo Bonzini (1):
       implement O_NONBLOCK for /proc/xen/xenbus

Sheng Yang (2):
       x86: early PV on HVM features initialization.
       x86/xen: event channels delivery on HVM.

Stefano Stabellini (9):
       xen: Xen PCI platform device driver.
       xen: Add suspend/resume support for PV on HVM guests.
       xen: Fix find_unbound_irq in presence of ioapic irqs.
       x86: Use xen_vcpuop_clockevent, xen_clocksource and xen wallclock.
       x86: Unplug emulated disks and nics.
       x86: Call HVMOP_pagetable_dying on exit_mmap.
       blkfront: do not create a PV cdrom device if xen_hvm_guest
       Introduce CONFIG_XEN_PVHVM compile option
       pvops: do not notify callers from register_xenstore_notifier

  Documentation/kernel-parameters.txt  |   11 ++
  arch/x86/include/asm/hypervisor.h    |    1 +
  arch/x86/include/asm/irq_vectors.h   |    3 +
  arch/x86/include/asm/setup.h         |    2 +-
  arch/x86/include/asm/xen/hypercall.h |    6 +
  arch/x86/kernel/cpu/hypervisor.c     |    3 +
  arch/x86/kernel/entry_32.S           |    3 +
  arch/x86/kernel/entry_64.S           |    3 +
  arch/x86/xen/Kconfig                 |    5 +
  arch/x86/xen/Makefile                |    2 +-
  arch/x86/xen/enlighten.c             |  197 +++++++++++++++++++++++++++++---
  arch/x86/xen/mmu.c                   |   35 ++++++
  arch/x86/xen/mmu.h                   |    1 +
  arch/x86/xen/platform-pci-unplug.c   |  137 ++++++++++++++++++++++
  arch/x86/xen/setup.c                 |   72 ++++++++++++
  arch/x86/xen/smp.c                   |    2 +
  arch/x86/xen/suspend.c               |   12 ++
  arch/x86/xen/time.c                  |   96 +++++++++-------
  arch/x86/xen/xen-ops.h               |   13 ++-
  drivers/block/xen-blkfront.c         |   30 +++++
  drivers/input/xen-kbdfront.c         |    2 +-
  drivers/video/xen-fbfront.c          |    2 +-
  drivers/xen/Kconfig                  |    9 ++
  drivers/xen/Makefile                 |    3 +-
  drivers/xen/events.c                 |   95 ++++++++++++++--
  drivers/xen/grant-table.c            |   77 +++++++++++--
  drivers/xen/manage.c                 |   46 +++++++-
  drivers/xen/platform-pci.c           |  207 ++++++++++++++++++++++++++++++++++
  drivers/xen/xenbus/xenbus_probe.c    |   52 +++++++--
  drivers/xen/xenbus/xenbus_xs.c       |   57 ++++++++--
  drivers/xen/xenfs/super.c            |    4 +-
  drivers/xen/xenfs/xenbus.c           |    3 +
  include/asm-generic/vmlinux.lds.h    |    1 +
  include/linux/pci_ids.h              |    3 +
  include/xen/events.h                 |    7 +
  include/xen/grant_table.h            |    4 +
  include/xen/hvm.h                    |   30 +++++
  include/xen/interface/features.h     |    6 +
  include/xen/interface/grant_table.h  |    1 +
  include/xen/interface/hvm/hvm_op.h   |   46 ++++++++
  include/xen/interface/hvm/params.h   |   95 ++++++++++++++++
  include/xen/platform_pci.h           |   49 ++++++++
  include/xen/xen-ops.h                |    3 +
  43 files changed, 1317 insertions(+), 119 deletions(-)
  create mode 100644 arch/x86/xen/platform-pci-unplug.c
  create mode 100644 drivers/xen/platform-pci.c
  create mode 100644 include/xen/hvm.h
  create mode 100644 include/xen/interface/hvm/hvm_op.h
  create mode 100644 include/xen/interface/hvm/params.h
  create mode 100644 include/xen/platform_pci.h

git diff v2.6.35..upstream/xen
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 2b2407d..2f32da7 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -115,6 +115,7 @@ parameter is applicable:
  			More X86-64 boot options can be found in
  			Documentation/x86/x86_64/boot-options.txt .
  	X86	Either 32bit or 64bit x86 (same as X86-32+X86-64)
+	XEN	Xen support is enabled

  In addition, the following text indicates that the option:

@@ -2879,6 +2880,16 @@ and is between 256 and 4096 characters. It is defined in the file
  	xd=		[HW,XT] Original XT pre-IDE (RLL encoded) disks.
  	xd_geo=		See header of drivers/block/xd.c.

+	xen_emul_unplug=		[HW,X86,XEN]
+			Unplug Xen emulated devices
+			Format: [unplug0,][unplug1]
+			ide-disks -- unplug primary master IDE devices
+			aux-ide-disks -- unplug non-primary-master IDE devices
+			nics -- unplug network devices
+			all -- unplug all emulated devices (NICs and IDE disks)
+			ignore -- continue loading the Xen platform PCI driver even
+				if the version check failed
+
  	xirc2ps_cs=	[NET,PCMCIA]
  			Format:
  			<irq>,<irq_mask>,<io>,<full_duplex>,<do_sound>,<lockup_hack>[,<irq2>[,<irq3>[,<irq4>]]]
diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
index 70abda7..ff2546c 100644
--- a/arch/x86/include/asm/hypervisor.h
+++ b/arch/x86/include/asm/hypervisor.h
@@ -45,5 +45,6 @@ extern const struct hypervisor_x86 *x86_hyper;
  /* Recognized hypervisors */
  extern const struct hypervisor_x86 x86_hyper_vmware;
  extern const struct hypervisor_x86 x86_hyper_ms_hyperv;
+extern const struct hypervisor_x86 x86_hyper_xen_hvm;

  #endif
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 8767d99..e2ca300 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -125,6 +125,9 @@
   */
  #define MCE_SELF_VECTOR			0xeb

+/* Xen vector callback to receive events in a HVM domain */
+#define XEN_HVM_EVTCHN_CALLBACK		0xe9
+
  #define NR_VECTORS			 256

  #define FPU_IRQ				  13
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 86b1506..ef292c7 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -82,7 +82,7 @@ void *extend_brk(size_t size, size_t align);
   * executable.)
   */
  #define RESERVE_BRK(name,sz)						\
-	static void __section(.discard) __used				\
+	static void __section(.discard.text) __used			\
  	__brk_reservation_fn_##name##__(void) {				\
  		asm volatile (						\
  			".pushsection .brk_reservation,\"aw\",@nobits;" \
diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xen/hypercall.h
index 9c371e4..7fda040 100644
--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -417,6 +417,12 @@ HYPERVISOR_nmi_op(unsigned long op, unsigned long arg)
  	return _hypercall2(int, nmi_op, op, arg);
  }

+static inline unsigned long __must_check
+HYPERVISOR_hvm_op(int op, void *arg)
+{
+       return _hypercall2(unsigned long, hvm_op, op, arg);
+}
+
  static inline void
  MULTI_fpu_taskswitch(struct multicall_entry *mcl, int set)
  {
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index dd531cc..8095f86 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -34,6 +34,9 @@ static const __initconst struct hypervisor_x86 * const hypervisors[] =
  {
  	&x86_hyper_vmware,
  	&x86_hyper_ms_hyperv,
+#ifdef CONFIG_XEN_PVHVM
+	&x86_hyper_xen_hvm,
+#endif
  };

  const struct hypervisor_x86 *x86_hyper;
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index cd49141..6b19683 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1166,6 +1166,9 @@ ENTRY(xen_failsafe_callback)
  .previous
  ENDPROC(xen_failsafe_callback)

+BUILD_INTERRUPT3(xen_hvm_callback_vector, XEN_HVM_EVTCHN_CALLBACK,
+		xen_evtchn_do_upcall)
+
  #endif	/* CONFIG_XEN */

  #ifdef CONFIG_FUNCTION_TRACER
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 4db7c4d..649ed17 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1329,6 +1329,9 @@ ENTRY(xen_failsafe_callback)
  	CFI_ENDPROC
  END(xen_failsafe_callback)

+apicinterrupt XEN_HVM_EVTCHN_CALLBACK \
+	xen_hvm_callback_vector xen_evtchn_do_upcall
+
  #endif /* CONFIG_XEN */

  /*
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index b83e119..68128a1 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -13,6 +13,11 @@ config XEN
  	  kernel to boot in a paravirtualized environment under the
  	  Xen hypervisor.

+config XEN_PVHVM
+	def_bool y
+	depends on XEN
+	depends on X86_LOCAL_APIC
+
  config XEN_MAX_DOMAIN_MEMORY
         int "Maximum allowed size of a domain in gigabytes"
         default 8 if X86_32
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 3bb4fc2..9309546 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -12,7 +12,7 @@ CFLAGS_mmu.o			:= $(nostackp)

  obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
  			time.o xen-asm.o xen-asm_$(BITS).o \
-			grant-table.o suspend.o
+			grant-table.o suspend.o platform-pci-unplug.o

  obj-$(CONFIG_SMP)		+= smp.o
  obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 65d8d79..d4ff5e8 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -11,6 +11,7 @@
   * Jeremy Fitzhardinge<jeremy@xensource.com>, XenSource Inc, 2007
   */

+#include<linux/cpu.h>
  #include<linux/kernel.h>
  #include<linux/init.h>
  #include<linux/smp.h>
@@ -35,8 +36,10 @@
  #include<xen/interface/version.h>
  #include<xen/interface/physdev.h>
  #include<xen/interface/vcpu.h>
+#include<xen/interface/memory.h>
  #include<xen/features.h>
  #include<xen/page.h>
+#include<xen/hvm.h>
  #include<xen/hvc-console.h>

  #include<asm/paravirt.h>
@@ -55,7 +58,9 @@
  #include<asm/pgtable.h>
  #include<asm/tlbflush.h>
  #include<asm/reboot.h>
+#include<asm/setup.h>
  #include<asm/stackprotector.h>
+#include<asm/hypervisor.h>

  #include "xen-ops.h"
  #include "mmu.h"
@@ -76,6 +81,10 @@ struct shared_info xen_dummy_shared_info;

  void *xen_initial_gdt;

+RESERVE_BRK(shared_info_page_brk, PAGE_SIZE);
+__read_mostly int xen_have_vector_callback;
+EXPORT_SYMBOL_GPL(xen_have_vector_callback);
+
  /*
   * Point at some empty memory to start with. We map the real shared_info
   * page as soon as fixmap is up and running.
@@ -97,6 +106,14 @@ struct shared_info *HYPERVISOR_shared_info = (void *)&xen_dummy_shared_info;
   */
  static int have_vcpu_info_placement = 1;

+static void clamp_max_cpus(void)
+{
+#ifdef CONFIG_SMP
+	if (setup_max_cpus>  MAX_VIRT_CPUS)
+		setup_max_cpus = MAX_VIRT_CPUS;
+#endif
+}
+
  static void xen_vcpu_setup(int cpu)
  {
  	struct vcpu_register_vcpu_info info;
@@ -104,13 +121,17 @@ static void xen_vcpu_setup(int cpu)
  	struct vcpu_info *vcpup;

  	BUG_ON(HYPERVISOR_shared_info ==&xen_dummy_shared_info);
-	per_cpu(xen_vcpu, cpu) =&HYPERVISOR_shared_info->vcpu_info[cpu];

-	if (!have_vcpu_info_placement)
-		return;		/* already tested, not available */
+	if (cpu<  MAX_VIRT_CPUS)
+		per_cpu(xen_vcpu,cpu) =&HYPERVISOR_shared_info->vcpu_info[cpu];

-	vcpup =&per_cpu(xen_vcpu_info, cpu);
+	if (!have_vcpu_info_placement) {
+		if (cpu>= MAX_VIRT_CPUS)
+			clamp_max_cpus();
+		return;
+	}

+	vcpup =&per_cpu(xen_vcpu_info, cpu);
  	info.mfn = arbitrary_virt_to_mfn(vcpup);
  	info.offset = offset_in_page(vcpup);

@@ -125,6 +146,7 @@ static void xen_vcpu_setup(int cpu)
  	if (err) {
  		printk(KERN_DEBUG "register_vcpu_info failed: err=%d\n", err);
  		have_vcpu_info_placement = 0;
+		clamp_max_cpus();
  	} else {
  		/* This cpu is using the registered vcpu info, even if
  		   later ones fail to. */
@@ -731,7 +753,6 @@ static void set_xen_basic_apic_ops(void)

  #endif

-
  static void xen_clts(void)
  {
  	struct multicall_space mcs;
@@ -926,10 +947,6 @@ static const struct pv_init_ops xen_init_ops __initdata = {
  	.patch = xen_patch,
  };

-static const struct pv_time_ops xen_time_ops __initdata = {
-	.sched_clock = xen_sched_clock,
-};
-
  static const struct pv_cpu_ops xen_cpu_ops __initdata = {
  	.cpuid = xen_cpuid,

@@ -1028,6 +1045,23 @@ static void xen_crash_shutdown(struct pt_regs *regs)
  	xen_reboot(SHUTDOWN_crash);
  }

+static int
+xen_panic_event(struct notifier_block *this, unsigned long event, void *ptr)
+{
+	xen_reboot(SHUTDOWN_crash);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block xen_panic_block = {
+	.notifier_call= xen_panic_event,
+};
+
+int xen_panic_handler_init(void)
+{
+	atomic_notifier_chain_register(&panic_notifier_list,&xen_panic_block);
+	return 0;
+}
+
  static const struct machine_ops __initdata xen_machine_ops = {
  	.restart = xen_restart,
  	.halt = xen_machine_halt,
@@ -1067,7 +1101,6 @@ asmlinkage void __init xen_start_kernel(void)
  	/* Install Xen paravirt ops */
  	pv_info = xen_info;
  	pv_init_ops = xen_init_ops;
-	pv_time_ops = xen_time_ops;
  	pv_cpu_ops = xen_cpu_ops;
  	pv_apic_ops = xen_apic_ops;

@@ -1075,13 +1108,7 @@ asmlinkage void __init xen_start_kernel(void)
  	x86_init.oem.arch_setup = xen_arch_setup;
  	x86_init.oem.banner = xen_banner;

-	x86_init.timers.timer_init = xen_time_init;
-	x86_init.timers.setup_percpu_clockev = x86_init_noop;
-	x86_cpuinit.setup_percpu_clockev = x86_init_noop;
-
-	x86_platform.calibrate_tsc = xen_tsc_khz;
-	x86_platform.get_wallclock = xen_get_wallclock;
-	x86_platform.set_wallclock = xen_set_wallclock;
+	xen_init_time_ops();

  	/*
  	 * Set up some pagetable state before starting to set any ptes.
@@ -1206,3 +1233,139 @@ asmlinkage void __init xen_start_kernel(void)
  	x86_64_start_reservations((char *)__pa_symbol(&boot_params));
  #endif
  }
+
+static uint32_t xen_cpuid_base(void)
+{
+	uint32_t base, eax, ebx, ecx, edx;
+	char signature[13];
+
+	for (base = 0x40000000; base<  0x40010000; base += 0x100) {
+		cpuid(base,&eax,&ebx,&ecx,&edx);
+		*(uint32_t *)(signature + 0) = ebx;
+		*(uint32_t *)(signature + 4) = ecx;
+		*(uint32_t *)(signature + 8) = edx;
+		signature[12] = 0;
+
+		if (!strcmp("XenVMMXenVMM", signature)&&  ((eax - base)>= 2))
+			return base;
+	}
+
+	return 0;
+}
+
+static int init_hvm_pv_info(int *major, int *minor)
+{
+	uint32_t eax, ebx, ecx, edx, pages, msr, base;
+	u64 pfn;
+
+	base = xen_cpuid_base();
+	cpuid(base + 1,&eax,&ebx,&ecx,&edx);
+
+	*major = eax>>  16;
+	*minor = eax&  0xffff;
+	printk(KERN_INFO "Xen version %d.%d.\n", *major, *minor);
+
+	cpuid(base + 2,&pages,&msr,&ecx,&edx);
+
+	pfn = __pa(hypercall_page);
+	wrmsr_safe(msr, (u32)pfn, (u32)(pfn>>  32));
+
+	xen_setup_features();
+
+	pv_info = xen_info;
+	pv_info.kernel_rpl = 0;
+
+	xen_domain_type = XEN_HVM_DOMAIN;
+
+	return 0;
+}
+
+void xen_hvm_init_shared_info(void)
+{
+	int cpu;
+	struct xen_add_to_physmap xatp;
+	static struct shared_info *shared_info_page = 0;
+
+	if (!shared_info_page)
+		shared_info_page = (struct shared_info *)
+			extend_brk(PAGE_SIZE, PAGE_SIZE);
+	xatp.domid = DOMID_SELF;
+	xatp.idx = 0;
+	xatp.space = XENMAPSPACE_shared_info;
+	xatp.gpfn = __pa(shared_info_page)>>  PAGE_SHIFT;
+	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap,&xatp))
+		BUG();
+
+	HYPERVISOR_shared_info = (struct shared_info *)shared_info_page;
+
+	/* xen_vcpu is a pointer to the vcpu_info struct in the shared_info
+	 * page, we use it in the event channel upcall and in some pvclock
+	 * related functions. We don't need the vcpu_info placement
+	 * optimizations because we don't use any pv_mmu or pv_irq op on
+	 * HVM.
+	 * When xen_hvm_init_shared_info is run at boot time only vcpu 0 is
+	 * online but xen_hvm_init_shared_info is run at resume time too and
+	 * in that case multiple vcpus might be online. */
+	for_each_online_cpu(cpu) {
+		per_cpu(xen_vcpu, cpu) =&HYPERVISOR_shared_info->vcpu_info[cpu];
+	}
+}
+
+#ifdef CONFIG_XEN_PVHVM
+static int __cpuinit xen_hvm_cpu_notify(struct notifier_block *self,
+				    unsigned long action, void *hcpu)
+{
+	int cpu = (long)hcpu;
+	switch (action) {
+	case CPU_UP_PREPARE:
+		per_cpu(xen_vcpu, cpu) =&HYPERVISOR_shared_info->vcpu_info[cpu];
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata xen_hvm_cpu_notifier = {
+	.notifier_call	= xen_hvm_cpu_notify,
+};
+
+static void __init xen_hvm_guest_init(void)
+{
+	int r;
+	int major, minor;
+
+	r = init_hvm_pv_info(&major,&minor);
+	if (r<  0)
+		return;
+
+	xen_hvm_init_shared_info();
+
+	if (xen_feature(XENFEAT_hvm_callback_vector))
+		xen_have_vector_callback = 1;
+	register_cpu_notifier(&xen_hvm_cpu_notifier);
+	xen_unplug_emulated_devices();
+	have_vcpu_info_placement = 0;
+	x86_init.irqs.intr_init = xen_init_IRQ;
+	xen_hvm_init_time_ops();
+	xen_hvm_init_mmu_ops();
+}
+
+static bool __init xen_hvm_platform(void)
+{
+	if (xen_pv_domain())
+		return false;
+
+	if (!xen_cpuid_base())
+		return false;
+
+	return true;
+}
+
+const __refconst struct hypervisor_x86 x86_hyper_xen_hvm = {
+	.name			= "Xen HVM",
+	.detect			= xen_hvm_platform,
+	.init_platform		= xen_hvm_guest_init,
+};
+EXPORT_SYMBOL(x86_hyper_xen_hvm);
+#endif
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 914f046..413b19b 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -58,6 +58,7 @@

  #include<xen/page.h>
  #include<xen/interface/xen.h>
+#include<xen/interface/hvm/hvm_op.h>
  #include<xen/interface/version.h>
  #include<xen/hvc-console.h>

@@ -1941,6 +1942,40 @@ void __init xen_init_mmu_ops(void)
  	pv_mmu_ops = xen_mmu_ops;
  }

+#ifdef CONFIG_XEN_PVHVM
+static void xen_hvm_exit_mmap(struct mm_struct *mm)
+{
+	struct xen_hvm_pagetable_dying a;
+	int rc;
+
+	a.domid = DOMID_SELF;
+	a.gpa = __pa(mm->pgd);
+	rc = HYPERVISOR_hvm_op(HVMOP_pagetable_dying,&a);
+	WARN_ON_ONCE(rc<  0);
+}
+
+static int is_pagetable_dying_supported(void)
+{
+	struct xen_hvm_pagetable_dying a;
+	int rc = 0;
+
+	a.domid = DOMID_SELF;
+	a.gpa = 0x00;
+	rc = HYPERVISOR_hvm_op(HVMOP_pagetable_dying,&a);
+	if (rc<  0) {
+		printk(KERN_DEBUG "HVMOP_pagetable_dying not supported\n");
+		return 0;
+	}
+	return 1;
+}
+
+void __init xen_hvm_init_mmu_ops(void)
+{
+	if (is_pagetable_dying_supported())
+		pv_mmu_ops.exit_mmap = xen_hvm_exit_mmap;
+}
+#endif
+
  #ifdef CONFIG_XEN_DEBUG_FS

  static struct dentry *d_mmu_debug;
diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
index 5fe6bc7..fa938c4 100644
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -60,4 +60,5 @@ void  xen_ptep_modify_prot_commit(struct mm_struct *mm, unsigned long addr,
  unsigned long xen_read_cr2_direct(void);

  extern void xen_init_mmu_ops(void);
+extern void xen_hvm_init_mmu_ops(void);
  #endif	/* _XEN_MMU_H */
diff --git a/arch/x86/xen/platform-pci-unplug.c b/arch/x86/xen/platform-pci-unplug.c
new file mode 100644
index 0000000..554c002
--- /dev/null
+++ b/arch/x86/xen/platform-pci-unplug.c
@@ -0,0 +1,137 @@
+/******************************************************************************
+ * platform-pci-unplug.c
+ *
+ * Xen platform PCI device driver
+ * Copyright (c) 2010, Citrix
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ */
+
+#include<linux/init.h>
+#include<linux/io.h>
+#include<linux/module.h>
+
+#include<xen/platform_pci.h>
+
+#define XEN_PLATFORM_ERR_MAGIC -1
+#define XEN_PLATFORM_ERR_PROTOCOL -2
+#define XEN_PLATFORM_ERR_BLACKLIST -3
+
+/* store the value of xen_emul_unplug after the unplug is done */
+int xen_platform_pci_unplug;
+EXPORT_SYMBOL_GPL(xen_platform_pci_unplug);
+#ifdef CONFIG_XEN_PVHVM
+static int xen_emul_unplug;
+
+static int __init check_platform_magic(void)
+{
+	short magic;
+	char protocol;
+
+	magic = inw(XEN_IOPORT_MAGIC);
+	if (magic != XEN_IOPORT_MAGIC_VAL) {
+		printk(KERN_ERR "Xen Platform PCI: unrecognised magic value\n");
+		return XEN_PLATFORM_ERR_MAGIC;
+	}
+
+	protocol = inb(XEN_IOPORT_PROTOVER);
+
+	printk(KERN_DEBUG "Xen Platform PCI: I/O protocol version %d\n",
+			protocol);
+
+	switch (protocol) {
+	case 1:
+		outw(XEN_IOPORT_LINUX_PRODNUM, XEN_IOPORT_PRODNUM);
+		outl(XEN_IOPORT_LINUX_DRVVER, XEN_IOPORT_DRVVER);
+		if (inw(XEN_IOPORT_MAGIC) != XEN_IOPORT_MAGIC_VAL) {
+			printk(KERN_ERR "Xen Platform: blacklisted by host\n");
+			return XEN_PLATFORM_ERR_BLACKLIST;
+		}
+		break;
+	default:
+		printk(KERN_WARNING "Xen Platform PCI: unknown I/O protocol version");
+		return XEN_PLATFORM_ERR_PROTOCOL;
+	}
+
+	return 0;
+}
+
+void __init xen_unplug_emulated_devices(void)
+{
+	int r;
+
+	/* check the version of the xen platform PCI device */
+	r = check_platform_magic();
+	/* If the version matches enable the Xen platform PCI driver.
+	 * Also enable the Xen platform PCI driver if the version is really old
+	 * and the user told us to ignore it. */
+	if (r&&  !(r == XEN_PLATFORM_ERR_MAGIC&&
+			(xen_emul_unplug&  XEN_UNPLUG_IGNORE)))
+		return;
+	/* Set the default value of xen_emul_unplug depending on whether or
+	 * not the Xen PV frontends and the Xen platform PCI driver have
+	 * been compiled for this kernel (modules or built-in are both OK). */
+	if (!xen_emul_unplug) {
+		if (xen_must_unplug_nics()) {
+			printk(KERN_INFO "Netfront and the Xen platform PCI driver have "
+					"been compiled for this kernel: unplug emulated NICs.\n");
+			xen_emul_unplug |= XEN_UNPLUG_ALL_NICS;
+		}
+		if (xen_must_unplug_disks()) {
+			printk(KERN_INFO "Blkfront and the Xen platform PCI driver have "
+					"been compiled for this kernel: unplug emulated disks.\n"
+					"You might have to change the root device\n"
+					"from /dev/hd[a-d] to /dev/xvd[a-d]\n"
+					"in your root= kernel command line option\n");
+			xen_emul_unplug |= XEN_UNPLUG_ALL_IDE_DISKS;
+		}
+	}
+	/* Now unplug the emulated devices */
+	if (!(xen_emul_unplug&  XEN_UNPLUG_IGNORE))
+		outw(xen_emul_unplug, XEN_IOPORT_UNPLUG);
+	xen_platform_pci_unplug = xen_emul_unplug;
+}
+
+static int __init parse_xen_emul_unplug(char *arg)
+{
+	char *p, *q;
+	int l;
+
+	for (p = arg; p; p = q) {
+		q = strchr(p, ',');
+		if (q) {
+			l = q - p;
+			q++;
+		} else {
+			l = strlen(p);
+		}
+		if (!strncmp(p, "all", l))
+			xen_emul_unplug |= XEN_UNPLUG_ALL;
+		else if (!strncmp(p, "ide-disks", l))
+			xen_emul_unplug |= XEN_UNPLUG_ALL_IDE_DISKS;
+		else if (!strncmp(p, "aux-ide-disks", l))
+			xen_emul_unplug |= XEN_UNPLUG_AUX_IDE_DISKS;
+		else if (!strncmp(p, "nics", l))
+			xen_emul_unplug |= XEN_UNPLUG_ALL_NICS;
+		else if (!strncmp(p, "ignore", l))
+			xen_emul_unplug |= XEN_UNPLUG_IGNORE;
+		else
+			printk(KERN_WARNING "unrecognised option '%s' "
+				 "in parameter 'xen_emul_unplug'\n", p);
+	}
+	return 0;
+}
+early_param("xen_emul_unplug", parse_xen_emul_unplug);
+#endif
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index ad0047f..328b003 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -20,6 +20,7 @@
  #include<xen/page.h>
  #include<xen/interface/callback.h>
  #include<xen/interface/physdev.h>
+#include<xen/interface/memory.h>
  #include<xen/features.h>

  #include "xen-ops.h"
@@ -32,6 +33,73 @@ extern void xen_sysenter_target(void);
  extern void xen_syscall_target(void);
  extern void xen_syscall32_target(void);

+static unsigned long __init xen_release_chunk(phys_addr_t start_addr,
+					      phys_addr_t end_addr)
+{
+	struct xen_memory_reservation reservation = {
+		.address_bits = 0,
+		.extent_order = 0,
+		.domid        = DOMID_SELF
+	};
+	unsigned long start, end;
+	unsigned long len = 0;
+	unsigned long pfn;
+	int ret;
+
+	start = PFN_UP(start_addr);
+	end = PFN_DOWN(end_addr);
+
+	if (end<= start)
+		return 0;
+
+	printk(KERN_INFO "xen_release_chunk: looking at area pfn %lx-%lx: ",
+	       start, end);
+	for(pfn = start; pfn<  end; pfn++) {
+		unsigned long mfn = pfn_to_mfn(pfn);
+
+		/* Make sure pfn exists to start with */
+		if (mfn == INVALID_P2M_ENTRY || mfn_to_pfn(mfn) != pfn)
+			continue;
+
+		set_xen_guest_handle(reservation.extent_start,&mfn);
+		reservation.nr_extents = 1;
+
+		ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation,
+					&reservation);
+		WARN(ret != 1, "Failed to release memory %lx-%lx err=%d\n",
+		     start, end, ret);
+		if (ret == 1) {
+			set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
+			len++;
+		}
+	}
+	printk(KERN_CONT "%ld pages freed\n", len);
+
+	return len;
+}
+
+static unsigned long __init xen_return_unused_memory(unsigned long max_pfn,
+						     const struct e820map *e820)
+{
+	phys_addr_t max_addr = PFN_PHYS(max_pfn);
+	phys_addr_t last_end = 0;
+	unsigned long released = 0;
+	int i;
+
+	for (i = 0; i<  e820->nr_map&&  last_end<  max_addr; i++) {
+		phys_addr_t end = e820->map[i].addr;
+		end = min(max_addr, end);
+
+		released += xen_release_chunk(last_end, end);
+		last_end = e820->map[i].addr + e820->map[i].size;
+	}
+
+	if (last_end<  max_addr)
+		released += xen_release_chunk(last_end, max_addr);
+
+	printk(KERN_INFO "released %ld pages of unused memory\n", released);
+	return released;
+}

  /**
   * machine_specific_memory_setup - Hook for machine specific memory setup.
@@ -67,6 +135,8 @@ char * __init xen_memory_setup(void)

  	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map),&e820.nr_map);

+	xen_return_unused_memory(xen_start_info->nr_pages,&e820);
+
  	return "Xen";
  }

@@ -156,6 +226,8 @@ void __init xen_arch_setup(void)
  	struct physdev_set_iopl set_iopl;
  	int rc;

+	xen_panic_handler_init();
+
  	HYPERVISOR_vm_assist(VMASST_CMD_enable, VMASST_TYPE_4gb_segments);
  	HYPERVISOR_vm_assist(VMASST_CMD_enable, VMASST_TYPE_writable_pagetables);

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index a29693f..25f232b 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -394,6 +394,8 @@ static void stop_self(void *v)
  	load_cr3(swapper_pg_dir);
  	/* should set up a minimal gdt */

+	set_cpu_online(cpu, false);
+
  	HYPERVISOR_vcpu_op(VCPUOP_down, cpu, NULL);
  	BUG();
  }
diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index a9c6611..1d789d5 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -26,6 +26,18 @@ void xen_pre_suspend(void)
  		BUG();
  }

+void xen_hvm_post_suspend(int suspend_cancelled)
+{
+	int cpu;
+	xen_hvm_init_shared_info();
+	xen_callback_vector();
+	if (xen_feature(XENFEAT_hvm_safe_pvclock)) {
+		for_each_online_cpu(cpu) {
+			xen_setup_runstate_info(cpu);
+		}
+	}
+}
+
  void xen_post_suspend(int suspend_cancelled)
  {
  	xen_build_mfn_list_list();
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index b3c6c59..1a5353a 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -20,6 +20,7 @@
  #include<asm/xen/hypercall.h>

  #include<xen/events.h>
+#include<xen/features.h>
  #include<xen/interface/xen.h>
  #include<xen/interface/vcpu.h>

@@ -155,47 +156,8 @@ static void do_stolen_accounting(void)
  	account_idle_ticks(ticks);
  }

-/*
- * Xen sched_clock implementation.  Returns the number of unstolen
- * nanoseconds, which is nanoseconds the VCPU spent in RUNNING+BLOCKED
- * states.
- */
-unsigned long long xen_sched_clock(void)
-{
-	struct vcpu_runstate_info state;
-	cycle_t now;
-	u64 ret;
-	s64 offset;
-
-	/*
-	 * Ideally sched_clock should be called on a per-cpu basis
-	 * anyway, so preempt should already be disabled, but that's
-	 * not current practice at the moment.
-	 */
-	preempt_disable();
-
-	now = xen_clocksource_read();
-
-	get_runstate_snapshot(&state);
-
-	WARN_ON(state.state != RUNSTATE_running);
-
-	offset = now - state.state_entry_time;
-	if (offset<  0)
-		offset = 0;
-
-	ret = state.time[RUNSTATE_blocked] +
-		state.time[RUNSTATE_running] +
-		offset;
-
-	preempt_enable();
-
-	return ret;
-}
-
-
  /* Get the TSC speed from Xen */
-unsigned long xen_tsc_khz(void)
+static unsigned long xen_tsc_khz(void)
  {
  	struct pvclock_vcpu_time_info *info =
  		&HYPERVISOR_shared_info->vcpu_info[0].time;
@@ -230,7 +192,7 @@ static void xen_read_wallclock(struct timespec *ts)
  	put_cpu_var(xen_vcpu);
  }

-unsigned long xen_get_wallclock(void)
+static unsigned long xen_get_wallclock(void)
  {
  	struct timespec ts;

@@ -238,7 +200,7 @@ unsigned long xen_get_wallclock(void)
  	return ts.tv_sec;
  }

-int xen_set_wallclock(unsigned long now)
+static int xen_set_wallclock(unsigned long now)
  {
  	/* do nothing for domU */
  	return -1;
@@ -473,7 +435,11 @@ void xen_timer_resume(void)
  	}
  }

-__init void xen_time_init(void)
+static const struct pv_time_ops xen_time_ops __initdata = {
+	.sched_clock = xen_clocksource_read,
+};
+
+static __init void xen_time_init(void)
  {
  	int cpu = smp_processor_id();
  	struct timespec tp;
@@ -497,3 +463,47 @@ __init void xen_time_init(void)
  	xen_setup_timer(cpu);
  	xen_setup_cpu_clockevents();
  }
+
+__init void xen_init_time_ops(void)
+{
+	pv_time_ops = xen_time_ops;
+
+	x86_init.timers.timer_init = xen_time_init;
+	x86_init.timers.setup_percpu_clockev = x86_init_noop;
+	x86_cpuinit.setup_percpu_clockev = x86_init_noop;
+
+	x86_platform.calibrate_tsc = xen_tsc_khz;
+	x86_platform.get_wallclock = xen_get_wallclock;
+	x86_platform.set_wallclock = xen_set_wallclock;
+}
+
+#ifdef CONFIG_XEN_PVHVM
+static void xen_hvm_setup_cpu_clockevents(void)
+{
+	int cpu = smp_processor_id();
+	xen_setup_runstate_info(cpu);
+	xen_setup_timer(cpu);
+	xen_setup_cpu_clockevents();
+}
+
+__init void xen_hvm_init_time_ops(void)
+{
+	/* vector callback is needed otherwise we cannot receive interrupts
+	 * on cpu>  0 */
+	if (!xen_have_vector_callback&&  num_present_cpus()>  1)
+		return;
+	if (!xen_feature(XENFEAT_hvm_safe_pvclock)) {
+		printk(KERN_INFO "Xen doesn't support pvclock on HVM,"
+				"disable pv timer\n");
+		return;
+	}
+
+	pv_time_ops = xen_time_ops;
+	x86_init.timers.setup_percpu_clockev = xen_time_init;
+	x86_cpuinit.setup_percpu_clockev = xen_hvm_setup_cpu_clockevents;
+
+	x86_platform.calibrate_tsc = xen_tsc_khz;
+	x86_platform.get_wallclock = xen_get_wallclock;
+	x86_platform.set_wallclock = xen_set_wallclock;
+}
+#endif
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index f9153a3..7c8ab86 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -38,6 +38,10 @@ void xen_enable_sysenter(void);
  void xen_enable_syscall(void);
  void xen_vcpu_restore(void);

+void xen_callback_vector(void);
+void xen_hvm_init_shared_info(void);
+void __init xen_unplug_emulated_devices(void);
+
  void __init xen_build_dynamic_phys_to_machine(void);

  void xen_init_irq_ops(void);
@@ -46,11 +50,8 @@ void xen_setup_runstate_info(int cpu);
  void xen_teardown_timer(int cpu);
  cycle_t xen_clocksource_read(void);
  void xen_setup_cpu_clockevents(void);
-unsigned long xen_tsc_khz(void);
-void __init xen_time_init(void);
-unsigned long xen_get_wallclock(void);
-int xen_set_wallclock(unsigned long time);
-unsigned long long xen_sched_clock(void);
+void __init xen_init_time_ops(void);
+void __init xen_hvm_init_time_ops(void);

  irqreturn_t xen_debug_interrupt(int irq, void *dev_id);

@@ -101,4 +102,6 @@ void xen_sysret32(void);
  void xen_sysret64(void);
  void xen_adjust_exception_frame(void);

+extern int xen_panic_handler_init(void);
+
  #endif /* XEN_OPS_H */
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 82ed403..f63ac3d 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -48,6 +48,7 @@
  #include<xen/grant_table.h>
  #include<xen/events.h>
  #include<xen/page.h>
+#include<xen/platform_pci.h>

  #include<xen/interface/grant_table.h>
  #include<xen/interface/io/blkif.h>
@@ -737,6 +738,35 @@ static int blkfront_probe(struct xenbus_device *dev,
  		}
  	}

+	if (xen_hvm_domain()) {
+		char *type;
+		int len;
+		/* no unplug has been done: do not hook devices != xen vbds */
+		if (xen_platform_pci_unplug&  XEN_UNPLUG_IGNORE) {
+			int major;
+
+			if (!VDEV_IS_EXTENDED(vdevice))
+				major = BLKIF_MAJOR(vdevice);
+			else
+				major = XENVBD_MAJOR;
+
+			if (major != XENVBD_MAJOR) {
+				printk(KERN_INFO
+						"%s: HVM does not support vbd %d as xen block device\n",
+						__FUNCTION__, vdevice);
+				return -ENODEV;
+			}
+		}
+		/* do not create a PV cdrom device if we are an HVM guest */
+		type = xenbus_read(XBT_NIL, dev->nodename, "device-type",&len);
+		if (IS_ERR(type))
+			return -ENODEV;
+		if (strncmp(type, "cdrom", 5) == 0) {
+			kfree(type);
+			return -ENODEV;
+		}
+		kfree(type);
+	}
  	info = kzalloc(sizeof(*info), GFP_KERNEL);
  	if (!info) {
  		xenbus_dev_fatal(dev, -ENOMEM, "allocating info structure");
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index e140816..ebb1190 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -339,7 +339,7 @@ static struct xenbus_driver xenkbd_driver = {

  static int __init xenkbd_init(void)
  {
-	if (!xen_domain())
+	if (!xen_pv_domain())
  		return -ENODEV;

  	/* Nothing to do if running in dom0. */
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index fa97d3e..7c7f42a12 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -684,7 +684,7 @@ static struct xenbus_driver xenfb_driver = {

  static int __init xenfb_init(void)
  {
-	if (!xen_domain())
+	if (!xen_pv_domain())
  		return -ENODEV;

  	/* Nothing to do if running in dom0. */
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index fad3df2..0a88269 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -62,4 +62,13 @@ config XEN_SYS_HYPERVISOR
  	 virtual environment, /sys/hypervisor will still be present,
  	 but will have no xen contents.

+config XEN_PLATFORM_PCI
+	tristate "xen platform pci device driver"
+	depends on XEN_PVHVM
+	default m
+	help
+	  Driver for the Xen PCI Platform device: it is responsible for
+	  initializing xenbus and grant_table when running in a Xen HVM
+	  domain. As a consequence this driver is required to run any Xen PV
+	  frontend on Xen HVM.
  endmenu
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 7c28434..e392fb7 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -9,4 +9,5 @@ obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
  obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
  obj-$(CONFIG_XEN_DEV_EVTCHN)	+= evtchn.o
  obj-$(CONFIG_XENFS)		+= xenfs/
-obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
\ No newline at end of file
+obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
+obj-$(CONFIG_XEN_PLATFORM_PCI)	+= platform-pci.o
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index db8f506..5e1f348 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -29,6 +29,7 @@
  #include<linux/bootmem.h>
  #include<linux/slab.h>

+#include<asm/desc.h>
  #include<asm/ptrace.h>
  #include<asm/irq.h>
  #include<asm/idle.h>
@@ -36,10 +37,14 @@
  #include<asm/xen/hypercall.h>
  #include<asm/xen/hypervisor.h>

+#include<xen/xen.h>
+#include<xen/hvm.h>
  #include<xen/xen-ops.h>
  #include<xen/events.h>
  #include<xen/interface/xen.h>
  #include<xen/interface/event_channel.h>
+#include<xen/interface/hvm/hvm_op.h>
+#include<xen/interface/hvm/params.h>

  /*
   * This lock protects updates to the following mapping and reference-count
@@ -335,9 +340,18 @@ static int find_unbound_irq(void)
  	int irq;
  	struct irq_desc *desc;

-	for (irq = 0; irq<  nr_irqs; irq++)
+	for (irq = 0; irq<  nr_irqs; irq++) {
+		desc = irq_to_desc(irq);
+		/* only 0->15 have init'd desc; handle irq>  16 */
+		if (desc == NULL)
+			break;
+		if (desc->chip ==&no_irq_chip)
+			break;
+		if (desc->chip !=&xen_dynamic_chip)
+			continue;
  		if (irq_info[irq].type == IRQT_UNBOUND)
  			break;
+	}

  	if (irq == nr_irqs)
  		panic("No available IRQ to bind to: increase nr_irqs!\n");
@@ -346,7 +360,7 @@ static int find_unbound_irq(void)
  	if (WARN_ON(desc == NULL))
  		return -1;

-	dynamic_irq_init(irq);
+	dynamic_irq_init_keep_chip_data(irq);

  	return irq;
  }
@@ -617,17 +631,13 @@ static DEFINE_PER_CPU(unsigned, xed_nesting_count);
   * a bitset of words which contain pending event bits.  The second
   * level is a bitset of pending events themselves.
   */
-void xen_evtchn_do_upcall(struct pt_regs *regs)
+static void __xen_evtchn_do_upcall(void)
  {
  	int cpu = get_cpu();
-	struct pt_regs *old_regs = set_irq_regs(regs);
  	struct shared_info *s = HYPERVISOR_shared_info;
  	struct vcpu_info *vcpu_info = __get_cpu_var(xen_vcpu);
   	unsigned count;

-	exit_idle();
-	irq_enter();
-
  	do {
  		unsigned long pending_words;

@@ -664,14 +674,31 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)

  		count = __get_cpu_var(xed_nesting_count);
  		__get_cpu_var(xed_nesting_count) = 0;
-	} while(count != 1);
+	} while (count != 1 || vcpu_info->evtchn_upcall_pending);

  out:
+
+	put_cpu();
+}
+
+void xen_evtchn_do_upcall(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	exit_idle();
+	irq_enter();
+
+	__xen_evtchn_do_upcall();
+
  	irq_exit();
  	set_irq_regs(old_regs);
+}

-	put_cpu();
+void xen_hvm_evtchn_do_upcall(void)
+{
+	__xen_evtchn_do_upcall();
  }
+EXPORT_SYMBOL_GPL(xen_hvm_evtchn_do_upcall);

  /* Rebind a new event channel to an existing irq. */
  void rebind_evtchn_irq(int evtchn, int irq)
@@ -708,7 +735,10 @@ static int rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
  	struct evtchn_bind_vcpu bind_vcpu;
  	int evtchn = evtchn_from_irq(irq);

-	if (!VALID_EVTCHN(evtchn))
+	/* events delivered via platform PCI interrupts are always
+	 * routed to vcpu 0 */
+	if (!VALID_EVTCHN(evtchn) ||
+		(xen_hvm_domain()&&  !xen_have_vector_callback))
  		return -1;

  	/* Send future instances of this interrupt to other vcpu. */
@@ -933,6 +963,44 @@ static struct irq_chip xen_dynamic_chip __read_mostly = {
  	.retrigger	= retrigger_dynirq,
  };

+int xen_set_callback_via(uint64_t via)
+{
+	struct xen_hvm_param a;
+	a.domid = DOMID_SELF;
+	a.index = HVM_PARAM_CALLBACK_IRQ;
+	a.value = via;
+	return HYPERVISOR_hvm_op(HVMOP_set_param,&a);
+}
+EXPORT_SYMBOL_GPL(xen_set_callback_via);
+
+#ifdef CONFIG_XEN_PVHVM
+/* Vector callbacks are better than PCI interrupts to receive event
+ * channel notifications because we can receive vector callbacks on any
+ * vcpu and we don't need PCI support or APIC interactions. */
+void xen_callback_vector(void)
+{
+	int rc;
+	uint64_t callback_via;
+	if (xen_have_vector_callback) {
+		callback_via = HVM_CALLBACK_VECTOR(XEN_HVM_EVTCHN_CALLBACK);
+		rc = xen_set_callback_via(callback_via);
+		if (rc) {
+			printk(KERN_ERR "Request for Xen HVM callback vector"
+					" failed.\n");
+			xen_have_vector_callback = 0;
+			return;
+		}
+		printk(KERN_INFO "Xen HVM callback vector for event delivery is "
+				"enabled\n");
+		/* in the restore case the vector has already been allocated */
+		if (!test_bit(XEN_HVM_EVTCHN_CALLBACK, used_vectors))
+			alloc_intr_gate(XEN_HVM_EVTCHN_CALLBACK, xen_hvm_callback_vector);
+	}
+}
+#else
+void xen_callback_vector(void) {}
+#endif
+
  void __init xen_init_IRQ(void)
  {
  	int i;
@@ -947,5 +1015,10 @@ void __init xen_init_IRQ(void)
  	for (i = 0; i<  NR_EVENT_CHANNELS; i++)
  		mask_evtchn(i);

-	irq_ctx_init(smp_processor_id());
+	if (xen_hvm_domain()) {
+		xen_callback_vector();
+		native_init_IRQ();
+	} else {
+		irq_ctx_init(smp_processor_id());
+	}
  }
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index f66db3b..6c45318 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -37,11 +37,13 @@
  #include<linux/slab.h>
  #include<linux/vmalloc.h>
  #include<linux/uaccess.h>
+#include<linux/io.h>

  #include<xen/xen.h>
  #include<xen/interface/xen.h>
  #include<xen/page.h>
  #include<xen/grant_table.h>
+#include<xen/interface/memory.h>
  #include<asm/xen/hypercall.h>

  #include<asm/pgtable.h>
@@ -59,6 +61,8 @@ static unsigned int boot_max_nr_grant_frames;
  static int gnttab_free_count;
  static grant_ref_t gnttab_free_head;
  static DEFINE_SPINLOCK(gnttab_list_lock);
+unsigned long xen_hvm_resume_frames;
+EXPORT_SYMBOL_GPL(xen_hvm_resume_frames);

  static struct grant_entry *shared;

@@ -433,7 +437,7 @@ static unsigned int __max_nr_grant_frames(void)
  	return query.max_nr_frames;
  }

-static inline unsigned int max_nr_grant_frames(void)
+unsigned int gnttab_max_grant_frames(void)
  {
  	unsigned int xen_max = __max_nr_grant_frames();

@@ -441,6 +445,7 @@ static inline unsigned int max_nr_grant_frames(void)
  		return boot_max_nr_grant_frames;
  	return xen_max;
  }
+EXPORT_SYMBOL_GPL(gnttab_max_grant_frames);

  static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
  {
@@ -449,6 +454,30 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
  	unsigned int nr_gframes = end_idx + 1;
  	int rc;

+	if (xen_hvm_domain()) {
+		struct xen_add_to_physmap xatp;
+		unsigned int i = end_idx;
+		rc = 0;
+		/*
+		 * Loop backwards, so that the first hypercall has the largest
+		 * index, ensuring that the table will grow only once.
+		 */
+		do {
+			xatp.domid = DOMID_SELF;
+			xatp.idx = i;
+			xatp.space = XENMAPSPACE_grant_table;
+			xatp.gpfn = (xen_hvm_resume_frames>>  PAGE_SHIFT) + i;
+			rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap,&xatp);
+			if (rc != 0) {
+				printk(KERN_WARNING
+						"grant table add_to_physmap failed, err=%d\n", rc);
+				break;
+			}
+		} while (i-->  start_idx);
+
+		return rc;
+	}
+
  	frames = kmalloc(nr_gframes * sizeof(unsigned long), GFP_ATOMIC);
  	if (!frames)
  		return -ENOMEM;
@@ -465,7 +494,7 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)

  	BUG_ON(rc || setup.status);

-	rc = arch_gnttab_map_shared(frames, nr_gframes, max_nr_grant_frames(),
+	rc = arch_gnttab_map_shared(frames, nr_gframes, gnttab_max_grant_frames(),
  				&shared);
  	BUG_ON(rc);

@@ -476,9 +505,27 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)

  int gnttab_resume(void)
  {
-	if (max_nr_grant_frames()<  nr_grant_frames)
+	unsigned int max_nr_gframes;
+
+	max_nr_gframes = gnttab_max_grant_frames();
+	if (max_nr_gframes<  nr_grant_frames)
  		return -ENOSYS;
-	return gnttab_map(0, nr_grant_frames - 1);
+
+	if (xen_pv_domain())
+		return gnttab_map(0, nr_grant_frames - 1);
+
+	if (!shared) {
+		shared = ioremap(xen_hvm_resume_frames, PAGE_SIZE * max_nr_gframes);
+		if (shared == NULL) {
+			printk(KERN_WARNING
+					"Failed to ioremap gnttab share frames!");
+			return -ENOMEM;
+		}
+	}
+
+	gnttab_map(0, nr_grant_frames - 1);
+
+	return 0;
  }

  int gnttab_suspend(void)
@@ -495,7 +542,7 @@ static int gnttab_expand(unsigned int req_entries)
  	cur = nr_grant_frames;
  	extra = ((req_entries + (GREFS_PER_GRANT_FRAME-1)) /
  		 GREFS_PER_GRANT_FRAME);
-	if (cur + extra>  max_nr_grant_frames())
+	if (cur + extra>  gnttab_max_grant_frames())
  		return -ENOSPC;

  	rc = gnttab_map(cur, cur + extra - 1);
@@ -505,15 +552,12 @@ static int gnttab_expand(unsigned int req_entries)
  	return rc;
  }

-static int __devinit gnttab_init(void)
+int gnttab_init(void)
  {
  	int i;
  	unsigned int max_nr_glist_frames, nr_glist_frames;
  	unsigned int nr_init_grefs;

-	if (!xen_domain())
-		return -ENODEV;
-
  	nr_grant_frames = 1;
  	boot_max_nr_grant_frames = __max_nr_grant_frames();

@@ -556,5 +600,18 @@ static int __devinit gnttab_init(void)
  	kfree(gnttab_list);
  	return -ENOMEM;
  }
+EXPORT_SYMBOL_GPL(gnttab_init);
+
+static int __devinit __gnttab_init(void)
+{
+	/* Delay grant-table initialization in the PV on HVM case */
+	if (xen_hvm_domain())
+		return 0;
+
+	if (!xen_pv_domain())
+		return -ENODEV;
+
+	return gnttab_init();
+}

-core_initcall(gnttab_init);
+core_initcall(__gnttab_init);
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 07e857b0..1799bd8 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -9,6 +9,7 @@
  #include<linux/stop_machine.h>
  #include<linux/freezer.h>

+#include<xen/xen.h>
  #include<xen/xenbus.h>
  #include<xen/grant_table.h>
  #include<xen/events.h>
@@ -17,6 +18,7 @@

  #include<asm/xen/hypercall.h>
  #include<asm/xen/page.h>
+#include<asm/xen/hypervisor.h>

  enum shutdown_state {
  	SHUTDOWN_INVALID = -1,
@@ -33,10 +35,30 @@ enum shutdown_state {
  static enum shutdown_state shutting_down = SHUTDOWN_INVALID;

  #ifdef CONFIG_PM_SLEEP
-static int xen_suspend(void *data)
+static int xen_hvm_suspend(void *data)
  {
+	struct sched_shutdown r = { .reason = SHUTDOWN_suspend };
  	int *cancelled = data;
+
+	BUG_ON(!irqs_disabled());
+
+	*cancelled = HYPERVISOR_sched_op(SCHEDOP_shutdown,&r);
+
+	xen_hvm_post_suspend(*cancelled);
+	gnttab_resume();
+
+	if (!*cancelled) {
+		xen_irq_resume();
+		xen_timer_resume();
+	}
+
+	return 0;
+}
+
+static int xen_suspend(void *data)
+{
  	int err;
+	int *cancelled = data;

  	BUG_ON(!irqs_disabled());

@@ -106,7 +128,10 @@ static void do_suspend(void)
  		goto out_resume;
  	}

-	err = stop_machine(xen_suspend,&cancelled, cpumask_of(0));
+	if (xen_hvm_domain())
+		err = stop_machine(xen_hvm_suspend,&cancelled, cpumask_of(0));
+	else
+		err = stop_machine(xen_suspend,&cancelled, cpumask_of(0));

  	dpm_resume_noirq(PMSG_RESUME);

@@ -255,7 +280,19 @@ static int shutdown_event(struct notifier_block *notifier,
  	return NOTIFY_DONE;
  }

-static int __init setup_shutdown_event(void)
+static int __init __setup_shutdown_event(void)
+{
+	/* Delay initialization in the PV on HVM case */
+	if (xen_hvm_domain())
+		return 0;
+
+	if (!xen_pv_domain())
+		return -ENODEV;
+
+	return xen_setup_shutdown_event();
+}
+
+int xen_setup_shutdown_event(void)
  {
  	static struct notifier_block xenstore_notifier = {
  		.notifier_call = shutdown_event
@@ -264,5 +301,6 @@ static int __init setup_shutdown_event(void)

  	return 0;
  }
+EXPORT_SYMBOL_GPL(xen_setup_shutdown_event);

-subsys_initcall(setup_shutdown_event);
+subsys_initcall(__setup_shutdown_event);
diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
new file mode 100644
index 0000000..c01b5dd
--- /dev/null
+++ b/drivers/xen/platform-pci.c
@@ -0,0 +1,207 @@
+/******************************************************************************
+ * platform-pci.c
+ *
+ * Xen platform PCI device driver
+ * Copyright (c) 2005, Intel Corporation.
+ * Copyright (c) 2007, XenSource Inc.
+ * Copyright (c) 2010, Citrix
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ */
+
+
+#include<linux/interrupt.h>
+#include<linux/io.h>
+#include<linux/module.h>
+#include<linux/pci.h>
+
+#include<xen/platform_pci.h>
+#include<xen/grant_table.h>
+#include<xen/xenbus.h>
+#include<xen/events.h>
+#include<xen/hvm.h>
+#include<xen/xen-ops.h>
+
+#define DRV_NAME    "xen-platform-pci"
+
+MODULE_AUTHOR("ssmith@xensource.com and stefano.stabellini@eu.citrix.com");
+MODULE_DESCRIPTION("Xen platform PCI device");
+MODULE_LICENSE("GPL");
+
+static unsigned long platform_mmio;
+static unsigned long platform_mmio_alloc;
+static unsigned long platform_mmiolen;
+static uint64_t callback_via;
+
+unsigned long alloc_xen_mmio(unsigned long len)
+{
+	unsigned long addr;
+
+	addr = platform_mmio + platform_mmio_alloc;
+	platform_mmio_alloc += len;
+	BUG_ON(platform_mmio_alloc>  platform_mmiolen);
+
+	return addr;
+}
+
+static uint64_t get_callback_via(struct pci_dev *pdev)
+{
+	u8 pin;
+	int irq;
+
+	irq = pdev->irq;
+	if (irq<  16)
+		return irq; /* ISA IRQ */
+
+	pin = pdev->pin;
+
+	/* We don't know the GSI. Specify the PCI INTx line instead. */
+	return ((uint64_t)0x01<<  56) | /* PCI INTx identifier */
+		((uint64_t)pci_domain_nr(pdev->bus)<<  32) |
+		((uint64_t)pdev->bus->number<<  16) |
+		((uint64_t)(pdev->devfn&  0xff)<<  8) |
+		((uint64_t)(pin - 1)&  3);
+}
+
+static irqreturn_t do_hvm_evtchn_intr(int irq, void *dev_id)
+{
+	xen_hvm_evtchn_do_upcall();
+	return IRQ_HANDLED;
+}
+
+static int xen_allocate_irq(struct pci_dev *pdev)
+{
+	return request_irq(pdev->irq, do_hvm_evtchn_intr,
+			IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TRIGGER_RISING,
+			"xen-platform-pci", pdev);
+}
+
+static int platform_pci_resume(struct pci_dev *pdev)
+{
+	int err;
+	if (xen_have_vector_callback)
+		return 0;
+	err = xen_set_callback_via(callback_via);
+	if (err) {
+		dev_err(&pdev->dev, "platform_pci_resume failure!\n");
+		return err;
+	}
+	return 0;
+}
+
+static int __devinit platform_pci_init(struct pci_dev *pdev,
+				       const struct pci_device_id *ent)
+{
+	int i, ret;
+	long ioaddr, iolen;
+	long mmio_addr, mmio_len;
+	unsigned int max_nr_gframes;
+
+	i = pci_enable_device(pdev);
+	if (i)
+		return i;
+
+	ioaddr = pci_resource_start(pdev, 0);
+	iolen = pci_resource_len(pdev, 0);
+
+	mmio_addr = pci_resource_start(pdev, 1);
+	mmio_len = pci_resource_len(pdev, 1);
+
+	if (mmio_addr == 0 || ioaddr == 0) {
+		dev_err(&pdev->dev, "no resources found\n");
+		ret = -ENOENT;
+		goto pci_out;
+	}
+
+	if (request_mem_region(mmio_addr, mmio_len, DRV_NAME) == NULL) {
+		dev_err(&pdev->dev, "MEM I/O resource 0x%lx @ 0x%lx busy\n",
+		       mmio_addr, mmio_len);
+		ret = -EBUSY;
+		goto pci_out;
+	}
+
+	if (request_region(ioaddr, iolen, DRV_NAME) == NULL) {
+		dev_err(&pdev->dev, "I/O resource 0x%lx @ 0x%lx busy\n",
+		       iolen, ioaddr);
+		ret = -EBUSY;
+		goto mem_out;
+	}
+
+	platform_mmio = mmio_addr;
+	platform_mmiolen = mmio_len;
+
+	if (!xen_have_vector_callback) {
+		ret = xen_allocate_irq(pdev);
+		if (ret) {
+			dev_warn(&pdev->dev, "request_irq failed err=%d\n", ret);
+			goto out;
+		}
+		callback_via = get_callback_via(pdev);
+		ret = xen_set_callback_via(callback_via);
+		if (ret) {
+			dev_warn(&pdev->dev, "Unable to set the evtchn callback "
+					 "err=%d\n", ret);
+			goto out;
+		}
+	}
+
+	max_nr_gframes = gnttab_max_grant_frames();
+	xen_hvm_resume_frames = alloc_xen_mmio(PAGE_SIZE * max_nr_gframes);
+	ret = gnttab_init();
+	if (ret)
+		goto out;
+	xenbus_probe(NULL);
+	ret = xen_setup_shutdown_event();
+	if (ret)
+		goto out;
+	return 0;
+
+out:
+	release_region(ioaddr, iolen);
+mem_out:
+	release_mem_region(mmio_addr, mmio_len);
+pci_out:
+	pci_disable_device(pdev);
+	return ret;
+}
+
+static struct pci_device_id platform_pci_tbl[] __devinitdata = {
+	{PCI_VENDOR_ID_XEN, PCI_DEVICE_ID_XEN_PLATFORM,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{0,}
+};
+
+MODULE_DEVICE_TABLE(pci, platform_pci_tbl);
+
+static struct pci_driver platform_driver = {
+	.name =           DRV_NAME,
+	.probe =          platform_pci_init,
+	.id_table =       platform_pci_tbl,
+#ifdef CONFIG_PM
+	.resume_early =   platform_pci_resume,
+#endif
+};
+
+static int __init platform_pci_module_init(void)
+{
+	/* no unplug has been done, IGNORE hasn't been specified: just
+	 * return now */
+	if (!xen_platform_pci_unplug)
+		return -ENODEV;
+
+	return pci_register_driver(&platform_driver);
+}
+
+module_init(platform_pci_module_init);
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 3479332..29bac51 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -56,6 +56,9 @@
  #include<xen/events.h>
  #include<xen/page.h>

+#include<xen/platform_pci.h>
+#include<xen/hvm.h>
+
  #include "xenbus_comms.h"
  #include "xenbus_probe.h"

@@ -752,10 +755,7 @@ int register_xenstore_notifier(struct notifier_block *nb)
  {
  	int ret = 0;

-	if (xenstored_ready>  0)
-		ret = nb->notifier_call(nb, 0, NULL);
-	else
-		blocking_notifier_chain_register(&xenstore_chain, nb);
+	blocking_notifier_chain_register(&xenstore_chain, nb);

  	return ret;
  }
@@ -779,8 +779,23 @@ void xenbus_probe(struct work_struct *unused)
  	/* Notify others that xenstore is up */
  	blocking_notifier_call_chain(&xenstore_chain, 0, NULL);
  }
+EXPORT_SYMBOL_GPL(xenbus_probe);
+
+static int __init xenbus_probe_initcall(void)
+{
+	if (!xen_domain())
+		return -ENODEV;
+
+	if (xen_initial_domain() || xen_hvm_domain())
+		return 0;
+
+	xenbus_probe(NULL);
+	return 0;
+}
+
+device_initcall(xenbus_probe_initcall);

-static int __init xenbus_probe_init(void)
+static int __init xenbus_init(void)
  {
  	int err = 0;

@@ -805,11 +820,24 @@ static int __init xenbus_probe_init(void)
  	if (xen_initial_domain()) {
  		/* dom0 not yet supported */
  	} else {
+		if (xen_hvm_domain()) {
+			uint64_t v = 0;
+			err = hvm_get_parameter(HVM_PARAM_STORE_EVTCHN,&v);
+			if (err)
+				goto out_error;
+			xen_store_evtchn = (int)v;
+			err = hvm_get_parameter(HVM_PARAM_STORE_PFN,&v);
+			if (err)
+				goto out_error;
+			xen_store_mfn = (unsigned long)v;
+			xen_store_interface = ioremap(xen_store_mfn<<  PAGE_SHIFT, PAGE_SIZE);
+		} else {
+			xen_store_evtchn = xen_start_info->store_evtchn;
+			xen_store_mfn = xen_start_info->store_mfn;
+			xen_store_interface = mfn_to_virt(xen_store_mfn);
+		}
  		xenstored_ready = 1;
-		xen_store_evtchn = xen_start_info->store_evtchn;
-		xen_store_mfn = xen_start_info->store_mfn;
  	}
-	xen_store_interface = mfn_to_virt(xen_store_mfn);

  	/* Initialize the interface to xenstore. */
  	err = xs_init();
@@ -819,9 +847,6 @@ static int __init xenbus_probe_init(void)
  		goto out_unreg_back;
  	}

-	if (!xen_initial_domain())
-		xenbus_probe(NULL);
-
  #ifdef CONFIG_XEN_COMPAT_XENFS
  	/*
  	 * Create xenfs mountpoint in /proc for compatibility with
@@ -842,7 +867,7 @@ static int __init xenbus_probe_init(void)
  	return err;
  }

-postcore_initcall(xenbus_probe_init);
+postcore_initcall(xenbus_init);

  MODULE_LICENSE("GPL");

@@ -950,6 +975,9 @@ static void wait_for_devices(struct xenbus_driver *xendrv)
  #ifndef MODULE
  static int __init boot_wait_for_devices(void)
  {
+	if (xen_hvm_domain()&&  !xen_platform_pci_unplug)
+		return -ENODEV;
+
  	ready_to_wait_for_devices = 1;
  	wait_for_devices(NULL);
  	return 0;
diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index 7b547f5..5534690 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -76,6 +76,14 @@ struct xs_handle {
  	/*
  	 * Mutex ordering: transaction_mutex ->  watch_mutex ->  request_mutex.
  	 * response_mutex is never taken simultaneously with the other three.
+	 *
+	 * transaction_mutex must be held before incrementing
+	 * transaction_count. The mutex is held when a suspend is in
+	 * progress to prevent new transactions starting.
+	 *
+	 * When decrementing transaction_count to zero the wait queue
+	 * should be woken up, the suspend code waits for count to
+	 * reach zero.
  	 */

  	/* One request at a time. */
@@ -85,7 +93,9 @@ struct xs_handle {
  	struct mutex response_mutex;

  	/* Protect transactions against save/restore. */
-	struct rw_semaphore transaction_mutex;
+	struct mutex transaction_mutex;
+	atomic_t transaction_count;
+	wait_queue_head_t transaction_wq;

  	/* Protect watch (de)register against save/restore. */
  	struct rw_semaphore watch_mutex;
@@ -157,6 +167,31 @@ static void *read_reply(enum xsd_sockmsg_type *type, unsigned int *len)
  	return body;
  }

+static void transaction_start(void)
+{
+	mutex_lock(&xs_state.transaction_mutex);
+	atomic_inc(&xs_state.transaction_count);
+	mutex_unlock(&xs_state.transaction_mutex);
+}
+
+static void transaction_end(void)
+{
+	if (atomic_dec_and_test(&xs_state.transaction_count))
+		wake_up(&xs_state.transaction_wq);
+}
+
+static void transaction_suspend(void)
+{
+	mutex_lock(&xs_state.transaction_mutex);
+	wait_event(xs_state.transaction_wq,
+		   atomic_read(&xs_state.transaction_count) == 0);
+}
+
+static void transaction_resume(void)
+{
+	mutex_unlock(&xs_state.transaction_mutex);
+}
+
  void *xenbus_dev_request_and_reply(struct xsd_sockmsg *msg)
  {
  	void *ret;
@@ -164,7 +199,7 @@ void *xenbus_dev_request_and_reply(struct xsd_sockmsg *msg)
  	int err;

  	if (req_msg.type == XS_TRANSACTION_START)
-		down_read(&xs_state.transaction_mutex);
+		transaction_start();

  	mutex_lock(&xs_state.request_mutex);

@@ -180,7 +215,7 @@ void *xenbus_dev_request_and_reply(struct xsd_sockmsg *msg)
  	if ((msg->type == XS_TRANSACTION_END) ||
  	    ((req_msg.type == XS_TRANSACTION_START)&&
  	(msg->type == XS_ERROR)))
-		up_read(&xs_state.transaction_mutex);
+		transaction_end();

  	return ret;
  }
@@ -432,11 +467,11 @@ int xenbus_transaction_start(struct xenbus_transaction *t)
  {
  	char *id_str;

-	down_read(&xs_state.transaction_mutex);
+	transaction_start();

  	id_str = xs_single(XBT_NIL, XS_TRANSACTION_START, "", NULL);
  	if (IS_ERR(id_str)) {
-		up_read(&xs_state.transaction_mutex);
+		transaction_end();
  		return PTR_ERR(id_str);
  	}

@@ -461,7 +496,7 @@ int xenbus_transaction_end(struct xenbus_transaction t, int abort)

  	err = xs_error(xs_single(t, XS_TRANSACTION_END, abortstr, NULL));

-	up_read(&xs_state.transaction_mutex);
+	transaction_end();

  	return err;
  }
@@ -662,7 +697,7 @@ EXPORT_SYMBOL_GPL(unregister_xenbus_watch);

  void xs_suspend(void)
  {
-	down_write(&xs_state.transaction_mutex);
+	transaction_suspend();
  	down_write(&xs_state.watch_mutex);
  	mutex_lock(&xs_state.request_mutex);
  	mutex_lock(&xs_state.response_mutex);
@@ -677,7 +712,7 @@ void xs_resume(void)

  	mutex_unlock(&xs_state.response_mutex);
  	mutex_unlock(&xs_state.request_mutex);
-	up_write(&xs_state.transaction_mutex);
+	transaction_resume();

  	/* No need for watches_lock: the watch_mutex is sufficient. */
  	list_for_each_entry(watch,&watches, list) {
@@ -693,7 +728,7 @@ void xs_suspend_cancel(void)
  	mutex_unlock(&xs_state.response_mutex);
  	mutex_unlock(&xs_state.request_mutex);
  	up_write(&xs_state.watch_mutex);
-	up_write(&xs_state.transaction_mutex);
+	mutex_unlock(&xs_state.transaction_mutex);
  }

  static int xenwatch_thread(void *unused)
@@ -843,8 +878,10 @@ int xs_init(void)

  	mutex_init(&xs_state.request_mutex);
  	mutex_init(&xs_state.response_mutex);
-	init_rwsem(&xs_state.transaction_mutex);
+	mutex_init(&xs_state.transaction_mutex);
  	init_rwsem(&xs_state.watch_mutex);
+	atomic_set(&xs_state.transaction_count, 0);
+	init_waitqueue_head(&xs_state.transaction_wq);

  	/* Initialize the shared memory rings to talk to xenstored */
  	err = xb_init_comms();
diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
index 8924d93..78bfab0 100644
--- a/drivers/xen/xenfs/super.c
+++ b/drivers/xen/xenfs/super.c
@@ -65,7 +65,7 @@ static struct file_system_type xenfs_type = {

  static int __init xenfs_init(void)
  {
-	if (xen_pv_domain())
+	if (xen_domain())
  		return register_filesystem(&xenfs_type);

  	printk(KERN_INFO "XENFS: not registering filesystem on non-xen platform\n");
@@ -74,7 +74,7 @@ static int __init xenfs_init(void)

  static void __exit xenfs_exit(void)
  {
-	if (xen_pv_domain())
+	if (xen_domain())
  		unregister_filesystem(&xenfs_type);
  }

diff --git a/drivers/xen/xenfs/xenbus.c b/drivers/xen/xenfs/xenbus.c
index f28ece3..3b39c37 100644
--- a/drivers/xen/xenfs/xenbus.c
+++ b/drivers/xen/xenfs/xenbus.c
@@ -124,6 +124,9 @@ static ssize_t xenbus_file_read(struct file *filp,
  	mutex_lock(&u->reply_mutex);
  	while (list_empty(&u->read_buffers)) {
  		mutex_unlock(&u->reply_mutex);
+		if (filp->f_flags&  O_NONBLOCK)
+			return -EAGAIN;
+
  		ret = wait_event_interruptible(u->read_waitq,
  					       !list_empty(&u->read_buffers));
  		if (ret)
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 030a954..4e7ae60 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -653,6 +653,7 @@
  	EXIT_DATA							\
  	EXIT_CALL							\
  	*(.discard)							\
+	*(.discard.*)							\
  	}

  /**
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3bedcc1..cca2526 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2772,3 +2772,6 @@
  #define PCI_DEVICE_ID_RME_DIGI32	0x9896
  #define PCI_DEVICE_ID_RME_DIGI32_PRO	0x9897
  #define PCI_DEVICE_ID_RME_DIGI32_8	0x9898
+
+#define PCI_VENDOR_ID_XEN		0x5853
+#define PCI_DEVICE_ID_XEN_PLATFORM	0x0001
diff --git a/include/xen/events.h b/include/xen/events.h
index e68d59a..a15d932 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -56,4 +56,11 @@ void xen_poll_irq(int irq);
  /* Determine the IRQ which is bound to an event channel */
  unsigned irq_from_evtchn(unsigned int evtchn);

+/* Xen HVM evtchn vector callback */
+extern void xen_hvm_callback_vector(void);
+extern int xen_have_vector_callback;
+int xen_set_callback_via(uint64_t via);
+void xen_evtchn_do_upcall(struct pt_regs *regs);
+void xen_hvm_evtchn_do_upcall(void);
+
  #endif	/* _XEN_EVENTS_H */
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index a40f1cd..9a73170 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -51,6 +51,7 @@ struct gnttab_free_callback {
  	u16 count;
  };

+int gnttab_init(void);
  int gnttab_suspend(void);
  int gnttab_resume(void);

@@ -112,6 +113,9 @@ int arch_gnttab_map_shared(unsigned long *frames, unsigned long nr_gframes,
  void arch_gnttab_unmap_shared(struct grant_entry *shared,
  			      unsigned long nr_gframes);

+extern unsigned long xen_hvm_resume_frames;
+unsigned int gnttab_max_grant_frames(void);
+
  #define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))

  #endif /* __ASM_GNTTAB_H__ */
diff --git a/include/xen/hvm.h b/include/xen/hvm.h
new file mode 100644
index 0000000..b193fa2
--- /dev/null
+++ b/include/xen/hvm.h
@@ -0,0 +1,30 @@
+/* Simple wrappers around HVM functions */
+#ifndef XEN_HVM_H__
+#define XEN_HVM_H__
+
+#include<xen/interface/hvm/params.h>
+#include<asm/xen/hypercall.h>
+
+static inline int hvm_get_parameter(int idx, uint64_t *value)
+{
+	struct xen_hvm_param xhv;
+	int r;
+
+	xhv.domid = DOMID_SELF;
+	xhv.index = idx;
+	r = HYPERVISOR_hvm_op(HVMOP_get_param,&xhv);
+	if (r<  0) {
+		printk(KERN_ERR "Cannot get hvm parameter %d: %d!\n",
+			idx, r);
+		return r;
+	}
+	*value = xhv.value;
+	return r;
+}
+
+#define HVM_CALLBACK_VIA_TYPE_VECTOR 0x2
+#define HVM_CALLBACK_VIA_TYPE_SHIFT 56
+#define HVM_CALLBACK_VECTOR(x) (((uint64_t)HVM_CALLBACK_VIA_TYPE_VECTOR)<<\
+		HVM_CALLBACK_VIA_TYPE_SHIFT | (x))
+
+#endif /* XEN_HVM_H__ */
diff --git a/include/xen/interface/features.h b/include/xen/interface/features.h
index f51b641..70d2563 100644
--- a/include/xen/interface/features.h
+++ b/include/xen/interface/features.h
@@ -41,6 +41,12 @@
  /* x86: Does this Xen host support the MMU_PT_UPDATE_PRESERVE_AD hypercall? */
  #define XENFEAT_mmu_pt_update_preserve_ad  5

+/* x86: Does this Xen host support the HVM callback vector type? */
+#define XENFEAT_hvm_callback_vector        8
+
+/* x86: pvclock algorithm is safe to use on HVM */
+#define XENFEAT_hvm_safe_pvclock           9
+
  #define XENFEAT_NR_SUBMAPS 1

  #endif /* __XEN_PUBLIC_FEATURES_H__ */
diff --git a/include/xen/interface/grant_table.h b/include/xen/interface/grant_table.h
index 39da93c..39e5717 100644
--- a/include/xen/interface/grant_table.h
+++ b/include/xen/interface/grant_table.h
@@ -28,6 +28,7 @@
  #ifndef __XEN_PUBLIC_GRANT_TABLE_H__
  #define __XEN_PUBLIC_GRANT_TABLE_H__

+#include<xen/interface/xen.h>

  /***********************************
   * GRANT TABLE REPRESENTATION
diff --git a/include/xen/interface/hvm/hvm_op.h b/include/xen/interface/hvm/hvm_op.h
new file mode 100644
index 0000000..a4827f4
--- /dev/null
+++ b/include/xen/interface/hvm/hvm_op.h
@@ -0,0 +1,46 @@
+/*
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef __XEN_PUBLIC_HVM_HVM_OP_H__
+#define __XEN_PUBLIC_HVM_HVM_OP_H__
+
+/* Get/set subcommands: the second argument of the hypercall is a
+ * pointer to a xen_hvm_param struct. */
+#define HVMOP_set_param           0
+#define HVMOP_get_param           1
+struct xen_hvm_param {
+    domid_t  domid;    /* IN */
+    uint32_t index;    /* IN */
+    uint64_t value;    /* IN/OUT */
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_param);
+
+/* Hint from PV drivers for pagetable destruction. */
+#define HVMOP_pagetable_dying       9
+struct xen_hvm_pagetable_dying {
+    /* Domain with a pagetable about to be destroyed. */
+    domid_t  domid;
+    /* guest physical address of the toplevel pagetable dying */
+    aligned_u64 gpa;
+};
+typedef struct xen_hvm_pagetable_dying xen_hvm_pagetable_dying_t;
+DEFINE_GUEST_HANDLE_STRUCT(xen_hvm_pagetable_dying_t);
+
+#endif /* __XEN_PUBLIC_HVM_HVM_OP_H__ */
diff --git a/include/xen/interface/hvm/params.h b/include/xen/interface/hvm/params.h
new file mode 100644
index 0000000..1888d8c
--- /dev/null
+++ b/include/xen/interface/hvm/params.h
@@ -0,0 +1,95 @@
+/*
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef __XEN_PUBLIC_HVM_PARAMS_H__
+#define __XEN_PUBLIC_HVM_PARAMS_H__
+
+#include "hvm_op.h"
+
+/*
+ * Parameter space for HVMOP_{set,get}_param.
+ */
+
+/*
+ * How should CPU0 event-channel notifications be delivered?
+ * val[63:56] == 0: val[55:0] is a delivery GSI (Global System Interrupt).
+ * val[63:56] == 1: val[55:0] is a delivery PCI INTx line, as follows:
+ *                  Domain = val[47:32], Bus  = val[31:16],
+ *                  DevFn  = val[15: 8], IntX = val[ 1: 0]
+ * val[63:56] == 2: val[7:0] is a vector number.
+ * If val == 0 then CPU0 event-channel notifications are not delivered.
+ */
+#define HVM_PARAM_CALLBACK_IRQ 0
+
+#define HVM_PARAM_STORE_PFN    1
+#define HVM_PARAM_STORE_EVTCHN 2
+
+#define HVM_PARAM_PAE_ENABLED  4
+
+#define HVM_PARAM_IOREQ_PFN    5
+
+#define HVM_PARAM_BUFIOREQ_PFN 6
+
+/*
+ * Set mode for virtual timers (currently x86 only):
+ *  delay_for_missed_ticks (default):
+ *   Do not advance a vcpu's time beyond the correct delivery time for
+ *   interrupts that have been missed due to preemption. Deliver missed
+ *   interrupts when the vcpu is rescheduled and advance the vcpu's virtual
+ *   time stepwise for each one.
+ *  no_delay_for_missed_ticks:
+ *   As above, missed interrupts are delivered, but guest time always tracks
+ *   wallclock (i.e., real) time while doing so.
+ *  no_missed_ticks_pending:
+ *   No missed interrupts are held pending. Instead, to ensure ticks are
+ *   delivered at some non-zero rate, if we detect missed ticks then the
+ *   internal tick alarm is not disabled if the VCPU is preempted during the
+ *   next tick period.
+ *  one_missed_tick_pending:
+ *   Missed interrupts are collapsed together and delivered as one 'late tick'.
+ *   Guest time always tracks wallclock (i.e., real) time.
+ */
+#define HVM_PARAM_TIMER_MODE   10
+#define HVMPTM_delay_for_missed_ticks    0
+#define HVMPTM_no_delay_for_missed_ticks 1
+#define HVMPTM_no_missed_ticks_pending   2
+#define HVMPTM_one_missed_tick_pending   3
+
+/* Boolean: Enable virtual HPET (high-precision event timer)? (x86-only) */
+#define HVM_PARAM_HPET_ENABLED 11
+
+/* Identity-map page directory used by Intel EPT when CR0.PG=0. */
+#define HVM_PARAM_IDENT_PT     12
+
+/* Device Model domain, defaults to 0. */
+#define HVM_PARAM_DM_DOMAIN    13
+
+/* ACPI S state: currently support S0 and S3 on x86. */
+#define HVM_PARAM_ACPI_S_STATE 14
+
+/* TSS used on Intel when CR0.PE=0. */
+#define HVM_PARAM_VM86_TSS     15
+
+/* Boolean: Enable aligning all periodic vpts to reduce interrupts */
+#define HVM_PARAM_VPT_ALIGN    16
+
+#define HVM_NR_PARAMS          17
+
+#endif /* __XEN_PUBLIC_HVM_PARAMS_H__ */
diff --git a/include/xen/platform_pci.h b/include/xen/platform_pci.h
new file mode 100644
index 0000000..ce9d671
--- /dev/null
+++ b/include/xen/platform_pci.h
@@ -0,0 +1,49 @@
+#ifndef _XEN_PLATFORM_PCI_H
+#define _XEN_PLATFORM_PCI_H
+
+#define XEN_IOPORT_MAGIC_VAL 0x49d2
+#define XEN_IOPORT_LINUX_PRODNUM 0x0003
+#define XEN_IOPORT_LINUX_DRVVER  0x0001
+
+#define XEN_IOPORT_BASE 0x10
+
+#define XEN_IOPORT_PLATFLAGS	(XEN_IOPORT_BASE + 0) /* 1 byte access (R/W) */
+#define XEN_IOPORT_MAGIC	(XEN_IOPORT_BASE + 0) /* 2 byte access (R) */
+#define XEN_IOPORT_UNPLUG	(XEN_IOPORT_BASE + 0) /* 2 byte access (W) */
+#define XEN_IOPORT_DRVVER	(XEN_IOPORT_BASE + 0) /* 4 byte access (W) */
+
+#define XEN_IOPORT_SYSLOG	(XEN_IOPORT_BASE + 2) /* 1 byte access (W) */
+#define XEN_IOPORT_PROTOVER	(XEN_IOPORT_BASE + 2) /* 1 byte access (R) */
+#define XEN_IOPORT_PRODNUM	(XEN_IOPORT_BASE + 2) /* 2 byte access (W) */
+
+#define XEN_UNPLUG_ALL_IDE_DISKS 1
+#define XEN_UNPLUG_ALL_NICS 2
+#define XEN_UNPLUG_AUX_IDE_DISKS 4
+#define XEN_UNPLUG_ALL 7
+#define XEN_UNPLUG_IGNORE 8
+
+static inline int xen_must_unplug_nics(void) {
+#if (defined(CONFIG_XEN_NETDEV_FRONTEND) || \
+		defined(CONFIG_XEN_NETDEV_FRONTEND_MODULE))&&  \
+		(defined(CONFIG_XEN_PLATFORM_PCI) || \
+		 defined(CONFIG_XEN_PLATFORM_PCI_MODULE))
+        return 1;
+#else
+        return 0;
+#endif
+}
+
+static inline int xen_must_unplug_disks(void) {
+#if (defined(CONFIG_XEN_BLKDEV_FRONTEND) || \
+		defined(CONFIG_XEN_BLKDEV_FRONTEND_MODULE))&&  \
+		(defined(CONFIG_XEN_PLATFORM_PCI) || \
+		 defined(CONFIG_XEN_PLATFORM_PCI_MODULE))
+        return 1;
+#else
+        return 0;
+#endif
+}
+
+extern int xen_platform_pci_unplug;
+
+#endif /* _XEN_PLATFORM_PCI_H */
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 883a21b..46bc81e 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -7,6 +7,7 @@ DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);

  void xen_pre_suspend(void);
  void xen_post_suspend(int suspend_cancelled);
+void xen_hvm_post_suspend(int suspend_cancelled);

  void xen_mm_pin_all(void);
  void xen_mm_unpin_all(void);
@@ -14,4 +15,6 @@ void xen_mm_unpin_all(void);
  void xen_timer_resume(void);
  void xen_arch_resume(void);

+int xen_setup_shutdown_event(void);
+
  #endif /* INCLUDE_XEN_OPS_H */


