Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab0E1Ow7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:52:59 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:29263 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab0E1Ow5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:52:57 -0400
Date: Fri, 28 May 2010 16:53:28 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv2.1] USB: gadget: f_fs: use usb_string_ids_n()
In-reply-to: <131cc4995ce27841167b6736acc52608c1bbe4b8.1275034701.git.mina86@mina86.com>
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <54abfa6a4d85d26eebc9048ca2433c9f5141552e.1275057895.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1275034701.git.mina86@mina86.com>
 <dd6695f08a16b6e1269ea5c66bb16df4ba2d2e7b.1275034701.git.mina86@mina86.com>
 <55e838d52a2b4e37372e16d4238a82421fed11d6.1275034701.git.mina86@mina86.com>
 <e42e64aab3be6e8018f3b75f1f230ef7c3fbd481.1275034701.git.mina86@mina86.com>
 <131cc4995ce27841167b6736acc52608c1bbe4b8.1275034701.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use usb_string_ids_n() function to simplify string ids
registeration.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
This fixes to silly bugs in my previous patch.  One was that first_id
was unsigned should "first_id < 0" would be always false and in the
"lang" loop I forgot to include ++lang.

 drivers/usb/gadget/f_fs.c |   29 +++++++++++------------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 3fe120f..b7c4905 100644
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
@@ -1393,25 +1396,15 @@ static int functionfs_bind(struct ffs_data *ffs, struct usb_composite_dev *cdev)
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
+	for (lang = ffs->stringtabs; *lang; ++lang) {
+		struct usb_string *str = (*lang)->strings;
+		unsigned id = first_id;
+		for (; str->s; ++id, ++str)
+			str->id = id;
 	}
 
 	ffs->gadget = cdev->gadget;
+	ffs_data_get(ffs);
 	return 0;
 }
 
-- 
1.7.1

