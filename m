Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab1BNWrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:47:24 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:17841 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1BNWrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:47:19 -0500
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: x86@kernel.org
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Message-Id: <20110214224423.2182.13929.sendpatchset@nchumbalkar.americas.hpqcorp.net>
Subject: [PATCH]: x86, dmi: log Board Name, only when present, in dmesg/oops output
Date: Mon, 14 Feb 2011 22:47:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "Type 2" SMBIOS record that contains Board Name is not *strictly
required* and may be absent in the SMBIOS on some platforms.

Please note that Type 2 is not listed in Table 3 in Sec 6.2 
("Required Structures and Data") of the SMBIOS v2.7 Specification.

Use the Manufacturer Name (aka System Vendor) name. Print Board Name
only when it is present.

Before the fix:
(i) dmesg output:
DMI: /ProLiant DL380 G6, BIOS P62 01/29/2011

(ii) oops output:
Pid: 2170, comm: bash Not tainted 2.6.38-rc4+ #3 /ProLiant DL380 G6


After the fix:
(i)dmesg output:
DMI: HP ProLiant DL380 G6, BIOS P62 01/29/2011

(ii) oops output string:
Pid: 2278, comm: bash Not tainted 2.6.38-rc4+ #4 HP ProLiant DL380 G6

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>

---
 arch/x86/kernel/process.c   |   22 ++++++++++++++++------
 drivers/firmware/dmi_scan.c |   11 +++++++++--
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e764fc0..e1ec724 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -92,21 +92,31 @@ void show_regs(struct pt_regs *regs)
 
 void show_regs_common(void)
 {
-	const char *board, *product;
+	const char *vendor, *product, *board;
 
-	board = dmi_get_system_info(DMI_BOARD_NAME);
-	if (!board)
-		board = "";
+	vendor = dmi_get_system_info(DMI_SYS_VENDOR);
+	if (!vendor)
+		vendor = "";
 	product = dmi_get_system_info(DMI_PRODUCT_NAME);
 	if (!product)
 		product = "";
 
+	/* Board Name is optional */
+	board = dmi_get_system_info(DMI_BOARD_NAME);
+
 	printk(KERN_CONT "\n");
-	printk(KERN_DEFAULT "Pid: %d, comm: %.20s %s %s %.*s %s/%s\n",
+	printk(KERN_DEFAULT "Pid: %d, comm: %.20s %s %s %.*s",
 		current->pid, current->comm, print_tainted(),
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version, board, product);
+		init_utsname()->version);
+	printk(KERN_CONT " ");
+	printk(KERN_CONT "%s %s", vendor, product);
+	if (board) {
+		printk(KERN_CONT "/");
+		printk(KERN_CONT "%s", board);
+	}
+	printk(KERN_CONT "\n");
 }
 
 void flush_thread(void)
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index e28e416..bcb1126 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -378,10 +378,17 @@ static void __init print_filtered(const char *info)
 
 static void __init dmi_dump_ids(void)
 {
+	const char *board;	/* Board Name is optional */
+
 	printk(KERN_DEBUG "DMI: ");
-	print_filtered(dmi_get_system_info(DMI_BOARD_NAME));
-	printk(KERN_CONT "/");
+	print_filtered(dmi_get_system_info(DMI_SYS_VENDOR));
+	printk(KERN_CONT " ");
 	print_filtered(dmi_get_system_info(DMI_PRODUCT_NAME));
+	board = dmi_get_system_info(DMI_BOARD_NAME);
+	if (board) {
+		printk(KERN_CONT "/");
+		print_filtered(board);
+	}
 	printk(KERN_CONT ", BIOS ");
 	print_filtered(dmi_get_system_info(DMI_BIOS_VERSION));
 	printk(KERN_CONT " ");
-- 
1.7.1.2

