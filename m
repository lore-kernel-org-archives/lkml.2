Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965814Ab0COU2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 16:28:13 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59445 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936715Ab0COU2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 16:28:01 -0400
Date: Mon, 15 Mar 2010 21:28:00 +0100
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: f_mass_storage: dynamic buffers for better alignment
In-reply-to: <op.u9mjqvz87p4s8u@pikus>
To: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Felipe Balbi <me@felipebalbi.com>,
       Michal Nazarewicz <mina86@mina86.com>
Message-id: <99772ee77bb5e3bf56f115bd0b28786218e08662.1268682737.git.mina86@mina86.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <op.u9mjqvz87p4s8u@pikus>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

Using of "static" buffers in fsg_buffhd structure causes buffers
not to be aligned to any bigger power of two (like cache size for
instance) which as a result may lead to some copying of data or
slower DMA access (as head must to be copied via CPU).  So even
though code gets a bit more complicated this patch changes the
behaviour of mass storage function to use kmalloc()ed buffers which
are (because of their size) page aligned -- that should be enought
for any DMA or other hardware.
---
 drivers/usb/gadget/f_mass_storage.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 84f6491..eff339d 100644
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
 
 
@@ -2861,6 +2866,7 @@ static void fsg_common_release(struct kref *ref)
 		container_of(ref, struct fsg_common, ref);
 	unsigned i = common->nluns;
 	struct fsg_lun *lun = common->luns;
+	struct fsg_buffhd *bh;
 
 	/* If the thread isn't already dead, tell it to exit now */
 	if (common->state != FSG_STATE_TERMINATED) {
@@ -2882,6 +2888,13 @@ static void fsg_common_release(struct kref *ref)
 	}
 
 	kfree(common->luns);
+
+	i = FSG_BUFFHD;
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

