Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab2KSK4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:56:08 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46138 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2KSK4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:56:07 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: gregkh@linuxfoundation.org
Cc: alan@lxorguk.ukuu.org.uk, dan.carpenter@oracle.com, wfp5p@virginia.edu,
        geert@linux-m68k.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: dgrp: dgrp_tty.c: Audit the return values of get/put_user()
Date: Mon, 19 Nov 2012 16:25:31 +0530
Message-Id: <1353322531-10092-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-- fix for missing audits for return values of get_user() and put_user().
-- Remove the TIOCSSOFTCAR ioctl handling from dgrp driver.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/dgrp/dgrp_tty.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/dgrp/dgrp_tty.c b/drivers/staging/dgrp/dgrp_tty.c
index e125b03..0354169 100644
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
@@ -2285,7 +2283,8 @@ static int set_modem_info(struct ch_struct *ch, unsigned int command,
 	if (error == 0)
 		return -EFAULT;
 
-	get_user(arg, (unsigned int __user *) value);
+	if (get_user(arg, (unsigned int __user *) value))
+		return -EFAULT;
 	mval |= ((arg & TIOCM_RTS) ? DM_RTS : 0)
 		| ((arg & TIOCM_DTR) ? DM_DTR : 0);
 
@@ -2620,15 +2619,8 @@ static int dgrp_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 			       sizeof(long));
 		if (rc == 0)
 			return -EFAULT;
-		put_user(C_CLOCAL(tty) ? 1 : 0, (unsigned long __user *) arg);
-		return 0;
-
-	case TIOCSSOFTCAR:
-		get_user(arg, (unsigned long __user *) arg);
-		tty->termios.c_cflag =
-			((tty->termios.c_cflag & ~CLOCAL) |
-			 (arg ? CLOCAL : 0));
-		return 0;
+		return put_user(C_CLOCAL(tty) ? 1 : 0,
+				(unsigned long __user *) arg);
 
 	case TIOCMGET:
 		rc = access_ok(VERIFY_WRITE, (void __user *) arg,
@@ -2854,14 +2846,17 @@ static int dgrp_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 		rc = access_ok(VERIFY_WRITE, (void __user *) arg, sizeof(int));
 		if (rc == 0)
 			return -EFAULT;
-		put_user(ch->ch_custom_speed, (unsigned int __user *) arg);
+		if (put_user(ch->ch_custom_speed, (unsigned int __user *) arg))
+			return -EFAULT;
+
 		break;
 
 	case DIGI_SETCUSTOMBAUD:
 	{
 		int new_rate;
 
-		get_user(new_rate, (unsigned int __user *) arg);
+		if (get_user(new_rate, (unsigned int __user *) arg))
+			return -EFAULT;
 		dgrp_set_custom_speed(ch, new_rate);
 
 		break;
-- 
1.7.9.5

