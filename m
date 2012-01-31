Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab2AaOdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 09:33:19 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:33630 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab2AaOdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 09:33:17 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 31 Jan 2012 15:32:53 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire fixes post v3.3-rc1
Message-ID: <20120131153253.5fdd43ce@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from the tag "firewire-fixes" at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git firewire-fixes

to receive workarounds table entries for hardware bugs in
  - FireWire part of Sound Blaster Audigy cards,
  - Ricoh PCIe 1394 controllers.
Without these, several protocols, e.g. AV/C, do not work on the
Audigy, and the Ricoh PCIe controllers wouldn't work at all.
This does not concern the older Ricoh PCI controllers.

Clemens Ladisch (1):
      firewire: ohci: add reset packet quirk for SB Audigy

Stefan Richter (1):
      firewire: ohci: disable MSI on Ricoh controllers

 drivers/firewire/ohci.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)


commit 320cfa6ce0b3dc794fedfa4bae54c0f65077234d
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Jan 29 12:41:15 2012 +0100

    firewire: ohci: disable MSI on Ricoh controllers
    
    The PCIe device
    
        FireWire (IEEE 1394) [0c00]: Ricoh Co Ltd FireWire Host Controller
        [1180:e832] (prog-if 10 [OHCI])
    
    is unable to access attached FireWire devices when MSI is enabled but
    works if MSI is disabled.
    http://www.mail-archive.com/alsa-user@lists.sourceforge.net/msg28251.html
    
    Hence add the "disable MSI" quirks flag for this device, or in fact for
    safety and simplicity for all current (R5U230, R5U231, R5U240) and
    future Ricoh PCIe 1394 controllers.
    
    Reported-by: Stefan Thomas <kontrapunktstefan@googlemail.com>
    Cc: 2.6.36+ <stable@vger.kernel.org>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 21250ec..7f5f0da 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -303,7 +303,7 @@ static const struct {
 		QUIRK_NO_MSI},
 
 	{PCI_VENDOR_ID_RICOH, PCI_ANY_ID, PCI_ANY_ID,
-		QUIRK_CYCLE_TIMER},
+		QUIRK_CYCLE_TIMER | QUIRK_NO_MSI},
 
 	{PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_TSB12LV22, PCI_ANY_ID,
 		QUIRK_CYCLE_TIMER | QUIRK_RESET_PACKET | QUIRK_NO_1394A},

commit d1bb399ad03c11e792f6dea198d3b1e23061f094
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Thu Jan 26 22:05:58 2012 +0100

    firewire: ohci: add reset packet quirk for SB Audigy
    
    The Audigy's SB1394 controller is actually from Texas Instruments
    and has the same bus reset packet generation bug, so it needs the
    same quirk entry.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Cc: 2.6.36+ <stable@vger.kernel.org>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 6628fea..21250ec 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -263,6 +263,7 @@ static inline struct fw_ohci *fw_ohci(struct fw_card *card)
 static char ohci_driver_name[] = KBUILD_MODNAME;
 
 #define PCI_DEVICE_ID_AGERE_FW643	0x5901
+#define PCI_DEVICE_ID_CREATIVE_SB1394	0x4001
 #define PCI_DEVICE_ID_JMICRON_JMB38X_FW	0x2380
 #define PCI_DEVICE_ID_TI_TSB12LV22	0x8009
 #define PCI_DEVICE_ID_TI_TSB12LV26	0x8020
@@ -289,6 +290,9 @@ static const struct {
 	{PCI_VENDOR_ID_ATT, PCI_DEVICE_ID_AGERE_FW643, 6,
 		QUIRK_NO_MSI},
 
+	{PCI_VENDOR_ID_CREATIVE, PCI_DEVICE_ID_CREATIVE_SB1394, PCI_ANY_ID,
+		QUIRK_RESET_PACKET},
+
 	{PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB38X_FW, PCI_ANY_ID,
 		QUIRK_NO_MSI},
 

-- 
Stefan Richter
-=====-===-- ---= =====
http://arcgraph.de/sr/
