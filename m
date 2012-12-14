Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab2LNUaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 15:30:20 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47319 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab2LNUaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 15:30:17 -0500
From: Kamal Mostafa <kamal@whence.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fbcon: clear the logo bitmap from the margin area
Date: Fri, 14 Dec 2012 12:30:15 -0800
Message-Id: <1355517015-4926-1-git-send-email-kamal@whence.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Explicitly clear_margins when clearing the logo, in case the font dimensions
are non-integral to the framebuffer dimensions.

Signed-off-by: Kamal Mostafa <kamal@whence.com>
---
 drivers/video/console/fbcon.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 8745637..b51a4bd 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -1236,8 +1236,16 @@ static void fbcon_clear(struct vc_data *vc, int sy, int sx, int height,
 	if (!height || !width)
 		return;
 
-	if (sy < vc->vc_top && vc->vc_top == logo_lines)
+	if (sy < vc->vc_top && vc->vc_top == logo_lines) {
 		vc->vc_top = 0;
+		/*
+		 * If the font dimensions are not an integral of the display
+		 * dimensions then the ops->clear below won't end up clearing
+		 * the margins.  Call clear_margins here in case the logo
+		 * bitmap stretched into the margin area.
+		 */
+		fbcon_clear_margins(vc, 0);
+	}
 
 	/* Split blits that cross physical y_wrap boundary */
 
-- 
1.7.10.4

