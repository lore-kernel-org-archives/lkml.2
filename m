Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab1AFBBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 20:01:52 -0500
Received: from kroah.org ([198.145.64.141]:35426 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810Ab1AFA27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:28:59 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:58 2011
Message-Id: <20110106002258.219766647@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:21:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [016/152] firewire: ohci: fix regression with Agere FW643 rev 06, disable MSI
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 9993e0fe0f5f29c69e79efcb271ffc9843002985 upstream.

Agere FW643 rev 06, listed as "11c1:5901 (rev 06) (prog-if 10 [OHCI])",
produced SBP-2 I/O errors since kernel 2.6.36.  Disabling MSI fixes it.

Since MSI work on Agere FW643-E (same vendor and device ID, but rev 07),
introduce a device revision field into firewire-ohci's quirks list so
that different quirks can be defined for older and newer revisions.

Reported-by: Jonathan Isom <jeisom@gmail.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/ohci.c |   48 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -242,6 +242,7 @@ static inline struct fw_ohci *fw_ohci(st
 
 static char ohci_driver_name[] = KBUILD_MODNAME;
 
+#define PCI_DEVICE_ID_AGERE_FW643	0x5901
 #define PCI_DEVICE_ID_JMICRON_JMB38X_FW	0x2380
 #define PCI_DEVICE_ID_TI_TSB12LV22	0x8009
 
@@ -253,19 +254,34 @@ static char ohci_driver_name[] = KBUILD_
 
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
+	{PCI_VENDOR_ID_AL, PCI_ANY_ID, PCI_ANY_ID,
+		QUIRK_CYCLE_TIMER},
+
+	{PCI_VENDOR_ID_APPLE, PCI_DEVICE_ID_APPLE_UNI_N_FW, PCI_ANY_ID,
+		QUIRK_BE_HEADERS},
+
+	{PCI_VENDOR_ID_ATT, PCI_DEVICE_ID_AGERE_FW643, 6,
+		QUIRK_NO_MSI},
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
@@ -2922,9 +2938,11 @@ static int __devinit pci_probe(struct pc
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


