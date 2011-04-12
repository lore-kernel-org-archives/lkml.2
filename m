Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab1DLGlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 02:41:40 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:38709
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755359Ab1DLGli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 02:41:38 -0400
X-SpamScore: -32
X-BigFish: VPS-32(zzbb2cK179dN154dM1432N98dKzz1202hzz15d4R8275bhz32i637h668h839h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LJJ196-01-CXJ-02
X-M-MSG: 
Date: Tue, 12 Apr 2011 08:41:28 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Borislav Petkov <bp@alien8.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Xu, Andiry" <Andiry.Xu@amd.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH v6] USB host: Fix lockdep warning in AMD PLL quirk
Message-ID: <20110412064128.GC20607@amd.com>
References: <20110411163711.GA20607@amd.com>
 <Pine.LNX.4.44L0.1104111304080.1975-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1104111304080.1975-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 01:05:41PM -0400, Alan Stern wrote:
> On Mon, 11 Apr 2011, Roedel, Joerg wrote:

> > Hmm, I see how it can be done differently, but no real bug.
> 
> Never mind, you're right.  In the no-race case, the initial count is 
> always going to be 0, and so incrementing info.probe_count is the right 
> thing to do.

Okay, cool. So now that we have settled on this I removed the last
occurence of '2.6.38' from the changelog and here is the result. No
code changes since v5.

>From a6e00d237f20e940afdbcaafb27117fe8730466f Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Wed, 6 Apr 2011 13:07:53 +0200
Subject: [PATCH] USB host: Fix lockdep warning in AMD PLL quirk

Booting latest kernel on my test machine produces a lockdep
warning from the usb_amd_find_chipset_info() function:

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
  [<ffffffff8123886c>] pci_get_device+0x11/0x13
  [<ffffffff814082a9>] usb_amd_find_chipset_info+0x3f/0x18a
...

It turns out that this function calls pci_get_device under a spin_lock
with irqs disabled, but the pci_get_device function is only allowed in
preemptible context.

This patch fixes the warning by making all data-structure
modifications on temporal storage and commiting this back
into the visible structure at the end. While at it, this
patch also moves the pci_dev_put calls out of the spinlocks
because this function might sleep too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/usb/host/pci-quirks.c |  117 ++++++++++++++++++++++++++---------------
 1 files changed, 74 insertions(+), 43 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 1d586d4..c6eb69c 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -84,65 +84,92 @@ int usb_amd_find_chipset_info(void)
 {
 	u8 rev = 0;
 	unsigned long flags;
+	struct amd_chipset_info info;
+	int ret;
 
 	spin_lock_irqsave(&amd_lock, flags);
 
-	amd_chipset.probe_count++;
 	/* probe only once */
-	if (amd_chipset.probe_count > 1) {
+	if (amd_chipset.probe_count > 0) {
+		amd_chipset.probe_count++;
 		spin_unlock_irqrestore(&amd_lock, flags);
 		return amd_chipset.probe_result;
 	}
+	memset(&info, 0, sizeof(info));
+	spin_unlock_irqrestore(&amd_lock, flags);
 
-	amd_chipset.smbus_dev = pci_get_device(PCI_VENDOR_ID_ATI, 0x4385, NULL);
-	if (amd_chipset.smbus_dev) {
-		rev = amd_chipset.smbus_dev->revision;
+	info.smbus_dev = pci_get_device(PCI_VENDOR_ID_ATI, 0x4385, NULL);
+	if (info.smbus_dev) {
+		rev = info.smbus_dev->revision;
 		if (rev >= 0x40)
-			amd_chipset.sb_type = 1;
+			info.sb_type = 1;
 		else if (rev >= 0x30 && rev <= 0x3b)
-			amd_chipset.sb_type = 3;
+			info.sb_type = 3;
 	} else {
-		amd_chipset.smbus_dev = pci_get_device(PCI_VENDOR_ID_AMD,
-							0x780b, NULL);
-		if (!amd_chipset.smbus_dev) {
-			spin_unlock_irqrestore(&amd_lock, flags);
-			return 0;
+		info.smbus_dev = pci_get_device(PCI_VENDOR_ID_AMD,
+						0x780b, NULL);
+		if (!info.smbus_dev) {
+			ret = 0;
+			goto commit;
 		}
-		rev = amd_chipset.smbus_dev->revision;
+
+		rev = info.smbus_dev->revision;
 		if (rev >= 0x11 && rev <= 0x18)
-			amd_chipset.sb_type = 2;
+			info.sb_type = 2;
 	}
 
-	if (amd_chipset.sb_type == 0) {
-		if (amd_chipset.smbus_dev) {
-			pci_dev_put(amd_chipset.smbus_dev);
-			amd_chipset.smbus_dev = NULL;
+	if (info.sb_type == 0) {
+		if (info.smbus_dev) {
+			pci_dev_put(info.smbus_dev);
+			info.smbus_dev = NULL;
 		}
-		spin_unlock_irqrestore(&amd_lock, flags);
-		return 0;
+		ret = 0;
+		goto commit;
 	}
 
-	amd_chipset.nb_dev = pci_get_device(PCI_VENDOR_ID_AMD, 0x9601, NULL);
-	if (amd_chipset.nb_dev) {
-		amd_chipset.nb_type = 1;
+	info.nb_dev = pci_get_device(PCI_VENDOR_ID_AMD, 0x9601, NULL);
+	if (info.nb_dev) {
+		info.nb_type = 1;
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
+		info.nb_dev = pci_get_device(PCI_VENDOR_ID_AMD, 0x1510, NULL);
+		if (info.nb_dev) {
+			info.nb_type = 2;
+		} else {
+			info.nb_dev = pci_get_device(PCI_VENDOR_ID_AMD,
+						     0x9600, NULL);
+			if (info.nb_dev)
+				info.nb_type = 3;
 		}
 	}
 
-	amd_chipset.probe_result = 1;
+	ret = info.probe_result = 1;
 	printk(KERN_DEBUG "QUIRK: Enable AMD PLL fix\n");
 
-	spin_unlock_irqrestore(&amd_lock, flags);
-	return amd_chipset.probe_result;
+commit:
+
+	spin_lock_irqsave(&amd_lock, flags);
+	if (amd_chipset.probe_count > 0) {
+		/* race - someone else was faster - drop devices */
+
+		/* Mark that we where here */
+		amd_chipset.probe_count++;
+		ret = amd_chipset.probe_result;
+
+		spin_unlock_irqrestore(&amd_lock, flags);
+
+		if (info.nb_dev)
+			pci_dev_put(info.nb_dev);
+		if (info.smbus_dev)
+			pci_dev_put(info.smbus_dev);
+
+	} else {
+		/* no race - commit the result */
+		info.probe_count++;
+		amd_chipset = info;
+		spin_unlock_irqrestore(&amd_lock, flags);
+	}
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(usb_amd_find_chipset_info);
 
@@ -284,6 +311,7 @@ EXPORT_SYMBOL_GPL(usb_amd_quirk_pll_enable);
 
 void usb_amd_dev_put(void)
 {
+	struct pci_dev *nb, *smbus;
 	unsigned long flags;
 
 	spin_lock_irqsave(&amd_lock, flags);
@@ -294,20 +322,23 @@ void usb_amd_dev_put(void)
 		return;
 	}
 
-	if (amd_chipset.nb_dev) {
-		pci_dev_put(amd_chipset.nb_dev);
-		amd_chipset.nb_dev = NULL;
-	}
-	if (amd_chipset.smbus_dev) {
-		pci_dev_put(amd_chipset.smbus_dev);
-		amd_chipset.smbus_dev = NULL;
-	}
+	/* save them to pci_dev_put outside of spinlock */
+	nb    = amd_chipset.nb_dev;
+	smbus = amd_chipset.smbus_dev;
+
+	amd_chipset.nb_dev = NULL;
+	amd_chipset.smbus_dev = NULL;
 	amd_chipset.nb_type = 0;
 	amd_chipset.sb_type = 0;
 	amd_chipset.isoc_reqs = 0;
 	amd_chipset.probe_result = 0;
 
 	spin_unlock_irqrestore(&amd_lock, flags);
+
+	if (nb)
+		pci_dev_put(nb);
+	if (smbus)
+		pci_dev_put(amd_chipset.smbus_dev);
 }
 EXPORT_SYMBOL_GPL(usb_amd_dev_put);
 
-- 
1.7.1


-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

