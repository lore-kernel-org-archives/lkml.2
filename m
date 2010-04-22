Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab0DVTnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:43:00 -0400
Received: from kroah.org ([198.145.64.141]:41292 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725Ab0DVT3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:21 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:19 2010
Message-Id: <20100422190919.747315398@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Huang Ying <ying.huang@intel.com>,
       Andrew Patterson <andrew.patterson@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       maximilian attems <max@stro.at>
Subject: [139/197] PCI: fix nested spinlock hang in aer_inject
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Patterson <andrew.patterson@hp.com>

commit bd1f46deba615971a58193afd0202878cadf19a7 upstream.

The aer_inject module hangs in aer_inject() when checking the device's
error masks.  The hang is due to a recursive use of the aer_inject lock.
The aer_inject() routine grabs the lock while processing the error and then
calls pci_read_config_dword to read the masks. The pci_read_config_dword
routine is earlier overridden by pci_read_aer, which among other things,
grabs the aer_inject lock.

Fixed by moving the pci_read_config_dword calls to read the masks to before
the lock is taken.

Acked-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pcie/aer/aer_inject.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -302,7 +302,7 @@ static int aer_inject(struct aer_error_i
 	unsigned long flags;
 	unsigned int devfn = PCI_DEVFN(einj->dev, einj->fn);
 	int pos_cap_err, rp_pos_cap_err;
-	u32 sever, mask;
+	u32 sever, cor_mask, uncor_mask;
 	int ret = 0;
 
 	dev = pci_get_bus_and_slot(einj->bus, devfn);
@@ -320,6 +320,9 @@ static int aer_inject(struct aer_error_i
 		goto out_put;
 	}
 	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_UNCOR_SEVER, &sever);
+	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_COR_MASK, &cor_mask);
+	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_UNCOR_MASK,
+			      &uncor_mask);
 
 	rp_pos_cap_err = pci_find_ext_capability(rpdev, PCI_EXT_CAP_ID_ERR);
 	if (!rp_pos_cap_err) {
@@ -354,17 +357,14 @@ static int aer_inject(struct aer_error_i
 	err->header_log2 = einj->header_log2;
 	err->header_log3 = einj->header_log3;
 
-	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_COR_MASK, &mask);
-	if (einj->cor_status && !(einj->cor_status & ~mask)) {
+	if (einj->cor_status && !(einj->cor_status & ~cor_mask)) {
 		ret = -EINVAL;
 		printk(KERN_WARNING "The correctable error(s) is masked "
 				"by device\n");
 		spin_unlock_irqrestore(&inject_lock, flags);
 		goto out_put;
 	}
-
-	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_UNCOR_MASK, &mask);
-	if (einj->uncor_status && !(einj->uncor_status & ~mask)) {
+	if (einj->uncor_status && !(einj->uncor_status & ~uncor_mask)) {
 		ret = -EINVAL;
 		printk(KERN_WARNING "The uncorrectable error(s) is masked "
 				"by device\n");


