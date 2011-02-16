Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab1BPAdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:33:22 -0500
Received: from kroah.org ([198.145.64.141]:49740 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932298Ab1BPAYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:42 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:48 2011
Message-Id: <20110216001448.483257881@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [234/272] x86, dmi, debug: Log board name (when present) in dmesg/oops output
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>

commit 84e383b322e5348db03be54ff64cc6da87003717 upstream.

The "Type 2" SMBIOS record that contains Board Name is not
strictly required and may be absent in the SMBIOS on some
platforms.

( Please note that Type 2 is not listed in Table 3 in Sec 6.2
  ("Required Structures and Data") of the SMBIOS v2.7
  Specification. )

Use the Manufacturer Name (aka System Vendor) name.
Print Board Name only when it is present.

Before the fix:
  (i) dmesg output: DMI: /ProLiant DL380 G6, BIOS P62 01/29/2011
 (ii) oops output:  Pid: 2170, comm: bash Not tainted 2.6.38-rc4+ #3 /ProLiant DL380 G6

After the fix:
  (i) dmesg output: DMI: HP ProLiant DL380 G6, BIOS P62 01/29/2011
 (ii) oops output:  Pid: 2278, comm: bash Not tainted 2.6.38-rc4+ #4 HP ProLiant DL380 G6

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
LKML-Reference: <20110214224423.2182.13929.sendpatchset@nchumbalkar.americas.hpqcorp.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/process.c   |   22 ++++++++++++++++------
 drivers/firmware/dmi_scan.c |   11 +++++++++--
 2 files changed, 25 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -97,21 +97,31 @@ void show_regs(struct pt_regs *regs)
 
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
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -378,10 +378,17 @@ static void __init print_filtered(const
 
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


