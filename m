Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888Ab1J2Spq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 14:45:46 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42092 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933848Ab1J2Spo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 14:45:44 -0400
Date: Sat, 29 Oct 2011 20:45:37 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: David Herrmann <dh.herrmann@googlemail.com>,
        Arend van Spriel <arend@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5 v3] drivers/hid/hid-roccat.c: eliminate a null pointer
 dereference
In-Reply-To: <alpine.LNX.2.00.1110291857310.3541@pobox.suse.cz>
Message-ID: <Pine.LNX.4.64.1110292045180.10808@ask.diku.dk>
References: <1319846297-2985-3-git-send-email-julia@diku.dk>
 <20111029062412.GG14881@longonot.mountain> <4EABC937.60600@broadcom.com>
 <CANq1E4QJoM+NYub9hfs3KnL1w212FK0MHo8ez2p1nyGmNVb-=A@mail.gmail.com>
 <Pine.LNX.4.64.1110291411150.17700@ask.diku.dk> <alpine.LNX.2.00.1110291857310.3541@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From nobody Sat Oct 29 01:38:55 CEST 2011
From: Julia Lawall <julia@diku.dk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org,linux-kernel@vger.kernel.org
Subject: [PATCH 3/5 v3] drivers/hid/hid-roccat.c: eliminate a null pointer dereference

From: Julia Lawall <julia@diku.dk>

It is not possible to take the lock in device if device is NULL.
The mutex_lock is thus moved after the NULL test.  New error handling
labels are added at the end to differentiate between the cases where
different sets of locks should be unlocks, and between whether or not
reader should be freed (only on error).

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
Moved the error handling code back to the end.

 drivers/hid/hid-roccat.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
index 2596321..b685b04 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -163,27 +163,27 @@ static int roccat_open(struct inode *inode, struct file *file)
 
 	device = devices[minor];
 
-	mutex_lock(&device->readers_lock);
-
 	if (!device) {
 		pr_emerg("roccat device with minor %d doesn't exist\n", minor);
 		error = -ENODEV;
-		goto exit_err;
+		goto exit_err_devices;
 	}
 
+	mutex_lock(&device->readers_lock);
+
 	if (!device->open++) {
 		/* power on device on adding first reader */
 		error = hid_hw_power(device->hid, PM_HINT_FULLON);
 		if (error < 0) {
 			--device->open;
-			goto exit_err;
+			goto exit_err_readers;
 		}
 
 		error = hid_hw_open(device->hid);
 		if (error < 0) {
 			hid_hw_power(device->hid, PM_HINT_NORMAL);
 			--device->open;
-			goto exit_err;
+			goto exit_err_readers;
 		}
 	}
 
@@ -194,13 +194,13 @@ static int roccat_open(struct inode *inode, struct file *file)
 	list_add_tail(&reader->node, &device->readers);
 	file->private_data = reader;
 
-exit_unlock:
+exit_err_readers:
 	mutex_unlock(&device->readers_lock);
+exit_err_devices:
 	mutex_unlock(&devices_lock);
+	if (error)
+		kfree(reader);
 	return error;
-exit_err:
-	kfree(reader);
-	goto exit_unlock;
 }
 
 static int roccat_release(struct inode *inode, struct file *file)
