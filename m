Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab0EOVSY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:18:24 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:51321 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755678Ab0EOVSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:18:21 -0400
Date: Sat, 15 May 2010 23:18:16 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 17/37] drivers/pci/hotplug: Use kmemdup
Message-ID: <Pine.LNX.4.64.1005152318000.21345@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kmemdup when some other buffer is immediately copied into the
allocated region.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
statement S;
@@

-  to = \(kmalloc\|kzalloc\)(size,flag);
+  to = kmemdup(from,size,flag);
   if (to==NULL || ...) S
-  memcpy(to, from, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/pci/hotplug/cpqphp_core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -1075,13 +1075,12 @@ static int cpqhpc_probe(struct pci_dev *
 
 	/* make our own copy of the pci bus structure,
 	 * as we like tweaking it a lot */
-	ctrl->pci_bus = kmalloc(sizeof(*ctrl->pci_bus), GFP_KERNEL);
+	ctrl->pci_bus = kmemdup(pdev->bus, sizeof(*ctrl->pci_bus), GFP_KERNEL);
 	if (!ctrl->pci_bus) {
 		err("out of memory\n");
 		rc = -ENOMEM;
 		goto err_free_ctrl;
 	}
-	memcpy(ctrl->pci_bus, pdev->bus, sizeof(*ctrl->pci_bus));
 
 	ctrl->bus = pdev->bus->number;
 	ctrl->rev = pdev->revision;
