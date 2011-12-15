Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660Ab1LOWma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:42:30 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36387 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759605Ab1LOWm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:42:28 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Felipe Contreras <felipe.contreras@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] usb: musb: fix pm_runtime mismatch
Date: Fri, 16 Dec 2011 00:42:14 +0200
Message-Id: <1323988934-11350-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1.14.g248db
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In musb_init_controller() there's a pm_runtime_put(), but there's no
pm_runtime_get(), which creates a mismatch that causes the driver to
sleep when it shouldn't.

This was introduced in 7acc619, but it wasn't triggered until 18a2689
was merged to Linus' branch at point 6899608.

However, it seems most of the time this is used in a way that keeps the
counter above 0, so nobody noticed. Also, it seems to depend on the
configuration used.

I found the problem by loading isp1704_charger before any usb gadgets:
http://article.gmane.org/gmane.linux.kernel/1226122

All versions after 2.6.39 are affected.

Cc: stable@vger.kernel.org
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
1.7.8.rc1.14.g248db

