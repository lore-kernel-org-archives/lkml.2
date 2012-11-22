Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab2KVTrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:47:13 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59763 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab2KVTrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:47:09 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dan.carpenter@oracle.com, alan@lxorguk.ukuu.org.uk, wfp5p@virginia.edu,
        geert@linux-m68k.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] staging: dgrp: dgrp_tty.c: Audit the return values of get/put_user()
Date: Fri, 23 Nov 2012 01:16:35 +0530
Message-Id: <1353613595-8505-3-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353613595-8505-1-git-send-email-gmate.amit@gmail.com>
References: <1353613595-8505-1-git-send-email-gmate.amit@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix for missing audits for return values of get_user() and put_user().
Inspecting the return values of get/put_user() would make the access_ok()
redundant, hence removing calls to access_ok() in such scenarios.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/dgrp/dgrp_tty.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/dgrp/dgrp_tty.c b/drivers/staging/dgrp/dgrp_tty.c
index b46f56f..f4fdadc 100644
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
 
@@ -2616,12 +2615,8 @@ static int dgrp_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 		return 0;
 
 	case TIOCGSOFTCAR:
-		rc = access_ok(VERIFY_WRITE, (void __user *) arg,
-			       sizeof(long));
-		if (rc == 0)
-			return -EFAULT;
-		put_user(C_CLOCAL(tty) ? 1 : 0, (unsigned long __user *) arg);
-		return 0;
+		return put_user(C_CLOCAL(tty) ? 1 : 0,
+				(unsigned long __user *) arg);
 
 	case TIOCMGET:
 		rc = access_ok(VERIFY_WRITE, (void __user *) arg,
@@ -2844,17 +2839,16 @@ static int dgrp_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 		break;
 
 	case DIGI_GETCUSTOMBAUD:
-		rc = access_ok(VERIFY_WRITE, (void __user *) arg, sizeof(int));
-		if (rc == 0)
+		if (put_user(ch->ch_custom_speed, (unsigned int __user *) arg))
 			return -EFAULT;
-		put_user(ch->ch_custom_speed, (unsigned int __user *) arg);
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

