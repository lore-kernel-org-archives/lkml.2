Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab0LTLzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 06:55:11 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:56922 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505Ab0LTLzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 06:55:08 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>
Subject: [PATCHv7 08/16] pps: make idr lock a mutex and protect idr_pre_get
Date: Mon, 20 Dec 2010 14:54:51 +0300
Message-Id: <58999f51411566e1b9aad37f027f78e49ccb64ed.1292844387.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1292844387.git.lasaine@lvk.cs.msu.su>
References: <cover.1292604060.git.lasaine@lvk.cs.msu.su> <cover.1292844387.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now pps_idr_lock is never used in interrupt context so we can replace
spin_lock_irq/spin_unlock_irq with plain spin_lock/spin_unlock. But
there is also a potential race condition when someone can steal an id
which was allocated by idr_pre_get before it is used. So convert spin
lock to mutex and protect the whole id generation process.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/pps.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 79b4455..9e15cf1 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 #include <linux/uaccess.h>
 #include <linux/idr.h>
+#include <linux/mutex.h>
 #include <linux/cdev.h>
 #include <linux/poll.h>
 #include <linux/pps_kernel.h>
@@ -39,7 +40,7 @@
 static dev_t pps_devt;
 static struct class *pps_class;
 
-static DEFINE_SPINLOCK(pps_idr_lock);
+static DEFINE_MUTEX(pps_idr_lock);
 static DEFINE_IDR(pps_idr);
 
 /*
@@ -239,9 +240,9 @@ static void pps_device_destruct(struct device *dev)
 
 	/* release id here to protect others from using it while it's
 	 * still in use */
-	spin_lock_irq(&pps_idr_lock);
+	mutex_lock(&pps_idr_lock);
 	idr_remove(&pps_idr, pps->id);
-	spin_unlock_irq(&pps_idr_lock);
+	mutex_unlock(&pps_idr_lock);
 
 	kfree(dev);
 	kfree(pps);
@@ -252,17 +253,19 @@ int pps_register_cdev(struct pps_device *pps)
 	int err;
 	dev_t devt;
 
+	mutex_lock(&pps_idr_lock);
 	/* Get new ID for the new PPS source */
-	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0)
+	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0) {
+		mutex_unlock(&pps_idr_lock);
 		return -ENOMEM;
+	}
 
 	/* Now really allocate the PPS source.
 	 * After idr_get_new() calling the new source will be freely available
 	 * into the kernel.
 	 */
-	spin_lock_irq(&pps_idr_lock);
 	err = idr_get_new(&pps_idr, pps, &pps->id);
-	spin_unlock_irq(&pps_idr_lock);
+	mutex_unlock(&pps_idr_lock);
 
 	if (err < 0)
 		return err;
@@ -302,9 +305,9 @@ del_cdev:
 	cdev_del(&pps->cdev);
 
 free_idr:
-	spin_lock_irq(&pps_idr_lock);
+	mutex_lock(&pps_idr_lock);
 	idr_remove(&pps_idr, pps->id);
-	spin_unlock_irq(&pps_idr_lock);
+	mutex_unlock(&pps_idr_lock);
 
 	return err;
 }
-- 
1.7.2.3

