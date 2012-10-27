Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab2J0QGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 12:06:19 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63097 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759160Ab2J0QGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 12:06:18 -0400
Date: Sat, 27 Oct 2012 09:03:47 -0700
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] zram: handle mem suffixes in disk size zram_sysfs
 parameter
Message-ID: <20121027160347.GB4771@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  zram: handle mem suffixes in disk size zram_sysfs parameter

  Use memparse() to allow mem suffixes in disksize sysfs number.
  Examples:
       echo 256K > /sys/block/zram0/disksize
       echo 512M > /sys/block/zram0/disksize
       echo 1G > /sys/block/zram0/disksize
    
  Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/staging/zram/zram_sysfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index edb0ed4..6be318e 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -15,6 +15,7 @@
 #include <linux/device.h>
 #include <linux/genhd.h>
 #include <linux/mm.h>
+#include <linux/kernel.h>
 
 #include "zram_drv.h"
 
@@ -54,13 +55,12 @@ static ssize_t disksize_show(struct device *dev,
 static ssize_t disksize_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
-	int ret;
 	u64 disksize;
 	struct zram *zram = dev_to_zram(dev);
 
-	ret = kstrtoull(buf, 10, &disksize);
-	if (ret)
-		return ret;
+	disksize = memparse(buf, NULL);
+	if (disksize < 1)
+		return -EINVAL;
 
 	down_write(&zram->init_lock);
 	if (zram->init_done) {

