Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab0HXOi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 10:38:59 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59366 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab0HXOi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 10:38:58 -0400
Date: Tue, 24 Aug 2010 16:38:56 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/5] drivers/video/gbefb.c: Eliminate memory leak
Message-ID: <Pine.LNX.4.64.1008241638330.15172@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

This code is preceded by a call to framebuffer_alloc, which allocates
memory, so this memory should be freed before leaving the function in an
error case.  out_release_framebuffer just frees the frame buffer and returns.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression x;
expression E;
identifier f1;
iterator I;
@@

x = framebuffer_alloc(...);
<... when != x
     when != true (x == NULL || ...)
     when != if (...) { <+...x...+> }
     when != I (...) { <+...x...+> }
(
 x == NULL
|
 x == E
|
 x->f1
)
...>
* return ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/video/gbefb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/gbefb.c b/drivers/video/gbefb.c
index ca3355e..933899d 100644
--- a/drivers/video/gbefb.c
+++ b/drivers/video/gbefb.c
@@ -1143,8 +1143,10 @@ static int __devinit gbefb_probe(struct platform_device *p_dev)
 		return -ENOMEM;
 
 #ifndef MODULE
-	if (fb_get_options("gbefb", &options))
-		return -ENODEV;
+	if (fb_get_options("gbefb", &options)) {
+		ret = -ENODEV;
+		goto out_release_framebuffer;
+	}
 	gbefb_setup(options);
 #endif
 
