Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab0LGSTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 13:19:09 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50447 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab0LGSTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 13:19:07 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 7 Dec 2010 19:18:55 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Robin Cook <rcook@wyrms.net>,
        Jonathan Isom <jeisom@gmail.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH 1/2] firewire: ohci: fix regression with Agere FW643 rev 06,
 disable MSI
Message-ID: <20101207191855.4aae8bf9@stein>
In-Reply-To: <20101207191602.50419f9e@stein>
References: <20101207191602.50419f9e@stein>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Agere FW643 rev 06, listed as "11c1:5901 (rev 06) (prog-if 10 [OHCI])",
produced SBP-2 I/O errors since kernel 2.6.36.  Disabling MSI fixes it.

Since MSI work on Agere FW643-E (same vendor and device ID, but rev 07),
introduce a device revision field into firewire-ohci's quirks list so
that different quirks can be defined for older and newer revisions.

Reported-by: Jonathan Isom <jeisom@gmail.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: <stable@kernel.org> # 2.6.36.y
---
Jonathan, can you confirm that this changed blacklist setup works for you?
You need to apply patch 1/2 first to get patch 2/2 to apply without editing.

 drivers/firewire/ohci.c |   49 ++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 15 deletions(-)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -242,6 +242,8 @@ static inline struct fw_ohci *fw_ohci(st
 
 static char ohci_driver_name[] = KBUILD_MODNAME;
 
+#define PCI_VENDOR_ID_AGERE		PCI_VENDOR_ID_ATT
+#define PCI_DEVICE_ID_FW643		0x5901
 #define PCI_DEVICE_ID_JMICRON_JMB38X_FW	0x2380
 #define PCI_DEVICE_ID_TI_TSB12LV22	0x8009
 
@@ -253,19 +255,34 @@ static char ohci_driver_name[] = KBUILD_
 
 /* In case of multiple matches in ohci_quirks[], only the first one is used. */
 static const struct {
-	unsigned short vendor, device, flags;
+	unsigned short vendor, device, revision, flags;
 } ohci_quirks[] = {
-	{PCI_VENDOR_ID_TI,	PCI_DEVICE_ID_TI_TSB12LV22, QUIRK_CYCLE_TIMER |
-							    QUIRK_RESET_PACKET |
-							    QUIRK_NO_1394A},
-	{PCI_VENDOR_ID_TI,	PCI_ANY_ID,	QUIRK_RESET_PACKET},
-	{PCI_VENDOR_ID_AL,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
-	{PCI_VENDOR_ID_JMICRON,	PCI_DEVICE_ID_JMICRON_JMB38X_FW, QUIRK_NO_MSI},
-	{PCI_VENDOR_ID_NEC,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
-	{PCI_VENDOR_ID_VIA,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER |
-						QUIRK_NO_MSI},
-	{PCI_VENDOR_ID_RICOH,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
-	{PCI_VENDOR_ID_APPLE,	PCI_DEVICE_ID_APPLE_UNI_N_FW, QUIRK_BE_HEADERS},
+	{PCI_VENDOR_ID_AGERE, PCI_DEVICE_ID_FW643, 6,
+		QUIRK_NO_MSI},
+
+	{PCI_VENDOR_ID_AL, PCI_ANY_ID, PCI_ANY_ID,
+		QUIRK_CYCLE_TIMER},
+
+	{PCI_VENDOR_ID_APPLE, PCI_DEVICE_ID_APPLE_UNI_N_FW, PCI_ANY_ID,
+		QUIRK_BE_HEADERS},
+
+	{PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB38X_FW, PCI_ANY_ID,
+		QUIRK_NO_MSI},
+
+	{PCI_VENDOR_ID_NEC, PCI_ANY_ID, PCI_ANY_ID,
+		QUIRK_CYCLE_TIMER},
+
+	{PCI_VENDOR_ID_RICOH, PCI_ANY_ID, PCI_ANY_ID,
+		QUIRK_CYCLE_TIMER},
+
+	{PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_TSB12LV22, PCI_ANY_ID,
+		QUIRK_CYCLE_TIMER | QUIRK_RESET_PACKET | QUIRK_NO_1394A},
+
+	{PCI_VENDOR_ID_TI, PCI_ANY_ID, PCI_ANY_ID,
+		QUIRK_RESET_PACKET},
+
+	{PCI_VENDOR_ID_VIA, PCI_ANY_ID, PCI_ANY_ID,
+		QUIRK_CYCLE_TIMER | QUIRK_NO_MSI},
 };
 
 /* This overrides anything that was found in ohci_quirks[]. */
@@ -2931,9 +2948,11 @@ static int __devinit pci_probe(struct pc
 	}
 
 	for (i = 0; i < ARRAY_SIZE(ohci_quirks); i++)
-		if (ohci_quirks[i].vendor == dev->vendor &&
-		    (ohci_quirks[i].device == dev->device ||
-		     ohci_quirks[i].device == (unsigned short)PCI_ANY_ID)) {
+		if ((ohci_quirks[i].vendor == dev->vendor) &&
+		    (ohci_quirks[i].device == (unsigned short)PCI_ANY_ID ||
+		     ohci_quirks[i].device == dev->device) &&
+		    (ohci_quirks[i].revision == (unsigned short)PCI_ANY_ID ||
+		     ohci_quirks[i].revision >= dev->revision)) {
 			ohci->quirks = ohci_quirks[i].flags;
 			break;
 		}


-- 
Stefan Richter
-=====-==-=- ==-- --===
http://arcgraph.de/sr/
