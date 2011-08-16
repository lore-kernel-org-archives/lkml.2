Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab1HPCwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:52:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35853 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab1HPCwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:52:11 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Mon Aug 15 19:44:53 2011
Message-Id: <20110816024452.965925825@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 15 Aug 2011 19:42:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        John Stultz <john.stultz@linaro.org>, Felipe Balbi <balbi@ti.com>
Subject: [05/26] usb: musb: fix oops on musb_gadget_pullup
In-Reply-To: <20110816024553.GA5631@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit 72c487dfb94d02025fb7437dfe2314d836d5a9ab upstream.

an 'unhandled fault' is causes when a gadget driver calls
usb_gadget_connect() while the USB cable isn't plugged into
the OTG port.

the fault is caused by an access to MUSB's memory space
while its clock is turned off due to pm_runtime kicking
in.

in order to fix the fault, we enclose musb_gadget_pullup()
with pm_runtime_get_sync() ... pm_runtime_put() calls to
be sure we will always reach that path with clock turned on.

[ balbi@ti.com : simplified commit log; removed few things
	which didn't belong there ]

Reported-by: Zach Pfeffer <zach.pfeffer@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/musb_gadget.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1698,6 +1698,8 @@ static int musb_gadget_pullup(struct usb
 
 	is_on = !!is_on;
 
+	pm_runtime_get_sync(musb->controller);
+
 	/* NOTE: this assumes we are sensing vbus; we'd rather
 	 * not pullup unless the B-session is active.
 	 */
@@ -1707,6 +1709,9 @@ static int musb_gadget_pullup(struct usb
 		musb_pullup(musb, is_on);
 	}
 	spin_unlock_irqrestore(&musb->lock, flags);
+
+	pm_runtime_put(musb->controller);
+
 	return 0;
 }
 


