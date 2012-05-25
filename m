Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab2EYIGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 04:06:13 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:31812 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755898Ab2EYIFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 04:05:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAIo8v09bdWOb/2dsb2JhbABEtRCBB4IWAQUnUhBRVwYTiBG7SJBHA5UYj3CCYg
X-IronPort-AV: E=Sophos;i="4.75,655,1330902000"; 
   d="scan'208";a="995215623"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] Staging: ipack/bridges/tpci200: fix kernel oops when uninstalling a device
Date: Fri, 25 May 2012 10:03:05 +0200
Message-Id: <1337932985-10668-5-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337932985-10668-1-git-send-email-siglesias@igalia.com>
References: <1337932985-10668-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When uninstalling a device, the call to the ipack_bus_ops remove() frees
resources in the ipack device driver but without unregistering the device.

It generates a kernel oops when somebody wants to unregister the device.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index e04cb8a..46127bc 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -751,23 +751,12 @@ out:
 	return res;
 }
 
-static void tpci200_slot_remove(struct tpci200_slot *slot)
-{
-	if ((slot->dev == NULL) ||
-	    (slot->dev->driver == NULL) ||
-	    (slot->dev->driver->ops == NULL) ||
-	    (slot->dev->driver->ops->remove == NULL))
-		return;
-
-	slot->dev->driver->ops->remove(slot->dev);
-}
-
 static void tpci200_uninstall(struct tpci200_board *tpci200)
 {
 	int i;
 
 	for (i = 0; i < TPCI200_NB_SLOT; i++)
-		tpci200_slot_remove(&tpci200->slots[i]);
+		tpci200_slot_unregister(tpci200->slots[i].dev);
 
 	tpci200_unregister(tpci200);
 	kfree(tpci200->slots);
-- 
1.7.10

