Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab2BSTnm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 14:43:42 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:34174 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab2BSTnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 14:43:41 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: kernel-janitors@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/atm/solos-pci.c: exchange pci_iounmaps
Date: Sun, 19 Feb 2012 20:43:32 +0100
Message-Id: <1329680612-28055-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The calls to pci_iounmap are in the wrong order, as compared to the
associated calls to pci_iomap.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,x;
statement S,S1;
int ret;
@@
e = pci_iomap(x,...)
... when != pci_iounmap(x,e)
if (<+...e...+>) S
... when any
    when != pci_iounmap(x,e)
*if (...)
   { ... when != pci_iounmap(x,e)
     return ...; }
... when any
pci_iounmap(x,e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/atm/solos-pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index 5d1d076..e8cd652 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -1206,9 +1206,9 @@ static int fpga_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	
  out_unmap_both:
 	pci_set_drvdata(dev, NULL);
-	pci_iounmap(dev, card->config_regs);
- out_unmap_config:
 	pci_iounmap(dev, card->buffers);
+ out_unmap_config:
+	pci_iounmap(dev, card->config_regs);
  out_release_regions:
 	pci_release_regions(dev);
  out:

