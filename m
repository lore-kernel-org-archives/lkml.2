Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab1LHQyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 11:54:01 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:27183 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab1LHQx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 11:53:59 -0500
Message-ID: <4EE0EB51.5010900@oracle.com>
Date: Thu, 08 Dec 2011 08:52:33 -0800
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111101 SUSE/3.1.16 Thunderbird/3.1.16
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@darnok.org>, Peter Jones <pjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -v2] ibft: Fix finding IBFT ACPI table on UEFI
References: <4EE073BB.6080403@oracle.com> <20111208142958.GA4096@andromeda.dapyr.net>
In-Reply-To: <20111208142958.GA4096@andromeda.dapyr.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4EE0EB71.0078,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Found one system with UEFI/iBFT, Kernel does not detect the iBFT during
iscsi_ibft module loading.

the root cause: for x86, We have calling of find_ibft_region() much early.
in setup_arch() before ACPI is enabled.

Try to call find_ibft_region() second time in ibft_init().

At that time ACPI iBFT already get permanent mapped with ioremap.
So isa_virt_to_bus will get wrong phys from right virt address.
We could just skip that phys address printing.

For legacy one, print the found address early.

-v2: update comments and description according to Konrad.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/firmware/iscsi_ibft.c      |   14 ++++++++++++--
 drivers/firmware/iscsi_ibft_find.c |    1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/firmware/iscsi_ibft.c
===================================================================
--- linux-2.6.orig/drivers/firmware/iscsi_ibft.c
+++ linux-2.6/drivers/firmware/iscsi_ibft.c
@@ -753,9 +753,19 @@ static int __init ibft_init(void)
 {
 	int rc = 0;
 
+	/*
+	   Retry as on UEFI systems the setup_arch()/find_ibft_region()
+	   is called before ACPI tables are parsed so we never
+	   get the data.
+	*/
+	if (!ibft_addr) {
+		unsigned long size = 0;
+
+		find_ibft_region(&size);
+	}
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
@@ -94,6 +94,7 @@ static int __init find_ibft_in_mem(void)
 				 * the table cannot be valid. */
 				if (pos + len <= (IBFT_END-1)) {
 					ibft_addr = (struct acpi_table_ibft *)virt;
+					pr_info("iBFT found at 0x%lx.\n", pos);
 					goto done;
 				}
 			}
