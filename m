Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab0F0NWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 09:22:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47857 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab0F0NWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 09:22:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bs1VlBWa9mA96z3/jvrDRbyihkvDG4q6CfOLrJrDjw5cuzdpp5vPFN5Q9IbRyI0bkq
         8koB9Zp++F7LprtHw4fQLGQs5pOdbMa+sOw3K2yW7GKIRC14YrrBL69k/5CdsHv1HtRU
         KJn7zcnXESDBhZcGUIMpmg7QiJovIPIYJs2KM=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Lior Dotan <liodot@gmail.com>, <charrer@alacritech.com>,
       Denis Kirjanov <kirjanov@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jpirko@redhat.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] staging: slicoss: error handling with goto
Date: Sun, 27 Jun 2010 17:20:47 +0400
Message-Id: <1277644847-16292-5-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1277644847-16292-1-git-send-email-segooon@gmail.com>
References: <1277644847-16292-1-git-send-email-segooon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes error handling more readable due to 'goto err' pattern.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/slicoss/slicoss.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index d8c952e..478ba3b 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -1451,7 +1451,7 @@ static int slic_if_init(struct adapter *adapter)
 	struct net_device *dev = adapter->netdev;
 	__iomem struct slic_regs *slic_regs = adapter->slic_regs;
 	struct slic_shmem *pshmem;
-	int status = 0;
+	int rc;
 
 	ASSERT(card);
 
@@ -1459,7 +1459,8 @@ static int slic_if_init(struct adapter *adapter)
 	if (adapter->state != ADAPT_DOWN) {
 		dev_err(&dev->dev, "%s: adapter->state != ADAPT_DOWN\n",
 			__func__);
-		return -EIO;
+		rc = -EIO;
+		goto err;
 	}
 	ASSERT(adapter->linkstate == LINK_DOWN);
 
@@ -1475,22 +1476,22 @@ static int slic_if_init(struct adapter *adapter)
 		if (dev->flags & IFF_MULTICAST)
 			adapter->macopts |= MAC_MCAST;
 	}
-	status = slic_adapter_allocresources(adapter);
-	if (status != 0) {
+	rc = slic_adapter_allocresources(adapter);
+	if (rc) {
 		dev_err(&dev->dev,
 			"%s: slic_adapter_allocresources FAILED %x\n",
-			__func__, status);
+			__func__, rc);
 		slic_adapter_freeresources(adapter);
-		return status;
+		goto err;
 	}
 
 	if (!adapter->queues_initialized) {
-		if (slic_rspqueue_init(adapter))
-			return -ENOMEM;
-		if (slic_cmdq_init(adapter))
-			return -ENOMEM;
-		if (slic_rcvqueue_init(adapter))
-			return -ENOMEM;
+		if ((rc = slic_rspqueue_init(adapter)))
+			goto err;
+		if ((rc = slic_cmdq_init(adapter)))
+			goto err;
+		if ((rc = slic_rcvqueue_init(adapter)))
+			goto err;
 		adapter->queues_initialized = 1;
 	}
 
@@ -1553,7 +1554,8 @@ static int slic_if_init(struct adapter *adapter)
 	slic_link_config(adapter, LINK_AUTOSPEED, LINK_AUTOD);
 	slic_link_event_handler(adapter);
 
-	return 0;
+err:
+	return rc;
 }
 
 static void slic_unmap_mmio_space(struct adapter *adapter)
-- 
1.7.0.4

