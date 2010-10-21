Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab0JUNXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:23:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58227 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757991Ab0JUNXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:23:48 -0400
Date: Thu, 21 Oct 2010 15:23:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/bios changes for v2.6.37
Message-ID: <20101021132339.GA3620@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-bios-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-bios-for-linus

 Thanks,

	Ingo

------------------>
H. Peter Anvin (2):
      x86, bios: By default, reserve the low 64K for all BIOSes
      x86, bios: Make the x86 early memory reservation a kernel option


 Documentation/kernel-parameters.txt |    5 ++
 arch/x86/Kconfig                    |   47 +++++++++------
 arch/x86/kernel/setup.c             |  106 ++++++++++-------------------------
 3 files changed, 63 insertions(+), 95 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 2c85c06..41ce93e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2150,6 +2150,11 @@ and is between 256 and 4096 characters. It is defined in the file
 			Reserves a hole at the top of the kernel virtual
 			address space.
 
+	reservelow=	[X86]
+			Format: nn[K]
+			Set the amount of memory to reserve for BIOS at
+			the bottom of the address space.
+
 	reset_devices	[KNL] Force drivers to reset the underlying device
 			during initialization.
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..d359000 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1326,25 +1326,34 @@ config X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK
 	  Set whether the default state of memory_corruption_check is
 	  on or off.
 
-config X86_RESERVE_LOW_64K
-	bool "Reserve low 64K of RAM on AMI/Phoenix BIOSen"
-	default y
-	---help---
-	  Reserve the first 64K of physical RAM on BIOSes that are known
-	  to potentially corrupt that memory range. A numbers of BIOSes are
-	  known to utilize this area during suspend/resume, so it must not
-	  be used by the kernel.
-
-	  Set this to N if you are absolutely sure that you trust the BIOS
-	  to get all its memory reservations and usages right.
-
-	  If you have doubts about the BIOS (e.g. suspend/resume does not
-	  work or there's kernel crashes after certain hardware hotplug
-	  events) and it's not AMI or Phoenix, then you might want to enable
-	  X86_CHECK_BIOS_CORRUPTION=y to allow the kernel to check typical
-	  corruption patterns.
-
-	  Say Y if unsure.
+config X86_RESERVE_LOW
+	int "Amount of low memory, in kilobytes, to reserve for the BIOS"
+	default 64
+	range 4 640
+	---help---
+	  Specify the amount of low memory to reserve for the BIOS.
+
+	  The first page contains BIOS data structures that the kernel
+	  must not use, so that page must always be reserved.
+
+	  By default we reserve the first 64K of physical RAM, as a
+	  number of BIOSes are known to corrupt that memory range
+	  during events such as suspend/resume or monitor cable
+	  insertion, so it must not be used by the kernel.
+
+	  You can set this to 4 if you are absolutely sure that you
+	  trust the BIOS to get all its memory reservations and usages
+	  right.  If you know your BIOS have problems beyond the
+	  default 64K area, you can set this to 640 to avoid using the
+	  entire low memory range.
+
+	  If you have doubts about the BIOS (e.g. suspend/resume does
+	  not work or there's kernel crashes after certain hardware
+	  hotplug events) then you might want to enable
+	  X86_CHECK_BIOS_CORRUPTION=y to allow the kernel to check
+	  typical corruption patterns.
+
+	  Leave this to the default value of 64 if you are unsure.
 
 config MATH_EMULATION
 	bool
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c3a4fbb..af277e3 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -618,79 +618,7 @@ static __init void reserve_ibft_region(void)
 		reserve_early_overlap_ok(addr, addr + size, "ibft");
 }
 
-#ifdef CONFIG_X86_RESERVE_LOW_64K
-static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
-{
-	printk(KERN_NOTICE
-		"%s detected: BIOS may corrupt low RAM, working around it.\n",
-		d->ident);
-
-	e820_update_range(0, 0x10000, E820_RAM, E820_RESERVED);
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
-
-	return 0;
-}
-#endif
-
-/* List of systems that have known low memory corruption BIOS problems */
-static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
-#ifdef CONFIG_X86_RESERVE_LOW_64K
-	{
-		.callback = dmi_low_memory_corruption,
-		.ident = "AMI BIOS",
-		.matches = {
-			DMI_MATCH(DMI_BIOS_VENDOR, "American Megatrends Inc."),
-		},
-	},
-	{
-		.callback = dmi_low_memory_corruption,
-		.ident = "Phoenix BIOS",
-		.matches = {
-			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies"),
-		},
-	},
-	{
-		.callback = dmi_low_memory_corruption,
-		.ident = "Phoenix/MSC BIOS",
-		.matches = {
-			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix/MSC"),
-		},
-	},
-	/*
-	 * AMI BIOS with low memory corruption was found on Intel DG45ID and
-	 * DG45FC boards.
-	 * It has a different DMI_BIOS_VENDOR = "Intel Corp.", for now we will
-	 * match only DMI_BOARD_NAME and see if there is more bad products
-	 * with this vendor.
-	 */
-	{
-		.callback = dmi_low_memory_corruption,
-		.ident = "AMI BIOS",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "DG45ID"),
-		},
-	},
-	{
-		.callback = dmi_low_memory_corruption,
-		.ident = "AMI BIOS",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "DG45FC"),
-		},
-	},
-	/*
-	 * The Dell Inspiron Mini 1012 has DMI_BIOS_VENDOR = "Dell Inc.", so
-	 * match on the product name.
-	 */
-	{
-		.callback = dmi_low_memory_corruption,
-		.ident = "Phoenix BIOS",
-		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1012"),
-		},
-	},
-#endif
-	{}
-};
+static unsigned reserve_low = CONFIG_X86_RESERVE_LOW << 10;
 
 static void __init trim_bios_range(void)
 {
@@ -698,8 +626,14 @@ static void __init trim_bios_range(void)
 	 * A special case is the first 4Kb of memory;
 	 * This is a BIOS owned area, not kernel ram, but generally
 	 * not listed as such in the E820 table.
+	 *
+	 * This typically reserves additional memory (64KiB by default)
+	 * since some BIOSes are known to corrupt low memory.  See the
+	 * Kconfig help text for X86_RESERVE_LOW.
 	 */
-	e820_update_range(0, PAGE_SIZE, E820_RAM, E820_RESERVED);
+	e820_update_range(0, ALIGN(reserve_low, PAGE_SIZE),
+			  E820_RAM, E820_RESERVED);
+
 	/*
 	 * special case: Some BIOSen report the PC BIOS
 	 * area (640->1Mb) as ram even though it is not.
@@ -709,6 +643,28 @@ static void __init trim_bios_range(void)
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 }
 
+static int __init parse_reservelow(char *p)
+{
+	unsigned long long size;
+
+	if (!p)
+		return -EINVAL;
+
+	size = memparse(p, &p);
+
+	if (size < 4096)
+		size = 4096;
+
+	if (size > 640*1024)
+		size = 640*1024;
+
+	reserve_low = size;
+
+	return 0;
+}
+
+early_param("reservelow", parse_reservelow);
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -863,8 +819,6 @@ void __init setup_arch(char **cmdline_p)
 
 	dmi_scan_machine();
 
-	dmi_check_system(bad_bios_dmi_table);
-
 	/*
 	 * VMware detection requires dmi to be available, so this
 	 * needs to be done after dmi_scan_machine, for the BP.
