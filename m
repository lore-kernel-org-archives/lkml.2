Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab1HHQ27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 12:28:59 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59984 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab1HHQ26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 12:28:58 -0400
From: Julia Lawall <julia@diku.dk>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: kernel-janitors@vger.kernel.org, Joe Perches <joe@perches.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/net/can/sja1000/plx_pci.c: eliminate double free
Date: Mon,  8 Aug 2011 18:28:50 +0200
Message-Id: <1312820931-28230-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In this code, the failure_cleanup label calls the function
plx_pci_del_card, which frees everything in the card->net_dev array.  dev
is placed in this array immediately after allocation, so the two subsequent
jumps to failure_cleanup should not also call free_sja1000dev, but the
second one does.

If plx_pci_check_sja1000 fails, then free_sja1000dev is also called on
dev.  Because dev is already in the card->net_dev array, this implies that
when plx_pci_del_card is later called, it may get freed again.  So that
entry is reset to NULL after the free.

Finally, if there is a problem with one channel, there will be a hole in the
array.  card->channels counts the number of channels that have succeeded,
and does not keep track of the index of the largest element in the array
that is valid.  So the loop in plx_pci_del_card is changed to go up to
PLX_PCI_MAX_CHAN, which is only 2.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
Compiled but not tested.  I'm not sure the fix is sufficient to take into
account possible failures.  In particular, is it safe to call
unregister_sja1000dev without previously having (successfully) called
register_sja1000dev?

 drivers/net/can/sja1000/plx_pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/sja1000/plx_pci.c b/drivers/net/can/sja1000/plx_pci.c
index 231385b..c7f3d4e 100644
--- a/drivers/net/can/sja1000/plx_pci.c
+++ b/drivers/net/can/sja1000/plx_pci.c
@@ -408,7 +408,7 @@ static void plx_pci_del_card(struct pci_dev *pdev)
 	struct sja1000_priv *priv;
 	int i = 0;
 
-	for (i = 0; i < card->channels; i++) {
+	for (i = 0; i < PLX_PCI_MAX_CHAN; i++) {
 		dev = card->net_dev[i];
 		if (!dev)
 			continue;
@@ -536,7 +536,6 @@ static int __devinit plx_pci_add_card(struct pci_dev *pdev,
 			if (err) {
 				dev_err(&pdev->dev, "Registering device failed "
 					"(err=%d)\n", err);
-				free_sja1000dev(dev);
 				goto failure_cleanup;
 			}
 
@@ -549,6 +548,7 @@ static int __devinit plx_pci_add_card(struct pci_dev *pdev,
 			dev_err(&pdev->dev, "Channel #%d not detected\n",
 				i + 1);
 			free_sja1000dev(dev);
+			card->net_dev[i] = NULL;
 		}
 	}
 

