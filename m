Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab0GaRiV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 13:38:21 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64898 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab0GaRiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 13:38:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SI8fY2nxxXbpaLyokHltN+cpzi8cwU3XrjIm7Q426kebkJTTF16mRNrw3PBdvUPNxi
         x3CkC9TVlGYnrMp9qyJuY8dIDPTjZmOEUiqUMBodSEN0oH1kr126cqP5HbWNKbkBV0Zn
         xai1RVMj7Ph1PJHhnE1ulrEP93cThr+f57yi0=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Ungerer <gerg@uclinux.org>, Christoph Egger <siccegge@cs.fau.de>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] 68328serial: check return value of copy_*_user() instead of access_ok()
Date: Sat, 31 Jul 2010 21:38:00 +0400
Message-Id: <1280597881-8365-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As copy_*_user() calls access_ok() it should not be called explicitly.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/serial/68328serial.c |   29 ++++++++++-------------------
 1 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
index 7356a56..ab6ad8b 100644
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
@@ -999,27 +1001,16 @@ static int rs_ioctl(struct tty_struct *tty, struct file * file,
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
-				return -EFAULT;
-			copy_to_user((struct m68k_serial *) arg,
+			return copy_to_user((struct m68k_serial *) arg,
 				    info, sizeof(struct m68k_serial));
-			return 0;
-			
 		default:
 			return -ENOIOCTLCMD;
 		}
-- 
1.7.0.4

