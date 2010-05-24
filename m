Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab0EXXE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:04:58 -0400
Received: from relay2.sgi.com ([192.48.179.30]:47195 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758020Ab0EXXE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:04:57 -0400
Message-ID: <4BFB0612.5020409@sgi.com>
Date: Mon, 24 May 2010 16:04:50 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
CC: Yinghai <yinghai.lu@oracle.com>, x86@kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Jack Steiner <steiner@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, jkosina@novell.com
Subject: [Patch 1/1] x86 efi: insert add_efi_memmap entries into both e820
 maps
References: <4BEAEF10.9040809@sgi.com> <4BEAF9B6.2040606@zytor.com> <4BEB0D5F.8070806@oracle.com> <4BEB1781.1080907@sgi.com> <4BEC6C94.2020100@sgi.com> <4BEC73B2.2020909@oracle.com> <4BEC7544.1080506@sgi.com> <4BEC8161.6050206@zytor.com>
In-Reply-To: <4BEC8161.6050206@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the e820_reserve_resources() function does not add entries
obtained via the "add_efi_memmap" kernel cmdline option.  This causes
/sys/firmware/memmap/... to be incomplete (stops after 128 entries).
Utilities that examine these entries then do not get the complete
picture of system memory.

This patch causes the add_efi_memmap function to add the memmap entries
to both the e820 map and the e820_saved map.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Jack Steiner <steiner@sgi.com>
---
 arch/x86/include/asm/e820.h |    1 +
 arch/x86/kernel/e820-xen.c  |    5 +++++
 arch/x86/kernel/e820.c      |   11 ++++++++---
 arch/x86/kernel/efi.c       |    3 +++
 4 files changed, 17 insertions(+), 3 deletions(-)

--- linux-2.6.32.orig/arch/x86/include/asm/e820.h
+++ linux-2.6.32/arch/x86/include/asm/e820.h
@@ -70,6 +70,7 @@ extern unsigned long pci_mem_start;
 extern int e820_any_mapped(u64 start, u64 end, unsigned type);
 extern int e820_all_mapped(u64 start, u64 end, unsigned type);
 extern void e820_add_region(u64 start, u64 size, int type);
+extern void e820_saved_add_region(u64 start, u64 size, int type);
 extern void e820_print_map(char *who);
 extern int
 sanitize_e820_map(struct e820entry *biosmap, int max_nr_map, u32 *pnr_map);
--- linux-2.6.32.orig/arch/x86/kernel/e820-xen.c
+++ linux-2.6.32/arch/x86/kernel/e820-xen.c
@@ -150,6 +150,11 @@ void __init e820_add_region(u64 start, u
 	__e820_add_region(&e820, start, size, type);
 }
 
+void __init e820_saved_add_region(u64 start, u64 size, int type)
+{
+	__e820_add_region(&e820_saved, start, size, type);
+}
+
 static void __init e820_print_type(u32 type)
 {
 	switch (type) {
--- linux-2.6.32.orig/arch/x86/kernel/e820.c
+++ linux-2.6.32/arch/x86/kernel/e820.c
@@ -33,9 +33,9 @@
  * and that is also registered with modifications in the kernel resource tree
  * with the iomem_resource as parent.
  *
- * The e820_saved is directly saved after the BIOS-provided memory map is
- * copied. It doesn't get modified afterwards. It's registered for the
- * /sys/firmware/memmap interface.
+ * The e820_saved is saved after the BIOS-provided memory map is copied as
+ * well as the optional add_efi_memmap entries are processed.  It doesn't get
+ * modified afterwards. It's registered for the /sys/firmware/memmap interface.
  *
  * That memory map is not modified and is used as base for kexec. The kexec'd
  * kernel should get the same memory map as the firmware provides. Then the
@@ -132,6 +132,11 @@ void __init e820_add_region(u64 start, u
 	__e820_add_region(&e820, start, size, type);
 }
 
+void __init e820_saved_add_region(u64 start, u64 size, int type)
+{
+	__e820_add_region(&e820_saved, start, size, type);
+}
+
 static void __init e820_print_type(u32 type)
 {
 	switch (type) {
--- linux-2.6.32.orig/arch/x86/kernel/efi.c
+++ linux-2.6.32/arch/x86/kernel/efi.c
@@ -271,8 +271,11 @@ static void __init do_add_efi_memmap(voi
 			break;
 		}
 		e820_add_region(start, size, e820_type);
+		e820_saved_add_region(start, size, e820_type);
 	}
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map(e820_saved.map, ARRAY_SIZE(e820_saved.map),
+							&e820_saved.nr_map);
 }
 
 void __init efi_reserve_early(void)

