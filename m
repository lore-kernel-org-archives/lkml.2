Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004Ab1KWBSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:18:22 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:60940 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752877Ab1KWBSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 20:18:21 -0500
From: Kevin Hilman <khilman@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-omap@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de> (supporter:USB SUBSYSTEM),
        linux-usb@vger.kernel.org (open list:MUSB MULTIPOINT H...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] usb: musb: PM: fix context save/restore in suspend/resume path
Date: Tue, 22 Nov 2011 17:18:24 -0800
Message-Id: <1322011104-21817-1-git-send-email-khilman@ti.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the driver tries to save context in the suspend path, but
will cause an abort if the device is already runtime suspended.  This
happens, for example, if MUSB loaded/compiled-in, in host mode, but no
USB devices are attached.  MUSB will be runtime suspended, but then
attempting a system suspend will crash due to the context save
being attempted while the device is disabled.

On OMAP, as of v3.1, the driver's ->runtime_suspend() callback will be
called late in the suspend path (by the PM domain layer) if the driver
is not already runtime suspended, ensuring a full shutdown.

Therefore, the context save is not needed in the ->suspend() method
since it will be called in the ->runtime_suspend() method anyways
(similarily for resume.)

NOTE: this leaves the suspend/resume methods basically empty (with
      some FIXMEs and comments, but I'll leave it to the maintainers
      to decide whether to remove them.

Signed-off-by: Kevin Hilman <khilman@ti.com>
---
 drivers/usb/musb/musb_core.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 20a2873..a057a5a 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2302,18 +2302,12 @@ static int musb_suspend(struct device *dev)
 		 */
 	}
 
-	musb_save_context(musb);
-
 	spin_unlock_irqrestore(&musb->lock, flags);
 	return 0;
 }
 
 static int musb_resume_noirq(struct device *dev)
 {
-	struct musb	*musb = dev_to_musb(dev);
-
-	musb_restore_context(musb);
-
 	/* for static cmos like DaVinci, register values were preserved
 	 * unless for some reason the whole soc powered down or the USB
 	 * module got reset through the PSC (vs just being disabled).
-- 
1.7.6

