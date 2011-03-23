Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889Ab1CWNLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:11:52 -0400
Received: from mail1.elettra.trieste.it ([140.105.4.201]:61605 "EHLO
	elettra.trieste.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932671Ab1CWNLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:11:51 -0400
From: Alessio Igor Bogani <abogani@kernel.org>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH] staging: cx25821: Reuse the mutex lock for remove BKL
Date: Wed, 23 Mar 2011 14:11:03 +0100
Message-Id: <1300885863-16201-1-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL isn't exit anymore so this driver don't should use it.

Build tested only.

Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
---
 drivers/staging/cx25821/Kconfig         |    1 -
 drivers/staging/cx25821/cx25821-video.c |    8 ++++----
 drivers/staging/cx25821/cx25821.h       |    1 -
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/cx25821/Kconfig b/drivers/staging/cx25821/Kconfig
index b265695..5f6b542 100644
--- a/drivers/staging/cx25821/Kconfig
+++ b/drivers/staging/cx25821/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_CX25821
 	tristate "Conexant cx25821 support"
 	depends on DVB_CORE && VIDEO_DEV && PCI && I2C
-	depends on BKL # please fix
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEO_TVEEPROM
diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 0d8d756..9dbe551 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -27,7 +27,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include "cx25821-video.h"
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 MODULE_DESCRIPTION("v4l2 driver module for cx25821 based TV cards");
 MODULE_AUTHOR("Hiep Huynh <hiep.huynh@conexant.com>");
@@ -815,7 +815,7 @@ static int video_open(struct file *file)
        if (NULL == fh)
 	       return -ENOMEM;
 
-       lock_kernel();
+       mutex_lock(&h->lock);
 
        list_for_each(list, &cx25821_devlist)
        {
@@ -832,7 +832,7 @@ static int video_open(struct file *file)
        }
 
        if (NULL == dev) {
-	       unlock_kernel();
+	       mutex_unlock(&h->lock);
 	       return -ENODEV;
        }
 
@@ -862,7 +862,7 @@ static int video_open(struct file *file)
 			      sizeof(struct cx25821_buffer), fh, NULL);
 
        dprintk(1, "post videobuf_queue_init()\n");
-       unlock_kernel();
+       mutex_unlock(&h->lock);
 
        return 0;
 }
diff --git a/drivers/staging/cx25821/cx25821.h b/drivers/staging/cx25821/cx25821.h
index 5511523..8417a73 100644
--- a/drivers/staging/cx25821/cx25821.h
+++ b/drivers/staging/cx25821/cx25821.h
@@ -31,7 +31,6 @@
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/kdev_t.h>
-#include <linux/smp_lock.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
-- 
1.7.0.4

