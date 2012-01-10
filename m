Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452Ab2AJW6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 17:58:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933230Ab2AJW54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:57:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:46:20 2012
Message-Id: <20120110214620.372063394@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:45:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hema HK <hemahk@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [25/40] usb: musb: fix pm_runtime mismatch
In-Reply-To: <20120110214630.GA14384@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Contreras <felipe.contreras@gmail.com>

commit 772aed45b604c5ff171f0f12c12392d868333f79 upstream.

In musb_init_controller() there's a pm_runtime_put(), but there's no
pm_runtime_get(), which creates a mismatch that causes the driver to
sleep when it shouldn't.

This was introduced in 7acc619[1], but it wasn't triggered in my setup
until 18a2689[2] was merged to Linus' branch at point df0914[3]. IOW;
when PM is working as it was supposed to.

However, it seems most of the time this is used in a way that keeps the
counter above 0, so nobody noticed. Also, it seems to depend on the
configuration used in versions before 3.1, but not later (or in it).

I found the problem by loading isp1704_charger before any usb gadgets:
http://article.gmane.org/gmane.linux.kernel/1226122

All versions after 2.6.39 are affected.

[1] usb: musb: Idle path retention and offmode support for OMAP3
[2] OMAP2+: musb: hwmod adaptation for musb registration
[3] Merge branch 'omap-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6

Cc: Hema HK <hemahk@ti.com>
Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>

---
 drivers/usb/musb/musb_core.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2078,8 +2078,6 @@ musb_init_controller(struct device *dev,
 	if (status < 0)
 		goto fail3;
 
-	pm_runtime_put(musb->controller);
-
 	status = musb_init_debugfs(musb);
 	if (status < 0)
 		goto fail4;


