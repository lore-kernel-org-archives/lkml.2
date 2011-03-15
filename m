Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab1COOMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:12:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19799 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888Ab1COOLp (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 15 Mar 2011 10:11:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: xen-devel@lists.xensource.com, Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, dgdegra@tycho.nsa.gov
Subject: [PATCH 2/4] xen-kbdfront: Add grant reference for shared page
Date: Tue, 15 Mar 2011 10:11:13 -0400
Message-Id: <1300198274-1325-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300198274-1325-1-git-send-email-konrad.wilk@oracle.com>
References: <1300198274-1325-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D7F7394.0025,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel De Graaf <dgdegra@tycho.nsa.gov>

Without a grant reference, full access to the domain's memory is
required to use the shared page. Add an additional parameter in
xenstore to allow grant mapping to be used.

Signed-off-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Ian Campbell <Ian.Campbell@eu.citrix.com>
---
 drivers/input/xen-kbdfront.c |   39 ++++++++++++++++++++++++++++-----------
 1 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index 7f85a86..a5c064e 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -11,12 +11,6 @@
  *  more details.
  */
 
-/*
- * TODO:
- *
- * Switch to grant tables together with xen-fbfront.c.
- */
-
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
@@ -30,6 +24,8 @@
 #include <xen/xen.h>
 #include <xen/events.h>
 #include <xen/page.h>
+#include <xen/grant_table.h>
+#include <xen/interface/grant_table.h>
 #include <xen/interface/io/fbif.h>
 #include <xen/interface/io/kbdif.h>
 #include <xen/xenbus.h>
@@ -38,6 +34,7 @@ struct xenkbd_info {
 	struct input_dev *kbd;
 	struct input_dev *ptr;
 	struct xenkbd_page *page;
+	int gref;
 	int irq;
 	struct xenbus_device *xbdev;
 	char phys[32];
@@ -122,6 +119,7 @@ static int __devinit xenkbd_probe(struct xenbus_device *dev,
 	dev_set_drvdata(&dev->dev, info);
 	info->xbdev = dev;
 	info->irq = -1;
+	info->gref = -1;
 	snprintf(info->phys, sizeof(info->phys), "xenbus/%s", dev->nodename);
 
 	info->page = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
@@ -218,15 +216,20 @@ static int xenkbd_connect_backend(struct xenbus_device *dev,
 	int ret, evtchn;
 	struct xenbus_transaction xbt;
 
+	ret = gnttab_grant_foreign_access(dev->otherend_id,
+	                                  virt_to_mfn(info->page), 0);
+	if (ret < 0)
+		return ret;
+	info->gref = ret;
+
 	ret = xenbus_alloc_evtchn(dev, &evtchn);
 	if (ret)
-		return ret;
+		goto error_grant;
 	ret = bind_evtchn_to_irqhandler(evtchn, input_handler,
 					0, dev->devicetype, info);
 	if (ret < 0) {
-		xenbus_free_evtchn(dev, evtchn);
 		xenbus_dev_fatal(dev, ret, "bind_evtchn_to_irqhandler");
-		return ret;
+		goto error_evtchan;
 	}
 	info->irq = ret;
 
@@ -234,12 +237,15 @@ static int xenkbd_connect_backend(struct xenbus_device *dev,
 	ret = xenbus_transaction_start(&xbt);
 	if (ret) {
 		xenbus_dev_fatal(dev, ret, "starting transaction");
-		return ret;
+		goto error_irqh;
 	}
 	ret = xenbus_printf(xbt, dev->nodename, "page-ref", "%lu",
 			    virt_to_mfn(info->page));
 	if (ret)
 		goto error_xenbus;
+	ret = xenbus_printf(xbt, dev->nodename, "page-gref", "%u", info->gref);
+	if (ret)
+		goto error_xenbus;
 	ret = xenbus_printf(xbt, dev->nodename, "event-channel", "%u",
 			    evtchn);
 	if (ret)
@@ -249,7 +255,7 @@ static int xenkbd_connect_backend(struct xenbus_device *dev,
 		if (ret == -EAGAIN)
 			goto again;
 		xenbus_dev_fatal(dev, ret, "completing transaction");
-		return ret;
+		goto error_irqh;
 	}
 
 	xenbus_switch_state(dev, XenbusStateInitialised);
@@ -258,6 +264,14 @@ static int xenkbd_connect_backend(struct xenbus_device *dev,
  error_xenbus:
 	xenbus_transaction_end(xbt, 1);
 	xenbus_dev_fatal(dev, ret, "writing xenstore");
+ error_irqh:
+	unbind_from_irqhandler(info->irq, info);
+	info->irq = -1;
+ error_evtchan:
+	xenbus_free_evtchn(dev, evtchn);
+ error_grant:
+	gnttab_end_foreign_access_ref(info->gref, 0);
+	info->gref = -1;
 	return ret;
 }
 
@@ -266,6 +280,9 @@ static void xenkbd_disconnect_backend(struct xenkbd_info *info)
 	if (info->irq >= 0)
 		unbind_from_irqhandler(info->irq, info);
 	info->irq = -1;
+	if (info->gref >= 0)
+		gnttab_end_foreign_access_ref(info->gref, 0);
+	info->gref = -1;
 }
 
 static void xenkbd_backend_changed(struct xenbus_device *dev,
-- 
1.7.1

