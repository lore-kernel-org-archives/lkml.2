Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab1LHIXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 03:23:13 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:57687 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1LHIXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 03:23:12 -0500
Message-ID: <4EE073BB.6080403@oracle.com>
Date: Thu, 08 Dec 2011 00:22:19 -0800
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111101 SUSE/3.1.16 Thunderbird/3.1.16
MIME-Version: 1.0
To: Peter Jones <pjones@redhat.com>, Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ibft: Fix finding ibft with ACPI tables
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090204.4EE073E7.0038,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found one system with UEFI/iBFT is not detected.

the root cause: for x86, We move calling of find_ibft_region() much earlier.
in setup_arch() before ACPI is enabled.

Try to all find_ibft_region() second times in ibft_init()

at that time ACPI iBFT already get permanent mapped with ioremap.
So isa_virt_to_bus will get wrong phys from right virt address.
We could just skip that printing.
For legacy one, print the found address early.

Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>

---
 drivers/firmware/iscsi_ibft.c      |   18 +++++++++++++++---
 drivers/firmware/iscsi_ibft_find.c |    1 +
 2 files changed, 16 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/firmware/iscsi_ibft.c
===================================================================
--- linux-2.6.orig/drivers/firmware/iscsi_ibft.c
+++ linux-2.6/drivers/firmware/iscsi_ibft.c
@@ -753,9 +753,21 @@ static int __init ibft_init(void)
 {
 	int rc = 0;
 
+	/* find that from acpi tables */
+	if (!ibft_addr) {
+		unsigned long size = 0;
+
+		find_ibft_region(&size);
+		barrier();
+	}
+
 	if (ibft_addr) {
-		printk(KERN_INFO "iBFT detected at 0x%llx.\n",
-		       (u64)isa_virt_to_bus(ibft_addr));
+		/*
+		 * Second try is from acpi permanent map with ioremap
+		 *  can not simply convert back to phys addr.
+		 *  and We don't need to print that table phys addr.
+		 */
+		pr_info("iBFT detected.\n");
 
 		rc = ibft_check_device();
 		if (rc)
@@ -770,7 +782,7 @@ static int __init ibft_init(void)
 		if (rc)
 			goto out_free;
 	} else
-		printk(KERN_INFO "No iBFT detected.\n");
+		pr_info("No iBFT detected.\n");
 
 	return 0;
 
Index: linux-2.6/drivers/firmware/iscsi_ibft_find.c
===================================================================
--- linux-2.6.orig/drivers/firmware/iscsi_ibft_find.c
+++ linux-2.6/drivers/firmware/iscsi_ibft_find.c
@@ -94,6 +94,7 @@ static int __init find_ibft_in_mem(void)
 				 * the table cannot be valid. */
 				if (pos + len <= (IBFT_END-1)) {
 					ibft_addr = (struct acpi_table_ibft *)virt;
+					pr_info("iBFT found at 0x%lx.\n", pos);
 					goto done;
 				}
 			}
