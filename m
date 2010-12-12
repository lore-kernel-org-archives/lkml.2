Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab0LLP34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 10:29:56 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:56364 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab0LLP3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 10:29:54 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 12 Dec 2010 16:29:35 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire regression fixes
Message-ID: <20101212162935.1a1474d7@stein>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the fixes branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git fixes

to receive two IEEE 1394 (FireWire) subsystem fixes.  Thanks.

A side note:  During the coexistence of drivers/ieee1394/ and
drivers/firewire/, we explored previously unused hardware features in
the latter in order to expand the driver capabilities (example:
dual-buffer isochronous DMA mode) or to rely more on hardware for
correctness (example: observing reset packets in the asynchronous
reception queue).  Consequently we had quite a number of regressions in
drivers/firewire/ relative to drivers/ieee1394/ or even relative to
itself (example: MSI support).

Now that drivers/ieee1394/ is no longer present in the mainline as a
fallback --- and that drivers/firewire/ had become feature-complete ---
I plan to maintain drivers/firewire/ in a much more conservative
fashion.

Shortlog, diffstat, full logs and diffs:

Stefan Richter (2):
      firewire: ohci: fix regression with VIA VT6315, disable MSI
      firewire: ohci: fix regression with Agere FW643 rev 06, disable MSI

 drivers/firewire/ohci.c |   47 +++++++++++++++++++++++++++++++++--------------
 1 files changed, 33 insertions(+), 14 deletions(-)

commit 9993e0fe0f5f29c69e79efcb271ffc9843002985
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Tue Dec 7 20:32:40 2010 +0100

    firewire: ohci: fix regression with Agere FW643 rev 06, disable MSI
    
    Agere FW643 rev 06, listed as "11c1:5901 (rev 06) (prog-if 10 [OHCI])",
    produced SBP-2 I/O errors since kernel 2.6.36.  Disabling MSI fixes it.
    
    Since MSI work on Agere FW643-E (same vendor and device ID, but rev 07),
    introduce a device revision field into firewire-ohci's quirks list so
    that different quirks can be defined for older and newer revisions.
    
    Reported-by: Jonathan Isom <jeisom@gmail.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Cc: <stable@kernel.org> # 2.6.36.y

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 5697cf2..e3c8b60 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -242,6 +242,7 @@ static inline struct fw_ohci *fw_ohci(struct fw_card *card)
 
 static char ohci_driver_name[] = KBUILD_MODNAME;
 
+#define PCI_DEVICE_ID_AGERE_FW643	0x5901
 #define PCI_DEVICE_ID_JMICRON_JMB38X_FW	0x2380
 #define PCI_DEVICE_ID_TI_TSB12LV22	0x8009
 
@@ -253,19 +254,34 @@ static char ohci_driver_name[] = KBUILD_MODNAME;
 
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
@@ -2928,9 +2944,11 @@ static int __devinit pci_probe(struct pci_dev *dev,
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

commit af0cdf4947818becfe209610b209315578645ab4
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Tue Dec 7 19:16:02 2010 +0100

    firewire: ohci: fix regression with VIA VT6315, disable MSI
    
    "VIA Technologies, Inc. VT6315 Series Firewire Controller [1106:3403]"
    does not generate any interrupts if Message Signaled Interrupts were
    enabled.  This is a regression since kernel 2.6.36 in which MSI support
    was added to firewire-ohci.  Hence blacklist MSI on all VIA controllers.
    
    Reported-by: Robin Cook <rcook@wyrms.net>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Cc: <stable@kernel.org> # 2.6.36.y

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 84eb607..5697cf2 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -262,7 +262,8 @@ static const struct {
 	{PCI_VENDOR_ID_AL,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
 	{PCI_VENDOR_ID_JMICRON,	PCI_DEVICE_ID_JMICRON_JMB38X_FW, QUIRK_NO_MSI},
 	{PCI_VENDOR_ID_NEC,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
-	{PCI_VENDOR_ID_VIA,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
+	{PCI_VENDOR_ID_VIA,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER |
+						QUIRK_NO_MSI},
 	{PCI_VENDOR_ID_RICOH,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
 	{PCI_VENDOR_ID_APPLE,	PCI_DEVICE_ID_APPLE_UNI_N_FW, QUIRK_BE_HEADERS},
 };

-- 
Stefan Richter
-=====-==-=- ==-- -==--
http://arcgraph.de/sr/
