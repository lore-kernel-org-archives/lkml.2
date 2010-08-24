Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab0HXEYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 00:24:32 -0400
Received: from kroah.org ([198.145.64.141]:56435 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab0HXEYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 00:24:21 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kulikov Vasiliy <segooon@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 6/6] 68328serial: check return value of copy_*_user() instead of access_ok()
Date: Mon, 23 Aug 2010 21:24:06 -0700
Message-Id: <1282623846-17050-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100824040508.GC16749@kroah.com>
References: <20100824040508.GC16749@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kulikov Vasiliy <segooon@gmail.com>

As copy_*_user() calls access_ok() it should not be called explicitly.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.2

