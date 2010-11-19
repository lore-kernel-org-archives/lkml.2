Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab0KSV6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:58:23 -0500
Received: from kroah.org ([198.145.64.141]:44901 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757176Ab0KSV6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:21 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:38 2010
Message-Id: <20101119215638.909249892@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:55:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Max Vozeler <mvz@vozeler.com>
Subject: [02/82] staging: usbip: Process event flags without delay
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Max Vozeler <mvz@vozeler.com>

commit 584c5b7cf06194464240280483ee0376cdddbbae upstream.

The way the event handler works can cause it to delay
events until eventual wakeup for another event.

For example, on device detach (vhci):

 - Write to sysfs detach file
    -> usbip_event_add(VDEV_EVENT_DOWN)
      -> wakeup()

#define VDEV_EVENT_DOWN (USBIP_EH_SHUTDOWN | USBIP_EH_RESET).

 - Event thread wakes up and passes the event to
   event_handler() to process.

 - It processes and clears the USBIP_EH_SHUTDOWN
   flag then returns.

 - The outer event loop (event_handler_loop()) calls
   wait_event_interruptible().

The processing of the second flag which is part of
VDEV_EVENT_DOWN (USBIP_EH_RESET) did not happen yet.
It is delayed until the next event.

This means the ->reset callback may not happen for
a long time (if ever), leaving the usbip port in a
weird state which prevents its reuse.

This patch changes the handler to process all flags
before waiting for another wakeup.

I have verified this change to fix a problem which
prevented reattach of a usbip device. It also helps
for socket errors which missed the RESET as well.

The delayed event processing also affects the stub
side of usbip and the error handling there.

Signed-off-by: Max Vozeler <mvz@vozeler.com>
Reported-by: Marco Lancione <marco@optikam.com>
Tested-by: Luc Jalbert <ljalbert@optikam.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/usbip/usbip_event.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/drivers/staging/usbip/usbip_event.c
+++ b/drivers/staging/usbip/usbip_event.c
@@ -38,21 +38,13 @@ static int event_handler(struct usbip_de
 			ud->eh_ops.shutdown(ud);
 
 			ud->event &= ~USBIP_EH_SHUTDOWN;
-
-			break;
 		}
 
-		/* Stop the error handler. */
-		if (ud->event & USBIP_EH_BYE)
-			return -1;
-
 		/* Reset the device. */
 		if (ud->event & USBIP_EH_RESET) {
 			ud->eh_ops.reset(ud);
 
 			ud->event &= ~USBIP_EH_RESET;
-
-			break;
 		}
 
 		/* Mark the device as unusable. */
@@ -60,13 +52,11 @@ static int event_handler(struct usbip_de
 			ud->eh_ops.unusable(ud);
 
 			ud->event &= ~USBIP_EH_UNUSABLE;
-
-			break;
 		}
 
-		/* NOTREACHED */
-		printk(KERN_ERR "%s: unknown event\n", __func__);
-		return -1;
+		/* Stop the error handler. */
+		if (ud->event & USBIP_EH_BYE)
+			return -1;
 	}
 
 	return 0;


