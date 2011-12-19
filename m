Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab1LSUCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:02:12 -0500
Received: from smtp.nokia.com ([147.243.128.24]:23344 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab1LSUCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:02:11 -0500
From: Felipe Contreras <felipe.contreras@nokia.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap <linux-omap@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Felipe Contreras <felipe.contreras@gmail.com>, stable@vger.kernel.org,
        Hema HK <hemahk@ti.com>
Subject: [PATCH v2] usb: musb: fix pm_runtime mismatch
Date: Mon, 19 Dec 2011 22:01:54 +0200
Message-Id: <1324324914-14584-1-git-send-email-felipe.contreras@nokia.com>
X-Mailer: git-send-email 1.7.8
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Contreras <felipe.contreras@gmail.com>

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

Cc: stable@vger.kernel.org
Cc: Hema HK <hemahk@ti.com>
Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/usb/musb/musb_core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index b63ab15..920f04e 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2012,8 +2012,6 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 	if (status < 0)
 		goto fail3;
 
-	pm_runtime_put(musb->controller);
-
 	status = musb_init_debugfs(musb);
 	if (status < 0)
 		goto fail4;
-- 
1.7.8

