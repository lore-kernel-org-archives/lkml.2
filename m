Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab0EVIVN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:21:13 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:60308 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab0EVIVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:21:08 -0400
Date: Sat, 22 May 2010 10:21:02 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 9/27] drivers/media: Use memdup_user
Message-ID: <Pine.LNX.4.64.1005221020440.13021@ask.diku.dk>
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
 drivers/media/dvb/dvb-core/dvb_demux.c |   10 +++-------
 drivers/media/video/dabusb.c           |   13 ++++---------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_demux.c b/drivers/media/dvb/dvb-core/dvb_demux.c
index 977ddba..4a88a3e 100644
--- a/drivers/media/dvb/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb/dvb-core/dvb_demux.c
@@ -1130,13 +1130,9 @@ static int dvbdmx_write(struct dmx_demux *demux, const char __user *buf, size_t
 	if ((!demux->frontend) || (demux->frontend->source != DMX_MEMORY_FE))
 		return -EINVAL;
 
-	p = kmalloc(count, GFP_USER);
-	if (!p)
-		return -ENOMEM;
-	if (copy_from_user(p, buf, count)) {
-		kfree(p);
-		return -EFAULT;
-	}
+	p = memdup_user(buf, count);
+	if (IS_ERR(p))
+		return PTR_ERR(p);
 	if (mutex_lock_interruptible(&dvbdemux->mutex)) {
 		kfree(p);
 		return -ERESTARTSYS;
diff --git a/drivers/media/video/dabusb.c b/drivers/media/video/dabusb.c
index 0f50508..5b176bd 100644
--- a/drivers/media/video/dabusb.c
+++ b/drivers/media/video/dabusb.c
@@ -706,16 +706,11 @@ static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg
 	switch (cmd) {
 
 	case IOCTL_DAB_BULK:
-		pbulk = kmalloc(sizeof (bulk_transfer_t), GFP_KERNEL);
+		pbulk = memdup_user((void __user *)arg,
+				    sizeof(bulk_transfer_t));
 
-		if (!pbulk) {
-			ret = -ENOMEM;
-			break;
-		}
-
-		if (copy_from_user (pbulk, (void __user *) arg, sizeof (bulk_transfer_t))) {
-			ret = -EFAULT;
-			kfree (pbulk);
+		if (IS_ERR(pbulk)) {
+			ret = PTR_ERR(pbulk);
 			break;
 		}
 
