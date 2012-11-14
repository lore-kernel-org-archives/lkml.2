Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab2KNGc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:32:56 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59367 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab2KNGcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:32:55 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: gregkh@linuxfoundation.org
Cc: wfp5p@virginia.edu, geert@linux-m68k.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: dgrp: dgrp_tty.c: return an -EFAULT if put_user fails
Date: Wed, 14 Nov 2012 12:02:21 +0530
Message-Id: <1352874741-18526-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix adds checks for inspecting the return value of put_user() and return
-EFAULT on error.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/dgrp/dgrp_tty.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dgrp/dgrp_tty.c b/drivers/staging/dgrp/dgrp_tty.c
index e125b03..b294197 100644
--- a/drivers/staging/dgrp/dgrp_tty.c
+++ b/drivers/staging/dgrp/dgrp_tty.c
@@ -2265,7 +2265,8 @@ static int get_modem_info(struct ch_struct *ch, unsigned int *value)
 		| ((mlast & DM_RI)  ? TIOCM_RNG : 0)
 		| ((mlast & DM_DSR) ? TIOCM_DSR : 0)
 		| ((mlast & DM_CTS) ? TIOCM_CTS : 0);
-	put_user(mlast, (unsigned int __user *) value);
+	if (put_user(mlast, (unsigned int __user *) value))
+		return -EFAULT;
 
 	return 0;
 }
@@ -2620,7 +2621,8 @@ static int dgrp_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 			       sizeof(long));
 		if (rc == 0)
 			return -EFAULT;
-		put_user(C_CLOCAL(tty) ? 1 : 0, (unsigned long __user *) arg);
+		if (put_user(C_CLOCAL(tty) ? 1 : 0, (unsigned long __user *) arg))
+			return -EFAULT;
 		return 0;
 
 	case TIOCSSOFTCAR:
@@ -2854,7 +2856,8 @@ static int dgrp_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 		rc = access_ok(VERIFY_WRITE, (void __user *) arg, sizeof(int));
 		if (rc == 0)
 			return -EFAULT;
-		put_user(ch->ch_custom_speed, (unsigned int __user *) arg);
+		if (put_user(ch->ch_custom_speed, (unsigned int __user *) arg))
+			return -EFAULT;
 		break;
 
 	case DIGI_SETCUSTOMBAUD:
-- 
1.7.9.5

