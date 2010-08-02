Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab0HBM4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:56:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47383 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0HBM4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:56:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IaFNj6kUWGqTbRi3XaeYrjBA7SOP1GkjgFoJq4cCWUAA/XO4V4cKbqLrpB01SJwU2u
         YL0FKz7bZjNT96lU71/g7GTvuROj6K08KqSVS6lu+WmNGPwO7tK3IhsVLyuQB1yy+KVK
         LVFmlBzpP5T/D/X0Sahi7vh5fOSoqEuUFe6nw=
Date: Mon, 2 Aug 2010 16:56:38 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Simon Horman <horms@verge.net.au>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Joe Eloff <kagen101@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/9 v3] staging: dt3155: check put_user() return value
Message-ID: <20100802125638.GA6412@albatros>
References: <1280737873-5992-1-git-send-email-segooon@gmail.com>
 <20100802124125.GG5814@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802124125.GG5814@verge.net.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put_user() returns code was not checked for errors. To simplify the code
fill local struct dt3155_read with data and copy it with single
copy_to_user() call.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/dt3155/dt3155_drv.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index 7316996..6031837 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -745,6 +745,7 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
   struct dt3155_status *dts = &dt3155_status[minor];
   struct dt3155_fbuffer *fb = &dts->fbuffer;
   struct frame_info	*frame_info;
+  struct dt3155_read dt_read;
 
   /* TODO: this should check the error flag and */
   /*   return an error on hardware failures */
@@ -797,14 +798,12 @@ static ssize_t dt3155_read(struct file *filep, char __user *buf,
 
   /* make this an offset */
   offset = frame_info->addr - dts->mem_addr;
+  dt_read.offset = offset;
+  dt_read.frame_seq = fb->frame_count;
+  dt_read.state = dts->state;
+  memcpy(&dt_read.frame_info, frame_info, sizeof(struct frame_info));
 
-  put_user(offset, (unsigned int __user *)buf);
-  buf += sizeof(u32);
-  put_user(fb->frame_count, (unsigned int __user *)buf);
-  buf += sizeof(u32);
-  put_user(dts->state, (unsigned int __user *)buf);
-  buf += sizeof(u32);
-  if (copy_to_user(buf, frame_info, sizeof(*frame_info)))
+  if (copy_to_user(buf, &dt_read, sizeof(struct dt3155_read)))
       return -EFAULT;
 
   return sizeof(struct dt3155_read);
-- 
1.7.0.4

