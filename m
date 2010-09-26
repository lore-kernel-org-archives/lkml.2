Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab0IZJ6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 05:58:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33648 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab0IZJ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 05:58:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wXdZRx8G1T1BURlk3Czs/BZKyNLQLSErmjO5CjHUUNmXW90MtMZTyrPKQLcFsq9AZa
         UUzNP+sMSqk6pMghucAELyo63MNeCdLUHpzMjToS4/2EoLUtPhCMVZd+NLMb+Mqvss4l
         lFPHbpI6OXmu19NP3uwMedU721dQh5q8Db1l4=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jiri Pirko <jpirko@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 1/9] ibm_newemac: use free_netdev(netdev) instead of kfree()
Date: Sun, 26 Sep 2010 13:58:00 +0400
Message-Id: <1285495080-21857-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Freeing netdev without free_netdev() leads to net, tx leaks.
I might lead to dereferencing freed pointer.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

@@
struct net_device* dev;
@@

-kfree(dev)
+free_netdev(dev)
---
 drivers/net/ibm_newemac/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ibm_newemac/core.c b/drivers/net/ibm_newemac/core.c
index 3506fd6..519e19e 100644
--- a/drivers/net/ibm_newemac/core.c
+++ b/drivers/net/ibm_newemac/core.c
@@ -2928,7 +2928,7 @@ static int __devinit emac_probe(struct platform_device *ofdev,
 	if (dev->emac_irq != NO_IRQ)
 		irq_dispose_mapping(dev->emac_irq);
  err_free:
-	kfree(ndev);
+	free_netdev(ndev);
  err_gone:
 	/* if we were on the bootlist, remove us as we won't show up and
 	 * wake up all waiters to notify them in case they were waiting
@@ -2971,7 +2971,7 @@ static int __devexit emac_remove(struct platform_device *ofdev)
 	if (dev->emac_irq != NO_IRQ)
 		irq_dispose_mapping(dev->emac_irq);
 
-	kfree(dev->ndev);
+	free_netdev(dev->ndev);
 
 	return 0;
 }
-- 
1.7.0.4

