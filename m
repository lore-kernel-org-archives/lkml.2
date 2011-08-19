Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab1HSWeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 18:34:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27884 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab1HSWdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 18:33:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:x-system-of-record;
	b=DtbEquY/0KKNhrF4xH2clqBFqW1A1lXEjdGfjomKt52reUe1Wudzi/N9lbwHQNDOG
	Xj/O25ARCJeuH6JTkiicQ==
From: Michal Nazarewicz <mnazarewicz@google.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3 1/4] usb: Provide usb_device_speed_name() function
Date: Sat, 20 Aug 2011 00:32:59 +0200
Message-Id: <7e9435f5e8c2e9d6363d79de79f81b4f259e230c.1313791722.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1313791722.git.mina86@mina86.com>
References: <cover.1313791722.git.mina86@mina86.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

In a few places kernel wants to print a human-readable USB
device speed name (eg. "high") instead of a raw number
(eg. 3).  Usually a switch is introduced in those places
leading to code repetition.  To mitigate this issue, this
commit introduces usb_device_speed_name() function, which
returns a human-readable name of provided speed.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/Makefile          |    3 +++
 drivers/usb/common.c          |   24 ++++++++++++++++++++++++
 drivers/usb/gadget/udc-core.c |   19 ++-----------------
 include/linux/usb/ch9.h       |    8 ++++++++
 4 files changed, 37 insertions(+), 17 deletions(-)
 create mode 100644 drivers/usb/common.c

diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
index 30ddf8d..a3167cc 100644
--- a/drivers/usb/Makefile
+++ b/drivers/usb/Makefile
@@ -51,3 +51,6 @@ obj-$(CONFIG_USB_MUSB_HDRC)	+= musb/
 obj-$(CONFIG_USB_RENESAS_USBHS)	+= renesas_usbhs/
 obj-$(CONFIG_USB_OTG_UTILS)	+= otg/
 obj-$(CONFIG_USB_GADGET)	+= gadget/
+
+obj-$(CONFIG_USB)		+= common.o
+obj-$(CONFIG_USB_GADGET)	+= common.o
diff --git a/drivers/usb/common.c b/drivers/usb/common.c
new file mode 100644
index 0000000..e9d7141
--- /dev/null
+++ b/drivers/usb/common.c
@@ -0,0 +1,24 @@
+/*
+ * Provides code common for host and device side USB.
+ */
+
+#include <linux/kernel.h>  /* for ARRAY_SIZE() */
+#include <linux/module.h>  /* for EXPORT_SYMBOL_GPL() */
+#include <linux/usb/ch9.h>
+
+const char *usb_device_speed_name(enum usb_device_speed speed)
+{
+	static const char *const names[] = {
+		"UNKNOWN",
+		"low-speed",
+		"full-speed",
+		"high-speed",
+		"wireless",
+		"super-speed",
+	};
+
+	if (speed < 0 || speed >= ARRAY_SIZE(names))
+		speed = USB_SPEED_UNKNOWN;
+	return names[speed];
+}
+EXPORT_SYMBOL_GPL(usb_device_speed_name);
diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
index 05ba472..e1ecdbc 100644
--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -375,23 +375,8 @@ static ssize_t usb_udc_speed_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct usb_udc		*udc = container_of(dev, struct usb_udc, dev);
-	struct usb_gadget	*gadget = udc->gadget;
-
-	switch (gadget->speed) {
-	case USB_SPEED_LOW:
-		return snprintf(buf, PAGE_SIZE, "low-speed\n");
-	case USB_SPEED_FULL:
-		return snprintf(buf, PAGE_SIZE, "full-speed\n");
-	case USB_SPEED_HIGH:
-		return snprintf(buf, PAGE_SIZE, "high-speed\n");
-	case USB_SPEED_WIRELESS:
-		return snprintf(buf, PAGE_SIZE, "wireless\n");
-	case USB_SPEED_SUPER:
-		return snprintf(buf, PAGE_SIZE, "super-speed\n");
-	case USB_SPEED_UNKNOWN:	/* FALLTHROUGH */
-	default:
-		return snprintf(buf, PAGE_SIZE, "UNKNOWN\n");
-	}
+	return snprintf(buf, PAGE_SIZE, "%s\n",
+			usb_device_speed_name(udc->gadget->speed));
 }
 static DEVICE_ATTR(speed, S_IRUSR, usb_udc_speed_show, NULL);
 
diff --git a/include/linux/usb/ch9.h b/include/linux/usb/ch9.h
index 0fd3fbd..61c4c80 100644
--- a/include/linux/usb/ch9.h
+++ b/include/linux/usb/ch9.h
@@ -851,6 +851,14 @@ enum usb_device_speed {
 	USB_SPEED_SUPER,			/* usb 3.0 */
 };
 
+/**
+ * usb_device_speed_name() - Returns human readable-name of the speed.
+ * @speed: The speed to return human-readable name for.  If it's not
+ *   any of the speeds defined in usb_device_speed enum, string for
+ *   USB_SPEED_UNKNOWN will be returned.
+ */
+extern const char *usb_device_speed_name(enum usb_device_speed speed);
+
 enum usb_device_state {
 	/* NOTATTACHED isn't in the USB spec, and this state acts
 	 * the same as ATTACHED ... but it's clearer this way.
-- 
1.7.3.1

