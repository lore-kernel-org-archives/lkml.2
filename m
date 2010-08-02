Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab0HBIbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:31:23 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57341 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab0HBIbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:31:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kt91xodKmS2141WIuYsIyMYgdfK7ft7QVwVLbIAu6n8eBQ/l/jrm3MBIUlv0zxfBIn
         DprRJp7bRcpxeaLRSZquAIhXDP5Rap8oM0QudlllOBxb27VF0wF1mt9VQdTp6UYGFQ/G
         jWvsKuwgzVy+Ul3YjgIpCkmh/b33tpZ47VoVM=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Simon Horman <horms@verge.net.au>, Joe Eloff <kagen101@gmail.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/9 v2] staging: dt3155: check put_user() return value
Date: Mon,  2 Aug 2010 12:31:12 +0400
Message-Id: <1280737873-5992-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put_user() return code was not checked for errors. To simplify the code
fill local struct dt3155_read with data and copy it with single
copy_to_user() call.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/dt3155/dt3155_drv.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index 7316996..4013f09 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -745,10 +745,11 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
   struct dt3155_status *dts = &dt3155_status[minor];
   struct dt3155_fbuffer *fb = &dts->fbuffer;
   struct frame_info	*frame_info;
+  struct dt3155_read dt_read;
 
   /* TODO: this should check the error flag and */
   /*   return an error on hardware failures */
-  if (count != sizeof(struct dt3155_read))
+  if (count != sizeof(dt_read))
     {
       printk(KERN_INFO "DT3155 ERROR (NJC): count is not right\n");
       return -EINVAL;
@@ -797,17 +798,15 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
 
   /* make this an offset */
   offset = frame_info->addr - dts->mem_addr;
+  dt_read.offset = offset;
+  dt_read.frame_seq = fb->frame_count;
+  dt_read.state = dts->state;
+  memcpy(&dt_read.frame_info, frame_info, sizeof(frame_info));
 
-  put_user(offset, (unsigned int __user *)buf);
-  buf += sizeof(u32);
-  put_user(fb->frame_count, (unsigned int __user *)buf);
-  buf += sizeof(u32);
-  put_user(dts->state, (unsigned int __user *)buf);
-  buf += sizeof(u32);
-  if (copy_to_user(buf, frame_info, sizeof(*frame_info)))
+  if (copy_to_user(buf, &dt_read, sizeof(dt_read)))
       return -EFAULT;
 
-  return sizeof(struct dt3155_read);
+  return sizeof(dt_read);
 }
 
 static unsigned int dt3155_poll (struct file * filp, poll_table *wait)
-- 
1.7.0.4

