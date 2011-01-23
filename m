Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1AWWH4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 17:07:56 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19770 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1AWWHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 17:07:55 -0500
Date: Sun, 23 Jan 2011 23:08:31 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-usb@vger.kernel.org
cc: Greg Kroah-Hartman <gregkh@suse.de>, Mike Frysinger <vapier@gentoo.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] USB SL811HS HCD: Fix memory leak in sl811h_urb_enqueue()
Message-ID: <alpine.LNX.2.00.1101232301510.30955@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/usb/host/sl811-hcd.c::sl811h_urb_enqueue(), memory is allocated 
with kzalloc() and assigned to 'ep'. If we leave via the 'fail' label due 
to 'if (ep->maxpacket > H_MAXPACKET)', then 'ep' will go out of scope 
without having been assigned to anything, so we'll leak the memory we 
allocated.
This patch fixes the leak by simply calling kfree(ep); before jumping to 
the 'fail' label.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 sl811-hcd.c |    1 +
 1 file changed, 1 insertion(+)

  I don't have hardware to test this, so compile tested only.

diff --git a/drivers/usb/host/sl811-hcd.c b/drivers/usb/host/sl811-hcd.c
index 990f06b..2e9602a 100644
--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -861,6 +861,7 @@ static int sl811h_urb_enqueue(
 			DBG("dev %d ep%d maxpacket %d\n",
 				udev->devnum, epnum, ep->maxpacket);
 			retval = -EINVAL;
+			kfree(ep);
 			goto fail;
 		}
 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

