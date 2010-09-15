Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab0IOXIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 19:08:31 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:60646 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab0IOXIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 19:08:30 -0400
Subject: [PATCH v2] drivers/video/via/ioctl.c: prevent reading
 uninitialized stack memory
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: JosephChan@via.com.tw, ScottFang@viatech.com.cn, FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        security@kernel.org, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 19:08:24 -0400
Message-ID: <1284592104.10727.12.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disregard previous version, which had a typo and wouldn't compile.
Also, math is fun: the ioctl allows reading of 1968 BITS = 246 bytes,
not 1968 bytes as previously reported.

The VIAFB_GET_INFO device ioctl allows unprivileged users to read 246
bytes of uninitialized stack memory, because the "reserved" member of
the viafb_ioctl_info struct declared on the stack is not altered or
zeroed before being copied back to the user.  This patch takes care of
it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>

--- linux-2.6.35.4.orig/drivers/video/via/ioctl.c	2010-08-26 19:47:12.000000000 -0400
+++ linux-2.6.35.4/drivers/video/via/ioctl.c	2010-09-15 11:53:29.997375748 -0400
@@ -25,6 +25,8 @@ int viafb_ioctl_get_viafb_info(u_long ar
 {
 	struct viafb_ioctl_info viainfo;
 
+	memset(&viainfo, 0, sizeof(struct viafb_ioctl_info));
+
 	viainfo.viafb_id = VIAID;
 	viainfo.vendor_id = PCI_VIA_VENDOR_ID;
 


