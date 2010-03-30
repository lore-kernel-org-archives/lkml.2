Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab0CaAPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:15:21 -0400
Received: from kroah.org ([198.145.64.141]:51820 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756773Ab0C3XRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:39 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:12 2010
Message-Id: <20100330225611.826438377@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andrew Patterson <andrew.patterson@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Alex Chiang <achiang@hp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [022/116] PCI: unconditionally clear AER uncorr status register during cleanup
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Patterson <andrew.patterson@hp.com>

commit 6cdfd995a65a52e05b99e3a72a9b979abe73b312 upstream.

The current implementation of pci_cleanup_aer_uncorrect_error_status
only clears either fatal or non-fatal error status bits depending
on the state of the I/O channel. This implementation will then often
leave some bits set after PCI error recovery completes.  The uncleared bit
settings will then be falsely reported the next time an AER interrupt is
generated for that hierarchy. An easy way to illustrate this issue is to
use the aer-inject module to simultaneously inject both an uncorrectable
non-fatal and uncorrectable fatal error.  One of the errors will not be
cleared.

This patch resolves this issue by unconditionally clearing all bits in
the AER uncorrectable status register. All settings and corrective action
strategies are saved and determined before
pci_cleanup_aer_uncorrect_error_status is called, so this change should not
affect errory handling functionality.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Alex Chiang <achiang@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pcie/aer/aerdrv_core.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -78,19 +78,15 @@ EXPORT_SYMBOL_GPL(pci_disable_pcie_error
 int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev)
 {
 	int pos;
-	u32 status, mask;
+	u32 status;
 
 	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
 	if (!pos)
 		return -EIO;
 
 	pci_read_config_dword(dev, pos + PCI_ERR_UNCOR_STATUS, &status);
-	pci_read_config_dword(dev, pos + PCI_ERR_UNCOR_SEVER, &mask);
-	if (dev->error_state == pci_channel_io_normal)
-		status &= ~mask; /* Clear corresponding nonfatal bits */
-	else
-		status &= mask; /* Clear corresponding fatal bits */
-	pci_write_config_dword(dev, pos + PCI_ERR_UNCOR_STATUS, status);
+	if (status)
+		pci_write_config_dword(dev, pos + PCI_ERR_UNCOR_STATUS, status);
 
 	return 0;
 }


