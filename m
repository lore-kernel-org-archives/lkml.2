Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab2EDOKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 10:10:55 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18201 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758339Ab2EDOK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 10:10:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/4] drivers/video/xen-fbfront.c: add missing cleanup code
Date: Fri,  4 May 2012 10:04:24 -0400
Message-Id: <1336140267-7399-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1336140267-7399-1-git-send-email-konrad.wilk@oracle.com>
References: <1336140267-7399-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The operations in the subsequent error-handling code appear to be also
useful here.

Acked-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
[v1: Collapse some of the error handling functions]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/video/xen-fbfront.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index cb4529c..aa42160 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -458,26 +458,31 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 	xenfb_init_shared_page(info, fb_info);
 
 	ret = xenfb_connect_backend(dev, info);
-	if (ret < 0)
-		goto error;
+	if (ret < 0) {
+		xenbus_dev_fatal(dev, ret, "xenfb_connect_backend");
+		goto error_fb;
+	}
 
 	ret = register_framebuffer(fb_info);
 	if (ret) {
-		fb_deferred_io_cleanup(fb_info);
-		fb_dealloc_cmap(&fb_info->cmap);
-		framebuffer_release(fb_info);
 		xenbus_dev_fatal(dev, ret, "register_framebuffer");
-		goto error;
+		goto error_fb;
 	}
 	info->fb_info = fb_info;
 
 	xenfb_make_preferred_console();
 	return 0;
 
- error_nomem:
-	ret = -ENOMEM;
-	xenbus_dev_fatal(dev, ret, "allocating device memory");
- error:
+error_fb:
+	fb_deferred_io_cleanup(fb_info);
+	fb_dealloc_cmap(&fb_info->cmap);
+	framebuffer_release(fb_info);
+error_nomem:
+	if (!ret) {
+		ret = -ENOMEM;
+		xenbus_dev_fatal(dev, ret, "allocating device memory");
+	}
+error:
 	xenfb_remove(dev);
 	return ret;
 }
-- 
1.7.7.5

