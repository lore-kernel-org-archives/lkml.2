Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab1ABHgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:36:00 -0500
Received: from mail.windriver.com ([147.11.1.11]:36951 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab1ABHZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:15 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Max Vozeler <mvz@vozeler.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 220/260] staging: usbip: Process event flags without delay
Date: Sun,  2 Jan 2011 02:18:36 -0500
Message-Id: <1293952756-15010-221-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:09.0979 (UTC) FILETIME=[0C3E94B0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
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
1.7.3.3

