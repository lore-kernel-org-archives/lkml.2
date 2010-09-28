Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab0I1RIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:08:07 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51574 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224Ab0I1RIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:08:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WsisoaHuCkaOr8B086KdqALK83yfSfIYFOD6dksIAzeYGqreolEPHxqjH3sEECXZBg
         3mqf+tKQAhAyGU0GDPD6rrYrzYTAMmLUZp5vtZGxgIS2x0g195wrDdaas8UNBMmEZ6RY
         /jdAj8N1Nmb6SbHEbm9YlGECvGZ2tylyzFeO8=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] staging: octeon: use free_netdev(netdev) instead of kfree()
Date: Tue, 28 Sep 2010 21:08:01 +0400
Message-Id: <1285693681-4679-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not guaranteed that free_netdev() is macro.
Freeing netdev without free_netdev() leads to net, tx leaks.
I might lead to dereferencing freed pointer.


Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
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

