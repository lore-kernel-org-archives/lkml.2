Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab2CPG1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 02:27:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41741 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab2CPG1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 02:27:23 -0400
X-AuditID: cbfee61a-b7b78ae000001ceb-54-4f62dd44e0bb
From: Yongsul Oh <yongsul96.oh@samsung.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Nazarewicz <mnazarewicz@gmail.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] USB: Gadget: Composite: Added error handling codes to prevent
 a memory leak case when the configuration's bind function failed
Date: Fri, 16 Mar 2012 15:27:15 +0900
Message-id: <1331879235-2910-1-git-send-email-yongsul96.oh@samsung.com>
X-Mailer: git-send-email 1.7.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 In some usb gadget driver, (for example usb gadget serial driver(serial.c),
multifunction composite driver(multi,c), nokia composite gadget driver(nokia.c),
HID composite driver(hid.c), CDC composite driver(cdc2.c)..) the configuration's
bind function by called the 'usb_add_config()' has multiple bind config functions
for each functionality. (for example cdc2 configuration bind function -'cdc_do_config()'
has two functionality bind config functions -'ecm_bind_config()' & 'acm_bind_config()'
in CDC composite driver.)

 In each functionality bind config function, new instance for each functionality is
allocated & initialized by 'kzalloc()' and finally the new instance is added by
'usb_add_function()'. After 'usb_add_function' state, already created the instance
is only handled by it's configuration & freed from functionality unbind function.

 So, If an error occurred during the second functionality bind config state,
(for example an error occurred at 'acm_bind_config()' after succeeding of
'ecm_bind_function()') the created instance by 'acm_bind_config()'
cannot be freed. And it makes memory leak situation.

This patch fixes this issue

Signed-off-by: Yongsul Oh <yongsul96.oh@samsung.com>
---
 drivers/usb/gadget/composite.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index baaebf2..4cb1801 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -737,6 +737,19 @@ int usb_add_config(struct usb_composite_dev *cdev,
 
 	status = bind(config);
 	if (status < 0) {
+		while (!list_empty(&config->functions)) {
+			struct usb_function		*f;
+
+			f = list_first_entry(&config->functions,
+					struct usb_function, list);
+			list_del(&f->list);
+			if (f->unbind) {
+				DBG(cdev, "unbind function '%s'/%p\n",
+					f->name, f);
+				f->unbind(config, f);
+				/* may free memory for "f" */
+			}
+		}
 		list_del(&config->list);
 		config->cdev = NULL;
 	} else {
-- 
1.7.1

