Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab1K2Vdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:33:53 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42257 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab1K2Vdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:33:50 -0500
From: Haogang Chen <haogangchen@gmail.com>
To: laurent.pinchart@ideasonboard.com, mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haogang Chen <haogangchen@gmail.com>
Subject: [PATCH] Media: video: uvc: integer overflow in uvc_ioctl_ctrl_map()
Date: Tue, 29 Nov 2011 16:32:25 -0500
Message-Id: <1322602345-26279-1-git-send-email-haogangchen@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a potential integer overflow in uvc_ioctl_ctrl_map(). When a
large xmap->menu_count is passed from the userspace, the subsequent call
to kmalloc() will allocate a buffer smaller than expected.
map->menu_count and map->menu_info would later be used in a loop (e.g.
in uvc_query_v4l2_ctrl), which leads to out-of-bound access.

The patch checks the ioctl argument and returns -EINVAL for zero or too
large values in xmap->menu_count.

Signed-off-by: Haogang Chen <haogangchen@gmail.com>
---
 drivers/media/video/uvc/uvc_v4l2.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index dadf11f..9a180d6 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -58,6 +58,12 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
 		break;
 
 	case V4L2_CTRL_TYPE_MENU:
+		if (xmap->menu_count == 0 ||
+		    xmap->menu_count > INT_MAX / sizeof(*map->menu_info)) {
+			kfree(map);
+			return -EINVAL;
+		}
+
 		size = xmap->menu_count * sizeof(*map->menu_info);
 		map->menu_info = kmalloc(size, GFP_KERNEL);
 		if (map->menu_info == NULL) {
-- 
1.7.5.4

