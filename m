Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab0EVIZL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:25:11 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60773 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767Ab0EVIZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:25:08 -0400
Date: Sat, 22 May 2010 10:25:03 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 21/27] drivers/ide: Use memdup_user
Message-ID: <Pine.LNX.4.64.1005221024470.13021@ask.diku.dk>
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
 drivers/ide/ide-taskfile.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 67fb735..34b9872 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -480,13 +480,9 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 	u16 nsect		= 0;
 	char __user *buf = (char __user *)arg;
 
-	req_task = kzalloc(tasksize, GFP_KERNEL);
-	if (req_task == NULL)
-		return -ENOMEM;
-	if (copy_from_user(req_task, buf, tasksize)) {
-		kfree(req_task);
-		return -EFAULT;
-	}
+	req_task = memdup_user(buf, tasksize);
+	if (IS_ERR(req_task))
+		return PTR_ERR(req_task);
 
 	taskout = req_task->out_size;
 	taskin  = req_task->in_size;
