Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab1DNH6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 03:58:52 -0400
Received: from mail.ispras.ru ([83.149.199.43]:47923 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab1DNH6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:58:51 -0400
Message-ID: <4DA6A8C9.3060705@ispras.ru>
Date: Thu, 14 Apr 2011 11:56:57 +0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: fix unchecked interruptible mutex locks
References: <4DA698BE.70903@ispras.ru> <20110414170814.40f4d3eb@notabene.brown>
In-Reply-To: <20110414170814.40f4d3eb@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 11:08 AM, NeilBrown wrote:
> 
> I would mark mddev_lock as __must_check__ (or however it is spelt) and fix
> the errors produced.
> 
> I think the call in md_stop_writes is the only one where an uninterruptible
> wait is needed - I'd probaby just change that to an explicit "mutex_lock",
> but I wouldn't be against creating "mddev_lock_uninterruptible" for that case.
> 

That is fine for me, but actually I do not see a good way to fix 
rdev_size_store as well (at least for mddev_lock(my_mddev)).
Please find another try.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/md/md.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b12b377..4f83f16 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -623,11 +623,16 @@ static mddev_t * mddev_find(dev_t unit)
 	goto retry;
 }
 
-static inline int mddev_lock(mddev_t * mddev)
+static inline int __must_check mddev_lock(mddev_t *mddev)
 {
 	return mutex_lock_interruptible(&mddev->reconfig_mutex);
 }
 
+static inline void mddev_lock_uninterruptible(mddev_t *mddev)
+{
+	return mutex_lock(&mddev->reconfig_mutex);
+}
+
 static inline int mddev_is_locked(mddev_t *mddev)
 {
 	return mutex_is_locked(&mddev->reconfig_mutex);
@@ -2610,13 +2615,18 @@ rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 		 */
 		mddev_t *mddev;
 		int overlap = 0;
+		int intr = 0;
 		struct list_head *tmp;
 
 		mddev_unlock(my_mddev);
 		for_each_mddev(mddev, tmp) {
 			mdk_rdev_t *rdev2;
 
-			mddev_lock(mddev);
+			if (mddev_lock(mddev)) {
+				mddev_put(mddev);
+				intr = 1;
+				break;
+			}
 			list_for_each_entry(rdev2, &mddev->disks, same_set)
 				if (rdev->bdev == rdev2->bdev &&
 				    rdev != rdev2 &&
@@ -2632,8 +2642,8 @@ rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 				break;
 			}
 		}
-		mddev_lock(my_mddev);
-		if (overlap) {
+		mddev_lock_uninterruptible(my_mddev);
+		if (overlap || intr) {
 			/* Someone else could have slipped in a size
 			 * change here, but doing so is just silly.
 			 * We put oldsectors back because we *know* it is
@@ -2641,7 +2651,7 @@ rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 			 * itself
 			 */
 			rdev->sectors = oldsectors;
-			return -EBUSY;
+			return overlap ? -EBUSY : -EINTR;
 		}
 	}
 	return len;
@@ -4748,7 +4758,7 @@ static void __md_stop_writes(mddev_t *mddev)
 
 void md_stop_writes(mddev_t *mddev)
 {
-	mddev_lock(mddev);
+	mddev_lock_uninterruptible(mddev);
 	__md_stop_writes(mddev);
 	mddev_unlock(mddev);
 }
-- 
1.7.1
