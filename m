Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690Ab1LPTvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:51:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932597Ab1LPTuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:50:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:46:02 2011
Message-Id: <20111216194602.240951074@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [50/53] ibft: Fix finding IBFT ACPI table on UEFI
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai.lu@oracle.com>

commit 935a9fee51c945b8942be2d7b4bae069167b4886 upstream.

Found one system with UEFI/iBFT, kernel does not detect the iBFT during
iscsi_ibft module loading.

Root cause: on x86 (UEFI), we are calling of find_ibft_region() much earlier
- specifically in setup_arch() before ACPI is enabled.

Try to split acpi checking code out and call that later

At that time ACPI iBFT already get permanent mapped with ioremap.
So isa_virt_to_bus() will get wrong phys from right virt address.
We could just skip that phys address printing.

For legacy one, print the found address early.

-v2: update comments and description according to Konrad.
-v3: fix problem about module use case that is found by Konrad.
-v4: use acpi_get_table() instead of acpi_table_parse() to handle module use case that is found by Konrad again..
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firmware/iscsi_ibft.c      |   42 +++++++++++++++++++++++++++++++++++--
 drivers/firmware/iscsi_ibft_find.c |   26 +---------------------
 2 files changed, 42 insertions(+), 26 deletions(-)

--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -746,6 +746,37 @@ static void __exit ibft_exit(void)
 	ibft_cleanup();
 }
 
+#ifdef CONFIG_ACPI
+static const struct {
+	char *sign;
+} ibft_signs[] = {
+	/*
+	 * One spec says "IBFT", the other says "iBFT". We have to check
+	 * for both.
+	 */
+	{ ACPI_SIG_IBFT },
+	{ "iBFT" },
+};
+
+static void __init acpi_find_ibft_region(void)
+{
+	int i;
+	struct acpi_table_header *table = NULL;
+
+	if (acpi_disabled)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(ibft_signs) && !ibft_addr; i++) {
+		acpi_get_table(ibft_signs[i].sign, 0, &table);
+		ibft_addr = (struct acpi_table_ibft *)table;
+	}
+}
+#else
+static void __init acpi_find_ibft_region(void)
+{
+}
+#endif
+
 /*
  * ibft_init() - creates sysfs tree entries for the iBFT data.
  */
@@ -753,9 +784,16 @@ static int __init ibft_init(void)
 {
 	int rc = 0;
 
+	/*
+	   As on UEFI systems the setup_arch()/find_ibft_region()
+	   is called before ACPI tables are parsed and it only does
+	   legacy finding.
+	*/
+	if (!ibft_addr)
+		acpi_find_ibft_region();
+
 	if (ibft_addr) {
-		printk(KERN_INFO "iBFT detected at 0x%llx.\n",
-		       (u64)isa_virt_to_bus(ibft_addr));
+		pr_info("iBFT detected.\n");
 
 		rc = ibft_check_device();
 		if (rc)
--- a/drivers/firmware/iscsi_ibft_find.c
+++ b/drivers/firmware/iscsi_ibft_find.c
@@ -45,13 +45,6 @@ EXPORT_SYMBOL_GPL(ibft_addr);
 static const struct {
 	char *sign;
 } ibft_signs[] = {
-#ifdef CONFIG_ACPI
-	/*
-	 * One spec says "IBFT", the other says "iBFT". We have to check
-	 * for both.
-	 */
-	{ ACPI_SIG_IBFT },
-#endif
 	{ "iBFT" },
 	{ "BIFT" },	/* Broadcom iSCSI Offload */
 };
@@ -62,14 +55,6 @@ static const struct {
 #define VGA_MEM 0xA0000 /* VGA buffer */
 #define VGA_SIZE 0x20000 /* 128kB */
 
-#ifdef CONFIG_ACPI
-static int __init acpi_find_ibft(struct acpi_table_header *header)
-{
-	ibft_addr = (struct acpi_table_ibft *)header;
-	return 0;
-}
-#endif /* CONFIG_ACPI */
-
 static int __init find_ibft_in_mem(void)
 {
 	unsigned long pos;
@@ -94,6 +79,7 @@ static int __init find_ibft_in_mem(void)
 				 * the table cannot be valid. */
 				if (pos + len <= (IBFT_END-1)) {
 					ibft_addr = (struct acpi_table_ibft *)virt;
+					pr_info("iBFT found at 0x%lx.\n", pos);
 					goto done;
 				}
 			}
@@ -108,20 +94,12 @@ done:
  */
 unsigned long __init find_ibft_region(unsigned long *sizep)
 {
-#ifdef CONFIG_ACPI
-	int i;
-#endif
 	ibft_addr = NULL;
 
-#ifdef CONFIG_ACPI
-	for (i = 0; i < ARRAY_SIZE(ibft_signs) && !ibft_addr; i++)
-		acpi_table_parse(ibft_signs[i].sign, acpi_find_ibft);
-#endif /* CONFIG_ACPI */
-
 	/* iBFT 1.03 section 1.4.3.1 mandates that UEFI machines will
 	 * only use ACPI for this */
 
-	if (!ibft_addr && !efi_enabled)
+	if (!efi_enabled)
 		find_ibft_in_mem();
 
 	if (ibft_addr) {


