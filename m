Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab0EJGHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 02:07:55 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:45192 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab0EJGHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 02:07:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=VQUaQIbT1e1MJCfyNxPpUWnm1yg8UTPPGLwt++dABlsxolL6E8LSocKXsZrO32dUuG
         h5Ottpg6iblnHlI7d19O1erlS22h8umxaOhtXT178dr0SQc5QD6/70TPXgjofwr5bZN4
         1e8M8x/YwAMExKvrZTQMxe5zPxjaosKNxo3AM=
Date: Mon, 10 May 2010 14:16:02 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk
Subject: [PATCH] Block: Check major number before allocate the buffer in register_blkdev()
Message-ID: <20100510061602.GB2858@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check major number before allocate the buffer, if the major number is not exist,
and the register_blkdev() called many times, kmalloc()/kfree() will be no need 
to invoked many times. So check the major number before use kmalloc() to allocate
the buffer will be better.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 block/genhd.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index d13ba76..15360cc 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -300,30 +300,29 @@ int register_blkdev(unsigned int major, const char *name)
 		ret = major;
 	}
 
-	p = kmalloc(sizeof(struct blk_major_name), GFP_KERNEL);
-	if (p == NULL) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	p->major = major;
-	strlcpy(p->name, name, sizeof(p->name));
-	p->next = NULL;
 	index = major_to_index(major);
 
 	for (n = &major_names[index]; *n; n = &(*n)->next) {
 		if ((*n)->major == major)
 			break;
 	}
-	if (!*n)
+	if (!*n) {
+		p = kmalloc(sizeof(struct blk_major_name), GFP_KERNEL);
+		if (p == NULL) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		p->major = major;
+		strlcpy(p->name, name, sizeof(p->name));
+		p->next = NULL;
 		*n = p;
-	else
+	}
+	else {
 		ret = -EBUSY;
 
-	if (ret < 0) {
 		printk("register_blkdev: cannot get major %d for %s\n",
 		       major, name);
-		kfree(p);
 	}
 out:
 	mutex_unlock(&block_class_lock);
-- 
1.6.5.3

