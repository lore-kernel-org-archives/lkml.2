Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181Ab0EUQxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:53:22 -0400
Received: from kroah.org ([198.145.64.141]:50352 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934138Ab0EUQwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:52:17 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 24/25] serial: isicomm: handle running out of slots
Date: Fri, 21 May 2010 09:51:53 -0700
Message-Id: <1274460714-11277-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165113.GB11216@kroah.com>
References: <20100521165113.GB11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

This patch makes it return -ENODEV if we run out of empty slots in the
probe function.  It's unlikely to happen, but it makes the static
checkers happy.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/isicom.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index c1ab303..98310e1 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -1573,11 +1573,16 @@ static int __devinit isicom_probe(struct pci_dev *pdev,
 	dev_info(&pdev->dev, "ISI PCI Card(Device ID 0x%x)\n", ent->device);
 
 	/* allot the first empty slot in the array */
-	for (index = 0; index < BOARD_COUNT; index++)
+	for (index = 0; index < BOARD_COUNT; index++) {
 		if (isi_card[index].base == 0) {
 			board = &isi_card[index];
 			break;
 		}
+	}
+	if (index == BOARD_COUNT) {
+		retval = -ENODEV;
+		goto err_disable;
+	}
 
 	board->index = index;
 	board->base = pci_resource_start(pdev, 3);
@@ -1624,6 +1629,7 @@ errunrr:
 errdec:
 	board->base = 0;
 	card_count--;
+err_disable:
 	pci_disable_device(pdev);
 err:
 	return retval;
-- 
1.7.0.3

