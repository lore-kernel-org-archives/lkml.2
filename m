Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab1G1QaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 12:30:22 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:34243 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287Ab1G1QaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 12:30:20 -0400
Date: Thu, 28 Jul 2011 18:30:18 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: mirq-linux@rere.qmqm.pl
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] drivers/misc/cb710/core.c: Add missing pci_dev_put
Message-ID: <Pine.LNX.4.64.1107281829460.20584@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Pci_get_slot calls pci_dev_get, so pci_dev_put is needed before leaving the
function.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
local idexpression x;
expression e;
@@

*x = pci_get_slot(...)
... when != true x == NULL
    when != pci_dev_put(x)
    when != e = x
    when != if (x != NULL) {<+... pci_dev_put(x); ...+>}
*return ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
Not tested.

 drivers/misc/cb710/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/cb710/core.c b/drivers/misc/cb710/core.c
index efec413..84983c7 100644
--- a/drivers/misc/cb710/core.c
+++ b/drivers/misc/cb710/core.c
@@ -41,7 +41,7 @@ static int __devinit cb710_pci_configure(struct pci_dev *pdev)
 
 	pci_read_config_dword(pdev, 0x48, &val);
 	if (val & 0x80000000)
-		return 0;
+		goto out;
 
 	if (!pdev0)
 		return -ENODEV;
@@ -59,6 +59,7 @@ static int __devinit cb710_pci_configure(struct pci_dev *pdev)
 	cb710_pci_update_config_reg(pdev0, 0x90,
 		~0x00060000, 0x00040000);
 
+out:
 	pci_dev_put(pdev0);
 
 	return 0;

