Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab0IUQRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:17:09 -0400
Received: from mail.nusquama.org ([85.131.211.20]:39019 "EHLO
	mail.nusquama.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab0IUQRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:17:08 -0400
Date: Tue, 21 Sep 2010 17:43:30 +0200
From: Max Vozeler <mvz@vozeler.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: hirofuchi@users.sourceforge.net, hschauhan@nulltrace.org,
        "Robert P. J. Day" <rpjday@crashcourse.ca>,
        "Brian G. Merrell" <bgmerrell@novell.com>,
        Eric Lescouet <eric@lescouet.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Marco Lancione <marco@optikam.com>,
        Luc Jalbert <ljalbert@optikam.com>
Subject: [PATCH] staging: usbip: Process event flags without delay
Message-ID: <20100921154330.GA4960@quark.vpn.nusquama.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@kernel.org
---
 drivers/staging/usbip/usbip_event.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/usbip/usbip_event.c b/drivers/staging/usbip/usbip_event.c
index a2566f1..af3832b 100644
--- a/drivers/staging/usbip/usbip_event.c
+++ b/drivers/staging/usbip/usbip_event.c
@@ -38,21 +38,13 @@ static int event_handler(struct usbip_device *ud)
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
@@ -60,13 +52,11 @@ static int event_handler(struct usbip_device *ud)
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
-- 
1.7.1


