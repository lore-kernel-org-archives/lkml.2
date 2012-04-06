Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab2DFNct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 09:32:49 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43506 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256Ab2DFNcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 09:32:46 -0400
From: Xi Wang <xi.wang@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>
Subject: [PATCH 2/2] [media] v4l2-ctrls: fix integer overflow in try_set_ext_ctrls()
Date: Fri,  6 Apr 2012 09:32:37 -0400
Message-Id: <1333719157-31240-2-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333719157-31240-1-git-send-email-xi.wang@gmail.com>
References: <1333719157-31240-1-git-send-email-xi.wang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A large cs->count from userspace may overflow the allocation size,
leading to memory corruption.  try_set_ext_ctrls() can be reached
from subdev_do_ioctl() or __video_do_ioctl().

Use kmalloc_array() to avoid the overflow.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 drivers/media/video/v4l2-ctrls.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index f355fd5..6f38a5d 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -2219,7 +2219,8 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 		return class_check(hdl, cs->ctrl_class);
 
 	if (cs->count > ARRAY_SIZE(helper)) {
-		helpers = kmalloc(sizeof(helper[0]) * cs->count, GFP_KERNEL);
+		helpers = kmalloc_array(cs->count, sizeof(helper[0]),
+					GFP_KERNEL);
 		if (!helpers)
 			return -ENOMEM;
 	}
-- 
1.7.5.4

