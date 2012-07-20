Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab2GTSr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:47:57 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:24865 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab2GTSr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:47:56 -0400
Date: Fri, 20 Jul 2012 20:47:55 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: David Airlie <airlied@linux.ie>
cc: Adam Jackson <ajax@redhat.com>, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm, cirrus_fbdev: Fix leak in cirrusfb_create()
Message-ID: <alpine.LNX.2.00.1207202039350.23164@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have this code:

...
	sysram = vmalloc(size);
	if (!sysram)
		return -ENOMEM;

	info = framebuffer_alloc(0, device);
	if (info == NULL)
		return -ENOMEM;
...

If the vmalloc() call succeeds but the framebuffer_alloc() call
subsequently fails then we'll leak the memory allocated for 'sysram'
with vmalloc().

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/gpu/drm/cirrus/cirrus_fbdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/cirrus/cirrus_fbdev.c b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
index 9a276a5..cdaa270 100644
--- a/drivers/gpu/drm/cirrus/cirrus_fbdev.c
+++ b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
@@ -155,8 +155,10 @@ static int cirrusfb_create(struct cirrus_fbdev *gfbdev,
 		return -ENOMEM;
 
 	info = framebuffer_alloc(0, device);
-	if (info == NULL)
+	if (!info) {
+		vfree(sysram);
 		return -ENOMEM;
+	}
 
 	info->par = gfbdev;
 
-- 
1.7.11.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

