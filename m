Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761992Ab0HFTtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:49:22 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52903 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab0HFTtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:49:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=R23pjJ6WN70z//yCNUi0Qc0p0jBKZGvaHbTzLzIANIz3bN73hH9WfdVGqtSXDXRNc2
         6sLv0JKhQq6n9Xwqoy/ocxnue3MryuJcSLhwaqMY60t6RxhV2VjJFdMMye2f+rHto/aq
         tAc9pedR+OazfxdnLJ4NXPisYc80ilu/1U+DA=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rakib Mullick <rakib.mullick@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/18] char: moxa: call disable_pci_device() if pci_probe() failed
Date: Fri,  6 Aug 2010 23:49:10 +0400
Message-Id: <1281124152-12630-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver should call disable_pci_device() if it returns from pci_probe()
with error. Also it must not be called if pci_request_region() fails as
it means that somebody uses device resources and rules the device.

Move pci_enable_device() after checking moxa_boards[] to remove senseless
pci_enable_device()/pci_disable_device().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/char/moxa.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 107b0bd..0ea5aeb 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -939,11 +939,6 @@ static int __devinit moxa_pci_probe(struct pci_dev *pdev,
 	int board_type = ent->driver_data;
 	int retval;
 
-	retval = pci_enable_device(pdev);
-	if (retval) {
-		dev_err(&pdev->dev, "can't enable pci device\n");
-		goto err;
-	}
 
 	for (i = 0; i < MAX_BOARDS; i++)
 		if (moxa_boards[i].basemem == NULL)
@@ -956,6 +951,12 @@ static int __devinit moxa_pci_probe(struct pci_dev *pdev,
 		goto err;
 	}
 
+	retval = pci_enable_device(pdev);
+	if (retval) {
+		dev_err(&pdev->dev, "can't enable pci device\n");
+		goto err;
+	}
+
 	board = &moxa_boards[i];
 
 	retval = pci_request_region(pdev, 2, "moxa-base");
@@ -1001,6 +1002,7 @@ err_base:
 	board->basemem = NULL;
 err_reg:
 	pci_release_region(pdev, 2);
+	pci_disable_device(pdev);
 err:
 	return retval;
 }
-- 
1.7.0.4

