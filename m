Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab1CBNZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 08:25:49 -0500
Received: from cnxt09252.conexant.com ([198.62.9.252]:36348 "EHLO
	Cnxtsmtp1.conexant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab1CBNZs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 08:25:48 -0500
X-WSS-ID: 0LHFMMW-04-0DO-03
X-M-MSG: 
From: "Palash Bandyopadhyay" <Palash.Bandyopadhyay@conexant.com>
To: "Arnd Bergmann" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
Date: Wed, 2 Mar 2011 05:23:55 -0800
Subject: RE: [PATCH 2/7] staging/cx25721: serialize access to devlist
Thread-Topic: [PATCH 2/7] staging/cx25721: serialize access to devlist
Thread-Index: AcvYZkQ15yS+b+IhQl69YwnKERR77QAdtBlR
Message-ID: <34B38BE41EDBA046A4AFBB591FA31132024C3C65A2@NBMBX01.bbnet.ad>
References: <1299021191-17961-1-git-send-email-arnd@arndb.de>,<1299021191-17961-3-git-send-email-arnd@arndb.de>
In-Reply-To: <1299021191-17961-3-git-send-email-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 02 Mar 2011 13:25:00.0513 (UTC) FILETIME=[3B572510:01CBD8DD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks ok to me.

Signed-off-by: Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>

Thanks,
Palash
________________________________________
From: Arnd Bergmann [arnd@arndb.de]
Sent: Tuesday, March 01, 2011 3:13 PM
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann; Mauro Carvalho Chehab; Palash Bandyopadhyay; Greg Kroah-Hartman
Subject: [PATCH 2/7] staging/cx25721: serialize access to devlist

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
-       depends on BKL # please fix
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

+       mutex_lock(&cx25821_devlist_mutex);
        list_for_each(list, &cx25821_devlist) {
                dev = list_entry(list, struct cx25821_dev, devlist);
                cx25821_audio_initdev(dev);
        }
+       mutex_unlock(&cx25821_devlist_mutex);

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

-       mutex_lock(&devlist);
+       mutex_lock(&cx25821_devlist_mutex);
        list_add_tail(&dev->devlist, &cx25821_devlist);
-       mutex_unlock(&devlist);
+       mutex_unlock(&cx25821_devlist_mutex);

        strcpy(cx25821_boards[UNKNOWN_BOARD].name, "unknown");
        strcpy(cx25821_boards[CX25821_BOARD].name, "cx25821");
@@ -1465,9 +1464,9 @@ static void __devexit cx25821_finidev(struct pci_dev *pci_dev)
        if (pci_dev->irq)
                free_irq(pci_dev->irq, dev);

-       mutex_lock(&devlist);
+       mutex_lock(&cx25821_devlist_mutex);
        list_del(&dev->devlist);
-       mutex_unlock(&devlist);
+       mutex_unlock(&cx25821_devlist_mutex);

        cx25821_dev_unregister(dev);
        v4l2_device_unregister(v4l2_dev);
@@ -1501,7 +1500,6 @@ static struct pci_driver cx25821_pci_driver = {

 static int __init cx25821_init(void)
 {
-       INIT_LIST_HEAD(&cx25821_devlist);
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
+       mutex_lock(&cx25821_devlist_mutex);

        list_for_each(list, &cx25821_devlist)
        {
@@ -832,8 +831,8 @@ static int video_open(struct file *file)
        }

        if (NULL == dev) {
-              unlock_kernel();
-              return -ENODEV;
+               mutex_unlock(&cx25821_devlist_mutex);
+               return -ENODEV;
        }

        file->private_data = fh;
@@ -862,7 +861,7 @@ static int video_open(struct file *file)
                              sizeof(struct cx25821_buffer), fh, NULL);

        dprintk(1, "post videobuf_queue_init()\n");
-       unlock_kernel();
+       mutex_unlock(&cx25821_devlist_mutex);

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
Conexant E-mail Firewall (Conexant.Com) made the following annotations
---------------------------------------------------------------------
********************** Legal Disclaimer **************************** 

"This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 

********************************************************************** 

---------------------------------------------------------------------

