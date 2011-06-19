Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab1FSDej (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 23:34:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57403 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab1FSDeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 23:34:37 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=3rvgeqzMqd0A:10 a=bnYJitQnDroA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=yQdBAQUQAAAA:8 a=VwQbUJbxAAAA:8 a=ppCmxOWCxf9IY5qlpcIA:9 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=LI9Vle30uBYA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Sat, 18 Jun 2011 22:34:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH] staging: r8192e_pci: Handle duplicate PCI ID
 0x10ec:0x8192 conflict with rtl8192se
Message-ID: <4dfd6e4a.gI5divq0rG5Vpxbz%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two devices with PCI ID 0x10ec:0x8192, namely RTL8192E and
RTL8192SE. The method of distinguishing them is by the revision ID
at offset 0x8 of the PCI configuration space. If the value is 0x10,
then the device uses rtl8192se for a driver.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org>
---

Greg,

This patch should be applied to kernel 3.0 to prevent problems if both
rtl8192se and r8192e_pci are configured. There is a similar patch to
rtl8192se that is submitted to John Linville's tree. As r8192e_pci
is in older kernels, this patch should also be applied to stable.

Larry
---

Index: wireless-testing-new/drivers/staging/rtl8192e/r8192E_core.c
===================================================================
--- wireless-testing-new.orig/drivers/staging/rtl8192e/r8192E_core.c
+++ wireless-testing-new/drivers/staging/rtl8192e/r8192E_core.c
@@ -4532,6 +4532,7 @@ static int __devinit rtl8192_pci_probe(s
 	u8 unit = 0;
 	int ret = -ENODEV;
 	unsigned long pmem_start, pmem_len, pmem_flags;
+	u8 revisionid;
 
 	RT_TRACE(COMP_INIT,"Configuring chip resources\n");
 
@@ -4592,6 +4593,11 @@ static int __devinit rtl8192_pci_probe(s
          pci_write_config_byte(pdev, 0x41, 0x00);
 
 
+	pci_read_config_byte(pdev, 0x08, &revisionid);
+	/* If the revisionid is 0x10, the device uses rtl8192se. */
+	if (pdev->device == 0x8192 && revisionid == 0x10)
+		goto fail1;
+
 	pci_read_config_byte(pdev, 0x05, &unit);
 	pci_write_config_byte(pdev, 0x05, unit & (~0x04));
 
