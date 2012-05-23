Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125Ab2EWN5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:57:36 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:50434 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755225Ab2EWNyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:54:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJHrvE9bdWOb/2dsb2JhbABDtDOBB4IWAQUnUhBRVwYBEogSukuQTwOVHIkehlKCbA
X-IronPort-AV: E=Sophos;i="4.75,645,1330902000"; 
   d="scan'208";a="518630125"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] Staging: ipack/bridges/tpci200: tpci200_slot_unmap_space() should return 0 if succeed.
Date: Wed, 23 May 2012 15:54:42 +0200
Message-Id: <1337781287-28628-4-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337781287-28628-1-git-send-email-siglesias@igalia.com>
References: <1337781287-28628-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tpci200_slot_unmap_space() should return 0 if the operation was properly done. If
not, the caller will think that something wrong happened.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 75ed600..85560c7 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -551,20 +551,15 @@ out:
 
 static int tpci200_slot_unmap_space(struct ipack_device *dev, int space)
 {
-	int res;
 	struct ipack_addr_space *virt_addr_space;
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
 
 	switch (space) {
 	case IPACK_IO_SPACE:
@@ -594,9 +589,8 @@ static int tpci200_slot_unmap_space(struct ipack_device *dev, int space)
 	default:
 		pr_err("Slot [%d:%d] space number %d doesn't exist !\n",
 		       dev->bus_nr, dev->slot, space);
-		res = -EINVAL;
-		goto out_unlock;
-		break;
+		mutex_unlock(&tpci200->mutex);
+		return -EINVAL;
 	}
 
 	iounmap(virt_addr_space->address);
@@ -605,8 +599,7 @@ static int tpci200_slot_unmap_space(struct ipack_device *dev, int space)
 	virt_addr_space->size = 0;
 out_unlock:
 	mutex_unlock(&tpci200->mutex);
-out:
-	return res;
+	return 0;
 }
 
 static int tpci200_slot_unregister(struct ipack_device *dev)
-- 
1.7.10

