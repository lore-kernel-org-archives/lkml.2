Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423419Ab2KNUnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 15:43:39 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:55263 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755287Ab2KNUne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 15:43:34 -0500
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86/Sandy Bridge: reserve pages when integrated graphics is present
Date: Wed, 14 Nov 2012 20:43:31 +0000
Message-Id: <1352925811-2598-1-git-send-email-jbarnes@virtuousgeek.org>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SNB graphics devices have a bug that prevent them from accessing certain
memory ranges, namely anything below 1M and in the pages listed in the
table.  So reserve those at boot if set detect a SNB gfx device on the
CPU to avoid GPU hangs.

Stephane Marchesin had a similar patch to the page allocator awhile
back, but rather than reserving pages up front, it leaked them at
allocation time.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/kernel/setup.c |   72 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 468e98d..bb9fabe 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -614,6 +614,75 @@ static __init void reserve_ibft_region(void)
 
 static unsigned reserve_low = CONFIG_X86_RESERVE_LOW << 10;
 
+static bool __init snb_gfx_workaround_needed(void)
+{
+	int i;
+	u16 vendor, devid;
+	u16 snb_ids[] = {
+		0x0102,
+		0x0112,
+		0x0122,
+		0x0106,
+		0x0116,
+		0x0126,
+		0x010a,
+	};
+
+	/* Assume no if something weird is going on with PCI */
+	if (!early_pci_allowed())
+		return false;
+
+	vendor = read_pci_config_16(0, 2, 0, PCI_VENDOR_ID);
+	if (vendor != 0x8086)
+		return false;
+
+	devid = read_pci_config_16(0, 2, 0, PCI_DEVICE_ID);
+	for (i = 0; i < ARRAY_SIZE(snb_ids); i++)
+		if (devid == snb_ids[i])
+			return true;
+
+	return false;
+}
+
+static void __init trim_snb_ranges(void)
+{
+ 	/*
+	 * Sandy Bridge graphics has trouble with certain ranges, exclude
+	 * them from allocation.
+	 */
+	if (snb_gfx_workaround_needed()) {
+		unsigned long bad_ranges[] = {
+			0x20050000,
+			0x20110000,
+			0x20130000,
+			0x20138000,
+			0x40004000,
+		};
+		phys_addr_t mem;
+		int i;
+
+		printk(KERN_DEBUG "reserving inaccessible SNB gfx pages\n");
+
+		for (;;) {
+			mem = memblock_find_in_range(0, 1<<20, PAGE_SIZE,
+						     PAGE_SIZE);
+			if (!mem)
+				break;
+			memblock_reserve(mem, PAGE_SIZE);
+			printk(KERN_DEBUG "reserved 0x%08lx\n", mem);
+		}
+
+		for (i = 0; i < ARRAY_SIZE(bad_ranges); i++) {
+			if (!memblock_reserve(bad_ranges[i], PAGE_SIZE))
+				printk(KERN_DEBUG "reserved 0x%08lx\n",
+				       bad_ranges[i]);
+			else
+				printk(KERN_DEBUG "failed to reserve 0x%08lx\n",
+				       bad_ranges[i]);
+		}
+	}
+}
+
 static void __init trim_bios_range(void)
 {
 	/*
@@ -634,6 +703,7 @@ static void __init trim_bios_range(void)
 	 * take them out.
 	 */
 	e820_remove_range(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RAM, 1);
+
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 }
 
@@ -912,6 +982,8 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_real_mode();
 
+	trim_snb_ranges();
+
 	init_gbpages();
 
 	/* max_pfn_mapped is updated here */
-- 
1.7.9.5

