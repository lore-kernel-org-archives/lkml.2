Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab2DKJP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:15:56 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:46541 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab2DKJPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:15:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 3/3] TTY: con3215, use tty from tty_port
Date: Wed, 11 Apr 2012 11:14:59 +0200
Message-Id: <1334135699-30180-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1334135699-30180-1-git-send-email-jslaby@suse.cz>
References: <1334135699-30180-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obtain tty_struct only once in ISR and pass it down to
raw3215_next_io. Other than that, we just use the tty with raised
reference. And set it properly in open and close.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/char/con3215.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index f7bc23b..e928e04 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -83,7 +83,6 @@ struct raw3215_info {
 	int head;		      /* first free byte in output buffer */
 	int count;		      /* number of bytes in output buffer */
 	int written;		      /* number of bytes in write requests */
-	struct tty_struct *tty;	      /* pointer to tty structure if present */
 	struct raw3215_req *queued_read; /* pointer to queued read requests */
 	struct raw3215_req *queued_write;/* pointer to queued write requests */
 	struct tasklet_struct tlet;   /* tasklet to invoke tty_wakeup */
@@ -343,11 +342,11 @@ static void raw3215_wakeup(unsigned long data)
 /*
  * Try to start the next IO and wake up processes waiting on the tty.
  */
-static void raw3215_next_io(struct raw3215_info *raw)
+static void raw3215_next_io(struct raw3215_info *raw, struct tty_struct *tty)
 {
 	raw3215_mk_write_req(raw);
 	raw3215_try_io(raw);
-	if (raw->tty && RAW3215_BUFFER_SIZE - raw->count >= RAW3215_MIN_SPACE)
+	if (tty && RAW3215_BUFFER_SIZE - raw->count >= RAW3215_MIN_SPACE)
 		tasklet_schedule(&raw->tlet);
 }
 
@@ -365,10 +364,11 @@ static void raw3215_irq(struct ccw_device *cdev, unsigned long intparm,
 
 	raw = dev_get_drvdata(&cdev->dev);
 	req = (struct raw3215_req *) intparm;
+	tty = tty_port_tty_get(&raw->port);
 	cstat = irb->scsw.cmd.cstat;
 	dstat = irb->scsw.cmd.dstat;
 	if (cstat != 0)
-		raw3215_next_io(raw);
+		raw3215_next_io(raw, tty);
 	if (dstat & 0x01) { /* we got a unit exception */
 		dstat &= ~0x01;	 /* we can ignore it */
 	}
@@ -378,13 +378,13 @@ static void raw3215_irq(struct ccw_device *cdev, unsigned long intparm,
 			break;
 		/* Attention interrupt, someone hit the enter key */
 		raw3215_mk_read_req(raw);
-		raw3215_next_io(raw);
+		raw3215_next_io(raw, tty);
 		break;
 	case 0x08:
 	case 0x0C:
 		/* Channel end interrupt. */
 		if ((raw = req->info) == NULL)
-			return;		     /* That shouldn't happen ... */
+			goto put_tty;	     /* That shouldn't happen ... */
 		if (req->type == RAW3215_READ) {
 			/* store residual count, then wait for device end */
 			req->residual = irb->scsw.cmd.count;
@@ -394,11 +394,10 @@ static void raw3215_irq(struct ccw_device *cdev, unsigned long intparm,
 	case 0x04:
 		/* Device end interrupt. */
 		if ((raw = req->info) == NULL)
-			return;		     /* That shouldn't happen ... */
-		if (req->type == RAW3215_READ && raw->tty != NULL) {
+			goto put_tty;	     /* That shouldn't happen ... */
+		if (req->type == RAW3215_READ && tty != NULL) {
 			unsigned int cchar;
 
-			tty = raw->tty;
 			count = 160 - req->residual;
 			EBCASC(raw->inbuf, count);
 			cchar = ctrlchar_handle(raw->inbuf, count, tty);
@@ -408,7 +407,7 @@ static void raw3215_irq(struct ccw_device *cdev, unsigned long intparm,
 
 			case CTRLCHAR_CTRL:
 				tty_insert_flip_char(tty, cchar, TTY_NORMAL);
-				tty_flip_buffer_push(raw->tty);
+				tty_flip_buffer_push(tty);
 				break;
 
 			case CTRLCHAR_NONE:
@@ -421,7 +420,7 @@ static void raw3215_irq(struct ccw_device *cdev, unsigned long intparm,
 				} else
 					count -= 2;
 				tty_insert_flip_string(tty, raw->inbuf, count);
-				tty_flip_buffer_push(raw->tty);
+				tty_flip_buffer_push(tty);
 				break;
 			}
 		} else if (req->type == RAW3215_WRITE) {
@@ -436,7 +435,7 @@ static void raw3215_irq(struct ccw_device *cdev, unsigned long intparm,
 		    raw->queued_read == NULL) {
 			wake_up_interruptible(&raw->empty_wait);
 		}
-		raw3215_next_io(raw);
+		raw3215_next_io(raw, tty);
 		break;
 	default:
 		/* Strange interrupt, I'll do my best to clean up */
@@ -448,9 +447,10 @@ static void raw3215_irq(struct ccw_device *cdev, unsigned long intparm,
 			raw->flags &= ~RAW3215_WORKING;
 			raw3215_free_req(req);
 		}
-		raw3215_next_io(raw);
+		raw3215_next_io(raw, tty);
 	}
-	return;
+put_tty:
+	tty_kref_put(tty);
 }
 
 /*
@@ -946,7 +946,7 @@ static int tty3215_open(struct tty_struct *tty, struct file * filp)
 		return -ENODEV;
 
 	tty->driver_data = raw;
-	raw->tty = tty;
+	tty_port_tty_set(&raw->port, tty);
 
 	tty->low_latency = 0;  /* don't use bottom half for pushing chars */
 	/*
@@ -977,7 +977,7 @@ static void tty3215_close(struct tty_struct *tty, struct file * filp)
 	raw3215_shutdown(raw);
 	tasklet_kill(&raw->tlet);
 	tty->closing = 0;
-	raw->tty = NULL;
+	tty_port_tty_set(&raw->port, NULL);
 }
 
 /*
-- 
1.7.9.2


