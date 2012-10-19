Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab2JSVOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 17:14:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34524 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab2JSVOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 17:14:52 -0400
Date: Fri, 19 Oct 2012 14:12:26 -0700
Message-Id: <201210192112.q9JLCQZl027964@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for 3.7-rc2
Cc: Alan Cox <alan@linux.intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        David Hooper <dave@beermex.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Shai Fultheim <shai@scalemp.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        stable@vger.kernel.org.#.3.6
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 19 Oct 2012 14:12:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Miscellaneous x86 fixes for 3.7-rc2.

The biggest ones are fixing suspend/resume breakage on 32 bits, and an
interrim fix for mapping over holes that allows AMD kit with more than
1 TB.  A final solution for the latter is in the works, but involves
some fairly invasive changes that will probably mean it will only be
appropriate for 3.8.

The following changes since commit c9623de4fc2f8320fe94316b46171683be3b1d59:

  Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2012-10-18 16:10:42 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/urgent

Borislav Petkov (1):
      x86, MCE: Remove bios_cmci_threshold sysfs attribute

Dan Carpenter (1):
      x86/cache_info: Use ARRAY_SIZE() in amd_l3_attrs()

Daniel J Blueman (1):
      x86, amd, mce: Avoid NULL pointer reference on CPU northbridge lookup

David Hooper (1):
      x86/reboot: Remove quirk entry for SBC FITPC

H. Peter Anvin (2):
      x86, suspend: Correct the restore of CR4, EFER; skip computing EFLAGS.ID
      Merge commit '5bc66170dc486556a1e36fd384463536573f4b82' into x86/urgent

Jacob Shin (1):
      x86: Exclude E820_RESERVED regions and memory holes above 4 GB from direct mapping.

 arch/x86/kernel/cpu/intel_cacheinfo.c |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c      |    6 ------
 arch/x86/kernel/cpu/mcheck/mce_amd.c  |   10 +++++-----
 arch/x86/kernel/reboot.c              |    8 --------
 arch/x86/kernel/setup.c               |   17 +++++++++++++++--
 arch/x86/realmode/rm/wakeup_asm.S     |   15 +++------------
 6 files changed, 24 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 9a7c90d..93c5451 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -991,7 +991,7 @@ static struct attribute ** __cpuinit amd_l3_attrs(void)
 	if (attrs)
 		return attrs;
 
-	n = sizeof (default_attrs) / sizeof (struct attribute *);
+	n = ARRAY_SIZE(default_attrs);
 
 	if (amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
 		n += 2;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 29e87d3..46cbf86 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2209,11 +2209,6 @@ static struct dev_ext_attribute dev_attr_cmci_disabled = {
 	&mce_cmci_disabled
 };
 
-static struct dev_ext_attribute dev_attr_bios_cmci_threshold = {
-	__ATTR(bios_cmci_threshold, 0444, device_show_int, NULL),
-	&mce_bios_cmci_threshold
-};
-
 static struct device_attribute *mce_device_attrs[] = {
 	&dev_attr_tolerant.attr,
 	&dev_attr_check_interval.attr,
@@ -2222,7 +2217,6 @@ static struct device_attribute *mce_device_attrs[] = {
 	&dev_attr_dont_log_ce.attr,
 	&dev_attr_ignore_ce.attr,
 	&dev_attr_cmci_disabled.attr,
-	&dev_attr_bios_cmci_threshold.attr,
 	NULL
 };
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index c4e916d..698b6ec 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -576,12 +576,10 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 	int err = 0;
 
 	if (shared_bank[bank]) {
-
 		nb = node_to_amd_nb(amd_get_nb_id(cpu));
-		WARN_ON(!nb);
 
 		/* threshold descriptor already initialized on this node? */
-		if (nb->bank4) {
+		if (nb && nb->bank4) {
 			/* yes, use it */
 			b = nb->bank4;
 			err = kobject_add(b->kobj, &dev->kobj, name);
@@ -615,8 +613,10 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		atomic_set(&b->cpus, 1);
 
 		/* nb is already initialized, see above */
-		WARN_ON(nb->bank4);
-		nb->bank4 = b;
+		if (nb) {
+			WARN_ON(nb->bank4);
+			nb->bank4 = b;
+		}
 	}
 
 	err = allocate_threshold_blocks(cpu, bank, 0,
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 52190a9..4e8ba39 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -358,14 +358,6 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-Z540N"),
 		},
 	},
-	{	/* Handle problems with rebooting on CompuLab SBC-FITPC2 */
-		.callback = set_bios_reboot,
-		.ident = "CompuLab SBC-FITPC2",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "CompuLab"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "SBC-FITPC2"),
-		},
-	},
 	{	/* Handle problems with rebooting on ASUS P4S800 */
 		.callback = set_bios_reboot,
 		.ident = "ASUS P4S800",
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a2bb18e..468e98d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -920,8 +920,21 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_X86_64
 	if (max_pfn > max_low_pfn) {
-		max_pfn_mapped = init_memory_mapping(1UL<<32,
-						     max_pfn<<PAGE_SHIFT);
+		int i;
+		for (i = 0; i < e820.nr_map; i++) {
+			struct e820entry *ei = &e820.map[i];
+
+			if (ei->addr + ei->size <= 1UL << 32)
+				continue;
+
+			if (ei->type == E820_RESERVED)
+				continue;
+
+			max_pfn_mapped = init_memory_mapping(
+				ei->addr < 1UL << 32 ? 1UL << 32 : ei->addr,
+				ei->addr + ei->size);
+		}
+
 		/* can we preseve max_low_pfn ?*/
 		max_low_pfn = max_pfn;
 	}
diff --git a/arch/x86/realmode/rm/wakeup_asm.S b/arch/x86/realmode/rm/wakeup_asm.S
index e56479e..9e7e147 100644
--- a/arch/x86/realmode/rm/wakeup_asm.S
+++ b/arch/x86/realmode/rm/wakeup_asm.S
@@ -74,18 +74,9 @@ ENTRY(wakeup_start)
 
 	lidtl	wakeup_idt
 
-	/* Clear the EFLAGS but remember if we have EFLAGS.ID */
-	movl $X86_EFLAGS_ID, %ecx
-	pushl %ecx
-	popfl
-	pushfl
-	popl %edi
+	/* Clear the EFLAGS */
 	pushl $0
 	popfl
-	pushfl
-	popl %edx
-	xorl %edx, %edi
-	andl %ecx, %edi		/* %edi is zero iff CPUID & %cr4 are missing */
 
 	/* Check header signature... */
 	movl	signature, %eax
@@ -120,12 +111,12 @@ ENTRY(wakeup_start)
 	movl	%eax, %cr3
 
 	btl	$WAKEUP_BEHAVIOR_RESTORE_CR4, %edi
-	jz	1f
+	jnc	1f
 	movl	pmode_cr4, %eax
 	movl	%eax, %cr4
 1:
 	btl	$WAKEUP_BEHAVIOR_RESTORE_EFER, %edi
-	jz	1f
+	jnc	1f
 	movl	pmode_efer, %eax
 	movl	pmode_efer + 4, %edx
 	movl	$MSR_EFER, %ecx
