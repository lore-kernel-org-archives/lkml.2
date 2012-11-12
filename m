Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab2KLLI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:08:29 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42909 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab2KLLI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:08:27 -0500
Date: Mon, 12 Nov 2012 14:08:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] fbmem: return -EFAULT on copy_to_user() failure
Message-ID: <20121112110814.GB1678@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to_user() returns the number of bytes remaining to be copied.
put_user() returns -EFAULT on error.

This function ORs a bunch of stuff together and returns jumbled non-zero
values on error.  It should return -EFAULT.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 3ff0105..3d2a4d0 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1302,8 +1302,9 @@ static int do_fscreeninfo_to_user(struct fb_fix_screeninfo *fix,
 	err |= put_user(fix->accel, &fix32->accel);
 	err |= copy_to_user(fix32->reserved, fix->reserved,
 			    sizeof(fix->reserved));
-
-	return err;
+	if (err)
+		return -EFAULT;
+	return 0;
 }
 
 static int fb_get_fscreeninfo(struct fb_info *info, unsigned int cmd,
