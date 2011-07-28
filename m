Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab1G1Q04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 12:26:56 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50290 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186Ab1G1Q0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 12:26:54 -0400
From: Julia Lawall <julia@diku.dk>
To: "David S. Miller" <davem@davemloft.net>
Cc: kernel-janitors@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drivers/ide/cy82c693.c: Add missing pci_dev_put
Date: Thu, 28 Jul 2011 18:26:47 +0200
Message-Id: <1311870407-22461-2-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Pci_get_slot calls pci_dev_get, so pci_dev_put is needed before leaving the
function in the case where pci_get_slot is locally used.

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

 drivers/ide/cy82c693.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ide/cy82c693.c b/drivers/ide/cy82c693.c
index 3be60da..67cbcfa 100644
--- a/drivers/ide/cy82c693.c
+++ b/drivers/ide/cy82c693.c
@@ -141,6 +141,8 @@ static void cy82c693_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 		pci_write_config_byte(dev, CY82_IDE_SLAVE_IOW, time_16);
 		pci_write_config_byte(dev, CY82_IDE_SLAVE_8BIT, time_8);
 	}
+	if (hwif->index > 0)
+		pci_dev_put(dev);
 }
 
 static void __devinit init_iops_cy82c693(ide_hwif_t *hwif)

