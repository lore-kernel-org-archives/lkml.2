Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab0IOVuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 17:50:19 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:64967 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab0IOVuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 17:50:16 -0400
Subject: [PATCH] drivers/video/sis/sis_main.c: prevent reading
 uninitialized stack memory
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: thomas@winischhofer.net
Cc: linux-kernel@vger.kernel.org, security@kernel.org, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 17:43:53 -0400
Message-ID: <1284587033.6275.96.camel@dan>
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

--- linux-2.6.35.4.orig/drivers/video/sis/sis_main.c	2010-08-26 19:47:12.000000000 -0400
+++ linux-2.6.35.4/drivers/video/sis/sis_main.c	2010-09-15 11:52:41.437375730 -0400
@@ -1701,6 +1701,9 @@ static int	sisfb_ioctl(struct fb_info *i
 		break;
 
 	   case FBIOGET_VBLANK:
+
+		memset(&sisvbblank, 0, sizeof(struct fb_vblank));
+
 		sisvbblank.count = 0;
 		sisvbblank.flags = sisfb_setupvbblankflags(ivideo, &sisvbblank.vcount, &sisvbblank.hcount);
 




