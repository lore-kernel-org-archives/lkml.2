Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab1LGQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:25:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757816Ab1LGQZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:25:21 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:20 2011
Message-Id: <20111207161220.380972634@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:12:10 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Kevin Hilman <khilman@ti.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [068/104] usb: musb: PM: fix context save/restore in suspend/resume path
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Hilman <khilman@ti.com>

commit 5d193ce8f1fa7c67c7fd7be2c03ef31eed344a4f upstream.

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
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/musb_core.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2302,18 +2302,12 @@ static int musb_suspend(struct device *d
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


