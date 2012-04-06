Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab2DFNcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 09:32:46 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:64578 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab2DFNco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 09:32:44 -0400
From: Xi Wang <xi.wang@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>
Subject: [PATCH 1/2] [media] v4l2-ctrls: fix integer overflow in v4l2_g_ext_ctrls()
Date: Fri,  6 Apr 2012 09:32:36 -0400
Message-Id: <1333719157-31240-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A large cs->count from userspace may overflow the allocation size,
leading to memory corruption.  v4l2_g_ext_ctrls() can be reached
from subdev_do_ioctl() or __video_do_ioctl().

Use kmalloc_array() to avoid the overflow.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 drivers/media/video/v4l2-ctrls.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 18015c0..f355fd5 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1996,7 +1996,8 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 		return class_check(hdl, cs->ctrl_class);
 
 	if (cs->count > ARRAY_SIZE(helper)) {
-		helpers = kmalloc(sizeof(helper[0]) * cs->count, GFP_KERNEL);
+		helpers = kmalloc_array(cs->count, sizeof(helper[0]),
+					GFP_KERNEL);
 		if (helpers == NULL)
 			return -ENOMEM;
 	}
-- 
1.7.5.4

