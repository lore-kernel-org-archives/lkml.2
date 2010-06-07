Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab0FGS0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:26:34 -0400
Received: from p01c11o143.mxlogic.net ([208.65.144.66]:44228 "EHLO
	p01c11o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab0FGS0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:26:32 -0400
X-MXL-Hash: 4c0d39d8637e72cd-7489493412a986676fa291059d377148a870431f
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
CC: Greg KH <gregkh@suse.de>
Date: Mon, 7 Jun 2010 13:25:37 -0500
Subject: [PATCH] Staging: dt3155: fix different address spaces noise in
 dt3155_drv.c
Thread-Topic: [PATCH] Staging: dt3155: fix different address spaces noise in
 dt3155_drv.c
Thread-Index: AcsGbtM5SEm1hoYJRbei242pYAKQ9g==
Message-ID: <0D753D10438DA54287A00B0270842697636F83AE81@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010052801)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [(unknown)]
X-AnalysisOut: [v=1.0 c=1 a=KEiZf0DKLZkA:10 a=yQWWgrYGNuUA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=IkcTkHD0fZMA:10 a=MfCJKx98tC58LqYwCYfhJw==:17 a=i0]
X-AnalysisOut: [0gxMtYAAAA:8 a=5FfMgeX54Kp29W8Kf2EA:9 a=JuO63lYOeBiWWo1fma]
X-AnalysisOut: [YA:7 a=KLYwbPu5UoHbn3Gvq2ha_2RZIb0A:4 a=QEXdDO2ut3YA:10 a=]
X-AnalysisOut: [x1WnkoZAwusA:10 a=0kPLrQdw3YYA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o57IQhim028383

This fixes the different address spaces noise when copying data to/from
user space to kernel space.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index 40ef97f..3024d35 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -521,6 +521,7 @@ static int dt3155_ioctl(struct inode *inode,
 			unsigned long arg)
 {
   int minor = MINOR(inode->i_rdev); /* What device are we ioctl()'ing? */
+  void __user *up = (void __user *)arg;
 
   if (minor >= MAXBOARDS || minor < 0)
     return -ENODEV;
@@ -547,7 +548,7 @@ static int dt3155_ioctl(struct inode *inode,
 
 	{
 	  struct dt3155_config tmp;
-	  if (copy_from_user((void *)&tmp, (void *) arg, sizeof(tmp)))
+	  if (copy_from_user(&tmp, up, sizeof(tmp)))
 	      return -EFAULT;
 	  /* check for valid settings */
 	  if (tmp.rows > DT3155_MAX_ROWS ||
@@ -565,7 +566,7 @@ static int dt3155_ioctl(struct inode *inode,
       }
     case DT3155_GET_CONFIG:
       {
-	if (copy_to_user((void *) arg, (void *) &dt3155_status[minor],
+	if (copy_to_user(up, &dt3155_status[minor],
 		     sizeof(struct dt3155_status)))
 	    return -EFAULT;
 	return 0;
@@ -586,7 +587,7 @@ static int dt3155_ioctl(struct inode *inode,
 	  return 0;
 
 	quick_stop(minor);
-	if (copy_to_user((void *) arg, (void *) &dt3155_status[minor],
+	if (copy_to_user(up, &dt3155_status[minor],
 		     sizeof(struct dt3155_status)))
 	    return -EFAULT;
 	return 0;
@@ -610,7 +611,7 @@ static int dt3155_ioctl(struct inode *inode,
 	  }
 
 	dt3155_init_isr(minor);
-	if (copy_to_user((void *) arg, (void *) &dt3155_status[minor],
+	if (copy_to_user(up, &dt3155_status[minor],
 		      sizeof(struct dt3155_status)))
 	    return -EFAULT;
 	return 0;
@@ -812,11 +813,11 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
   /* make this an offset */
   offset = frame_info->addr - dt3155_status[minor].mem_addr;
 
-  put_user(offset, (unsigned int *) buf);
+  put_user(offset, (unsigned int __user *)buf);
   buf += sizeof(u32);
-  put_user(dt3155_status[minor].fbuffer.frame_count, (unsigned int *) buf);
+  put_user(dt3155_status[minor].fbuffer.frame_count, (unsigned int __user *)buf);
   buf += sizeof(u32);
-  put_user(dt3155_status[minor].state, (unsigned int *) buf);
+  put_user(dt3155_status[minor].state, (unsigned int __user *)buf);
   buf += sizeof(u32);
   if (copy_to_user(buf, frame_info, sizeof(*frame_info)))
       return -EFAULT;
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
