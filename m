Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab0EVI0c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:26:32 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:35075 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831Ab0EVI02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:26:28 -0400
Date: Sat, 22 May 2010 10:26:22 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 25/27] drivers/usb/gadget: Use memdup_user
Message-ID: <Pine.LNX.4.64.1005221026050.13021@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use memdup_user when user data is immediately copied into the
allocated region.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
position p;
identifier l1,l2;
@@

-  to = \(kmalloc@p\|kzalloc@p\)(size,flag);
+  to = memdup_user(from,size);
   if (
-      to==NULL
+      IS_ERR(to)
                 || ...) {
   <+... when != goto l1;
-  -ENOMEM
+  PTR_ERR(to)
   ...+>
   }
-  if (copy_from_user(to, from, size) != 0) {
-    <+... when != goto l2;
-    -EFAULT
-    ...+>
-  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/usb/gadget/inode.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index de8a838..63fc171 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -1867,13 +1867,9 @@ dev_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 	buf += 4;
 	length -= 4;
 
-	kbuf = kmalloc (length, GFP_KERNEL);
-	if (!kbuf)
-		return -ENOMEM;
-	if (copy_from_user (kbuf, buf, length)) {
-		kfree (kbuf);
-		return -EFAULT;
-	}
+	kbuf = memdup_user(buf, length);
+	if (IS_ERR(kbuf))
+		return PTR_ERR(kbuf);
 
 	spin_lock_irq (&dev->lock);
 	value = -EINVAL;
