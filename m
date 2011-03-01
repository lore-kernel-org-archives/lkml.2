Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab1CAXN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 18:13:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52102 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756971Ab1CAXNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 18:13:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/7] staging/cx25721: serialize access to devlist
Date: Wed,  2 Mar 2011 00:13:06 +0100
Message-Id: <1299021191-17961-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299021191-17961-1-git-send-email-arnd@arndb.de>
References: <1299021191-17961-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:66glkGnHsOoVyilN/8jf6qsWZ/q0Yc2l7lBPh4DIqZK
 QDTmXeJQmsHn6dyh+vIPm2f5w16G2Qs1+4eU1UrC/em8zM/YjO
 ae246l8/aJZGgIiKGrs8/k2bQ1Ql5n2NAyfxyucnT0L0dILeiv
 YRWWclFaA1qaA+EnZSOB3kUk8khj2+WRjrp8YI67Ug7Yo031iS
 Ga0FmHUJyhwcEHNNJ7w6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Out of the three files accessing the device list,
one uses a mutex, one uses the BKL and one does
not have any locking. That is of course pointless,
so let's make all of them use the same mutex,
and get rid of one more BKL user.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/cx25821/Kconfig         |    1 -
 drivers/staging/cx25821/cx25821-alsa.c  |    2 ++
 drivers/staging/cx25821/cx25821-core.c  |   16 +++++++---------
 drivers/staging/cx25821/cx25821-video.c |    9 ++++-----
 drivers/staging/cx25821/cx25821.h       |    3 ++-
 5 files changed, 15 insertions(+), 16 deletions(-)

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
diff --git a/drivers/staging/cx25821/cx25821-alsa.c b/drivers/staging/cx25821/cx25821-alsa.c
index 160f669..ebdba7c 100644
--- a/drivers/staging/cx25821/cx25821-alsa.c
+++ b/drivers/staging/cx25821/cx25821-alsa.c
@@ -770,10 +770,12 @@ static int cx25821_alsa_init(void)
 	struct cx25821_dev *dev = NULL;
 	struct list_head *list;
 
+	mutex_lock(&cx25821_devlist_mutex);
 	list_for_each(list, &cx25821_devlist) {
 		dev = list_entry(list, struct cx25821_dev, devlist);
 		cx25821_audio_initdev(dev);
 	}
+	mutex_unlock(&cx25821_devlist_mutex);
 
 	if (dev == NULL)
 		pr_info("ERROR ALSA: no cx25821 cards found\n");
diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
index a216b62..523ac5e 100644
--- a/drivers/staging/cx25821/cx25821-core.c
+++ b/drivers/staging/cx25821/cx25821-core.c
@@ -33,9 +33,6 @@ MODULE_DESCRIPTION("Driver for Athena cards");
 MODULE_AUTHOR("Shu Lin - Hiep Huynh");
 MODULE_LICENSE("GPL");
 
-struct list_head cx25821_devlist;
-EXPORT_SYMBOL(cx25821_devlist);
-
 static unsigned int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "enable debug messages");
@@ -46,8 +43,10 @@ MODULE_PARM_DESC(card, "card type");
 
 static unsigned int cx25821_devcount;
 
-static DEFINE_MUTEX(devlist);
+DEFINE_MUTEX(cx25821_devlist_mutex);
+EXPORT_SYMBOL(cx25821_devlist_mutex);
 LIST_HEAD(cx25821_devlist);
+EXPORT_SYMBOL(cx25821_devlist);
 
 struct sram_channel cx25821_sram_channels[] = {
 	[SRAM_CH00] = {
@@ -911,9 +910,9 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 	dev->nr = ++cx25821_devcount;
 	sprintf(dev->name, "cx25821[%d]", dev->nr);
 
-	mutex_lock(&devlist);
+	mutex_lock(&cx25821_devlist_mutex);
 	list_add_tail(&dev->devlist, &cx25821_devlist);
-	mutex_unlock(&devlist);
+	mutex_unlock(&cx25821_devlist_mutex);
 
 	strcpy(cx25821_boards[UNKNOWN_BOARD].name, "unknown");
 	strcpy(cx25821_boards[CX25821_BOARD].name, "cx25821");
@@ -1465,9 +1464,9 @@ static void __devexit cx25821_finidev(struct pci_dev *pci_dev)
 	if (pci_dev->irq)
 		free_irq(pci_dev->irq, dev);
 
-	mutex_lock(&devlist);
+	mutex_lock(&cx25821_devlist_mutex);
 	list_del(&dev->devlist);
-	mutex_unlock(&devlist);
+	mutex_unlock(&cx25821_devlist_mutex);
 
 	cx25821_dev_unregister(dev);
 	v4l2_device_unregister(v4l2_dev);
@@ -1501,7 +1500,6 @@ static struct pci_driver cx25821_pci_driver = {
 
 static int __init cx25821_init(void)
 {
-	INIT_LIST_HEAD(&cx25821_devlist);
 	pr_info("driver version %d.%d.%d loaded\n",
 		(CX25821_VERSION_CODE >> 16) & 0xff,
 		(CX25821_VERSION_CODE >> 8) & 0xff,
diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 0d8d756..ab05392 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -27,7 +27,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include "cx25821-video.h"
-#include <linux/smp_lock.h>
 
 MODULE_DESCRIPTION("v4l2 driver module for cx25821 based TV cards");
 MODULE_AUTHOR("Hiep Huynh <hiep.huynh@conexant.com>");
@@ -815,7 +814,7 @@ static int video_open(struct file *file)
        if (NULL == fh)
 	       return -ENOMEM;
 
-       lock_kernel();
+	mutex_lock(&cx25821_devlist_mutex);
 
        list_for_each(list, &cx25821_devlist)
        {
@@ -832,8 +831,8 @@ static int video_open(struct file *file)
        }
 
        if (NULL == dev) {
-	       unlock_kernel();
-	       return -ENODEV;
+		mutex_unlock(&cx25821_devlist_mutex);
+		return -ENODEV;
        }
 
        file->private_data = fh;
@@ -862,7 +861,7 @@ static int video_open(struct file *file)
 			      sizeof(struct cx25821_buffer), fh, NULL);
 
        dprintk(1, "post videobuf_queue_init()\n");
-       unlock_kernel();
+	mutex_unlock(&cx25821_devlist_mutex);
 
        return 0;
 }
diff --git a/drivers/staging/cx25821/cx25821.h b/drivers/staging/cx25821/cx25821.h
index 5511523..6230243 100644
--- a/drivers/staging/cx25821/cx25821.h
+++ b/drivers/staging/cx25821/cx25821.h
@@ -31,7 +31,6 @@
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/kdev_t.h>
-#include <linux/smp_lock.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
@@ -445,6 +444,8 @@ static inline struct cx25821_dev *get_cx25821(struct v4l2_device *v4l2_dev)
 	v4l2_device_call_all(&dev->v4l2_dev, 0, o, f, ##args)
 
 extern struct list_head cx25821_devlist;
+extern struct mutex cx25821_devlist_mutex;
+
 extern struct cx25821_board cx25821_boards[];
 extern struct cx25821_subid cx25821_subids[];
 
-- 
1.7.1

