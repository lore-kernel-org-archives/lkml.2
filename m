Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab2CLQzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:55:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:65259 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab2CLQzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:55:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="76512420"
Date: Mon, 12 Mar 2012 16:55:15 +0000
From: Tadeusz Struk <tadeusz.struk@intel.com>
To: bhelgaas@google.com, jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, tadeusz.struk@intel.com
Subject: [PATCH] PCI: Device specific reset function
Message-ID: <4f5e2a73.YyO0Gu2m5JhSVsu6%tadeusz.struk@intel.com>
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a use case where I need to cleanup resource allocated for Virtual
Functions after a guest OS that used it crashed. This cleanup needs to
be done before the VF is being FLRed. The only possible way to do this
seems to be by using pci_dev_specific_reset() function.
This patch adds specific reset function to the pci_driver struct.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/pci/quirks.c |    4 ++++
 include/linux/pci.h  |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6476547..13d224b 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3081,8 +3081,12 @@ static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
 
 int pci_dev_specific_reset(struct pci_dev *dev, int probe)
 {
+	struct pci_driver *drv = dev->driver;
 	const struct pci_dev_reset_methods *i;
 
+	if (drv && drv->reset)
+		return drv->reset(dev, probe);
+
 	for (i = pci_dev_reset_methods; i->reset; i++) {
 		if ((i->vendor == dev->vendor ||
 		     i->vendor == (u16)PCI_ANY_ID) &&
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a16b1df..2ccd838 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -560,6 +560,7 @@ struct pci_driver {
 	int  (*resume_early) (struct pci_dev *dev);
 	int  (*resume) (struct pci_dev *dev);	                /* Device woken up */
 	void (*shutdown) (struct pci_dev *dev);
+	int  (*reset) (struct pci_dev *dev, int probe);
 	struct pci_error_handlers *err_handler;
 	struct device_driver	driver;
 	struct pci_dynids dynids;
-- 
1.7.7.6

