Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab2KVXL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 18:11:28 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:45121 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916Ab2KVXL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 18:11:26 -0500
Message-ID: <50AEB10D.3050909@ilyx.ru>
Date: Fri, 23 Nov 2012 03:11:09 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2] tty: Add driver unthrottle in ioctl(...,TCFLSH,..).
References: <50AEAF20.3070001@ilyx.ru>
In-Reply-To: <50AEAF20.3070001@ilyx.ru>
X-Forwarded-Message-Id: <50AEAF20.3070001@ilyx.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regression 'tty: fix "IRQ45: nobody cared"'
Regression commit 7b292b4bf9a9d6098440d85616d6ca4c608b8304

  Function reset_buffer_flags() also invoked during the ioctl(...,TCFLSH,..). 
At the time of request we can have full buffers and throttled driver too. 
If we don't unthrottle driver, we can get forever throttled driver, because,
after request, we will have empty buffers and throttled driver and 
there is no place to unthrottle driver.
It simple reproduce with "pty" pair then one side sleep on tty->write_wait,
and other side do ioctl(...,TCFLSH,..). Then there is no place to do writers wake up.

About 'tty: fix "IRQ45: nobody cared"':
  We don't call tty_unthrottle() if release last filp - ('tty->count == 0')
In other case it must be safely. 

Unfortunately, many drivers indirectly invoke tty_unthrottle() before TTY LAYER
decremented (tty->count).
  This Patch help us catch bugs in tty's drivers and invoke tty_unthrottle()
in right moment only.

Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
---

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 26f0d0e..f20b44a 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -173,6 +173,13 @@ static void reset_buffer_flags(struct tty_struct *tty)
 {
 	unsigned long flags;
 
+	WARN_ON(tty->drvbug);
+	/*
+	 * We should not call this method from driver's close function.
+	 * It will be called by TTY layer later.
+	 */
+	if (tty->drvbug)
+		return;
 	spin_lock_irqsave(&tty->read_lock, flags);
 	tty->read_head = tty->read_tail = tty->read_cnt = 0;
 	spin_unlock_irqrestore(&tty->read_lock, flags);
@@ -184,6 +191,7 @@ static void reset_buffer_flags(struct tty_struct *tty)
 	tty->canon_head = tty->canon_data = tty->erasing = 0;
 	memset(&tty->read_flags, 0, sizeof tty->read_flags);
 	n_tty_set_room(tty);
+	check_unthrottle(tty);
 }
 
 /**
@@ -1585,7 +1593,6 @@ static int n_tty_open(struct tty_struct *tty)
 			return -ENOMEM;
 	}
 	reset_buffer_flags(tty);
-	tty_unthrottle(tty);
 	tty->column = 0;
 	n_tty_set_termios(tty, NULL);
 	tty->minimum_to_wake = 1;
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index b425c79..0cd2370 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1649,8 +1649,10 @@ int tty_release(struct inode *inode, struct file *filp)
 			tty_name(tty, buf), tty->count);
 #endif
 
+	tty->drvbug = 1;
 	if (tty->ops->close)
 		tty->ops->close(tty, filp);
+	tty->drvbug = 0;
 
 	tty_unlock();
 	/*
diff --git a/include/linux/tty.h b/include/linux/tty.h
index ed1e82e..01455b6 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -281,7 +281,7 @@ struct tty_struct {
 	int count;
 	struct winsize winsize;		/* termios mutex */
 	unsigned char stopped:1, hw_stopped:1, flow_stopped:1, packet:1;
-	unsigned char low_latency:1, warned:1;
+	unsigned char low_latency:1, warned:1, drvbug:1;
 	unsigned char ctrl_status;	/* ctrl_lock */
 	unsigned int receive_room;	/* Bytes free for queue */



