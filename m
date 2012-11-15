Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767674Ab2KOMQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 07:16:15 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47695 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993412Ab2KOMQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 07:16:14 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: gregkh@linuxfoundation.org
Cc: alan@lxorguk.ukuu.org.uk, dan.carpenter@oracle.com, wfp5p@virginia.edu,
        geert@linux-m68k.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH v3] staging: dgrp: dgrp_tty.c: return an -EFAULT if put_user() fails
Date: Thu, 15 Nov 2012 17:45:32 +0530
Message-Id: <1352981732-7864-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inspect the return value of put_user() and return -EFAULT on error.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/dgrp/dgrp_tty.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/dgrp/dgrp_tty.c b/drivers/staging/dgrp/dgrp_tty.c
index e125b03..bc14479 100644
--- a/drivers/staging/dgrp/dgrp_tty.c
+++ b/drivers/staging/dgrp/dgrp_tty.c
@@ -2265,9 +2265,7 @@ static int get_modem_info(struct ch_struct *ch, unsigned int *value)
 		| ((mlast & DM_RI)  ? TIOCM_RNG : 0)
 		| ((mlast & DM_DSR) ? TIOCM_DSR : 0)
 		| ((mlast & DM_CTS) ? TIOCM_CTS : 0);
-	put_user(mlast, (unsigned int __user *) value);
-
-	return 0;
+	return put_user(mlast, (unsigned int __user *) value);
 }
 
 /*
@@ -2620,8 +2618,7 @@ static int dgrp_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 			       sizeof(long));
 		if (rc == 0)
 			return -EFAULT;
-		put_user(C_CLOCAL(tty) ? 1 : 0, (unsigned long __user *) arg);
-		return 0;
+		return put_user(C_CLOCAL(tty) ? 1 : 0, (unsigned long __user *) arg);
 
 	case TIOCSSOFTCAR:
 		get_user(arg, (unsigned long __user *) arg);
@@ -2854,7 +2851,8 @@ static int dgrp_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
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

