Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab1DFLVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:21:32 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.183]:20227
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754224Ab1DFLVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:21:30 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bh8275dhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJ8A7M-01-3B1-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andiry Xu <andiry.xu@amd.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>, <stable@kernel.org>
Subject: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk
Date: Wed, 6 Apr 2011 13:21:18 +0200
Message-ID: <1302088878-25740-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting 2.6.38 on my test machine produces a lockdep warning
from the usb_amd_find_chipset_info() function:

 WARNING: at /data/lemmy/linux.trees.git/kernel/lockdep.c:2465 lockdep_trace_alloc+0x95/0xc2()
 Hardware name: Snook
 Modules linked in:
 Pid: 959, comm: work_for_cpu Not tainted 2.6.39-rc2+ #22
 Call Trace:
  [<ffffffff8103c0d4>] warn_slowpath_common+0x80/0x98
  [<ffffffff812387e6>] ? T.492+0x24/0x26
  [<ffffffff8103c101>] warn_slowpath_null+0x15/0x17
  [<ffffffff81068667>] lockdep_trace_alloc+0x95/0xc2
  [<ffffffff810ed9ac>] slab_pre_alloc_hook+0x18/0x3b
  [<ffffffff810ef227>] kmem_cache_alloc_trace+0x25/0xba
  [<ffffffff812387e6>] T.492+0x24/0x26
  [<ffffffff81238816>] pci_get_subsys+0x2e/0x73
 sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
  [<ffffffff8123886c>] pci_get_device+0x11/0x13
  [<ffffffff814082a9>] usb_amd_find_chipset_info+0x3f/0x18a
...

It turns out that this function calls pci_get_device under a spin_lock
with irqs disabled, but the pci_get_device function is only allowed in
preemptible context.

This patch fixes this by using temporary variables in the quirk
algorithm and commiting them later to the struct under the lock. This
moves all pci_get_device() invocations out of the spin_lock and fixes
the lockdep warning for me.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/usb/host/pci-quirks.c |   67 +++++++++++++++++++++++-----------------
 1 files changed, 38 insertions(+), 29 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 1d586d4..d3e5cf3 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -84,64 +84,73 @@ int usb_amd_find_chipset_info(void)
 {
 	u8 rev = 0;
 	unsigned long flags;
+	struct pci_dev *nb_dev, *smbus_dev;
+	int nb_type, sb_type;
 
 	spin_lock_irqsave(&amd_lock, flags);
-
 	amd_chipset.probe_count++;
 	/* probe only once */
 	if (amd_chipset.probe_count > 1) {
 		spin_unlock_irqrestore(&amd_lock, flags);
 		return amd_chipset.probe_result;
 	}
+	spin_unlock_irqrestore(&amd_lock, flags);
 
-	amd_chipset.smbus_dev = pci_get_device(PCI_VENDOR_ID_ATI, 0x4385, NULL);
-	if (amd_chipset.smbus_dev) {
-		rev = amd_chipset.smbus_dev->revision;
+	sb_type   = 0;
+	smbus_dev = pci_get_device(PCI_VENDOR_ID_ATI, 0x4385, NULL);
+	if (smbus_dev) {
+		rev = smbus_dev->revision;
 		if (rev >= 0x40)
-			amd_chipset.sb_type = 1;
+			sb_type = 1;
 		else if (rev >= 0x30 && rev <= 0x3b)
-			amd_chipset.sb_type = 3;
+			sb_type = 3;
 	} else {
-		amd_chipset.smbus_dev = pci_get_device(PCI_VENDOR_ID_AMD,
-							0x780b, NULL);
-		if (!amd_chipset.smbus_dev) {
+		smbus_dev = pci_get_device(PCI_VENDOR_ID_AMD, 0x780b, NULL);
+		if (smbus_dev) {
+			spin_lock_irqsave(&amd_lock, flags);
+			amd_chipset.smbus_dev = smbus_dev;
 			spin_unlock_irqrestore(&amd_lock, flags);
 			return 0;
 		}
-		rev = amd_chipset.smbus_dev->revision;
+		rev = smbus_dev->revision;
 		if (rev >= 0x11 && rev <= 0x18)
-			amd_chipset.sb_type = 2;
+			sb_type = 2;
 	}
 
-	if (amd_chipset.sb_type == 0) {
-		if (amd_chipset.smbus_dev) {
-			pci_dev_put(amd_chipset.smbus_dev);
-			amd_chipset.smbus_dev = NULL;
+	if (sb_type == 0) {
+		if (smbus_dev) {
+			pci_dev_put(smbus_dev);
+			smbus_dev = NULL;
 		}
-		spin_unlock_irqrestore(&amd_lock, flags);
 		return 0;
 	}
 
-	amd_chipset.nb_dev = pci_get_device(PCI_VENDOR_ID_AMD, 0x9601, NULL);
-	if (amd_chipset.nb_dev) {
-		amd_chipset.nb_type = 1;
+	nb_type = 0;
+	nb_dev  = pci_get_device(PCI_VENDOR_ID_AMD, 0x9601, NULL);
+	if (nb_dev) {
+		nb_type = 1;
 	} else {
-		amd_chipset.nb_dev = pci_get_device(PCI_VENDOR_ID_AMD,
-							0x1510, NULL);
-		if (amd_chipset.nb_dev) {
-			amd_chipset.nb_type = 2;
-		} else  {
-			amd_chipset.nb_dev = pci_get_device(PCI_VENDOR_ID_AMD,
-								0x9600, NULL);
-			if (amd_chipset.nb_dev)
-				amd_chipset.nb_type = 3;
+		nb_dev = pci_get_device(PCI_VENDOR_ID_AMD, 0x1510, NULL);
+		if (nb_dev) {
+			nb_type = 2;
+		} else {
+			nb_dev = pci_get_device(PCI_VENDOR_ID_AMD,
+						0x9600, NULL);
+			if (nb_dev)
+				nb_type = 3;
 		}
 	}
 
+	spin_lock_irqsave(&amd_lock, flags);
+	amd_chipset.smbus_dev    = smbus_dev;
+	amd_chipset.sb_type      = sb_type;
+	amd_chipset.nb_dev       = nb_dev;
+	amd_chipset.nb_type      = nb_type;
 	amd_chipset.probe_result = 1;
+	spin_unlock_irqrestore(&amd_lock, flags);
+
 	printk(KERN_DEBUG "QUIRK: Enable AMD PLL fix\n");
 
-	spin_unlock_irqrestore(&amd_lock, flags);
 	return amd_chipset.probe_result;
 }
 EXPORT_SYMBOL_GPL(usb_amd_find_chipset_info);
-- 
1.7.1


