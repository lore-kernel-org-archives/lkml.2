Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325Ab2FGJLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 05:11:10 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:45523 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760252Ab2FGJLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 05:11:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAM1v0E9bdWOb/2dsb2JhbABFhU6uToEHghkBBSMECwFGECUCJgICVwcSiA+mGJJhgSOOcIESA5UdiSOGV4Ji
X-IronPort-AV: E=Sophos;i="4.75,730,1330902000"; 
   d="scan'208";a="917638225"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: gregkh@linuxfoundation.org, siglesias@igalia.com, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH v2 1/9] Staging: ipack/bridges/tpci200: remove gotos in tpci200_free_irq().
Date: Thu,  7 Jun 2012 11:10:17 +0200
Message-Id: <1339060217-6896-1-git-send-email-magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339057498-5256-1-git-send-email-magomez@igalia.com>
References: <1339057498-5256-1-git-send-email-magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle error conditions with simple returns instead of usig gotos.

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
v2: release lock on success
---
 drivers/staging/ipack/bridges/tpci200.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index c39499a..68bcc55 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -512,24 +512,19 @@ static void __tpci200_free_irq(struct tpci200_board *tpci200,
 
 static int tpci200_free_irq(struct ipack_device *dev)
 {
-	int res;
 	struct slot_irq *slot_irq;
 	struct tpci200_board *tpci200;
 
 	tpci200 = check_slot(dev);
-	if (tpci200 == NULL) {
-		res = -EINVAL;
-		goto out;
-	}
+	if (tpci200 == NULL)
+		return -EINVAL;
 
-	if (mutex_lock_interruptible(&tpci200->mutex)) {
-		res = -ERESTARTSYS;
-		goto out;
-	}
+	if (mutex_lock_interruptible(&tpci200->mutex))
+		return -ERESTARTSYS;
 
 	if (tpci200->slots[dev->slot].irq == NULL) {
-		res = -EINVAL;
-		goto out_unlock;
+		mutex_unlock(&tpci200->mutex);
+		return -EINVAL;
 	}
 
 	__tpci200_free_irq(tpci200, dev);
@@ -537,10 +532,8 @@ static int tpci200_free_irq(struct ipack_device *dev)
 	tpci200->slots[dev->slot].irq = NULL;
 	kfree(slot_irq);
 
-out_unlock:
 	mutex_unlock(&tpci200->mutex);
-out:
-	return res;
+	return 0;
 }
 
 static int tpci200_slot_unmap_space(struct ipack_device *dev, int space)
-- 
1.7.9.5

