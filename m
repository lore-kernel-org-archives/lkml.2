Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab2FUWOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 18:14:11 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11740 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab2FUWN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 18:13:59 -0400
Date: Fri, 22 Jun 2012 00:13:56 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Dave Airlie <airlied@redhat.com>
cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mgag200: Fix a memory leak in mgag200fb_create()
Message-ID: <alpine.LNX.2.00.1206220012470.7671@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First we allocate memory for 'sysram' with vmalloc() and subsequently
we allocate for 'info' with framebuffer_alloc(). If the second
allocation fails we return -ENOMEM, but neglect to vfree() the memory
we previously allocated for 'sysram', thus leaking it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/gpu/drm/mgag200/mgag200_fb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_fb.c b/drivers/gpu/drm/mgag200/mgag200_fb.c
index 880d336..3c837e5 100644
--- a/drivers/gpu/drm/mgag200/mgag200_fb.c
+++ b/drivers/gpu/drm/mgag200/mgag200_fb.c
@@ -156,8 +156,10 @@ static int mgag200fb_create(struct mga_fbdev *mfbdev,
 		return -ENOMEM;
 
 	info = framebuffer_alloc(0, device);
-	if (info == NULL)
+	if (info == NULL) {
+		vfree(sysram);
 		return -ENOMEM;
+	}
 
 	info->par = mfbdev;
 
-- 
1.7.11


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

