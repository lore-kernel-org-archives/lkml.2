Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab0EOVSI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:18:08 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:46749 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520Ab0EOVSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:18:04 -0400
Date: Sat, 15 May 2010 23:17:59 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Laurent Pinchart <laurent.pinchart@skynet.be>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 16/37] drivers/media/video/uvc: Use kmemdup
Message-ID: <Pine.LNX.4.64.1005152317410.21345@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kmemdup when some other buffer is immediately copied into the
allocated region.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
statement S;
@@

-  to = \(kmalloc\|kzalloc\)(size,flag);
+  to = kmemdup(from,size,flag);
   if (to==NULL || ...) S
-  memcpy(to, from, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/uvc/uvc_driver.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -u -p a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -637,14 +637,13 @@ static int uvc_parse_streaming(struct uv
 	}
 	streaming->header.bControlSize = n;
 
-	streaming->header.bmaControls = kmalloc(p*n, GFP_KERNEL);
+	streaming->header.bmaControls = kmemdup(&buffer[size], p * n,
+						GFP_KERNEL);
 	if (streaming->header.bmaControls == NULL) {
 		ret = -ENOMEM;
 		goto error;
 	}
 
-	memcpy(streaming->header.bmaControls, &buffer[size], p*n);
-
 	buflen -= buffer[0];
 	buffer += buffer[0];
 
