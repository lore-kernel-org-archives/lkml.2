Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab0FGMj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:39:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35000 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab0FGMjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:39:22 -0400
Date: Mon, 07 Jun 2010 14:39:52 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv4 05/13] USB: gadget: f_fs: use usb_string_ids_n()
In-reply-to: <b34cbaab37bf0590cb254a03478c5297bc4a1723.1275906835.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org, linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <7781ec0d22fa9dde7afbd3bf915af1a592780938.1275906835.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1275906835.git.m.nazarewicz@samsung.com>
 <72866638a69b660e3eb534330937955d15dde4de.1275906835.git.m.nazarewicz@samsung.com>
 <df04b95ee38845c46fa735c3e53768f57f94f748.1275906835.git.m.nazarewicz@samsung.com>
 <897d8ae37d4fa2fdb7dad8787add81c720581313.1275906835.git.m.nazarewicz@samsung.com>
 <b34cbaab37bf0590cb254a03478c5297bc4a1723.1275906835.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use usb_string_ids_n() function to simplify string ids
registeration.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/f_fs.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 3fe120f..97c2ac2 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1377,7 +1377,8 @@ static void ffs_data_reset(struct ffs_data *ffs)
 
 static int functionfs_bind(struct ffs_data *ffs, struct usb_composite_dev *cdev)
 {
-	unsigned i, count;
+	struct usb_gadget_strings **lang;
+	int first_id;
 
 	ENTER();
 
@@ -1385,7 +1386,9 @@ static int functionfs_bind(struct ffs_data *ffs, struct usb_composite_dev *cdev)
 		 || test_and_set_bit(FFS_FL_BOUND, &ffs->flags)))
 		return -EBADFD;
 
-	ffs_data_get(ffs);
+	first_id = usb_string_ids_n(cdev, ffs->strings_count);
+	if (unlikely(first_id < 0))
+		return first_id;
 
 	ffs->ep0req = usb_ep_alloc_request(cdev->gadget->ep0, GFP_KERNEL);
 	if (unlikely(!ffs->ep0req))
@@ -1393,25 +1396,16 @@ static int functionfs_bind(struct ffs_data *ffs, struct usb_composite_dev *cdev)
 	ffs->ep0req->complete = ffs_ep0_complete;
 	ffs->ep0req->context = ffs;
 
-	/* Get strings identifiers */
-	for (count = ffs->strings_count, i = 0; i < count; ++i) {
-		struct usb_gadget_strings **lang;
-
-		int id = usb_string_id(cdev);
-		if (unlikely(id < 0)) {
-			usb_ep_free_request(cdev->gadget->ep0, ffs->ep0req);
-			ffs->ep0req = NULL;
-			return id;
-		}
-
-		lang = ffs->stringtabs;
-		do {
-			(*lang)->strings[i].id = id;
-			++lang;
-		} while (*lang);
+	lang = ffs->stringtabs;
+	for (lang = ffs->stringtabs; *lang; ++lang) {
+		struct usb_string *str = (*lang)->strings;
+		int id = first_id;
+		for (; str->s; ++id, ++str)
+			str->id = id;
 	}
 
 	ffs->gadget = cdev->gadget;
+	ffs_data_get(ffs);
 	return 0;
 }
 
-- 
1.7.1

