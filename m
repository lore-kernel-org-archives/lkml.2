Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab0IZJ7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 05:59:44 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61634 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab0IZJ6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 05:58:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=I3sVymuAUD438vcMVbN7QJ7a/MYwrzreJozzbFqTen+Ak9kDs3euPhGzDLErsg8Z4q
         KTQ+P5m50wxqKLzP11M63KFTSdMC3n1RrpPVz/mnL7pp5XHns3BioSHUiu+28U6JMiY8
         O0W1pirf0tj/BJPq/Cj779+oNHryn6zD3sj8o=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] rionet: use free_netdev(netdev) instead of kfree()
Date: Sun, 26 Sep 2010 13:58:03 +0400
Message-Id: <1285495083-21899-1-git-send-email-segooon@gmail.com>
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
 drivers/net/rionet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index 07eb884..44150f2 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -384,7 +384,7 @@ static void rionet_remove(struct rio_dev *rdev)
 	free_pages((unsigned long)rionet_active, rdev->net->hport->sys_size ?
 					__ilog2(sizeof(void *)) + 4 : 0);
 	unregister_netdev(ndev);
-	kfree(ndev);
+	free_netdev(ndev);
 
 	list_for_each_entry_safe(peer, tmp, &rionet_peers, node) {
 		list_del(&peer->node);
-- 
1.7.0.4

