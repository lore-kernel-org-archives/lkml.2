Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab0HYAhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:37:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:54033 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab0HYAhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:37:31 -0400
Date: Wed, 25 Aug 2010 00:37:02 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <tip-*@git.kernel.org>
References: <tip-*@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/bios] x86, bios: By default, reserve the low 64K for all BIOSes
Message-ID: <tip-d0cd7425fab774a480cce17c2f649984312d0b55@git.kernel.org>
Git-Commit-ID: d0cd7425fab774a480cce17c2f649984312d0b55
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 Aug 2010 00:37:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d0cd7425fab774a480cce17c2f649984312d0b55
Gitweb:     http://git.kernel.org/tip/d0cd7425fab774a480cce17c2f649984312d0b55
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 24 Aug 2010 17:32:04 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 24 Aug 2010 17:32:04 -0700

x86, bios: By default, reserve the low 64K for all BIOSes

The laundry list of BIOSes that need the low 64K reserved is getting
very long, so make it the default across all BIOSes.  This also allows
the code to be simplified and unified with the reservation code for
the first 4K.

This resolves kernel bugzilla 16661 and who knows what else...

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <tip-*@git.kernel.org>
---
 arch/x86/Kconfig        |   47 +++++++++++++++----------
 arch/x86/kernel/setup.c |   84 ++++-------------------------------------------
 2 files changed, 35 insertions(+), 96 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..683ae8f 100644
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
+config X86_LOW_RESERVE
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
index c3a4fbb..eb87f1c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -618,88 +618,20 @@ static __init void reserve_ibft_region(void)
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
-
 static void __init trim_bios_range(void)
 {
 	/*
 	 * A special case is the first 4Kb of memory;
 	 * This is a BIOS owned area, not kernel ram, but generally
 	 * not listed as such in the E820 table.
+	 *
+	 * This typically reserves additional memory (64KiB by default)
+	 * since some BIOSes are known to corrupt low memory.  See the
+	 * Kconfig help text for X86_LOW_RESERVE.
 	 */
-	e820_update_range(0, PAGE_SIZE, E820_RAM, E820_RESERVED);
+	e820_update_range(0, ALIGN(CONFIG_X86_LOW_RESERVE << 10, PAGE_SIZE),
+			  E820_RAM, E820_RESERVED);
+
 	/*
 	 * special case: Some BIOSen report the PC BIOS
 	 * area (640->1Mb) as ram even though it is not.
@@ -863,8 +795,6 @@ void __init setup_arch(char **cmdline_p)
 
 	dmi_scan_machine();
 
-	dmi_check_system(bad_bios_dmi_table);
-
 	/*
 	 * VMware detection requires dmi to be available, so this
 	 * needs to be done after dmi_scan_machine, for the BP.
