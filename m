Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab0IKPzJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 11:55:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62408 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab0IKPzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 11:55:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH] loop: fix double BKL lock
Date: Sat, 11 Sep 2010 17:54:59 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009111754.59381.arnd@arndb.de>
X-Provags-ID: V02:K0:Zh86vik6gJlWMi5g6SOVmlLfZrsabhX9oxOz0SYKkbR
 LoGt2FMYxETARXn0WjDAuD9zkEbavsmxHiTgJGVOAAspSJs28i
 xq5AY13uBwKNLwi9EP1z/6AQkxRK3Dc/swRtWeXSIynnehjkaH
 kP0mUMzikHX1xjQ9ZGHM4Prjm1sKc4l9Emb3VIgMmwA+y8fFNj
 SwMUf9aZsPZNr46tsfAEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 6e9624b8c "block: push down BKL into .open and .release"
accidentally introduced an extra lock_kernel() instead of
unlock_kernel(). Because of the recursiveness and
release-while-sleeping properties of the BKL, this did
not do much harm, but is incorrect nonetheless.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---

Please apply before 2.6.36

 drivers/block/loop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 91797bb..d311e38 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1448,7 +1448,7 @@ static int lo_release(struct gendisk *disk, fmode_t mode)
 out:
 	mutex_unlock(&lo->lo_ctl_mutex);
 out_unlocked:
-	lock_kernel();
+	unlock_kernel();
 	return 0;
 }
 
-- 
1.7.1

