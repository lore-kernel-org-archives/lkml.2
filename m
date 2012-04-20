Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab2DTPGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:06:34 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:33606 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab2DTPGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:06:31 -0400
Subject: [PATCH 03/17] hpsa: enable bus master bit after pci_enable_device
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matthew.gates@hp.com, stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Date: Fri, 20 Apr 2012 10:06:29 -0500
Message-ID: <20120420150629.10596.51923.stgit@beardog.cce.hp.com>
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

pci_disable_device() disables the bus master bit and pci_enable_device does
not re-enable it.  It needs to be enabled.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5119ce6..363619d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3917,6 +3917,7 @@ static int __devinit hpsa_enter_simple_mode(struct ctlr_info *h)
 static int __devinit hpsa_pci_init(struct ctlr_info *h)
 {
 	int prod_index, err;
+	u16 command_register;
 
 	prod_index = hpsa_lookup_board_id(h->pdev, &h->board_id);
 	if (prod_index < 0)
@@ -3933,6 +3934,11 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 		return err;
 	}
 
+	/* Enable bus mastering (pci_disable_device may disable this) */
+	pci_read_config_word(h->pdev, PCI_COMMAND, &command_register);
+	command_register |= PCI_COMMAND_MASTER;
+	pci_write_config_word(h->pdev, PCI_COMMAND, command_register);
+
 	err = pci_request_regions(h->pdev, HPSA);
 	if (err) {
 		dev_err(&h->pdev->dev,

