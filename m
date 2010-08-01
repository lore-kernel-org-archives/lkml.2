Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab0HAG3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 02:29:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60680 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0HAG3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 02:29:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NOUetooMWt9zs4YwF8aY9yVYAAWT6R3pAaD41qGzD4SRRKBjxI/JTQYA0dC52Ix+Pk
         T0PkNwxemWWMy0ayYGDXMaT2bppXVG+46Wn/FtYd+3N12KtR1nCUmOKpXAOhRKuPBcHY
         xqzoAm3/0/XTjPHf0j5QnG8COvBOBdFM6vvP8=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Ungerer <gerg@uclinux.org>, Christoph Egger <siccegge@cs.fau.de>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7 v2] 68328serial: check return value of copy_*_user() instead of access_ok()
Date: Sun,  1 Aug 2010 10:29:06 +0400
Message-Id: <1280644146-4418-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As copy_*_user() calls access_ok() it should not be called explicitly.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/serial/68328serial.c |   29 +++++++++++------------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
index 7356a56..be0ebce 100644
--- a/drivers/serial/68328serial.c
+++ b/drivers/serial/68328serial.c
@@ -869,7 +869,9 @@ static int get_serial_info(struct m68k_serial * info,
 	tmp.close_delay = info->close_delay;
 	tmp.closing_wait = info->closing_wait;
 	tmp.custom_divisor = info->custom_divisor;
-	copy_to_user(retinfo,&tmp,sizeof(*retinfo));
+	if (copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
+		return -EFAULT;
+
 	return 0;
 }
 
@@ -882,7 +884,8 @@ static int set_serial_info(struct m68k_serial * info,
 
 	if (!new_info)
 		return -EFAULT;
-	copy_from_user(&new_serial,new_info,sizeof(new_serial));
+	if (copy_from_user(&new_serial, new_info, sizeof(new_serial)))
+		return -EFAULT;
 	old_info = *info;
 
 	if (!capable(CAP_SYS_ADMIN)) {
@@ -943,8 +946,7 @@ static int get_lsr_info(struct m68k_serial * info, unsigned int *value)
 	status = 0;
 #endif
 	local_irq_restore(flags);
-	put_user(status,value);
-	return 0;
+	return put_user(status, value);
 }
 
 /*
@@ -999,27 +1001,18 @@ static int rs_ioctl(struct tty_struct *tty, struct file * file,
 			send_break(info, arg ? arg*(100) : 250);
 			return 0;
 		case TIOCGSERIAL:
-			if (access_ok(VERIFY_WRITE, (void *) arg,
-						sizeof(struct serial_struct)))
-				return get_serial_info(info,
-					       (struct serial_struct *) arg);
-			return -EFAULT;
+			return get_serial_info(info,
+				       (struct serial_struct *) arg);
 		case TIOCSSERIAL:
 			return set_serial_info(info,
 					       (struct serial_struct *) arg);
 		case TIOCSERGETLSR: /* Get line status register */
-			if (access_ok(VERIFY_WRITE, (void *) arg,
-						sizeof(unsigned int)))
-				return get_lsr_info(info, (unsigned int *) arg);
-			return -EFAULT;
+			return get_lsr_info(info, (unsigned int *) arg);
 		case TIOCSERGSTRUCT:
-			if (!access_ok(VERIFY_WRITE, (void *) arg,
-						sizeof(struct m68k_serial)))
+			if (copy_to_user((struct m68k_serial *) arg,
+				    info, sizeof(struct m68k_serial)))
 				return -EFAULT;
-			copy_to_user((struct m68k_serial *) arg,
-				    info, sizeof(struct m68k_serial));
 			return 0;
-			
 		default:
 			return -ENOIOCTLCMD;
 		}
-- 
1.7.0.4

