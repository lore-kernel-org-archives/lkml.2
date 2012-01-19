Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891Ab2ASUAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 15:00:47 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:34548 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487Ab2ASUAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 15:00:45 -0500
Subject: [PATCH 01/10] hpsa: fix per device memory leak on driver unload
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikem@beardog.cce.hp.com, stephenmcameron@gmail.com, thenzl@redhat.com,
        scott.teel@hp.com, akpm@linux-foundation.org, stable@kernel.org
Date: Thu, 19 Jan 2012 14:00:42 -0600
Message-ID: <20120119200042.17835.93058.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3ecb703..e9b1aa8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4480,6 +4480,14 @@ static void hpsa_shutdown(struct pci_dev *pdev)
 #endif				/* CONFIG_PCI_MSI */
 }
 
+static void __devexit hpsa_free_device_info(struct ctlr_info *h)
+{
+	int i;
+
+	for (i = 0; i < h->ndevices; i++)
+		kfree(h->dev[i]);
+}
+
 static void __devexit hpsa_remove_one(struct pci_dev *pdev)
 {
 	struct ctlr_info *h;
@@ -4495,6 +4503,7 @@ static void __devexit hpsa_remove_one(struct pci_dev *pdev)
 	iounmap(h->vaddr);
 	iounmap(h->transtable);
 	iounmap(h->cfgtable);
+	hpsa_free_device_info(h);
 	hpsa_free_sg_chain_blocks(h);
 	pci_free_consistent(h->pdev,
 		h->nr_cmds * sizeof(struct CommandList),

