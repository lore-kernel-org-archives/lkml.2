Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab1F1WFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:05:49 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35060 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab1F1WFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:05:45 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 10/29] gma500: 2D acceleration tidying
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:05:20 +0100
Message-ID: <20110628220518.898.80069.stgit@bob.linux.org.uk>
In-Reply-To: <20110628220151.898.15775.stgit@bob.linux.org.uk>
References: <20110628220151.898.15775.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We have a FIXME to do the power management for which the framework now
exists, and we also need to deal with an erratum. Some operations exactly 8
pixels wide or high fail. The work around is to do two smaller ones (see
the Intel released X driver bits) but for console quite frankly if it's
8bits wide and/or high its not worth it so fall back.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_2d.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)


diff --git a/drivers/staging/gma500/psb_2d.c b/drivers/staging/gma500/psb_2d.c
index c3d7085..494bad5 100644
--- a/drivers/staging/gma500/psb_2d.c
+++ b/drivers/staging/gma500/psb_2d.c
@@ -183,10 +183,14 @@ static void psbfb_fillrect_accel(struct fb_info *info,
 		cfb_fillrect(info, r);
 		return;
 	}
-
+	if (!gma_power_begin(dev, false)) {
+		cfb_fillrect(info, r);
+		return;
+	}
 	psb_accel_2d_fillrect(dev_priv,
 			      offset, stride, format,
 			      r->dx, r->dy, r->width, r->height, r->color);
+	gma_power_end(dev);
 }
 
 void psbfb_fillrect(struct fb_info *info,
@@ -198,9 +202,7 @@ void psbfb_fillrect(struct fb_info *info,
 	if (1 || (info->flags & FBINFO_HWACCEL_DISABLED))
 		return cfb_fillrect(info, rect);
 
-	/*psb_check_power_state(dev, PSB_DEVICE_SGX); */
 	psbfb_fillrect_accel(info, rect);
-	/* Drop power again here on MRST FIXMEAC */
 }
 
 static u32 psb_accel_2d_copy_direction(int xdir, int ydir)
@@ -331,10 +333,15 @@ static void psbfb_copyarea_accel(struct fb_info *info,
 		return;
 	}
 
+	if (!gma_power_begin(dev, false)) {
+		cfb_copyarea(info, a);
+		return;
+	}
 	psb_accel_2d_copy(dev_priv,
 			  offset, stride, src_format,
 			  offset, stride, dst_format,
 			  a->sx, a->sy, a->dx, a->dy, a->width, a->height);
+	gma_power_end(dev);
 }
 
 void psbfb_copyarea(struct fb_info *info,
@@ -343,12 +350,12 @@ void psbfb_copyarea(struct fb_info *info,
 	if (unlikely(info->state != FBINFO_STATE_RUNNING))
 		return;
 
-	if (info->flags & FBINFO_HWACCEL_DISABLED)
+        /* Avoid the 8 pixel erratum */
+	if (region->width == 8 || region->height == 8 ||
+	        (info->flags & FBINFO_HWACCEL_DISABLED))
 		return cfb_copyarea(info, region);
 
-	/* psb_check_power_state(dev, PSB_DEVICE_SGX); */
 	psbfb_copyarea_accel(info, region);
-	/* Need to power back off here for MRST FIXMEAC */
 }
 
 void psbfb_imageblit(struct fb_info *info, const struct fb_image *image)

