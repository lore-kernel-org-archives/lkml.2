Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab2CZURd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:17:33 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:18569 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755417Ab2CZURc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:17:32 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH] video/console: Clip the right margin clear to the visible region
Date: Mon, 26 Mar 2012 21:17:02 +0100
Message-Id: <1332793022-29292-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.9.1
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some unknown reason, yres_virtual was 2x larger the the size specified
by i915 and so when blit_clear_margins() tried to clear the full virtual
right-hand margin it tried to write far beyond the end of the buffer.

This limits the clear to only the visible portion of the right-hand
margin, similar to how the bottom margin is treated.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=38138
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/video/console/bitblit.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/console/bitblit.c b/drivers/video/console/bitblit.c
index 28b1a83..9f89e5a 100644
--- a/drivers/video/console/bitblit.c
+++ b/drivers/video/console/bitblit.c
@@ -219,9 +219,9 @@ static void bit_clear_margins(struct vc_data *vc, struct fb_info *info,
 
 	if (rw && !bottom_only) {
 		region.dx = info->var.xoffset + rs;
-		region.dy = 0;
+		region.dy = info->var.yoffset;
 		region.width = rw;
-		region.height = info->var.yres_virtual;
+		region.height = info->var.yres;
 		info->fbops->fb_fillrect(info, &region);
 	}
 
-- 
1.7.9.1

