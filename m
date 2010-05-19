Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab0ESJEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:04:05 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22844 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab0ESJEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:04:00 -0400
Date: Wed, 19 May 2010 11:04:18 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 4/8] USB: gadget: composite: usb_string_ids_*() functions added
In-reply-to: <d38bd775a3b1c58255e19fda826cae7aa66a0a20.1274187425.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <906519813412e3970e06499f0dbe2823280ed54a.1274187425.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1274187425.git.m.nazarewicz@samsung.com>
 <6577770c2519efd2193ed6454dcd895472bba404.1274187425.git.m.nazarewicz@samsung.com>
 <f888a55a4bd4d631c0d36e8463bb5bbb8e9d7a3d.1274187425.git.m.nazarewicz@samsung.com>
 <d38bd775a3b1c58255e19fda826cae7aa66a0a20.1274187425.git.m.nazarewicz@samsung.com>
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
 drivers/usb/gadget/composite.c |   67 ++++++++++++++++++++++++++++++++++++++--
 include/linux/usb/composite.h  |    4 ++
 2 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 391d169..cd1a952 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -673,9 +673,10 @@ static int get_string(struct usb_composite_dev *cdev,
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
@@ -687,6 +688,66 @@ int usb_string_id(struct usb_composite_dev *cdev)
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
+		if (unlikely(next == 255))
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
+	if (unlikely(n > 254 || (unsigned)next + n > 255))
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

