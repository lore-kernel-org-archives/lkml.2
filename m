Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab0FGMlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:41:14 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14933 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab0FGMj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:39:29 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 07 Jun 2010 14:39:51 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv4 04/13] USB: gadget: composite: usb_string_ids_*() functions
 added
In-reply-to: <897d8ae37d4fa2fdb7dad8787add81c720581313.1275906835.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org, linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <b34cbaab37bf0590cb254a03478c5297bc4a1723.1275906835.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <cover.1275906835.git.m.nazarewicz@samsung.com>
 <72866638a69b660e3eb534330937955d15dde4de.1275906835.git.m.nazarewicz@samsung.com>
 <df04b95ee38845c46fa735c3e53768f57f94f748.1275906835.git.m.nazarewicz@samsung.com>
 <897d8ae37d4fa2fdb7dad8787add81c720581313.1275906835.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb_string_ids_tab() and usb_string_ids_n() functions added to
the composite framework.  The first accepts an array of
usb_string object and for each registeres a string id and the
second registeres a given number of ids and returns the first.

This may simplify string ids registration since gadgets and
composite functions won't have to call usb_string_id() several
times and each time check for errer status -- all this will be
done with a single call.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/composite.c |   71 +++++++++++++++++++++++++++++++++++++--
 include/linux/usb/composite.h  |    4 ++
 2 files changed, 71 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 391d169..125167e 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -673,20 +673,83 @@ static int get_string(struct usb_composite_dev *cdev,
  * string IDs.  Drivers for functions, configurations, or gadgets will
  * then store that ID in the appropriate descriptors and string table.
  *
- * All string identifier should be allocated using this routine, to
- * ensure that for example different functions don't wrongly assign
- * different meanings to the same identifier.
+ * All string identifier should be allocated using this,
+ * @usb_string_ids_tab() or @usb_string_ids_n() routine, to ensure
+ * that for example different functions don't wrongly assign different
+ * meanings to the same identifier.
  */
 int usb_string_id(struct usb_composite_dev *cdev)
 {
 	if (cdev->next_string_id < 254) {
-		/* string id 0 is reserved */
+		/* string id 0 is reserved by USB spec for list of
+		 * supported languages */
+		/* 255 reserved as well? -- mina86 */
 		cdev->next_string_id++;
 		return cdev->next_string_id;
 	}
 	return -ENODEV;
 }
 
+/**
+ * usb_string_ids() - allocate unused string IDs in batch
+ * @cdev: the device whose string descriptor IDs are being allocated
+ * @str: an array of usb_string objects to assign numbers to
+ * Context: single threaded during gadget setup
+ *
+ * @usb_string_ids() is called from bind() callbacks to allocate
+ * string IDs.  Drivers for functions, configurations, or gadgets will
+ * then copy IDs from the string table to the appropriate descriptors
+ * and string table for other languages.
+ *
+ * All string identifier should be allocated using this,
+ * @usb_string_id() or @usb_string_ids_n() routine, to ensure that for
+ * example different functions don't wrongly assign different meanings
+ * to the same identifier.
+ */
+int usb_string_ids_tab(struct usb_composite_dev *cdev, struct usb_string *str)
+{
+	int next = cdev->next_string_id;
+
+	for (; str->s; ++str) {
+		if (unlikely(next >= 254))
+			return -ENODEV;
+		str->id = ++next;
+	}
+
+	cdev->next_string_id = next;
+
+	return 0;
+}
+
+/**
+ * usb_string_ids_n() - allocate unused string IDs in batch
+ * @cdev: the device whose string descriptor IDs are being allocated
+ * @n: number of string IDs to allocate
+ * Context: single threaded during gadget setup
+ *
+ * Returns the first requested ID.  This ID and next @n-1 IDs are now
+ * valid IDs.  At least providind that @n is non zore because if it
+ * is, returns last requested ID which is now very useful information.
+ *
+ * @usb_string_ids_n() is called from bind() callbacks to allocate
+ * string IDs.  Drivers for functions, configurations, or gadgets will
+ * then store that ID in the appropriate descriptors and string table.
+ *
+ * All string identifier should be allocated using this,
+ * @usb_string_id() or @usb_string_ids_n() routine, to ensure that for
+ * example different functions don't wrongly assign different meanings
+ * to the same identifier.
+ */
+int usb_string_ids_n(struct usb_composite_dev *c, unsigned n)
+{
+	unsigned next = c->next_string_id;
+	if (unlikely(n > 254 || (unsigned)next + n > 254))
+		return -ENODEV;
+	c->next_string_id += n;
+	return next + 1;
+}
+
+
 /*-------------------------------------------------------------------------*/
 
 static void composite_setup_complete(struct usb_ep *ep, struct usb_request *req)
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 139353e..f378075 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -342,6 +342,10 @@ struct usb_composite_dev {
 };
 
 extern int usb_string_id(struct usb_composite_dev *c);
+extern int usb_string_ids_tab(struct usb_composite_dev *c,
+			      struct usb_string *str);
+extern int usb_string_ids_n(struct usb_composite_dev *c, unsigned n);
+
 
 /* messaging utils */
 #define DBG(d, fmt, args...) \
-- 
1.7.1

