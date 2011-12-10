Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab1LJAwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 19:52:13 -0500
Received: from mail-ey0-f202.google.com ([209.85.215.202]:38950 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab1LJAwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 19:52:12 -0500
From: Havard Skinnemoen <hskinnemoen@google.com>
To: gregkh@suse.de
Cc: alan@linux.intel.com, davej@redhat.com, jslaby@suse.cz,
        linux-kernel@vger.kernel.org,
        Havard Skinnemoen <hskinnemoen@google.com>
Subject: [PATCH] cdc-acm: Kill ACM_READY() macro completely
Date: Fri,  9 Dec 2011 16:51:54 -0800
Message-Id: <1323478314-29443-1-git-send-email-hskinnemoen@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <13234763473078@kroah.org>
References: <13234763473078@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACM_READY() macro doesn't seem to do anything useful, and it may
prevent tty_wait_until_sent() from working properly when called from
close.

Previously, acm_tty_chars_in_buffer() returned 0 whenever
acm->port.count was 0. This means close() could return before all the
data has actually been written.

Signed-off-by: Havard Skinnemoen <hskinnemoen@google.com>
---
Hi Greg,

Thanks for picking up  my patch. Unfortunately, it's not completely bug-free.

This fixes an issue I found while testing the patch: After writing something to
/dev/ttyACM0, the process would hang for a fairly long time (10-15 seconds)
when closing the device. This is because port.count drops to 0 before
tty_wait_until_sent_from_close() is called, which causes ACM_READY() to return
false, any outstanding writes never get reaped because the workqueue doesn't
get scheduled, tty_wait_until_sent never sees any progress and eventually times
out.

Please feel free to fold this into "cdc-acm: Fix potential deadlock (lockdep
warning)", or let me know if you want me to send you a v2 of that patch
instead.

 drivers/usb/class/cdc-acm.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 3027ada..d9d9340 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -60,8 +60,6 @@ static struct acm *acm_table[ACM_TTY_MINORS];
 
 static DEFINE_MUTEX(acm_table_lock);
 
-#define ACM_READY(acm)	(acm && acm->dev && acm->port.count)
-
 /*
  * acm_table accessors
  */
@@ -319,9 +317,6 @@ static void acm_ctrl_irq(struct urb *urb)
 		goto exit;
 	}
 
-	if (!ACM_READY(acm))
-		goto exit;
-
 	usb_mark_last_busy(acm->dev);
 
 	data = (unsigned char *)(dr + 1);
@@ -481,8 +476,7 @@ static void acm_write_bulk(struct urb *urb)
 	spin_lock_irqsave(&acm->write_lock, flags);
 	acm_write_done(acm, wb);
 	spin_unlock_irqrestore(&acm->write_lock, flags);
-	if (ACM_READY(acm))
-		schedule_work(&acm->work);
+	schedule_work(&acm->work);
 }
 
 static void acm_softint(struct work_struct *work)
@@ -492,8 +486,6 @@ static void acm_softint(struct work_struct *work)
 
 	dev_vdbg(&acm->data->dev, "%s\n", __func__);
 
-	if (!ACM_READY(acm))
-		return;
 	tty = tty_port_tty_get(&acm->port);
 	if (!tty)
 		return;
-- 
1.7.3.1

