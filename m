Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab2DBL4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:09 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48041 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2DBLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 25/69] TTY: con3215, remove tasklet for tty_wakeup
Date: Mon,  2 Apr 2012 13:54:09 +0200
Message-Id: <1333367693-3244-26-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_wakeup is safe to be called from all contexts. No need to schedule
a tasklet for that. Let us call it directly like in other drivers.

And delete the tasklet completely.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/char/con3215.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 7e30f85..fb195f3 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -87,7 +87,6 @@ struct raw3215_info {
 	struct tty_struct *tty;	      /* pointer to tty structure if present */
 	struct raw3215_req *queued_read; /* pointer to queued read requests */
 	struct raw3215_req *queued_write;/* pointer to queued write requests */
-	struct tasklet_struct tlet;   /* tasklet to invoke tty_wakeup */
 	wait_queue_head_t empty_wait; /* wait queue for flushing */
 	struct timer_list timer;      /* timer for delayed output */
 	int line_pos;		      /* position on the line (for tabs) */
@@ -332,15 +331,6 @@ static inline void raw3215_try_io(struct raw3215_info *raw)
 }
 
 /*
- * Call tty_wakeup from tasklet context
- */
-static void raw3215_wakeup(unsigned long data)
-{
-	struct raw3215_info *raw = (struct raw3215_info *) data;
-	tty_wakeup(raw->tty);
-}
-
-/*
  * Try to start the next IO and wake up processes waiting on the tty.
  */
 static void raw3215_next_io(struct raw3215_info *raw)
@@ -348,7 +338,7 @@ static void raw3215_next_io(struct raw3215_info *raw)
 	raw3215_mk_write_req(raw);
 	raw3215_try_io(raw);
 	if (raw->tty && RAW3215_BUFFER_SIZE - raw->count >= RAW3215_MIN_SPACE)
-		tasklet_schedule(&raw->tlet);
+		tty_wakeup(raw->tty);
 }
 
 /*
@@ -662,7 +652,6 @@ static struct raw3215_info *raw3215_alloc_info(void)
 
 	setup_timer(&info->timer, raw3215_timeout, (unsigned long)info);
 	init_waitqueue_head(&info->empty_wait);
-	tasklet_init(&info->tlet, raw3215_wakeup, (unsigned long)info);
 
 	return info;
 }
@@ -973,7 +962,6 @@ static void tty3215_close(struct tty_struct *tty, struct file * filp)
 	tty->closing = 1;
 	/* Shutdown the terminal */
 	raw3215_shutdown(raw);
-	tasklet_kill(&raw->tlet);
 	tty->closing = 0;
 	raw->tty = NULL;
 }
-- 
1.7.9.2


