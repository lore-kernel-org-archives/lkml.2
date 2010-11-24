Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0KXQWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:22:32 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:44232 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab0KXQWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:22:31 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>
Subject: [PATCHv5 09/17] pps: do not disable interrupts for idr operations
Date: Wed, 24 Nov 2010 19:15:47 +0300
Message-Id: <7d80c35f628a85c7db2123eca5794aea8e9a92e7.1290599845.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1290599843.git.lasaine@lvk.cs.msu.su>
References: <cover.1290599843.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now pps_idr_lock is never used in interrupt context so replace
spin_lock_irq/spin_unlock_irq with plain spin_lock/spin_unlock.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/pps.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 79b4455..54964a5 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -239,9 +239,9 @@ static void pps_device_destruct(struct device *dev)
 
 	/* release id here to protect others from using it while it's
 	 * still in use */
-	spin_lock_irq(&pps_idr_lock);
+	spin_lock(&pps_idr_lock);
 	idr_remove(&pps_idr, pps->id);
-	spin_unlock_irq(&pps_idr_lock);
+	spin_unlock(&pps_idr_lock);
 
 	kfree(dev);
 	kfree(pps);
@@ -260,9 +260,9 @@ int pps_register_cdev(struct pps_device *pps)
 	 * After idr_get_new() calling the new source will be freely available
 	 * into the kernel.
 	 */
-	spin_lock_irq(&pps_idr_lock);
+	spin_lock(&pps_idr_lock);
 	err = idr_get_new(&pps_idr, pps, &pps->id);
-	spin_unlock_irq(&pps_idr_lock);
+	spin_unlock(&pps_idr_lock);
 
 	if (err < 0)
 		return err;
@@ -302,9 +302,9 @@ del_cdev:
 	cdev_del(&pps->cdev);
 
 free_idr:
-	spin_lock_irq(&pps_idr_lock);
+	spin_lock(&pps_idr_lock);
 	idr_remove(&pps_idr, pps->id);
-	spin_unlock_irq(&pps_idr_lock);
+	spin_unlock(&pps_idr_lock);
 
 	return err;
 }
-- 
1.7.2.3

