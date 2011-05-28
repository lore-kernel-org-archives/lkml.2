Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab1E1Rio (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 13:38:44 -0400
Received: from mail.perches.com ([173.55.12.10]:2232 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280Ab1E1RhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 13:37:19 -0400
From: Joe Perches <joe@perches.com>
To: Jaya Kumar <jayalk@intworks.biz>, Paul Mundt <lethal@linux-sh.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jiri Kosina <trivial@kernel.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: [TRIVIAL PATCH next 12/15] video: Convert vmalloc/memset to vzalloc
Date: Sat, 28 May 2011 10:36:32 -0700
Message-Id: <77538de911b8af99f68b7bcfbaaedce8e40db04f.1306603968.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1306603968.git.joe@perches.com>
References: <cover.1306603968.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/video/arcfb.c        |    5 ++---
 drivers/video/broadsheetfb.c |    4 +---
 drivers/video/hecubafb.c     |    5 ++---
 drivers/video/metronomefb.c  |    4 +---
 drivers/video/xen-fbfront.c  |    3 +--
 5 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/video/arcfb.c b/drivers/video/arcfb.c
index 3ec4923..86573e2 100644
--- a/drivers/video/arcfb.c
+++ b/drivers/video/arcfb.c
@@ -515,11 +515,10 @@ static int __devinit arcfb_probe(struct platform_device *dev)
 
 	/* We need a flat backing store for the Arc's
 	   less-flat actual paged framebuffer */
-	if (!(videomemory = vmalloc(videomemorysize)))
+	videomemory = vmalloc(videomemorysize);
+	if (!videomemory)
 		return retval;
 
-	memset(videomemory, 0, videomemorysize);
-
 	info = framebuffer_alloc(sizeof(struct arcfb_par), &dev->dev);
 	if (!info)
 		goto err;
diff --git a/drivers/video/broadsheetfb.c b/drivers/video/broadsheetfb.c
index ebda687..377dde3 100644
--- a/drivers/video/broadsheetfb.c
+++ b/drivers/video/broadsheetfb.c
@@ -1101,12 +1101,10 @@ static int __devinit broadsheetfb_probe(struct platform_device *dev)
 
 	videomemorysize = roundup((dpyw*dpyh), PAGE_SIZE);
 
-	videomemory = vmalloc(videomemorysize);
+	videomemory = vzalloc(videomemorysize);
 	if (!videomemory)
 		goto err_fb_rel;
 
-	memset(videomemory, 0, videomemorysize);
-
 	info->screen_base = (char *)videomemory;
 	info->fbops = &broadsheetfb_ops;
 
diff --git a/drivers/video/hecubafb.c b/drivers/video/hecubafb.c
index 1b94643..fbef15f 100644
--- a/drivers/video/hecubafb.c
+++ b/drivers/video/hecubafb.c
@@ -231,11 +231,10 @@ static int __devinit hecubafb_probe(struct platform_device *dev)
 
 	videomemorysize = (DPY_W*DPY_H)/8;
 
-	if (!(videomemory = vmalloc(videomemorysize)))
+	videomemory = vzalloc(videomemorysize);
+	if (!videomemory)
 		return retval;
 
-	memset(videomemory, 0, videomemorysize);
-
 	info = framebuffer_alloc(sizeof(struct hecubafb_par), &dev->dev);
 	if (!info)
 		goto err_fballoc;
diff --git a/drivers/video/metronomefb.c b/drivers/video/metronomefb.c
index ed64edf..97d45e5 100644
--- a/drivers/video/metronomefb.c
+++ b/drivers/video/metronomefb.c
@@ -628,12 +628,10 @@ static int __devinit metronomefb_probe(struct platform_device *dev)
 	/* we need to add a spare page because our csum caching scheme walks
 	 * to the end of the page */
 	videomemorysize = PAGE_SIZE + (fw * fh);
-	videomemory = vmalloc(videomemorysize);
+	videomemory = vzalloc(videomemorysize);
 	if (!videomemory)
 		goto err_fb_rel;
 
-	memset(videomemory, 0, videomemorysize);
-
 	info->screen_base = (char __force __iomem *)videomemory;
 	info->fbops = &metronomefb_ops;
 
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index a20218c..beac52f 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -395,10 +395,9 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
 	spin_lock_init(&info->dirty_lock);
 	spin_lock_init(&info->resize_lock);
 
-	info->fb = vmalloc(fb_size);
+	info->fb = vzalloc(fb_size);
 	if (info->fb == NULL)
 		goto error_nomem;
-	memset(info->fb, 0, fb_size);
 
 	info->nr_pages = (fb_size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
-- 
1.7.5.rc3.dirty

