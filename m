Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1DUVRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:17:36 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21795 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab1DUVRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:17:35 -0400
Date: Thu, 21 Apr 2011 23:11:25 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-media@vger.kernel.org
cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH][Trivial] Media, DVB, Siano, smsusb: Avoid static analysis
 report about 'use after free'.
Message-ID: <alpine.LNX.2.00.1104212303220.4159@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/media/dvb/siano/smsusb.c we have this code:
 ...
               kfree(dev);

               sms_info("device %p destroyed", dev);
 ...

at least one static analysis tool (Coverity Prevent) complains about this 
as a use-after-free bug.
While it's true that we do use the pointer variable after freeing it, the 
only use is to print the value of the pointer, so there's not actually any 
problem here. But still, silencing the complaint is trivial by just moving 
the kfree() call below the sms_info(), so why not just do it?. It doesn't 
change the workings of the code in any way, but it makes the tool shut up. 
The patch below also removes a rather pointless blank line.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 smsusb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/dvb/siano/smsusb.c b/drivers/media/dvb/siano/smsusb.c
index 0b8da57..0c8164a 100644
--- a/drivers/media/dvb/siano/smsusb.c
+++ b/drivers/media/dvb/siano/smsusb.c
@@ -297,9 +297,8 @@ static void smsusb_term_device(struct usb_interface *intf)
 		if (dev->coredev)
 			smscore_unregister_device(dev->coredev);
 
-		kfree(dev);
-
 		sms_info("device %p destroyed", dev);
+		kfree(dev);
 	}
 
 	usb_set_intfdata(intf, NULL);


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

