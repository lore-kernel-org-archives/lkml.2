Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab2A2Blm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 20:41:42 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16719 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab2A2Blk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 20:41:40 -0500
Date: Sun, 29 Jan 2012 02:41:52 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Curtis McEnroe <programble@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tm6000: Don't use pointer after freeing it in
 tm6000_ir_fini()
Message-ID: <alpine.LNX.2.00.1201290239460.20079@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In tm6000_ir_fini() there seems to be a problem. 
rc_unregister_device(ir->rc); calls rc_free_device() on the pointer it is 
given, which frees it.

Subsequently the function does:

  if (!ir->polling)
    __tm6000_ir_int_stop(ir->rc);

and __tm6000_ir_int_stop() dereferences the pointer it is given, which
has already been freed.

and it also does:

  tm6000_ir_stop(ir->rc);

which also dereferences the (already freed) pointer.

So, it seems that the call to rc_unregister_device() should be move
below the calls to __tm6000_ir_int_stop() and tm6000_ir_stop(), so
those don't operate on a already freed pointer.

But, I must admit that I don't know this code *at all*, so someone who
knows the code should take a careful look before applying this
patch. It is based purely on inspection of facts of what is beeing
freed where and not at all on understanding what the code does or why.
I don't even have a means to test it, so beyond testing that the
change compiles it has seen no testing what-so-ever.

Anyway, here's a proposed patch.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/media/video/tm6000/tm6000-input.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/tm6000/tm6000-input.c b/drivers/media/video/tm6000/tm6000-input.c
index 7844607..859eb90 100644
--- a/drivers/media/video/tm6000/tm6000-input.c
+++ b/drivers/media/video/tm6000/tm6000-input.c
@@ -481,8 +481,6 @@ int tm6000_ir_fini(struct tm6000_core *dev)
 
 	dprintk(2, "%s\n",__func__);
 
-	rc_unregister_device(ir->rc);
-
 	if (!ir->polling)
 		__tm6000_ir_int_stop(ir->rc);
 
@@ -492,6 +490,7 @@ int tm6000_ir_fini(struct tm6000_core *dev)
 	tm6000_flash_led(dev, 0);
 	ir->pwled = 0;
 
+	rc_unregister_device(ir->rc);
 
 	kfree(ir);
 	dev->ir = NULL;
-- 
1.7.8.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

