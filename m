Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab0IZJ6X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 05:58:23 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61634 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab0IZJ6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 05:58:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MddbJ+kevXt+4FewI/f41y9p27l/zujNMACJCLTHxtsInypGQdz4FLQ4/TN27jf336
         YHRKZH6dpwUIo1v2WGMx7r/Q6ASkounZvJz7ChN0z63DgLzbKlOLDP8vNMKGn3XwesUG
         5TUjRByFlVTeoODUimcJd+110GMW3zUG4HQ0M=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, Julia Lawall <julia@diku.dk>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] s390: use free_netdev(netdev) instead of kfree()
Date: Sun, 26 Sep 2010 13:58:09 +0400
Message-Id: <1285495090-22002-1-git-send-email-segooon@gmail.com>
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
 drivers/s390/net/ctcm_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index 6edf20b..2c7d2d9 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -1154,7 +1154,7 @@ static struct net_device *ctcm_init_netdevice(struct ctcm_priv *priv)
 				dev_fsm, dev_fsm_len, GFP_KERNEL);
 	if (priv->fsm == NULL) {
 		CTCMY_DBF_DEV(SETUP, dev, "init_fsm error");
-		kfree(dev);
+		free_netdev(dev);
 		return NULL;
 	}
 	fsm_newstate(priv->fsm, DEV_STATE_STOPPED);
@@ -1165,7 +1165,7 @@ static struct net_device *ctcm_init_netdevice(struct ctcm_priv *priv)
 		grp = ctcmpc_init_mpc_group(priv);
 		if (grp == NULL) {
 			MPC_DBF_DEV(SETUP, dev, "init_mpc_group error");
-			kfree(dev);
+			free_netdev(dev);
 			return NULL;
 		}
 		tasklet_init(&grp->mpc_tasklet2,
-- 
1.7.0.4

