Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1LLUks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:40:48 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:28950 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab1LLUkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:40:45 -0500
Message-ID: <4EE66672.4020904@oracle.com>
Date: Mon, 12 Dec 2011 12:39:14 -0800
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111101 SUSE/3.1.16 Thunderbird/3.1.16
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad@darnok.org>, Peter Jones <pjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v3] ibft: Fix finding IBFT ACPI table on UEFI
References: <4EE073BB.6080403@oracle.com> <20111208142958.GA4096@andromeda.dapyr.net> <4EE0EB51.5010900@oracle.com> <20111208190808.GA25433@andromeda.dapyr.net> <4EE12975.5090506@oracle.com> <20111212171740.GA26407@phenom.dumpdata.com>
In-Reply-To: <20111212171740.GA26407@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4EE66691.00C4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 09:17 AM, Konrad Rzeszutek Wilk wrote:

> On Thu, Dec 08, 2011 at 01:17:41PM -0800, Yinghai Lu wrote:
>>
>> Found one system with UEFI/iBFT, kernel does not detect the iBFT during
>> iscsi_ibft module loading.
>>
>> Root cause: on x86 (UEFI), we are calling of find_ibft_region() much earlier
>> 	- specifically in setup_arch() before ACPI is enabled.
> 
> 
> I get this when compiling with make allmodconfig:
> 
>  BUILD   arch/x86/boot/bzImage
> Setup is 16636 bytes (padded to 16896 bytes).
> System is 4680 kB
> CRC 88f70464
> Kernel: arch/x86/boot/bzImage is ready  (#2)
> ERROR: "acpi_table_parse" [drivers/firmware/iscsi_ibft.ko] undefined!
> make[3]: *** [__modpost] Error 1
> make[2]: *** [modules] Error 2
> 
> 
> on 64-bit Fedora Core 16.


oh, my bad!

Sorry for that.

please check this one....

[PATCH -v4] ibft: Fix finding IBFT ACPI table on UEFI

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

---
 drivers/firmware/iscsi_ibft.c      |   42 +++++++++++++++++++++++++++++++++++--
 drivers/firmware/iscsi_ibft_find.c |   26 +---------------------
 2 files changed, 42 insertions(+), 26 deletions(-)

Index: linux-2.6/drivers/firmware/iscsi_ibft.c
===================================================================
--- linux-2.6.orig/drivers/firmware/iscsi_ibft.c
+++ linux-2.6/drivers/firmware/iscsi_ibft.c
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
Index: linux-2.6/drivers/firmware/iscsi_ibft_find.c
===================================================================
--- linux-2.6.orig/drivers/firmware/iscsi_ibft_find.c
+++ linux-2.6/drivers/firmware/iscsi_ibft_find.c
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
