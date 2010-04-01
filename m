Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341Ab0DAQgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:36:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44916 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758306Ab0DAQgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:36:08 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 14/14] synclink: reworking locking a bit
To: linux-kernel@vger.kernel.org
Date: Thu, 01 Apr 2010 17:07:18 +0100
Message-ID: <20100401160708.8882.46631.stgit@localhost.localdomain>
In-Reply-To: <20100401155513.8882.54006.stgit@localhost.localdomain>
References: <20100401155513.8882.54006.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the port mutex and port lock to fix the various races. The locking
still isn't totally consistent but its better than before. Wants switching
to the port helpers.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/synclink_gt.c |   12 +++++++++++-
 drivers/char/synclinkmp.c  |    9 ++++++++-
 2 files changed, 19 insertions(+), 2 deletions(-)


diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index d0f81f5..c56b70a 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -675,12 +675,14 @@ static int open(struct tty_struct *tty, struct file *filp)
 		goto cleanup;
 	}
 
+	mutex_lock(&info->port.mutex);
 	info->port.tty->low_latency = (info->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	spin_lock_irqsave(&info->netlock, flags);
 	if (info->netcount) {
 		retval = -EBUSY;
 		spin_unlock_irqrestore(&info->netlock, flags);
+		mutex_unlock(&info->port.mutex);
 		goto cleanup;
 	}
 	info->port.count++;
@@ -692,7 +694,7 @@ static int open(struct tty_struct *tty, struct file *filp)
 		if (retval < 0)
 			goto cleanup;
 	}
-
+	mutex_unlock(&info->port.mutex);
 	retval = block_til_ready(tty, filp, info);
 	if (retval) {
 		DBGINFO(("%s block_til_ready rc=%d\n", info->device_name, retval));
@@ -724,12 +726,14 @@ static void close(struct tty_struct *tty, struct file *filp)
 	if (tty_port_close_start(&info->port, tty, filp) == 0)
 		goto cleanup;
 
+	mutex_lock(&info->port.mutex);
  	if (info->port.flags & ASYNC_INITIALIZED)
  		wait_until_sent(tty, info->timeout);
 	flush_buffer(tty);
 	tty_ldisc_flush(tty);
 
 	shutdown(info);
+	mutex_unlock(&info->port.mutex);
 
 	tty_port_close_end(&info->port, tty);
 	info->port.tty = NULL;
@@ -740,17 +744,23 @@ cleanup:
 static void hangup(struct tty_struct *tty)
 {
 	struct slgt_info *info = tty->driver_data;
+	unsigned long flags;
 
 	if (sanity_check(info, tty->name, "hangup"))
 		return;
 	DBGINFO(("%s hangup\n", info->device_name));
 
 	flush_buffer(tty);
+
+	mutex_lock(&info->port.mutex);
 	shutdown(info);
 
+	spin_lock_irqsave(&info->port.lock, flags);
 	info->port.count = 0;
 	info->port.flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->port.tty = NULL;
+	spin_unlock_irqrestore(&info->port.lock, flags);
+	mutex_unlock(&info->port.mutex);
 
 	wake_up_interruptible(&info->port.open_wait);
 }
diff --git a/drivers/char/synclinkmp.c b/drivers/char/synclinkmp.c
index 8da976b..cfa581e 100644
--- a/drivers/char/synclinkmp.c
+++ b/drivers/char/synclinkmp.c
@@ -812,13 +812,15 @@ static void close(struct tty_struct *tty, struct file *filp)
 
 	if (tty_port_close_start(&info->port, tty, filp) == 0)
 		goto cleanup;
-		
+
+	mutex_lock(&info->port.mutex);		
  	if (info->port.flags & ASYNC_INITIALIZED)
  		wait_until_sent(tty, info->timeout);
 
 	flush_buffer(tty);
 	tty_ldisc_flush(tty);
 	shutdown(info);
+	mutex_unlock(&info->port.mutex);		
 
 	tty_port_close_end(&info->port, tty);
 	info->port.tty = NULL;
@@ -834,6 +836,7 @@ cleanup:
 static void hangup(struct tty_struct *tty)
 {
 	SLMP_INFO *info = tty->driver_data;
+	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):%s hangup()\n",
@@ -842,12 +845,16 @@ static void hangup(struct tty_struct *tty)
 	if (sanity_check(info, tty->name, "hangup"))
 		return;
 
+	mutex_lock(&info->port.mutex);		
 	flush_buffer(tty);
 	shutdown(info);
 
+	spin_lock_irqsave(&info->port.lock, flags);
 	info->port.count = 0;
 	info->port.flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->port.tty = NULL;
+	spin_unlock_irqrestore(&info->port.lock, flags);
+	mutex_unlock(&info->port.mutex);		
 
 	wake_up_interruptible(&info->port.open_wait);
 }

