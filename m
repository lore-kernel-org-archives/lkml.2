Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab2CTBjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 21:39:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14360 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab2CTBjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 21:39:19 -0400
X-AuditID: cbfee61b-b7c62ae000000989-2c-4f67dfc53be8
From: Yongsul Oh <yongsul96.oh@samsung.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Nazarewicz <mnazarewicz@gmail.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yongsul Oh <yongsul96.oh@samsung.com>
Subject: [PATCH] USB: Gadget: Composite: Added error handling codes to prevent
 a memory leak case when the configuration's bind function failed
Date: Tue, 20 Mar 2012 10:38:38 +0900
Message-id: <1332207518-24868-1-git-send-email-yongsul96.oh@samsung.com>
X-Mailer: git-send-email 1.7.1
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 In some USB composite gadget drivers, the configuration's bind function
  called by the usb_add_config() calls multiple bind config functions.
  (for example cdc2 configuration bind function in the cdc_do_config()
  of the cdc2.c has two functionality bind config functions.
  - the ecm_bind_config() & the acm_bind_config())

 In each functionality bind config function, new instance is allocated and
  finally added by the usb_add_function().

 So if an error occurred during the second functionality bind config
  (for example an error occurred at the acm_bind_config() after succeeding of
  the ecm_bind_function()), the instance created by the acm_bind_config()
  cannot be freed creating a memory leak.

 This patch fixes this issue.

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

