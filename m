Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab1ABU51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 15:57:27 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10937 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1ABU50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 15:57:26 -0500
Date: Sun, 2 Jan 2011 21:57:24 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-media@vger.kernel.org
cc: Huang Shijie <shijie8@gmail.com>, Kang Yong <kangyong@telegent.com>,
        Zhang Xiaobing <xbzhang@telegent.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media, tlg2300: Fix memory leak in
 alloc_bulk_urbs_generic()
Message-ID: <alpine.LNX.2.00.1101022150120.11481@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While reading 
drivers/media/video/tlg2300/pd-video.c::alloc_bulk_urbs_generic() I 
noticed that

 - We don't free the memory allocated to 'urb' if the call to 
   usb_alloc_coherent() fails.
 - If the 'num' argument to the function is ever <= 0 we'll return an 
   uninitialized variable 'i' to the caller.

The following patch addresses both of the above by a) calling 
usb_free_urb() when usb_alloc_coherent() fails and by explicitly 
initializing 'i' to zero.
I also moved the variables 'mem' and 'urb' inside the for loop. This does 
not actually make any difference, it just seemed more correct to me to let 
variables exist only in the innermost scope they are used.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 pd-video.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

  compile tested only.

diff --git a/drivers/media/video/tlg2300/pd-video.c b/drivers/media/video/tlg2300/pd-video.c
index a1ffe18..df33a1d 100644
--- a/drivers/media/video/tlg2300/pd-video.c
+++ b/drivers/media/video/tlg2300/pd-video.c
@@ -512,19 +512,20 @@ int alloc_bulk_urbs_generic(struct urb **urb_array, int num,
 			int buf_size, gfp_t gfp_flags,
 			usb_complete_t complete_fn, void *context)
 {
-	struct urb *urb;
-	void *mem;
-	int i;
+	int i = 0;
 
-	for (i = 0; i < num; i++) {
-		urb = usb_alloc_urb(0, gfp_flags);
+	for (; i < num; i++) {
+		void *mem;
+		struct urb *urb = usb_alloc_urb(0, gfp_flags);
 		if (urb == NULL)
 			return i;
 
 		mem = usb_alloc_coherent(udev, buf_size, gfp_flags,
 					 &urb->transfer_dma);
-		if (mem == NULL)
+		if (mem == NULL) {
+			usb_free_urb(urb);
 			return i;
+		}
 
 		usb_fill_bulk_urb(urb, udev, usb_rcvbulkpipe(udev, ep_addr),
 				mem, buf_size, complete_fn, context);



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

