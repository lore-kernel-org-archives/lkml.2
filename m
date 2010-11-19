Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005Ab0KSW1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:27:55 -0500
Received: from kroah.org ([198.145.64.141]:45120 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757440Ab0KSV6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:42 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:41 2010
Message-Id: <20101119215641.890852199@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:55:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>, Felipe Balbi <balbi@ti.com>
Subject: [38/82] USB: MUSB: fix kernel WARNING/oops when unloading module in OTG mode
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit f405387435a85a440d1ce16f3ca36e042281643a upstream.

Since commit 461972d8a4c94bc44f11a13046041c78a7cf18dd (musb_core: don't call
musb_platform_exit() twice), unloading the driver module results in a WARNING
"kobject: '(null)' (c73de788): is not initialized, yet kobject_put() is being
called." (or even kernel oops) on e.g. DaVincis, though only in the OTG mode.
There exists dubious and unbalanced put_device() call in musb_free() which
takes place only in the OTG mode.  As this commit caused musb_platform_exit()
to be called (and so unregister the NOP transceiver) before this put_device()
call, this function references already freed memory.

On the other hand, all the glue layers miss the otg_put_transceiver() call,
complementary to the otg_get_transceiver() call that they do.  So, I think
the solution is to get rid of the strange put_device() call, and instead
call otg_put_transceiver() in the glue layers...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/blackfin.c  |    1 +
 drivers/usb/musb/davinci.c   |    2 ++
 drivers/usb/musb/musb_core.c |    4 ----
 drivers/usb/musb/omap2430.c  |    1 +
 drivers/usb/musb/tusb6010.c  |    4 ++++
 5 files changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -397,5 +397,6 @@ int musb_platform_exit(struct musb *musb
 
 	gpio_free(musb->config->gpio_vrsel);
 
+	otg_put_transceiver(musb->xceiv);
 	return 0;
 }
--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -446,6 +446,7 @@ int __init musb_platform_init(struct mus
 fail:
 	clk_disable(musb->clock);
 
+	otg_put_transceiver(musb->xceiv);
 	usb_nop_xceiv_unregister();
 	return -ENODEV;
 }
@@ -496,6 +497,7 @@ int musb_platform_exit(struct musb *musb
 
 	clk_disable(musb->clock);
 
+	otg_put_transceiver(musb->xceiv);
 	usb_nop_xceiv_unregister();
 
 	return 0;
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1922,10 +1922,6 @@ static void musb_free(struct musb *musb)
 		dma_controller_destroy(c);
 	}
 
-#ifdef CONFIG_USB_MUSB_OTG
-	put_device(musb->xceiv->dev);
-#endif
-
 #ifdef CONFIG_USB_MUSB_HDRC_HCD
 	usb_put_hcd(musb_to_hcd(musb));
 #else
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -326,5 +326,6 @@ int musb_platform_exit(struct musb *musb
 
 	musb_platform_suspend(musb);
 
+	otg_put_transceiver(musb->xceiv);
 	return 0;
 }
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -1152,6 +1152,8 @@ done:
 	if (ret < 0) {
 		if (sync)
 			iounmap(sync);
+
+		otg_put_transceiver(musb->xceiv);
 		usb_nop_xceiv_unregister();
 	}
 	return ret;
@@ -1166,6 +1168,8 @@ int musb_platform_exit(struct musb *musb
 		musb->board_set_power(0);
 
 	iounmap(musb->sync_va);
+
+	otg_put_transceiver(musb->xceiv);
 	usb_nop_xceiv_unregister();
 	return 0;
 }


