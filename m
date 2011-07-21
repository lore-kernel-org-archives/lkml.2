Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab1GUAJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 20:09:42 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54049 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1GUAJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 20:09:41 -0400
Subject: [RFC][PATCH] musb: Avoid musb_gadget_pullup "Unhandled fault" oops
 on omap4
From: John Stultz <john.stultz@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jul 2011 17:09:34 -0700
Message-ID: <1311206974.2945.198.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've recently run across an "Unhandled fault: imprecise external abort"
oops that is caused when a driver called usb_gadget_connect() when there
was no cable plugged into the musb gadget port.

You can see the oops message here:
https://launchpadlibrarian.net/75635123/minicom.txt

Doing some digging, it seemed the problem was triggered when reading
from the musb registers in musb_pullup() when the device controller is
powered down.

Looking at other examples of where the registers were accessed, I
noticed they were always enclosed by pm_runtime_get/put calls. So I
added such calls to the musb_gadget_pullup() function and it seemed to
resolve the problem.

Now, full disclosure: this was triggered with the out-of-tree Android
adb gadget driver. However, I suspect the same behavior could be
triggered using the composite gadget driver as well, so I think this is
a generic issue. However, if I'm wrong, let me know and I'll try to make
sure the fix is done in the right place.

If this is the right fix, it probably should be queued for 3.1 and
3.0-stable.

Comments and feedback would be greatly appreciated!


Reported-by: Zach Pfeffer <zach.pfeffer@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index 6aeb363..548338c 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1698,6 +1698,8 @@ static int musb_gadget_pullup(struct usb_gadget *gadget, int is_on)
 
 	is_on = !!is_on;
 
+	pm_runtime_get_sync(musb->controller);
+
 	/* NOTE: this assumes we are sensing vbus; we'd rather
 	 * not pullup unless the B-session is active.
 	 */
@@ -1707,6 +1709,9 @@ static int musb_gadget_pullup(struct usb_gadget *gadget, int is_on)
 		musb_pullup(musb, is_on);
 	}
 	spin_unlock_irqrestore(&musb->lock, flags);
+
+	pm_runtime_put(musb->controller);
+
 	return 0;
 }
 


