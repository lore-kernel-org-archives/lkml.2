Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab1BGWP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 17:15:28 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:44891 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab1BGWP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 17:15:27 -0500
Message-ID: <4D506EDC.2070609@kernel.org>
Date: Mon, 07 Feb 2011 14:14:52 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2] x86: early_quirk check all bus/dev/func in domain 0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D506EEB.00AC,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When we have 00:1a.0, 00:1a.1, 00:1a.2, 00:1a.7
Found only 00:1a.0, and 00:1a.1 get processed. and 00:1a.2 and 00:1a.7 get skipped.

We should only check header type on func0.
Also should not bail out when have gap.

At last try to process bus 00 - 0xff instead of only bus 00.

-v2: check with VENDOR_ID instead of CLASS_DEVICE for invalid device.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/early-quirks.c |   44 +++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

Index: linux-2.6/arch/x86/kernel/early-quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/early-quirks.c
+++ linux-2.6/arch/x86/kernel/early-quirks.c
@@ -234,20 +234,22 @@ static struct chipset early_qrk[] __init
  */
 static int __init check_dev_quirk(int num, int slot, int func)
 {
+	u32 l;
 	u16 class;
 	u16 vendor;
 	u16 device;
 	u8 type;
 	int i;
 
-	class = read_pci_config_16(num, slot, func, PCI_CLASS_DEVICE);
-
-	if (class == 0xffff)
-		return -1; /* no class, treat as single function */
-
-	vendor = read_pci_config_16(num, slot, func, PCI_VENDOR_ID);
+	l = read_pci_config(num, slot, func, PCI_VENDOR_ID);
+	/* some broken boards return 0 or ~0 if a slot is empty: */
+	if (l == 0xffffffff || l == 0x00000000 ||
+	    l == 0x0000ffff || l == 0xffff0000)
+		return 0;
 
-	device = read_pci_config_16(num, slot, func, PCI_DEVICE_ID);
+	class = read_pci_config_16(num, slot, func, PCI_CLASS_DEVICE);
+	vendor = l & 0xffff;
+	device = l >> 16;
 
 	for (i = 0; early_qrk[i].f != NULL; i++) {
 		if (((early_qrk[i].vendor == PCI_ANY_ID) ||
@@ -263,27 +265,31 @@ static int __init check_dev_quirk(int nu
 			}
 	}
 
-	type = read_pci_config_byte(num, slot, func,
-				    PCI_HEADER_TYPE);
-	if (!(type & 0x80))
-		return -1;
+	/* only check header type on func 0 */
+	if (func == 0) {
+		type = read_pci_config_byte(num, slot, func,
+					    PCI_HEADER_TYPE);
+		if (!(type & 0x80))
+			return -1;
+	}
 
 	return 0;
 }
 
 void __init early_quirks(void)
 {
-	int slot, func;
+	int num, slot, func;
 
 	if (!early_pci_allowed())
 		return;
 
 	/* Poor man's PCI discovery */
-	/* Only scan the root bus */
-	for (slot = 0; slot < 32; slot++)
-		for (func = 0; func < 8; func++) {
-			/* Only probe function 0 on single fn devices */
-			if (check_dev_quirk(0, slot, func))
-				break;
-		}
+	/* Only can scan first domain */
+	for (num = 0; num < 256; num++)
+		for (slot = 0; slot < 32; slot++)
+			for (func = 0; func < 8; func++) {
+				/* Only probe func 0 on single fn devices */
+				if (check_dev_quirk(num, slot, func))
+					break;
+			}
 }
