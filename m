Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab0HCPn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:43:27 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46162 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab0HCPnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:43:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dM+Z24Pjq/7/Wx+Of/u3si4+m+jriMj4NY0C/mKkJtMNtfb7j77E3iuJHmuhpT+Wk1
         d6Dioy/kV73Tyig6ZvnNFHXIRKO4CGD4MAWoE5kZVyhAx34NKGiPRLpGIuXv2oEuVw/9
         AzM7rYJwsI30DqkuOMT/7UQzERAvUj7yJYZuQ=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>,
        Simon Kagstrom <simon.kagstrom@netinsight.net>,
        Ben Hutchings <ben@decadent.org.uk>, Jiri Pirko <jpirko@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] via-velocity: do not use PCI resources before pci_enable_device()
Date: Tue,  3 Aug 2010 19:43:18 +0400
Message-Id: <1280850199-5488-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ and resource[] may not have correct values until
after PCI hotplug setup occurs at pci_enable_device() time.

The semantic match that finds this problem is as follows:

// <smpl>
@@
identifier x;
identifier request ~= "pci_request.*|pci_resource.*";
@@

(
* x->irq
|
* x->resource
|
* request(x, ...)
)
 ...
*pci_enable_device(x)
// </smpl>

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/net/via-velocity.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
index 42dffd3..fd69095 100644
--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -2763,12 +2763,12 @@ static int __devinit velocity_found1(struct pci_dev *pdev, const struct pci_devi
 
 	vptr->dev = dev;
 
-	dev->irq = pdev->irq;
-
 	ret = pci_enable_device(pdev);
 	if (ret < 0)
 		goto err_free_dev;
 
+	dev->irq = pdev->irq;
+
 	ret = velocity_get_pci_info(vptr, pdev);
 	if (ret < 0) {
 		/* error message already printed */
-- 
1.7.0.4

