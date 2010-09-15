Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab0IOVu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 17:50:58 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:52438 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab0IOVu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 17:50:56 -0400
Subject: [PATCH] drivers/media/video/ivtv/ivtvfb.c: prevent reading
 uninitialized stack memory
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: awalls@md.metrocast.net
Cc: ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, security@kernel.org, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 17:44:22 -0400
Message-ID: <1284587062.6275.102.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FBIOGET_VBLANK device ioctl allows unprivileged users to read 16
bytes of uninitialized stack memory, because the "reserved" member of
the fb_vblank struct declared on the stack is not altered or zeroed
before being copied back to the user.  This patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>

--- linux-2.6.35.4.orig/drivers/media/video/ivtv/ivtvfb.c	2010-08-26 19:47:12.000000000 -0400
+++ linux-2.6.35.4/drivers/media/video/ivtv/ivtvfb.c	2010-09-15 14:16:46.797375399 -0400
@@ -458,6 +458,8 @@ static int ivtvfb_ioctl(struct fb_info *
 			struct fb_vblank vblank;
 			u32 trace;
 
+			memset(&vblank, 0, sizeof(struct fb_vblank));
+
 			vblank.flags = FB_VBLANK_HAVE_COUNT |FB_VBLANK_HAVE_VCOUNT |
 					FB_VBLANK_HAVE_VSYNC;
 			trace = read_reg(IVTV_REG_DEC_LINE_FIELD) >> 16;




