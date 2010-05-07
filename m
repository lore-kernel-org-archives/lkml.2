Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab0EGIas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:30:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56902 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab0EGIaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:30:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=k/WUjleEhU8Iomr3EoKMmBM6+JgXekNG5wUESKRGsdcAxCBXsMFJAInCIwCXk+nqYJ
         BbrTb5wGPclyCJnWcG9odUEAaSTW180b6Xj7Ut9OruMbX9vr4cGQBq/VD9MIpYovEtB7
         eOps73PykeajRfl1jxiiykuCWeRyfguqGyxUE=
Date: Fri, 7 May 2010 10:30:41 +0200
From: Dan Carpenter <error27@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] isicomm: handle running out of slots
Message-ID: <20100507083041.GU27064@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes it return -ENODEV if we run out of empty slots in the
probe function.  It's unlikely to happen, but it makes the static
checkers happy.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 0fa2e4a..5f24bdb 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -1568,11 +1568,16 @@ static int __devinit isicom_probe(struct pci_dev *pdev,
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
@@ -1619,6 +1624,7 @@ errunrr:
 errdec:
 	board->base = 0;
 	card_count--;
+err_disable:
 	pci_disable_device(pdev);
 err:
 	return retval;
