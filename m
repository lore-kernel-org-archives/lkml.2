Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab1J1X7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 19:59:03 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42343 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838Ab1J1X66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 19:58:58 -0400
From: Julia Lawall <julia@diku.dk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: kernel-janitors@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] drivers/hid/hid-roccat.c: eliminate a null pointer dereference
Date: Sat, 29 Oct 2011 01:58:15 +0200
Message-Id: <1319846297-2985-3-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

It is not possible to take the lock in device if device is NULL.
The mutex_lock is thus moved after the NULL test, and the relevant part of
the shared error handling code is moved up.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression E, E1;
identifier f;
statement S1,S2,S3;
@@

if (E == NULL)
{
  ... when != if (E == NULL || ...) S1 else S2
      when != E = E1
*E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/hid/hid-roccat.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
index 2596321..36a28b8 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -163,14 +163,15 @@ static int roccat_open(struct inode *inode, struct file *file)
 
 	device = devices[minor];
 
-	mutex_lock(&device->readers_lock);
-
 	if (!device) {
 		pr_emerg("roccat device with minor %d doesn't exist\n", minor);
-		error = -ENODEV;
-		goto exit_err;
+		kfree(reader);
+		mutex_lock(&devices_lock);
+		return -ENODEV;
 	}
 
+	mutex_lock(&device->readers_lock);
+
 	if (!device->open++) {
 		/* power on device on adding first reader */
 		error = hid_hw_power(device->hid, PM_HINT_FULLON);

