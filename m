Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab1COOMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:12:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19797 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883Ab1COOLp (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 15 Mar 2011 10:11:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: xen-devel@lists.xensource.com, Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, dgdegra@tycho.nsa.gov
Subject: [PATCH 3/4] xen-fbfront: Use grant references when requested
Date: Tue, 15 Mar 2011 10:11:14 -0400
Message-Id: <1300198274-1325-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300198274-1325-1-git-send-email-konrad.wilk@oracle.com>
References: <1300198274-1325-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D7F7394.0123,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel De Graaf <dgdegra@tycho.nsa.gov>

The current version of the Xen framebuffer API passes MFNs directly
to the backend driver, which requires the backend to have full access
to this domain's memory. Add a parameter in xenbus to request the use of
grant entries instead, which are slightly slower to map but provide
inter-domain isolation.

Signed-off-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Ian Campbell <Ian.Campbell@eu.citrix.com>
---
 drivers/video/xen-fbfront.c |   96 +++++++++++++++++++++++++++++++++++-------
 1 files changed, 80 insertions(+), 16 deletions(-)

diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 56d6061..b43c5c9 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -11,13 +11,6 @@
  *  more details.
  */
 
-/*
- * TODO:
- *
- * Switch to grant tables when they become capable of dealing with the
- * frame buffer.
- */
-
 #include <linux/console.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -32,6 +25,8 @@
 #include <xen/xen.h>
 #include <xen/events.h>
 #include <xen/page.h>
+#include <xen/grant_table.h>
+#include <xen/interface/grant_table.h>
 #include <xen/interface/io/fbif.h>
 #include <xen/interface/io/protocols.h>
 #include <xen/xenbus.h>
@@ -46,6 +41,8 @@ struct xenfb_info {
 	int			irq;
 	struct xenfb_page	*page;
 	unsigned long 		*mfns;
+	grant_ref_t             *mfn_grefs;
+	int                     page_gref;
 	int			update_wanted; /* XENFB_TYPE_UPDATE wanted */
 	int			feature_resize; /* XENFB_TYPE_RESIZE ok */
 	struct xenfb_resize	resize;		/* protected by resize_lock */
@@ -65,7 +62,7 @@ MODULE_PARM_DESC(video,
 
 static void xenfb_make_preferred_console(void);
 static int xenfb_remove(struct xenbus_device *);
-static void xenfb_init_shared_page(struct xenfb_info *, struct fb_info *);
+static void xenfb_init_shared_page(struct xenbus_device *, struct xenfb_info *, struct fb_info *);
 static int xenfb_connect_backend(struct xenbus_device *, struct xenfb_info *);
 static void xenfb_disconnect_backend(struct xenfb_info *);
 
@@ -412,6 +409,7 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 	info->x1 = info->y1 = INT_MAX;
 	spin_lock_init(&info->dirty_lock);
 	spin_lock_init(&info->resize_lock);
+	info->page_gref = -1;
 
 	info->fb = vmalloc(fb_size);
 	if (info->fb == NULL)
@@ -474,7 +472,7 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 	fb_info->fbdefio = &xenfb_defio;
 	fb_deferred_io_init(fb_info);
 
-	xenfb_init_shared_page(info, fb_info);
+	xenfb_init_shared_page(dev, info, fb_info);
 
 	ret = xenfb_connect_backend(dev, info);
 	if (ret < 0)
@@ -528,7 +526,7 @@ static int xenfb_resume(struct xenbus_device *dev)
 	struct xenfb_info *info = dev_get_drvdata(&dev->dev);
 
 	xenfb_disconnect_backend(info);
-	xenfb_init_shared_page(info, info->fb_info);
+	xenfb_init_shared_page(dev, info, info->fb_info);
 	return xenfb_connect_backend(dev, info);
 }
 
@@ -543,9 +541,25 @@ static int xenfb_remove(struct xenbus_device *dev)
 		fb_dealloc_cmap(&info->fb_info->cmap);
 		framebuffer_release(info->fb_info);
 	}
+	if (info->page_gref >= 0) {
+		int epd = PAGE_SIZE / sizeof(info->mfns[0]);
+		int pdpages = (info->nr_pages + epd - 1) / epd;
+		int i;
+		gnttab_end_foreign_access_ref(info->page_gref, 0);
+		gnttab_free_grant_reference(info->page_gref);
+		for (i = 0; i < pdpages; i++) {
+			gnttab_end_foreign_access_ref(info->mfn_grefs[i], 1);
+			gnttab_free_grant_reference(info->mfn_grefs[i]);
+		}
+		for (i = 0; i < info->nr_pages; i++) {
+			gnttab_end_foreign_access_ref(info->mfns[i], 1);
+			gnttab_free_grant_reference(info->mfns[i]);
+		}
+	}
 	free_page((unsigned long)info->page);
 	vfree(info->mfns);
 	vfree(info->fb);
+	kfree(info->mfn_grefs);
 	kfree(info);
 
 	return 0;
@@ -556,17 +570,63 @@ static unsigned long vmalloc_to_mfn(void *address)
 	return pfn_to_mfn(vmalloc_to_pfn(address));
 }
 
-static void xenfb_init_shared_page(struct xenfb_info *info,
+static void xenfb_init_shared_page(struct xenbus_device *dev,
+                                   struct xenfb_info *info,
 				   struct fb_info *fb_info)
 {
-	int i;
 	int epd = PAGE_SIZE / sizeof(info->mfns[0]);
+	int be_id = dev->otherend_id;
+	int i, ref;
+	unsigned long mfn;
+	grant_ref_t gref_head;
+	int pdpages = (info->nr_pages + epd - 1) / epd;
+	int allpages = info->nr_pages + pdpages + 1;
+
+	int grants = 0;
+	xenbus_scanf(XBT_NIL, dev->otherend, "feature-grants", "%d", &grants);
+
+	if (grants) {
+		int err = gnttab_alloc_grant_references(allpages, &gref_head);
+		info->mfn_grefs = kzalloc(pdpages*sizeof(grant_ref_t), GFP_KERNEL);
+		if (!info->mfn_grefs || err < 0) {
+			info->page_gref = -ENOSPC;
+			if (err >= 0)
+				gnttab_free_grant_references(gref_head);
+			grants = 0;
+		} else {
+			ref = gnttab_claim_grant_reference(&gref_head);
+			mfn = virt_to_mfn(info->page);
+			BUG_ON(ref == -ENOSPC);
+			gnttab_grant_foreign_access_ref(ref, be_id, mfn, 0);
+			info->page_gref = ref;
+		}
+	} else
+		info->page_gref = -ENOENT;
 
 	for (i = 0; i < info->nr_pages; i++)
-		info->mfns[i] = vmalloc_to_mfn(info->fb + i * PAGE_SIZE);
+	{
+		mfn = vmalloc_to_mfn(info->fb + i * PAGE_SIZE);
+		if (grants) {
+			ref = gnttab_claim_grant_reference(&gref_head);
+			BUG_ON(ref == -ENOSPC);
+			gnttab_grant_foreign_access_ref(ref, be_id, mfn, 1);
+			info->mfns[i] = ref;
+		} else
+			info->mfns[i] = mfn;
+	}
 
 	for (i = 0; i * epd < info->nr_pages; i++)
-		info->page->pd[i] = vmalloc_to_mfn(&info->mfns[i * epd]);
+	{
+		mfn = vmalloc_to_mfn(&info->mfns[i * epd]);
+		if (grants) {
+			ref = gnttab_claim_grant_reference(&gref_head);
+			BUG_ON(ref == -ENOSPC);
+			gnttab_grant_foreign_access_ref(ref, be_id, mfn, 1);
+			info->mfn_grefs[i] = ref;
+			info->page->pd[i] = ref;
+		} else
+			info->page->pd[i] = mfn;
+	}
 
 	info->page->width = fb_info->var.xres;
 	info->page->height = fb_info->var.yres;
@@ -599,8 +659,12 @@ static int xenfb_connect_backend(struct xenbus_device *dev,
 		xenbus_dev_fatal(dev, ret, "starting transaction");
 		goto unbind_irq;
 	}
-	ret = xenbus_printf(xbt, dev->nodename, "page-ref", "%lu",
-			    virt_to_mfn(info->page));
+	if (info->page_gref < 0)
+		ret = xenbus_printf(xbt, dev->nodename, "page-ref", "%lu",
+			            virt_to_mfn(info->page));
+	else
+		ret = xenbus_printf(xbt, dev->nodename, "page-gref", "%u",
+				    info->page_gref);
 	if (ret)
 		goto error_xenbus;
 	ret = xenbus_printf(xbt, dev->nodename, "event-channel", "%u",
-- 
1.7.1

