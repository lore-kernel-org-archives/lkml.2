Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab0EOVPf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:15:35 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59046 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab0EOVPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:15:32 -0400
Date: Sat, 15 May 2010 23:15:27 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
       mjpeg-users@lists.sourceforge.net, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 8/37] drivers/media/video/zoran: Use kmemdup
Message-ID: <Pine.LNX.4.64.1005152315100.21345@ask.diku.dk>
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
 drivers/media/video/zoran/videocodec.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -u -p a/drivers/media/video/zoran/videocodec.c b/drivers/media/video/zoran/videocodec.c
--- a/drivers/media/video/zoran/videocodec.c
+++ b/drivers/media/video/zoran/videocodec.c
@@ -107,15 +107,14 @@ videocodec_attach (struct videocodec_mas
 			if (!try_module_get(h->codec->owner))
 				return NULL;
 
-			codec =
-			    kmalloc(sizeof(struct videocodec), GFP_KERNEL);
+			codec = kmemdup(h->codec, sizeof(struct videocodec),
+					GFP_KERNEL);
 			if (!codec) {
 				dprintk(1,
 					KERN_ERR
 					"videocodec_attach: no mem\n");
 				goto out_module_put;
 			}
-			memcpy(codec, h->codec, sizeof(struct videocodec));
 
 			snprintf(codec->name, sizeof(codec->name),
 				 "%s[%d]", codec->name, h->attached);
