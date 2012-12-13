Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945Ab2LMFBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 00:01:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33030 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab2LMFBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 00:01:31 -0500
Date: Thu, 13 Dec 2012 00:01:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/for-linus-3.8-rc0-tag
Message-ID: <20121213050100.GA19728@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Linus,

Please git pull the following tag:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stabl=
e/for-linus-3.8-rc0-tag

or branch (this is included in this email b/c I keep on getting:
"fatal: Couldn't find remote ref stable/for-linus-3.8-rc0-tag"
even though I _know_ that the tag is there?! I can see it on the
website and when I do git fetch/clone). Anyhow if you get the same
message, please git pull the branch:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stabl=
e/for-linus-3.8

which has <copied from the signed tag>
Features:
 - Add necessary infrastructure to make balloon driver work under ARM.
 - Add /dev/xen/privcmd interfaces to work with ARM and PVH.
 - Improve Xen PCIBack wild-card parsing.
 - Add Xen ACPI PAD (Processor Aggregator) support - so can offline/online
   sockets depending on the power consumption.
 - PVHVM + kexec =3D use an E820_RESV region for the shared region so we do=
n't
   overwrite said region during kexec reboot.
 - Cleanups, compile fixes.
<end of copy>

This merge will result in conflicts - there were some ARM patches in
v3.7-rcX that this branch does not contain. The recipe is that the
balloon drivers (drivers/xen/balloon.c) can now compile under ARM, so
the temporary functions added in arch/arm/xen/enlighten.c. can be
ripped out (so these functions are axed: alloc_xenballooned_pages and
free_xenballooned_pages). Consequently the drivers/xen/Makefile
can now have the balloon.o on the generic build target.

To illustrate this I've created a branch called 'for-linus-3.8.resolved'
(http://git.kernel.org/?p=3Dlinux/kernel/git/konrad/xen.git;a=3Dcommitdiff;=
h=3D32423604549179b47d4d31c880c5fc45b0903543)
and also included as a big diff in this email.

Please pull!

 arch/arm/include/asm/xen/interface.h |    1 +
 arch/arm/xen/enlighten.c             |  123 +++++++++++++++++++----
 arch/x86/include/asm/xen/interface.h |    1 +
 arch/x86/xen/Kconfig                 |    1 +
 arch/x86/xen/enlighten.c             |  102 ++++++++++++++-----
 arch/x86/xen/mmu.c                   |   17 +++-
 arch/x86/xen/suspend.c               |    2 +-
 arch/x86/xen/xen-ops.h               |    2 +-
 drivers/xen/Kconfig                  |    3 +
 drivers/xen/Makefile                 |    7 +-
 drivers/xen/balloon.c                |    5 +-
 drivers/xen/privcmd.c                |   72 +++++++++++++-
 drivers/xen/xen-acpi-pad.c           |  182 ++++++++++++++++++++++++++++++=
++++
 drivers/xen/xen-pciback/pci_stub.c   |  118 ++++++++++++----------
 drivers/xen/xenbus/xenbus_xs.c       |    1 -
 include/xen/interface/memory.h       |   44 ++++++++-
 include/xen/interface/platform.h     |   17 +++
 include/xen/xen-ops.h                |    9 ++-
 18 files changed, 591 insertions(+), 116 deletions(-)

Ian Campbell (5):
      xen: add pages parameter to xen_remap_domain_mfn_range
      xen: balloon: allow PVMMU interfaces to be compiled out
      xen: arm: enable balloon driver
      xen: correctly use xen_pfn_t in remap_domain_mfn_range.
      xen: arm: implement remap interfaces needed for privcmd mappings.

Jan Beulich (2):
      xen-pciback: simplify and tighten parsing of device IDs
      xen-pciback: reject out of range inputs

Konrad Rzeszutek Wilk (2):
      xen/acpi: Fix compile error by missing decleration for xen_domain.
      xen/acpi: Move the xen_running_on_version_or_later function.

Liu, Jinsong (2):
      xen/acpi: ACPI PAD driver
      xen/acpi: revert pad config check in xen_check_mwait

Mukesh Rathor (1):
      xen: privcmd: support autotranslated physmap guests.

Olaf Hering (2):
      xen PVonHVM: use E820_Reserved area for shared_info
      xen/PVonHVM: fix compile warning in init_hvm_pv_info

Sachin Kamat (1):
      xen/xenbus: Remove duplicate inclusion of asm/xen/hypervisor.h

diff --git a/arch/arm/include/asm/xen/interface.h b/arch/arm/include/asm/xe=
n/interface.h
index 5000397..1151188 100644
--- a/arch/arm/include/asm/xen/interface.h
+++ b/arch/arm/include/asm/xen/interface.h
@@ -49,6 +49,7 @@ DEFINE_GUEST_HANDLE(void);
 DEFINE_GUEST_HANDLE(uint64_t);
 DEFINE_GUEST_HANDLE(uint32_t);
 DEFINE_GUEST_HANDLE(xen_pfn_t);
+DEFINE_GUEST_HANDLE(xen_ulong_t);
=20
 /* Maximum number of virtual CPUs in multi-processor guests. */
 #define MAX_VIRT_CPUS 1
diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index f576092..7a32976 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -8,6 +8,8 @@
 #include <xen/features.h>
 #include <xen/platform_pci.h>
 #include <xen/xenbus.h>
+#include <xen/page.h>
+#include <xen/xen-ops.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 #include <linux/interrupt.h>
@@ -17,6 +19,8 @@
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
=20
+#include <linux/mm.h>
+
 struct start_info _xen_start_info;
 struct start_info *xen_start_info =3D &_xen_start_info;
 EXPORT_SYMBOL_GPL(xen_start_info);
@@ -29,6 +33,10 @@ struct shared_info *HYPERVISOR_shared_info =3D (void *)&=
xen_dummy_shared_info;
=20
 DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
=20
+/* These are unused until we support booting "pre-ballooned" */
+unsigned long xen_released_pages;
+struct xen_memory_region xen_extra_mem[XEN_EXTRA_MEM_MAX_REGIONS] __initda=
ta;
+
 /* TODO: to be removed */
 __read_mostly int xen_have_vector_callback;
 EXPORT_SYMBOL_GPL(xen_have_vector_callback);
@@ -38,15 +46,106 @@ EXPORT_SYMBOL_GPL(xen_platform_pci_unplug);
=20
 static __read_mostly int xen_events_irq =3D -1;
=20
+/* map fgmfn of domid to lpfn in the current domain */
+static int map_foreign_page(unsigned long lpfn, unsigned long fgmfn,
+			    unsigned int domid)
+{
+	int rc;
+	struct xen_add_to_physmap_range xatp =3D {
+		.domid =3D DOMID_SELF,
+		.foreign_domid =3D domid,
+		.size =3D 1,
+		.space =3D XENMAPSPACE_gmfn_foreign,
+	};
+	xen_ulong_t idx =3D fgmfn;
+	xen_pfn_t gpfn =3D lpfn;
+
+	set_xen_guest_handle(xatp.idxs, &idx);
+	set_xen_guest_handle(xatp.gpfns, &gpfn);
+
+	rc =3D HYPERVISOR_memory_op(XENMEM_add_to_physmap_range, &xatp);
+	if (rc) {
+		pr_warn("Failed to map pfn to mfn rc:%d pfn:%lx mfn:%lx\n",
+			rc, lpfn, fgmfn);
+		return 1;
+	}
+	return 0;
+}
+
+struct remap_data {
+	xen_pfn_t fgmfn; /* foreign domain's gmfn */
+	pgprot_t prot;
+	domid_t  domid;
+	struct vm_area_struct *vma;
+	int index;
+	struct page **pages;
+	struct xen_remap_mfn_info *info;
+};
+
+static int remap_pte_fn(pte_t *ptep, pgtable_t token, unsigned long addr,
+			void *data)
+{
+	struct remap_data *info =3D data;
+	struct page *page =3D info->pages[info->index++];
+	unsigned long pfn =3D page_to_pfn(page);
+	pte_t pte =3D pfn_pte(pfn, info->prot);
+
+	if (map_foreign_page(pfn, info->fgmfn, info->domid))
+		return -EFAULT;
+	set_pte_at(info->vma->vm_mm, addr, ptep, pte);
+
+	return 0;
+}
+
 int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 			       unsigned long addr,
-			       unsigned long mfn, int nr,
-			       pgprot_t prot, unsigned domid)
+			       xen_pfn_t mfn, int nr,
+			       pgprot_t prot, unsigned domid,
+			       struct page **pages)
 {
-	return -ENOSYS;
+	int err;
+	struct remap_data data;
+
+	/* TBD: Batching, current sole caller only does page at a time */
+	if (nr > 1)
+		return -EINVAL;
+
+	data.fgmfn =3D mfn;
+	data.prot =3D prot;
+	data.domid =3D domid;
+	data.vma =3D vma;
+	data.index =3D 0;
+	data.pages =3D pages;
+	err =3D apply_to_page_range(vma->vm_mm, addr, nr << PAGE_SHIFT,
+				  remap_pte_fn, &data);
+	return err;
 }
 EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
=20
+int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
+			       int nr, struct page **pages)
+{
+	int i;
+
+	for (i =3D 0; i < nr; i++) {
+		struct xen_remove_from_physmap xrp;
+		unsigned long rc, pfn;
+
+		pfn =3D page_to_pfn(pages[i]);
+
+		xrp.domid =3D DOMID_SELF;
+		xrp.gpfn =3D pfn;
+		rc =3D HYPERVISOR_memory_op(XENMEM_remove_from_physmap, &xrp);
+		if (rc) {
+			pr_warn("Failed to unmap pfn:%lx rc:%ld\n",
+				pfn, rc);
+			return rc;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
+
 /*
  * see Documentation/devicetree/bindings/arm/xen.txt for the
  * documentation of the Xen Device Tree format.
@@ -149,24 +248,6 @@ static int __init xen_init_events(void)
 }
 postcore_initcall(xen_init_events);
=20
-/* XXX: only until balloon is properly working */
-int alloc_xenballooned_pages(int nr_pages, struct page **pages, bool highm=
em)
-{
-	*pages =3D alloc_pages(highmem ? GFP_HIGHUSER : GFP_KERNEL,
-			get_order(nr_pages));
-	if (*pages =3D=3D NULL)
-		return -ENOMEM;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(alloc_xenballooned_pages);
-
-void free_xenballooned_pages(int nr_pages, struct page **pages)
-{
-	kfree(*pages);
-	*pages =3D NULL;
-}
-EXPORT_SYMBOL_GPL(free_xenballooned_pages);
-
 /* In the hypervisor.S file. */
 EXPORT_SYMBOL_GPL(HYPERVISOR_event_channel_op);
 EXPORT_SYMBOL_GPL(HYPERVISOR_grant_table_op);
diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xe=
n/interface.h
index 54d52ff..fd9cb76 100644
--- a/arch/x86/include/asm/xen/interface.h
+++ b/arch/x86/include/asm/xen/interface.h
@@ -63,6 +63,7 @@ DEFINE_GUEST_HANDLE(void);
 DEFINE_GUEST_HANDLE(uint64_t);
 DEFINE_GUEST_HANDLE(uint32_t);
 DEFINE_GUEST_HANDLE(xen_pfn_t);
+DEFINE_GUEST_HANDLE(xen_ulong_t);
 #endif
=20
 #ifndef HYPERVISOR_VIRT_START
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 9a6775c..131dacd 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -6,6 +6,7 @@ config XEN
 	bool "Xen guest support"
 	select PARAVIRT
 	select PARAVIRT_CLOCK
+	select XEN_HAVE_PVMMU
 	depends on X86_64 || (X86_32 && X86_PAE && !X86_VISWS)
 	depends on X86_TSC
 	help
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 586d838..3aeaa93 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -223,6 +223,21 @@ static void __init xen_banner(void)
 	       version >> 16, version & 0xffff, extra.extraversion,
 	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-AD)" =
: "");
 }
+/* Check if running on Xen version (major, minor) or later */
+bool
+xen_running_on_version_or_later(unsigned int major, unsigned int minor)
+{
+	unsigned int version;
+
+	if (!xen_domain())
+		return false;
+
+	version =3D HYPERVISOR_xen_version(XENVER_version, NULL);
+	if ((((version >> 16) =3D=3D major) && ((version & 0xffff) >=3D minor)) ||
+		((version >> 16) > major))
+		return true;
+	return false;
+}
=20
 #define CPUID_THERM_POWER_LEAF 6
 #define APERFMPERF_PRESENT 0
@@ -287,8 +302,7 @@ static void xen_cpuid(unsigned int *ax, unsigned int *b=
x,
=20
 static bool __init xen_check_mwait(void)
 {
-#if defined(CONFIG_ACPI) && !defined(CONFIG_ACPI_PROCESSOR_AGGREGATOR) && \
-	!defined(CONFIG_ACPI_PROCESSOR_AGGREGATOR_MODULE)
+#ifdef CONFIG_ACPI
 	struct xen_platform_op op =3D {
 		.cmd			=3D XENPF_set_processor_pminfo,
 		.u.set_pminfo.id	=3D -1,
@@ -309,6 +323,13 @@ static bool __init xen_check_mwait(void)
 	if (!xen_initial_domain())
 		return false;
=20
+	/*
+	 * When running under platform earlier than Xen4.2, do not expose
+	 * mwait, to avoid the risk of loading native acpi pad driver
+	 */
+	if (!xen_running_on_version_or_later(4, 2))
+		return false;
+
 	ax =3D 1;
 	cx =3D 0;
=20
@@ -1495,51 +1516,72 @@ asmlinkage void __init xen_start_kernel(void)
 #endif
 }
=20
-void __ref xen_hvm_init_shared_info(void)
+#ifdef CONFIG_XEN_PVHVM
+#define HVM_SHARED_INFO_ADDR 0xFE700000UL
+static struct shared_info *xen_hvm_shared_info;
+static unsigned long xen_hvm_sip_phys;
+static int xen_major, xen_minor;
+
+static void xen_hvm_connect_shared_info(unsigned long pfn)
 {
-	int cpu;
 	struct xen_add_to_physmap xatp;
-	static struct shared_info *shared_info_page =3D 0;
=20
-	if (!shared_info_page)
-		shared_info_page =3D (struct shared_info *)
-			extend_brk(PAGE_SIZE, PAGE_SIZE);
 	xatp.domid =3D DOMID_SELF;
 	xatp.idx =3D 0;
 	xatp.space =3D XENMAPSPACE_shared_info;
-	xatp.gpfn =3D __pa(shared_info_page) >> PAGE_SHIFT;
+	xatp.gpfn =3D pfn;
 	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
 		BUG();
=20
-	HYPERVISOR_shared_info =3D (struct shared_info *)shared_info_page;
+}
+static void __init xen_hvm_set_shared_info(struct shared_info *sip)
+{
+	int cpu;
+
+	HYPERVISOR_shared_info =3D sip;
=20
 	/* xen_vcpu is a pointer to the vcpu_info struct in the shared_info
 	 * page, we use it in the event channel upcall and in some pvclock
 	 * related functions. We don't need the vcpu_info placement
 	 * optimizations because we don't use any pv_mmu or pv_irq op on
-	 * HVM.
-	 * When xen_hvm_init_shared_info is run at boot time only vcpu 0 is
-	 * online but xen_hvm_init_shared_info is run at resume time too and
-	 * in that case multiple vcpus might be online. */
-	for_each_online_cpu(cpu) {
+	 * HVM. */
+	for_each_online_cpu(cpu)
 		per_cpu(xen_vcpu, cpu) =3D &HYPERVISOR_shared_info->vcpu_info[cpu];
+}
+
+/* Reconnect the shared_info pfn to a (new) mfn */
+void xen_hvm_resume_shared_info(void)
+{
+	xen_hvm_connect_shared_info(xen_hvm_sip_phys >> PAGE_SHIFT);
+}
+
+/* Xen tools prior to Xen 4 do not provide a E820_Reserved area for guest =
usage.
+ * On these old tools the shared info page will be placed in E820_Ram.
+ * Xen 4 provides a E820_Reserved area at 0xFC000000, and this code expects
+ * that nothing is mapped up to HVM_SHARED_INFO_ADDR.
+ * Xen 4.3+ provides an explicit 1MB area at HVM_SHARED_INFO_ADDR which is=
 used
+ * here for the shared info page. */
+static void __init xen_hvm_init_shared_info(void)
+{
+	if (xen_major < 4) {
+		xen_hvm_shared_info =3D extend_brk(PAGE_SIZE, PAGE_SIZE);
+		xen_hvm_sip_phys =3D __pa(xen_hvm_shared_info);
+	} else {
+		xen_hvm_sip_phys =3D HVM_SHARED_INFO_ADDR;
+		set_fixmap(FIX_PARAVIRT_BOOTMAP, xen_hvm_sip_phys);
+		xen_hvm_shared_info =3D
+		(struct shared_info *)fix_to_virt(FIX_PARAVIRT_BOOTMAP);
 	}
+	xen_hvm_connect_shared_info(xen_hvm_sip_phys >> PAGE_SHIFT);
+	xen_hvm_set_shared_info(xen_hvm_shared_info);
 }
=20
-#ifdef CONFIG_XEN_PVHVM
 static void __init init_hvm_pv_info(void)
 {
-	int major, minor;
-	uint32_t eax, ebx, ecx, edx, pages, msr, base;
+	uint32_t ecx, edx, pages, msr, base;
 	u64 pfn;
=20
 	base =3D xen_cpuid_base();
-	cpuid(base + 1, &eax, &ebx, &ecx, &edx);
-
-	major =3D eax >> 16;
-	minor =3D eax & 0xffff;
-	printk(KERN_INFO "Xen version %d.%d.\n", major, minor);
-
 	cpuid(base + 2, &pages, &msr, &ecx, &edx);
=20
 	pfn =3D __pa(hypercall_page);
@@ -1590,12 +1632,22 @@ static void __init xen_hvm_guest_init(void)
=20
 static bool __init xen_hvm_platform(void)
 {
+	uint32_t eax, ebx, ecx, edx, base;
+
 	if (xen_pv_domain())
 		return false;
=20
-	if (!xen_cpuid_base())
+	base =3D xen_cpuid_base();
+	if (!base)
 		return false;
=20
+	cpuid(base + 1, &eax, &ebx, &ecx, &edx);
+
+	xen_major =3D eax >> 16;
+	xen_minor =3D eax & 0xffff;
+
+	printk(KERN_INFO "Xen version %d.%d.\n", xen_major, xen_minor);
+
 	return true;
 }
=20
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index dcf5f2d..01de35c 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2497,8 +2497,10 @@ static int remap_area_mfn_pte_fn(pte_t *ptep, pgtabl=
e_t token,
=20
 int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 			       unsigned long addr,
-			       unsigned long mfn, int nr,
-			       pgprot_t prot, unsigned domid)
+			       xen_pfn_t mfn, int nr,
+			       pgprot_t prot, unsigned domid,
+			       struct page **pages)
+
 {
 	struct remap_data rmd;
 	struct mmu_update mmu_update[REMAP_BATCH_SIZE];
@@ -2542,3 +2544,14 @@ out:
 	return err;
 }
 EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
+
+/* Returns: 0 success */
+int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
+			       int numpgs, struct page **pages)
+{
+	if (!pages || !xen_feature(XENFEAT_auto_translated_physmap))
+		return 0;
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index 45329c8..ae8a00c 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -30,7 +30,7 @@ void xen_arch_hvm_post_suspend(int suspend_cancelled)
 {
 #ifdef CONFIG_XEN_PVHVM
 	int cpu;
-	xen_hvm_init_shared_info();
+	xen_hvm_resume_shared_info();
 	xen_callback_vector();
 	xen_unplug_emulated_devices();
 	if (xen_feature(XENFEAT_hvm_safe_pvclock)) {
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index a95b417..d2e73d1 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -40,7 +40,7 @@ void xen_enable_syscall(void);
 void xen_vcpu_restore(void);
=20
 void xen_callback_vector(void);
-void xen_hvm_init_shared_info(void);
+void xen_hvm_resume_shared_info(void);
 void xen_unplug_emulated_devices(void);
=20
 void __init xen_build_dynamic_phys_to_machine(void);
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 126d8ce..cabfa97 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -206,4 +206,7 @@ config XEN_MCE_LOG
 	  Allow kernel fetching MCE error from Xen platform and
 	  converting it into Linux mcelog format for mcelog tools
=20
+config XEN_HAVE_PVMMU
+       bool
+
 endmenu
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 7435470..fb213cf 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,9 +1,9 @@
 ifneq ($(CONFIG_ARM),y)
-obj-y	+=3D manage.o balloon.o
+obj-y	+=3D manage.o
 obj-$(CONFIG_HOTPLUG_CPU)		+=3D cpu_hotplug.o
 endif
 obj-$(CONFIG_X86)			+=3D fallback.o
-obj-y	+=3D grant-table.o features.o events.o
+obj-y	+=3D grant-table.o features.o events.o balloon.o
 obj-y	+=3D xenbus/
=20
 nostackp :=3D $(call cc-option, -fno-stack-protector)
@@ -11,7 +11,8 @@ CFLAGS_features.o			:=3D $(nostackp)
=20
 dom0-$(CONFIG_PCI) +=3D pci.o
 dom0-$(CONFIG_USB_SUPPORT) +=3D dbgp.o
-dom0-$(CONFIG_ACPI) +=3D acpi.o
+dom0-$(CONFIG_ACPI) +=3D acpi.o $(xen-pad-y)
+xen-pad-$(CONFIG_X86) +=3D xen-acpi-pad.o
 dom0-$(CONFIG_X86) +=3D pcpu.o
 obj-$(CONFIG_XEN_DOM0)			+=3D $(dom0-y)
 obj-$(CONFIG_BLOCK)			+=3D biomerge.o
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index d6886d9..a56776d 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -359,6 +359,7 @@ static enum bp_state increase_reservation(unsigned long=
 nr_pages)
=20
 		set_phys_to_machine(pfn, frame_list[i]);
=20
+#ifdef CONFIG_XEN_HAVE_PVMMU
 		/* Link back into the page tables if not highmem. */
 		if (xen_pv_domain() && !PageHighMem(page)) {
 			int ret;
@@ -368,6 +369,7 @@ static enum bp_state increase_reservation(unsigned long=
 nr_pages)
 				0);
 			BUG_ON(ret);
 		}
+#endif
=20
 		/* Relinquish the page back to the allocator. */
 		ClearPageReserved(page);
@@ -416,13 +418,14 @@ static enum bp_state decrease_reservation(unsigned lo=
ng nr_pages, gfp_t gfp)
=20
 		scrub_page(page);
=20
+#ifdef CONFIG_XEN_HAVE_PVMMU
 		if (xen_pv_domain() && !PageHighMem(page)) {
 			ret =3D HYPERVISOR_update_va_mapping(
 				(unsigned long)__va(pfn << PAGE_SHIFT),
 				__pte_ma(0), 0);
 			BUG_ON(ret);
 		}
-
+#endif
 	}
=20
 	/* Ensure that ballooned highmem pages don't have kmaps. */
diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 71f5c45..0bbbccb 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -33,11 +33,14 @@
 #include <xen/features.h>
 #include <xen/page.h>
 #include <xen/xen-ops.h>
+#include <xen/balloon.h>
=20
 #include "privcmd.h"
=20
 MODULE_LICENSE("GPL");
=20
+#define PRIV_VMA_LOCKED ((void *)1)
+
 #ifndef HAVE_ARCH_PRIVCMD_MMAP
 static int privcmd_enforce_singleshot_mapping(struct vm_area_struct *vma);
 #endif
@@ -178,7 +181,7 @@ static int mmap_mfn_range(void *data, void *state)
 					msg->va & PAGE_MASK,
 					msg->mfn, msg->npages,
 					vma->vm_page_prot,
-					st->domain);
+					st->domain, NULL);
 	if (rc < 0)
 		return rc;
=20
@@ -199,6 +202,10 @@ static long privcmd_ioctl_mmap(void __user *udata)
 	if (!xen_initial_domain())
 		return -EPERM;
=20
+	/* We only support privcmd_ioctl_mmap_batch for auto translated. */
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return -ENOSYS;
+
 	if (copy_from_user(&mmapcmd, udata, sizeof(mmapcmd)))
 		return -EFAULT;
=20
@@ -246,6 +253,7 @@ struct mmap_batch_state {
 	domid_t domain;
 	unsigned long va;
 	struct vm_area_struct *vma;
+	int index;
 	/* A tristate:
 	 *      0 for no errors
 	 *      1 if at least one error has happened (and no
@@ -260,14 +268,24 @@ struct mmap_batch_state {
 	xen_pfn_t __user *user_mfn;
 };
=20
+/* auto translated dom0 note: if domU being created is PV, then mfn is
+ * mfn(addr on bus). If it's auto xlated, then mfn is pfn (input to HAP).
+ */
 static int mmap_batch_fn(void *data, void *state)
 {
 	xen_pfn_t *mfnp =3D data;
 	struct mmap_batch_state *st =3D state;
+	struct vm_area_struct *vma =3D st->vma;
+	struct page **pages =3D vma->vm_private_data;
+	struct page *cur_page =3D NULL;
 	int ret;
=20
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		cur_page =3D pages[st->index++];
+
 	ret =3D xen_remap_domain_mfn_range(st->vma, st->va & PAGE_MASK, *mfnp, 1,
-					 st->vma->vm_page_prot, st->domain);
+					 st->vma->vm_page_prot, st->domain,
+					 &cur_page);
=20
 	/* Store error code for second pass. */
 	*(st->err++) =3D ret;
@@ -303,6 +321,32 @@ static int mmap_return_errors_v1(void *data, void *sta=
te)
 	return __put_user(*mfnp, st->user_mfn++);
 }
=20
+/* Allocate pfns that are then mapped with gmfns from foreign domid. Update
+ * the vma with the page info to use later.
+ * Returns: 0 if success, otherwise -errno
+ */
+static int alloc_empty_pages(struct vm_area_struct *vma, int numpgs)
+{
+	int rc;
+	struct page **pages;
+
+	pages =3D kcalloc(numpgs, sizeof(pages[0]), GFP_KERNEL);
+	if (pages =3D=3D NULL)
+		return -ENOMEM;
+
+	rc =3D alloc_xenballooned_pages(numpgs, pages, 0);
+	if (rc !=3D 0) {
+		pr_warn("%s Could not alloc %d pfns rc:%d\n", __func__,
+			numpgs, rc);
+		kfree(pages);
+		return -ENOMEM;
+	}
+	BUG_ON(vma->vm_private_data !=3D PRIV_VMA_LOCKED);
+	vma->vm_private_data =3D pages;
+
+	return 0;
+}
+
 static struct vm_operations_struct privcmd_vm_ops;
=20
 static long privcmd_ioctl_mmap_batch(void __user *udata, int version)
@@ -370,10 +414,18 @@ static long privcmd_ioctl_mmap_batch(void __user *uda=
ta, int version)
 		ret =3D -EINVAL;
 		goto out;
 	}
+	if (xen_feature(XENFEAT_auto_translated_physmap)) {
+		ret =3D alloc_empty_pages(vma, m.num);
+		if (ret < 0) {
+			up_write(&mm->mmap_sem);
+			goto out;
+		}
+	}
=20
 	state.domain        =3D m.dom;
 	state.vma           =3D vma;
 	state.va            =3D m.addr;
+	state.index         =3D 0;
 	state.global_error  =3D 0;
 	state.err           =3D err_array;
=20
@@ -442,6 +494,19 @@ static long privcmd_ioctl(struct file *file,
 	return ret;
 }
=20
+static void privcmd_close(struct vm_area_struct *vma)
+{
+	struct page **pages =3D vma->vm_private_data;
+	int numpgs =3D (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+
+	if (!xen_feature(XENFEAT_auto_translated_physmap || !numpgs || !pages))
+		return;
+
+	xen_unmap_domain_mfn_range(vma, numpgs, pages);
+	free_xenballooned_pages(numpgs, pages);
+	kfree(pages);
+}
+
 static int privcmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	printk(KERN_DEBUG "privcmd_fault: vma=3D%p %lx-%lx, pgoff=3D%lx, uv=3D%p\=
n",
@@ -452,6 +517,7 @@ static int privcmd_fault(struct vm_area_struct *vma, st=
ruct vm_fault *vmf)
 }
=20
 static struct vm_operations_struct privcmd_vm_ops =3D {
+	.close =3D privcmd_close,
 	.fault =3D privcmd_fault
 };
=20
@@ -469,7 +535,7 @@ static int privcmd_mmap(struct file *file, struct vm_ar=
ea_struct *vma)
=20
 static int privcmd_enforce_singleshot_mapping(struct vm_area_struct *vma)
 {
-	return (xchg(&vma->vm_private_data, (void *)1) =3D=3D NULL);
+	return !cmpxchg(&vma->vm_private_data, NULL, PRIV_VMA_LOCKED);
 }
=20
 const struct file_operations xen_privcmd_fops =3D {
diff --git a/drivers/xen/xen-acpi-pad.c b/drivers/xen/xen-acpi-pad.c
new file mode 100644
index 0000000..da39191
--- /dev/null
+++ b/drivers/xen/xen-acpi-pad.c
@@ -0,0 +1,182 @@
+/*
+ * xen-acpi-pad.c - Xen pad interface
+ *
+ * Copyright (c) 2012, Intel Corporation.
+ *    Author: Liu, Jinsong <jinsong.liu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License f=
or
+ * more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <acpi/acpi_bus.h>
+#include <acpi/acpi_drivers.h>
+#include <asm/xen/hypercall.h>
+#include <xen/interface/version.h>
+#include <xen/xen-ops.h>
+
+#define ACPI_PROCESSOR_AGGREGATOR_CLASS	"acpi_pad"
+#define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
+#define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
+static DEFINE_MUTEX(xen_cpu_lock);
+
+static int xen_acpi_pad_idle_cpus(unsigned int idle_nums)
+{
+	struct xen_platform_op op;
+
+	op.cmd =3D XENPF_core_parking;
+	op.u.core_parking.type =3D XEN_CORE_PARKING_SET;
+	op.u.core_parking.idle_nums =3D idle_nums;
+
+	return HYPERVISOR_dom0_op(&op);
+}
+
+static int xen_acpi_pad_idle_cpus_num(void)
+{
+	struct xen_platform_op op;
+
+	op.cmd =3D XENPF_core_parking;
+	op.u.core_parking.type =3D XEN_CORE_PARKING_GET;
+
+	return HYPERVISOR_dom0_op(&op)
+	       ?: op.u.core_parking.idle_nums;
+}
+
+/*
+ * Query firmware how many CPUs should be idle
+ * return -1 on failure
+ */
+static int acpi_pad_pur(acpi_handle handle)
+{
+	struct acpi_buffer buffer =3D {ACPI_ALLOCATE_BUFFER, NULL};
+	union acpi_object *package;
+	int num =3D -1;
+
+	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_PUR", NULL, &buffer)))
+		return num;
+
+	if (!buffer.length || !buffer.pointer)
+		return num;
+
+	package =3D buffer.pointer;
+
+	if (package->type =3D=3D ACPI_TYPE_PACKAGE &&
+		package->package.count =3D=3D 2 &&
+		package->package.elements[0].integer.value =3D=3D 1) /* rev 1 */
+		num =3D package->package.elements[1].integer.value;
+
+	kfree(buffer.pointer);
+	return num;
+}
+
+/* Notify firmware how many CPUs are idle */
+static void acpi_pad_ost(acpi_handle handle, int stat,
+	uint32_t idle_nums)
+{
+	union acpi_object params[3] =3D {
+		{.type =3D ACPI_TYPE_INTEGER,},
+		{.type =3D ACPI_TYPE_INTEGER,},
+		{.type =3D ACPI_TYPE_BUFFER,},
+	};
+	struct acpi_object_list arg_list =3D {3, params};
+
+	params[0].integer.value =3D ACPI_PROCESSOR_AGGREGATOR_NOTIFY;
+	params[1].integer.value =3D  stat;
+	params[2].buffer.length =3D 4;
+	params[2].buffer.pointer =3D (void *)&idle_nums;
+	acpi_evaluate_object(handle, "_OST", &arg_list, NULL);
+}
+
+static void acpi_pad_handle_notify(acpi_handle handle)
+{
+	int idle_nums;
+
+	mutex_lock(&xen_cpu_lock);
+	idle_nums =3D acpi_pad_pur(handle);
+	if (idle_nums < 0) {
+		mutex_unlock(&xen_cpu_lock);
+		return;
+	}
+
+	idle_nums =3D xen_acpi_pad_idle_cpus(idle_nums)
+		    ?: xen_acpi_pad_idle_cpus_num();
+	if (idle_nums >=3D 0)
+		acpi_pad_ost(handle, 0, idle_nums);
+	mutex_unlock(&xen_cpu_lock);
+}
+
+static void acpi_pad_notify(acpi_handle handle, u32 event,
+	void *data)
+{
+	switch (event) {
+	case ACPI_PROCESSOR_AGGREGATOR_NOTIFY:
+		acpi_pad_handle_notify(handle);
+		break;
+	default:
+		pr_warn("Unsupported event [0x%x]\n", event);
+		break;
+	}
+}
+
+static int acpi_pad_add(struct acpi_device *device)
+{
+	acpi_status status;
+
+	strcpy(acpi_device_name(device), ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME);
+	strcpy(acpi_device_class(device), ACPI_PROCESSOR_AGGREGATOR_CLASS);
+
+	status =3D acpi_install_notify_handler(device->handle,
+		ACPI_DEVICE_NOTIFY, acpi_pad_notify, device);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	return 0;
+}
+
+static int acpi_pad_remove(struct acpi_device *device,
+	int type)
+{
+	mutex_lock(&xen_cpu_lock);
+	xen_acpi_pad_idle_cpus(0);
+	mutex_unlock(&xen_cpu_lock);
+
+	acpi_remove_notify_handler(device->handle,
+		ACPI_DEVICE_NOTIFY, acpi_pad_notify);
+	return 0;
+}
+
+static const struct acpi_device_id pad_device_ids[] =3D {
+	{"ACPI000C", 0},
+	{"", 0},
+};
+
+static struct acpi_driver acpi_pad_driver =3D {
+	.name =3D "processor_aggregator",
+	.class =3D ACPI_PROCESSOR_AGGREGATOR_CLASS,
+	.ids =3D pad_device_ids,
+	.ops =3D {
+		.add =3D acpi_pad_add,
+		.remove =3D acpi_pad_remove,
+	},
+};
+
+static int __init xen_acpi_pad_init(void)
+{
+	/* Only DOM0 is responsible for Xen acpi pad */
+	if (!xen_initial_domain())
+		return -ENODEV;
+
+	/* Only Xen4.2 or later support Xen acpi pad */
+	if (!xen_running_on_version_or_later(4, 2))
+		return -ENODEV;
+
+	return acpi_bus_register_driver(&acpi_pad_driver);
+}
+subsys_initcall(xen_acpi_pad_init);
diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/p=
ci_stub.c
index 961d664..129e167 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -142,7 +142,8 @@ static struct pcistub_device *pcistub_device_find(int d=
omain, int bus,
 		if (psdev->dev !=3D NULL
 		    && domain =3D=3D pci_domain_nr(psdev->dev->bus)
 		    && bus =3D=3D psdev->dev->bus->number
-		    && PCI_DEVFN(slot, func) =3D=3D psdev->dev->devfn) {
+		    && slot =3D=3D PCI_SLOT(psdev->dev->devfn)
+		    && func =3D=3D PCI_FUNC(psdev->dev->devfn)) {
 			pcistub_device_get(psdev);
 			goto out;
 		}
@@ -191,7 +192,8 @@ struct pci_dev *pcistub_get_pci_dev_by_slot(struct xen_=
pcibk_device *pdev,
 		if (psdev->dev !=3D NULL
 		    && domain =3D=3D pci_domain_nr(psdev->dev->bus)
 		    && bus =3D=3D psdev->dev->bus->number
-		    && PCI_DEVFN(slot, func) =3D=3D psdev->dev->devfn) {
+		    && slot =3D=3D PCI_SLOT(psdev->dev->devfn)
+		    && func =3D=3D PCI_FUNC(psdev->dev->devfn)) {
 			found_dev =3D pcistub_device_get_pci_dev(pdev, psdev);
 			break;
 		}
@@ -897,42 +899,35 @@ static struct pci_driver xen_pcibk_pci_driver =3D {
 static inline int str_to_slot(const char *buf, int *domain, int *bus,
 			      int *slot, int *func)
 {
-	int err;
-	char wc =3D '*';
+	int parsed =3D 0;
=20
-	err =3D sscanf(buf, " %x:%x:%x.%x", domain, bus, slot, func);
-	switch (err) {
+	switch (sscanf(buf, " %x:%x:%x.%x %n", domain, bus, slot, func,
+		       &parsed)) {
 	case 3:
 		*func =3D -1;
-		err =3D sscanf(buf, " %x:%x:%x.%c", domain, bus, slot, &wc);
+		sscanf(buf, " %x:%x:%x.* %n", domain, bus, slot, &parsed);
 		break;
 	case 2:
 		*slot =3D *func =3D -1;
-		err =3D sscanf(buf, " %x:%x:*.%c", domain, bus, &wc);
-		if (err >=3D 2)
-			++err;
+		sscanf(buf, " %x:%x:*.* %n", domain, bus, &parsed);
 		break;
 	}
-	if (err =3D=3D 4 && wc =3D=3D '*')
+	if (parsed && !buf[parsed])
 		return 0;
-	else if (err < 0)
-		return -EINVAL;
=20
 	/* try again without domain */
 	*domain =3D 0;
-	wc =3D '*';
-	err =3D sscanf(buf, " %x:%x.%x", bus, slot, func);
-	switch (err) {
+	switch (sscanf(buf, " %x:%x.%x %n", bus, slot, func, &parsed)) {
 	case 2:
 		*func =3D -1;
-		err =3D sscanf(buf, " %x:%x.%c", bus, slot, &wc);
+		sscanf(buf, " %x:%x.* %n", bus, slot, &parsed);
 		break;
 	case 1:
 		*slot =3D *func =3D -1;
-		err =3D sscanf(buf, " %x:*.%c", bus, &wc) + 1;
+		sscanf(buf, " %x:*.* %n", bus, &parsed);
 		break;
 	}
-	if (err =3D=3D 3 && wc =3D=3D '*')
+	if (parsed && !buf[parsed])
 		return 0;
=20
 	return -EINVAL;
@@ -941,13 +936,20 @@ static inline int str_to_slot(const char *buf, int *d=
omain, int *bus,
 static inline int str_to_quirk(const char *buf, int *domain, int *bus, int
 			       *slot, int *func, int *reg, int *size, int *mask)
 {
-	int err;
+	int parsed =3D 0;
=20
-	err =3D
-	    sscanf(buf, " %04x:%02x:%02x.%d-%08x:%1x:%08x", domain, bus, slot,
-		   func, reg, size, mask);
-	if (err =3D=3D 7)
+	sscanf(buf, " %x:%x:%x.%x-%x:%x:%x %n", domain, bus, slot, func,
+	       reg, size, mask, &parsed);
+	if (parsed && !buf[parsed])
 		return 0;
+
+	/* try again without domain */
+	*domain =3D 0;
+	sscanf(buf, " %x:%x.%x-%x:%x:%x %n", bus, slot, func, reg, size,
+	       mask, &parsed);
+	if (parsed && !buf[parsed])
+		return 0;
+
 	return -EINVAL;
 }
=20
@@ -955,7 +957,7 @@ static int pcistub_device_id_add(int domain, int bus, i=
nt slot, int func)
 {
 	struct pcistub_device_id *pci_dev_id;
 	unsigned long flags;
-	int rc =3D 0;
+	int rc =3D 0, devfn =3D PCI_DEVFN(slot, func);
=20
 	if (slot < 0) {
 		for (slot =3D 0; !rc && slot < 32; ++slot)
@@ -969,13 +971,24 @@ static int pcistub_device_id_add(int domain, int bus,=
 int slot, int func)
 		return rc;
 	}
=20
+	if ((
+#if !defined(MODULE) /* pci_domains_supported is not being exported */ \
+    || !defined(CONFIG_PCI_DOMAINS)
+	     !pci_domains_supported ? domain :
+#endif
+	     domain < 0 || domain > 0xffff)
+	    || bus < 0 || bus > 0xff
+	    || PCI_SLOT(devfn) !=3D slot
+	    || PCI_FUNC(devfn) !=3D func)
+		return -EINVAL;
+
 	pci_dev_id =3D kmalloc(sizeof(*pci_dev_id), GFP_KERNEL);
 	if (!pci_dev_id)
 		return -ENOMEM;
=20
 	pci_dev_id->domain =3D domain;
 	pci_dev_id->bus =3D bus;
-	pci_dev_id->devfn =3D PCI_DEVFN(slot, func);
+	pci_dev_id->devfn =3D devfn;
=20
 	pr_debug(DRV_NAME ": wants to seize %04x:%02x:%02x.%d\n",
 		 domain, bus, slot, func);
@@ -1016,14 +1029,18 @@ static int pcistub_device_id_remove(int domain, int=
 bus, int slot, int func)
 	return err;
 }
=20
-static int pcistub_reg_add(int domain, int bus, int slot, int func, int re=
g,
-			   int size, int mask)
+static int pcistub_reg_add(int domain, int bus, int slot, int func,
+			   unsigned int reg, unsigned int size,
+			   unsigned int mask)
 {
 	int err =3D 0;
 	struct pcistub_device *psdev;
 	struct pci_dev *dev;
 	struct config_field *field;
=20
+	if (reg > 0xfff || (size < 4 && (mask >> (size * 8))))
+		return -EINVAL;
+
 	psdev =3D pcistub_device_find(domain, bus, slot, func);
 	if (!psdev) {
 		err =3D -ENODEV;
@@ -1254,13 +1271,11 @@ static ssize_t permissive_add(struct device_driver =
*drv, const char *buf,
 	int err;
 	struct pcistub_device *psdev;
 	struct xen_pcibk_dev_data *dev_data;
+
 	err =3D str_to_slot(buf, &domain, &bus, &slot, &func);
 	if (err)
 		goto out;
-	if (slot < 0 || func < 0) {
-		err =3D -EINVAL;
-		goto out;
-	}
+
 	psdev =3D pcistub_device_find(domain, bus, slot, func);
 	if (!psdev) {
 		err =3D -ENODEV;
@@ -1339,8 +1354,6 @@ static int __init pcistub_init(void)
=20
 	if (pci_devs_to_hide && *pci_devs_to_hide) {
 		do {
-			char wc =3D '*';
-
 			parsed =3D 0;
=20
 			err =3D sscanf(pci_devs_to_hide + pos,
@@ -1349,51 +1362,48 @@ static int __init pcistub_init(void)
 			switch (err) {
 			case 3:
 				func =3D -1;
-				err =3D sscanf(pci_devs_to_hide + pos,
-					     " (%x:%x:%x.%c) %n",
-					     &domain, &bus, &slot, &wc,
-					     &parsed);
+				sscanf(pci_devs_to_hide + pos,
+				       " (%x:%x:%x.*) %n",
+				       &domain, &bus, &slot, &parsed);
 				break;
 			case 2:
 				slot =3D func =3D -1;
-				err =3D sscanf(pci_devs_to_hide + pos,
-					     " (%x:%x:*.%c) %n",
-					     &domain, &bus, &wc, &parsed) + 1;
+				sscanf(pci_devs_to_hide + pos,
+				       " (%x:%x:*.*) %n",
+				       &domain, &bus, &parsed);
 				break;
 			}
=20
-			if (err !=3D 4 || wc !=3D '*') {
+			if (!parsed) {
 				domain =3D 0;
-				wc =3D '*';
 				err =3D sscanf(pci_devs_to_hide + pos,
 					     " (%x:%x.%x) %n",
 					     &bus, &slot, &func, &parsed);
 				switch (err) {
 				case 2:
 					func =3D -1;
-					err =3D sscanf(pci_devs_to_hide + pos,
-						     " (%x:%x.%c) %n",
-						     &bus, &slot, &wc,
-						     &parsed);
+					sscanf(pci_devs_to_hide + pos,
+					       " (%x:%x.*) %n",
+					       &bus, &slot, &parsed);
 					break;
 				case 1:
 					slot =3D func =3D -1;
-					err =3D sscanf(pci_devs_to_hide + pos,
-						     " (%x:*.%c) %n",
-						     &bus, &wc, &parsed) + 1;
+					sscanf(pci_devs_to_hide + pos,
+					       " (%x:*.*) %n",
+					       &bus, &parsed);
 					break;
 				}
-				if (err !=3D 3 || wc !=3D '*')
-					goto parse_error;
 			}
=20
+			if (parsed <=3D 0)
+				goto parse_error;
+
 			err =3D pcistub_device_id_add(domain, bus, slot, func);
 			if (err)
 				goto out;
=20
-			/* if parsed<=3D0, we've reached the end of the string */
 			pos +=3D parsed;
-		} while (parsed > 0 && pci_devs_to_hide[pos]);
+		} while (pci_devs_to_hide[pos]);
 	}
=20
 	/* If we're the first PCI Device Driver to register, we're the
diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index acedeab..88e677b 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -48,7 +48,6 @@
 #include <xen/xenbus.h>
 #include <xen/xen.h>
 #include "xenbus_comms.h"
-#include <asm/xen/hypervisor.h>
=20
 struct xs_stored_msg {
 	struct list_head list;
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index 90712e2..b40a431 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -153,6 +153,14 @@ struct xen_machphys_mapping {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xen_machphys_mapping_t);
=20
+#define XENMAPSPACE_shared_info  0 /* shared info page */
+#define XENMAPSPACE_grant_table  1 /* grant table page */
+#define XENMAPSPACE_gmfn         2 /* GMFN */
+#define XENMAPSPACE_gmfn_range   3 /* GMFN range, XENMEM_add_to_physmap on=
ly. */
+#define XENMAPSPACE_gmfn_foreign 4 /* GMFN from another dom,
+				    * XENMEM_add_to_physmap_range only.
+				    */
+
 /*
  * Sets the GPFN at which a particular page appears in the specified guest=
's
  * pseudophysical address space.
@@ -167,8 +175,6 @@ struct xen_add_to_physmap {
     uint16_t    size;
=20
     /* Source mapping space. */
-#define XENMAPSPACE_shared_info 0 /* shared info page */
-#define XENMAPSPACE_grant_table 1 /* grant table page */
     unsigned int space;
=20
     /* Index into source mapping space. */
@@ -182,6 +188,24 @@ DEFINE_GUEST_HANDLE_STRUCT(xen_add_to_physmap);
 /*** REMOVED ***/
 /*#define XENMEM_translate_gpfn_list  8*/
=20
+#define XENMEM_add_to_physmap_range 23
+struct xen_add_to_physmap_range {
+    /* Which domain to change the mapping for. */
+    domid_t domid;
+    uint16_t space; /* =3D> enum phys_map_space */
+
+    /* Number of pages to go through */
+    uint16_t size;
+    domid_t foreign_domid; /* IFF gmfn_foreign */
+
+    /* Indexes into space being mapped. */
+    GUEST_HANDLE(xen_ulong_t) idxs;
+
+    /* GPFN in domid where the source mapping page should appear. */
+    GUEST_HANDLE(xen_pfn_t) gpfns;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_add_to_physmap_range);
+
 /*
  * Returns the pseudo-physical memory map as it was when the domain
  * was started (specified by XENMEM_set_memory_map).
@@ -217,4 +241,20 @@ DEFINE_GUEST_HANDLE_STRUCT(xen_memory_map);
  * during a driver critical region.
  */
 extern spinlock_t xen_reservation_lock;
+
+/*
+ * Unmaps the page appearing at a particular GPFN from the specified guest=
's
+ * pseudophysical address space.
+ * arg =3D=3D addr of xen_remove_from_physmap_t.
+ */
+#define XENMEM_remove_from_physmap      15
+struct xen_remove_from_physmap {
+    /* Which domain to change the mapping for. */
+    domid_t domid;
+
+    /* GPFN of the current mapping of the page. */
+    xen_pfn_t gpfn;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_remove_from_physmap);
+
 #endif /* __XEN_PUBLIC_MEMORY_H__ */
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platf=
orm.h
index 4755b5f..5e36932 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -324,6 +324,22 @@ struct xenpf_cpu_ol {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_cpu_ol);
=20
+/*
+ * CMD 58 and 59 are reserved for cpu hotadd and memory hotadd,
+ * which are already occupied at Xen hypervisor side.
+ */
+#define XENPF_core_parking     60
+struct xenpf_core_parking {
+	/* IN variables */
+#define XEN_CORE_PARKING_SET   1
+#define XEN_CORE_PARKING_GET   2
+	uint32_t type;
+	/* IN variables:  set cpu nums expected to be idled */
+	/* OUT variables: get cpu nums actually be idled */
+	uint32_t idle_nums;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xenpf_core_parking);
+
 struct xen_platform_op {
 	uint32_t cmd;
 	uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
@@ -341,6 +357,7 @@ struct xen_platform_op {
 		struct xenpf_set_processor_pminfo set_pminfo;
 		struct xenpf_pcpuinfo          pcpu_info;
 		struct xenpf_cpu_ol            cpu_ol;
+		struct xenpf_core_parking      core_parking;
 		uint8_t                        pad[128];
 	} u;
 };
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 6a198e4..d6fe062 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -2,6 +2,7 @@
 #define INCLUDE_XEN_OPS_H
=20
 #include <linux/percpu.h>
+#include <asm/xen/interface.h>
=20
 DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
=20
@@ -26,7 +27,11 @@ void xen_destroy_contiguous_region(unsigned long vstart,=
 unsigned int order);
 struct vm_area_struct;
 int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 			       unsigned long addr,
-			       unsigned long mfn, int nr,
-			       pgprot_t prot, unsigned domid);
+			       xen_pfn_t mfn, int nr,
+			       pgprot_t prot, unsigned domid,
+			       struct page **pages);
+int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
+			       int numpgs, struct page **pages);
=20
+bool xen_running_on_version_or_later(unsigned int major, unsigned int mino=
r);
 #endif /* INCLUDE_XEN_OPS_H */

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQyWEdAAoJEFjIrFwIi8fJ+HkH/25ZfktNqy7iz0rrrG0qkyTt
g/zP9FQ0rGqszSNK29fJI+wEsKpRfm2h9j+wQ+AraxfD1fXILRrK0nU0TgnSGaaE
mUoy3TUCTTmrl/cn+SzLIzKv5VJNMEqBRt8EsIVD7Zg3wROeAEwgrysd1onjviu2
muCpbPZfHHSeq8DzBkrGY3M2sg/5/AZYSi0Nk4xjO4jdMXJLFRm4bdmMbf4KZKhN
SssoONqIt3hxvWW67qtfFfFNkF+Pmk6w+MfkwsbN6Jcg2WgDKBW2QPirfQn+VHrj
Z48TXE0jFoqIMQxcZJ+stjsorAsp3p3gSweiVU3KV7pZzUV6kAbI0sywjO/hb38=
=X7RC
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
