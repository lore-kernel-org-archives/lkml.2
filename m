Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab2CAWDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 17:03:12 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22484 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab2CAWDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 17:03:10 -0500
Date: Thu, 1 Mar 2012 23:01:19 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-usb@vger.kernel.org
cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        Ben Williamson <ben.williamson@greyinnovation.com>,
        Bryan Wu <cooloney@kernel.org>, Daniel Mack <zonque@gmail.com>
Subject: [PATCH] Allocate correct size (portably) in
 drivers/usb/gadget/f_midi.c::f_midi_bind()
Message-ID: <alpine.LNX.2.00.1203012256520.19443@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the coverity checker puts it:

"Passing argument "sizeof (midi_function) /*8*/" to function "kcalloc"
and then casting the return value to "struct usb_descriptor_header **"
is suspicious. ... In this particular case sizeof(struct
usb_descriptor_header **) happens to be equal to sizeof(struct
usb_descriptor_header *), but this is not a portable assumption."

I believe we really do intend to use 'sizeof(*midi_function)' here, so
this patch makes that change.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/usb/gadget/f_midi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/f_midi.c b/drivers/usb/gadget/f_midi.c
index 3797b3d..2f7e8f2 100644
--- a/drivers/usb/gadget/f_midi.c
+++ b/drivers/usb/gadget/f_midi.c
@@ -780,7 +780,7 @@ f_midi_bind(struct usb_configuration *c, struct usb_function *f)
 	midi->out_ep->driver_data = cdev;	/* claim */
 
 	/* allocate temporary function list */
-	midi_function = kcalloc((MAX_PORTS * 4) + 9, sizeof(midi_function),
+	midi_function = kcalloc((MAX_PORTS * 4) + 9, sizeof(*midi_function),
 				GFP_KERNEL);
 	if (!midi_function) {
 		status = -ENOMEM;
-- 
1.7.9.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

