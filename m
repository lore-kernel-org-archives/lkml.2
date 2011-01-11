Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab1AKA4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 19:56:16 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:60313 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab1AKA4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 19:56:13 -0500
Message-ID: <4D2BAA7B.3030800@kernel.org>
Date: Mon, 10 Jan 2011 16:55:23 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <greg@kroah.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4]  x86: early_quirk check all dev/func in domain 0
References: <4D2A1382.7010407@kernel.org> <4D2AC6BF.3010907@kernel.org> <4D2BA8FE.9090204@kernel.org>
In-Reply-To: <4D2BA8FE.9090204@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


go with all buses instead of bus0.
also only check header type on func0.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/early-quirks.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

Index: linux-2.6/arch/x86/kernel/early-quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/early-quirks.c
+++ linux-2.6/arch/x86/kernel/early-quirks.c
@@ -243,7 +243,7 @@ static int __init check_dev_quirk(int nu
 	class = read_pci_config_16(num, slot, func, PCI_CLASS_DEVICE);
 
 	if (class == 0xffff)
-		return -1; /* no class, treat as single function */
+		return 0; /* no class, func gap */
 
 	vendor = read_pci_config_16(num, slot, func, PCI_VENDOR_ID);
 
@@ -263,27 +263,30 @@ static int __init check_dev_quirk(int nu
 			}
 	}
 
-	type = read_pci_config_byte(num, slot, func,
-				    PCI_HEADER_TYPE);
-	if (!(type & 0x80))
-		return -1;
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
