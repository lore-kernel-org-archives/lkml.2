Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357Ab0HJWK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:10:27 -0400
Received: from kroah.org ([198.145.64.141]:44858 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933355Ab0HJV77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:59:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 23/68] synclink: reworking locking a bit
Date: Tue, 10 Aug 2010 14:58:45 -0700
Message-Id: <1281477570-18944-23-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Use the port mutex and port lock to fix the various races. The locking
still isn't totally consistent but its better than before. Wants switching
to the port helpers.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/synclink_gt.c |   12 +++++++++++-
 drivers/char/synclinkmp.c  |    9 ++++++++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index 3c7ac6a..5a602eb 100644
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
index 8da976b..ac447c7 100644
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
-- 
1.7.2

