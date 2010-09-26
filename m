Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab0IZJ62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 05:58:28 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33648 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891Ab0IZJ6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 05:58:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GKrCdRKdSD9ZhTa9961XrowYHczND6/I0CAv744uaNYAU05EHQPPY06SJE8snPbzpL
         o0tuNxGZOhhbqJYVGD6/Jn7W6lugZCotK7iIU6er6UTu0vQ44VMOxnwEbsnqIDee1kds
         BjLKnKNsTvaDp3rDAnnGJbsT2p6BLCgvxdmNE=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] staging: octeon: use free_netdev(netdev) instead of kfree()
Date: Sun, 26 Sep 2010 13:58:21 +0400
Message-Id: <1285495102-22111-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not guaranteed that free_netdev() is macro.
Freeing netdev without free_netdev() leads to net, tx leaks.
I might lead to dereferencing freed pointer.

---
 drivers/staging/octeon/ethernet.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index fb568a9..a8f780e 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -670,7 +670,7 @@ static int __init cvm_oct_init_module(void)
 
 			if (register_netdev(dev) < 0) {
 				pr_err("Failed to register ethernet device for POW\n");
-				kfree(dev);
+				free_netdev(dev);
 			} else {
 				cvm_oct_device[CVMX_PIP_NUM_INPUT_PORTS] = dev;
 				pr_info("%s: POW send group %d, receive group %d\n",
@@ -756,12 +756,12 @@ static int __init cvm_oct_init_module(void)
 			}
 
 			if (!dev->netdev_ops) {
-				kfree(dev);
+				free_netdev(dev);
 			} else if (register_netdev(dev) < 0) {
 				pr_err("Failed to register ethernet device "
 					 "for interface %d, port %d\n",
 					 interface, priv->port);
-				kfree(dev);
+				free_netdev(dev);
 			} else {
 				cvm_oct_device[priv->port] = dev;
 				fau -=
@@ -815,7 +815,7 @@ static void __exit cvm_oct_cleanup_module(void)
 
 			cvm_oct_tx_shutdown_dev(dev);
 			unregister_netdev(dev);
-			kfree(dev);
+			free_netdev(dev);
 			cvm_oct_device[port] = NULL;
 		}
 	}
-- 
1.7.0.4

