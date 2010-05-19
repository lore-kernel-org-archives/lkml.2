Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab0ESJFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:05:42 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22844 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab0ESJEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:04:04 -0400
Date: Wed, 19 May 2010 11:04:19 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 5/8] USB: gadget: f_fs: use usb_string_ids_n()
In-reply-to: <906519813412e3970e06499f0dbe2823280ed54a.1274187425.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <a2865e8e9c3a9a305833ffea9caaec661082d5cf.1274187425.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1274187425.git.m.nazarewicz@samsung.com>
 <6577770c2519efd2193ed6454dcd895472bba404.1274187425.git.m.nazarewicz@samsung.com>
 <f888a55a4bd4d631c0d36e8463bb5bbb8e9d7a3d.1274187425.git.m.nazarewicz@samsung.com>
 <d38bd775a3b1c58255e19fda826cae7aa66a0a20.1274187425.git.m.nazarewicz@samsung.com>
 <906519813412e3970e06499f0dbe2823280ed54a.1274187425.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use usb_string_ids_n() function to simplify string ids
registeration.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/f_fs.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 3fe120f..ffc0001 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1377,7 +1377,8 @@ static void ffs_data_reset(struct ffs_data *ffs)
 
 static int functionfs_bind(struct ffs_data *ffs, struct usb_composite_dev *cdev)
 {
-	unsigned i, count;
+	struct usb_gadget_strings **lang;
+	unsigned first_id;
 
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
@@ -1393,25 +1396,17 @@ static int functionfs_bind(struct ffs_data *ffs, struct usb_composite_dev *cdev)
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
+	lang = ffs->stringtabs;
+	while (*lang) {
+		struct usb_string *str = (*lang)->strings;
+		int id = first_id;
+		for (; str->s; ++id, ++str) {
+			str->id = id;
 		}
-
-		lang = ffs->stringtabs;
-		do {
-			(*lang)->strings[i].id = id;
-			++lang;
-		} while (*lang);
 	}
 
 	ffs->gadget = cdev->gadget;
+	ffs_data_get(ffs);
 	return 0;
 }
 
-- 
1.7.1

