Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab2DTPG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:06:27 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:32115 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab2DTPGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:06:25 -0400
Subject: [PATCH 02/17] hpsa: do not skip disabled devices
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matthew.gates@hp.com, stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Date: Fri, 20 Apr 2012 10:06:24 -0500
Message-ID: <20120420150624.10596.53288.stgit@beardog.cce.hp.com>
In-Reply-To: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

There was code to skip "disabled" devices which was intended to
skip devices disabled in the BIOS, but it really just checks to
see if the device can write to host memory, which this is disabled
by pci_disable_device on driver unload, so this check has the effect
of preventing subsequent load of the driver.  And devices disabled in
the BIOS don't show up at all anyway, so this check never made any
sense to begin with, and should be removed.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 1a6c319..5119ce6 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3705,14 +3705,6 @@ static int __devinit hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
 	return ARRAY_SIZE(products) - 1; /* generic unknown smart array */
 }
 
-static inline bool hpsa_board_disabled(struct pci_dev *pdev)
-{
-	u16 command;
-
-	(void) pci_read_config_word(pdev, PCI_COMMAND, &command);
-	return ((command & PCI_COMMAND_MEMORY) == 0);
-}
-
 static int __devinit hpsa_pci_find_memory_BAR(struct pci_dev *pdev,
 	unsigned long *memory_bar)
 {
@@ -3932,11 +3924,6 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 	h->product_name = products[prod_index].product_name;
 	h->access = *(products[prod_index].access);
 
-	if (hpsa_board_disabled(h->pdev)) {
-		dev_warn(&h->pdev->dev, "controller appears to be disabled\n");
-		return -ENODEV;
-	}
-
 	pci_disable_link_state(h->pdev, PCIE_LINK_STATE_L0S |
 			       PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_CLKPM);
 

