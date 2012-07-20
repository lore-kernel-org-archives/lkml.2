Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab2GTSqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:46:34 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:24839 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2GTSqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:46:33 -0400
Date: Fri, 20 Jul 2012 20:46:31 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: David Airlie <airlied@linux.ie>
cc: Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm, ast_fb: Fix a small leak in astfb_create()
Message-ID: <alpine.LNX.2.00.1207202045020.23164@swampdragon.chaosbits.net>
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
	if (!info) {
		ret = -ENOMEM;
		goto out;
	}
...

We'll leak the memory allocated to 'sysram' if the framebuffer_alloc()
call fails and the variable goes out of scope.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/gpu/drm/ast/ast_fb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/ast/ast_fb.c b/drivers/gpu/drm/ast/ast_fb.c
index 2fc8e9e..260a760 100644
--- a/drivers/gpu/drm/ast/ast_fb.c
+++ b/drivers/gpu/drm/ast/ast_fb.c
@@ -180,6 +180,7 @@ static int astfb_create(struct ast_fbdev *afbdev,
 
 	info = framebuffer_alloc(0, device);
 	if (!info) {
+		vfree(sysram);
 		ret = -ENOMEM;
 		goto out;
 	}
-- 
1.7.11.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

