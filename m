Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab0DVToW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:44:22 -0400
Received: from kroah.org ([198.145.64.141]:41238 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704Ab0DVT3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:17 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:19 2010
Message-Id: <20100422190919.308022705@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andi Kleen <ak@linux.intel.com>, Youquan Song <youquan.song@intel.com>,
       Ying Huang <ying.huang@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       maximilian attems <max@stro.at>
Subject: [134/197] PCIe AER: prevent AER injection if hardware masks error reporting
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Youquan Song <youquan.song@linux.intel.com>

commit b49bfd32901625e4adcfee011d2b32a43b4db67d upstream.

The Correcteable/Uncorrectable Error Mask Registers are used by PCIe AER
driver which will controls the reporting of individual errors to PCIe RC
via PCIe error messages.

If hardware masks special error reporting to RC, the aer_inject driver
should not inject aer error.

Acked-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Youquan Song <youquan.song@intel.com>
Acked-by: Ying Huang <ying.huang@intel.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pcie/aer/aer_inject.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -302,7 +302,7 @@ static int aer_inject(struct aer_error_i
 	unsigned long flags;
 	unsigned int devfn = PCI_DEVFN(einj->dev, einj->fn);
 	int pos_cap_err, rp_pos_cap_err;
-	u32 sever;
+	u32 sever, mask;
 	int ret = 0;
 
 	dev = pci_get_bus_and_slot(einj->bus, devfn);
@@ -354,6 +354,24 @@ static int aer_inject(struct aer_error_i
 	err->header_log2 = einj->header_log2;
 	err->header_log3 = einj->header_log3;
 
+	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_COR_MASK, &mask);
+	if (einj->cor_status && !(einj->cor_status & ~mask)) {
+		ret = -EINVAL;
+		printk(KERN_WARNING "The correctable error(s) is masked "
+				"by device\n");
+		spin_unlock_irqrestore(&inject_lock, flags);
+		goto out_put;
+	}
+
+	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_UNCOR_MASK, &mask);
+	if (einj->uncor_status && !(einj->uncor_status & ~mask)) {
+		ret = -EINVAL;
+		printk(KERN_WARNING "The uncorrectable error(s) is masked "
+				"by device\n");
+		spin_unlock_irqrestore(&inject_lock, flags);
+		goto out_put;
+	}
+
 	rperr = __find_aer_error_by_dev(rpdev);
 	if (!rperr) {
 		rperr = rperr_alloc;


