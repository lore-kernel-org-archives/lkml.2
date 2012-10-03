Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810Ab2JCXxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:53:49 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:27452 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932904Ab2JCXxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:53:48 -0400
From: Randy Wright <rwright@filesys1.fc.hp.com>
Message-Id: <201210032353.q93NrkNi018443@filesys1.fc.hp.com>
Subject: [PATCH RFC] function probe_roms accessing improper addresses on UEFI systems
To: linux-kernel@vger.kernel.org
Date: Wed, 3 Oct 2012 17:53:46 -0600 (MDT)
Reply-To: rwright@hp.com
Organization: Hewlett-Packard/Mission Critical Open Source Development Lab
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in function probe_roms accesses the legacy adapter space (in
the physical address range 640k-1mb) without regard to how this range is
described in the memory map. The assumption in the code is that the
result of an access to unpopulated space is a soft fail, returning -1.
This assumption is not universally true; some systems may cause a hard
error (MCE) when accessing an unpopulated physical address.

The following proposed patch takes advantage of the fact that on EFI
systems, the memory map provides a better description of the physical
space than on pre-EFI legacy systems. If the efi_enabled state variable
indicates the kernel is running on an UEFI system, the patch will use
information from the UEFI memory map so as not to access addresses that
should avoided according to the UEFI specification.

See also a discussion underway in the context of a patch to devmem_is_allowed 
  https://lkml.org/lkml/2012/10/2/458
which has the same overall goal of restricting access to 
inappropriate ranges of the EFI memory map.

Following is my proposed patch based on v3.6. I would appreciate input
on the following points.  

1. Is the implementation properly interpreting the UEFI specification by
disallowing probes of addresses for which the type is EFI_RESERVED_TYPE,
EFI_UNUSABLE_MEMORY, or otherwise unknown?

2. The patch includes some simple test cases in function test_probes
that can be customized to the testing needs of a particular target
system.  This test code is conditionally enabled based on the
pre-processor symbol DO_TEST_PROBES; if that is not defined, the body of
function test_probes() is empty.  This code can be enabled and modified
as needed to test specific addresses of interest.  Is this code useful
to include in an upstream patch?  If not, is there a more generally
useful testing strategy?

Please CC me directly with comments or questions.

Signed-off-by: Randy Wright <rwright@hp.com>

---
 arch/x86/kernel/probe_roms.c |   71 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/arch/x86/kernel/probe_roms.c b/arch/x86/kernel/probe_roms.c
index d5f15c3..76c20c9 100644
--- a/arch/x86/kernel/probe_roms.c
+++ b/arch/x86/kernel/probe_roms.c
@@ -11,6 +11,7 @@
 #include <linux/pfn.h>
 #include <linux/pci.h>
 #include <linux/export.h>
+#include <linux/efi.h>		/* efi_enabled, efi_mem_type */
 
 #include <asm/probe_roms.h>
 #include <asm/pci-direct.h>
@@ -177,11 +178,46 @@ EXPORT_SYMBOL(pci_biosrom_size);
 
 #define ROMSIGNATURE 0xaa55
 
+/*
+ * efi_paddr_valid returns 1 if the input physical address
+ * is valid in the efi memory map, 0 otherwise.
+ */
+static int __init efi_paddr_valid(phys_addr_t paddr)
+{
+	u32 type = efi_mem_type((unsigned long)paddr);
+	printk(KERN_DEBUG "efi_paddr_valid(0x%lx): type 0x%lx\n",
+			(unsigned long)paddr, (unsigned long)type);
+	if (type == EFI_RESERVED_TYPE
+	||  type == EFI_UNUSABLE_MEMORY
+	||  type >= EFI_MAX_MEMORY_TYPE)
+		return 0;
+	return 1;
+}
+
+/*
+ * efi_vaddr_valid translates itsinput va to a pa, then
+ * returns the result of efi_paddr_valid applied to that pa.
+ */
+
+static int __init efi_vaddr_valid(const unsigned char *vaddr)
+{
+	phys_addr_t paddr = virt_to_phys((volatile void *)vaddr);
+	return efi_paddr_valid(paddr);
+}
+
 static int __init romsignature(const unsigned char *rom)
 {
 	const unsigned short * const ptr = (const unsigned short *)rom;
 	unsigned short sig;
 
+	if (efi_enabled) {
+		int rv = efi_vaddr_valid(rom);
+		printk(KERN_DEBUG
+			"romsignature: efi_vaddr_valid(0x%llx) returned %d\n",
+			 (unsigned long long)rom, rv);
+		if (0 == rv)
+			return 0;
+	}
 	return probe_kernel_address(ptr, sig) == 0 && sig == ROMSIGNATURE;
 }
 
@@ -194,6 +230,39 @@ static int __init romchecksum(const unsigned char *rom, unsigned long length)
 	return !length && !sum;
 }
 
+/* #define DO_TEST_PROBES "include customizable test code" */
+static void __init test_probes(void)
+{
+#ifdef	DO_TEST_PROBES
+	static struct {
+		phys_addr_t	paddr;
+		int		ptype;
+	} plist[] = {
+		{0x000000003e760000ULL,	0},	/* RESERVED		*/
+		{0x0000009ffda9f000ULL,	1},	/* LOADER CODE		*/
+		{0x000000000005e000ULL,	2},	/* LOADER DATA		*/
+		{0x0000000000060000ULL,	3},	/* BOOT CODE (why after EBS?) */
+		{0x0000000036400000ULL,	4},	/* BOOT DATA (why after EBS?) */
+		{0x0000009fffc96000ULL,	5},	/* RUNTIME CODE		*/
+		{0x0000009fffcd3000ULL,	6},	/* RUNTIME DATA		*/
+		{0x0000000000001000ULL,	7},	/* CONVENTIONAL MEM	*/
+		{0x000000003e75f000ULL,	9},	/* ACPI RECLAIM		*/
+		{0x000000000008c000ULL,	10},	/* ACPI NVS		*/
+		{0x0000000040000000ULL,	11},	/* MMIO			*/
+		{0,			-1}	/* terminate list	*/
+	};
+	int i, valid;
+	phys_addr_t paddr;
+	for (i = 0; plist[i].ptype >= 0; i++) {
+		paddr = plist[i].paddr;
+		valid = efi_paddr_valid(paddr);
+		printk(KERN_DEBUG
+		      "test_probes: efi_paddr_valid(0x%llx) returned %d\n",
+			(unsigned long long)plist[i].paddr, valid);
+	}
+#endif
+}
+
 void __init probe_roms(void)
 {
 	const unsigned char *rom;
@@ -201,6 +270,8 @@ void __init probe_roms(void)
 	unsigned char c;
 	int i;
 
+	test_probes();
+
 	/* video rom */
 	upper = adapter_rom_resources[0].start;
 	for (start = video_rom_resource.start; start < upper; start += 2048) {
-- 
1.7.9.5

