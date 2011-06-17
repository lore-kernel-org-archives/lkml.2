Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab1FQQ5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 12:57:00 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:56037 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406Ab1FQQ47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 12:56:59 -0400
From: Pavel Shved <shved@ispras.ru>
Cc: Pavel Shved <shved@ispras.ru>, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: [PATCH] synclink_gt: add module_put on error path in hdlcdev_open()
Date: Fri, 17 Jun 2011 20:25:13 +0400
Message-Id: <1308327913-23220-4-git-send-email-shved@ispras.ru>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1308327913-23220-1-git-send-email-shved@ispras.ru>
References: <1308327913-23220-1-git-send-email-shved@ispras.ru>
To: Greg Kroah-Hartman <gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hdlcdev_open() calls try_module_get, and does not put the module when
other functions subsequently called fail.

The patch adds an exit point in hdlcdev_open() that calls module_put()
after such errors.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Pavel Shved <shved@ispras.ru>
---
 drivers/tty/synclink_gt.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 18b48cd..e1e89a0 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -1542,14 +1542,15 @@ static int hdlcdev_open(struct net_device *dev)
 
 	/* generic HDLC layer open processing */
 	if ((rc = hdlc_open(dev)))
-		return rc;
+		goto do_put;
 
 	/* arbitrate between network and tty opens */
 	spin_lock_irqsave(&info->netlock, flags);
 	if (info->port.count != 0 || info->netcount != 0) {
 		DBGINFO(("%s hdlc_open busy\n", dev->name));
 		spin_unlock_irqrestore(&info->netlock, flags);
-		return -EBUSY;
+		rc = -EBUSY;
+		goto do_put;
 	}
 	info->netcount=1;
 	spin_unlock_irqrestore(&info->netlock, flags);
@@ -1559,7 +1560,7 @@ static int hdlcdev_open(struct net_device *dev)
 		spin_lock_irqsave(&info->netlock, flags);
 		info->netcount=0;
 		spin_unlock_irqrestore(&info->netlock, flags);
-		return rc;
+		goto do_put;
 	}
 
 	/* assert DTR and RTS, apply hardware settings */
@@ -1579,6 +1580,10 @@ static int hdlcdev_open(struct net_device *dev)
 	else
 		netif_carrier_off(dev);
 	return 0;
+
+do_put:
+	module_put(THIS_MODULE);
+	return rc;
 }
 
 /**
-- 
1.7.0.2

