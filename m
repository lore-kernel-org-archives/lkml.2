Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab0COUij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 16:38:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59759 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab0COUif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 16:38:35 -0400
Date: Mon, 15 Mar 2010 21:38:31 +0100
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv3] USB: f_mass_storage: dynamic buffers for better alignment
In-reply-to: <op.u9mjqvz87p4s8u@pikus>
To: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Felipe Balbi <me@felipebalbi.com>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <99772ee77bb5e3bf56f115bd0b28786218e08662.1268682738.git.mina86@mina86.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <op.u9mjqvz87p4s8u@pikus>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Static" buffers in fsg_buffhd structure (ie. fields which are arrays
rather then pointers to dynamically allocated memory) are not aligned
to any "big" power of two which may lead to poor DMA performance
(copying "by hand" of head or tail) or no DMA at all even if otherwise
hardware supports it.

Therefore, this patch makes mass storage function use kmalloc()ed
buffers which are (because of their size) page aligned (which should
be enough for any hardware).

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/f_mass_storage.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

 The buffhds buffers initialisation loop has been refactored.
 Hopefully it's more pleasent to look at now. ;)

 PS. Someone should flog me with a willow branch...  Sorry for the
     previous mail, it was obviously an invalid file.  I must stop
     sending patches after 9pm...

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 84f6491..8945573 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -302,7 +302,6 @@ static const char fsg_string_interface[] = "Mass Storage";
 
 
 #define FSG_NO_INTR_EP 1
-#define FSG_BUFFHD_STATIC_BUFFER 1
 #define FSG_NO_DEVICE_STRINGS    1
 #define FSG_NO_OTG               1
 #define FSG_NO_INTR_EP           1
@@ -2747,13 +2746,19 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 
 
 	/* Data buffers cyclic list */
-	/* Buffers in buffhds are static -- no need for additional
-	 * allocation. */
 	bh = common->buffhds;
-	i = FSG_NUM_BUFFERS - 1;
+	i = FSG_NUM_BUFFERS;
+	goto buffhds_first_it;
 	do {
 		bh->next = bh + 1;
-	} while (++bh, --i);
+		++bh;
+buffhds_first_it:
+		bh->buf = kmalloc(FSG_BUFLEN, GFP_KERNEL);
+		if (unlikely(!bh->buf)) {
+			rc = -ENOMEM;
+			goto error_release;
+		}
+	} while (--i);
 	bh->next = common->buffhds;
 
 
@@ -2861,6 +2865,7 @@ static void fsg_common_release(struct kref *ref)
 		container_of(ref, struct fsg_common, ref);
 	unsigned i = common->nluns;
 	struct fsg_lun *lun = common->luns;
+	struct fsg_buffhd *bh;
 
 	/* If the thread isn't already dead, tell it to exit now */
 	if (common->state != FSG_STATE_TERMINATED) {
@@ -2882,6 +2887,13 @@ static void fsg_common_release(struct kref *ref)
 	}
 
 	kfree(common->luns);
+
+	i = FSG_NUM_BUFFERS;
+	bh = common->buffhds;
+	do {
+		kfree(bh->buf);
+	} while (++bh, --i);
+
 	if (common->free_storage_on_release)
 		kfree(common);
 }
-- 
1.7.0

