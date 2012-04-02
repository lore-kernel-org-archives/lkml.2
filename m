Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab2DBL4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:53 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48226 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab2DBLzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:20 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 45/69] TTY: hvsi, sanitize uses of tty
Date: Mon,  2 Apr 2012 13:54:29 +0200
Message-Id: <1333367693-3244-46-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- use tty, not hp->tty wherever possible
- pass tty down to some functions and go to step one
- do not defer tty_hangup calls -- it is as simple as schedule_work,
  so might be called with hp->lock held
- do not defer tty buffer flips -- since the driver does not use
  low_latency (it cannot actually), the flip is a simple tail move
  plus schedule_work. It will make our life easier in the next patch.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: linuxppc-dev@lists.ozlabs.org
---
 drivers/tty/hvc/hvsi.c |   88 +++++++++++++++++-------------------------------
 1 file changed, 30 insertions(+), 58 deletions(-)

diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
index 113a09a..68b729b 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -237,7 +237,7 @@ static int hvsi_read(struct hvsi_struct *hp, char *buf, int count)
 }
 
 static void hvsi_recv_control(struct hvsi_struct *hp, uint8_t *packet,
-	struct tty_struct **to_hangup, struct hvsi_struct **to_handshake)
+	struct tty_struct *tty, struct hvsi_struct **to_handshake)
 {
 	struct hvsi_control *header = (struct hvsi_control *)packet;
 
@@ -247,9 +247,8 @@ static void hvsi_recv_control(struct hvsi_struct *hp, uint8_t *packet,
 				/* CD went away; no more connection */
 				pr_debug("hvsi%i: CD dropped\n", hp->index);
 				hp->mctrl &= TIOCM_CD;
-				/* If userland hasn't done an open(2) yet, hp->tty is NULL. */
-				if (hp->tty && !C_CLOCAL(hp->tty))
-					*to_hangup = hp->tty;
+				if (tty && !C_CLOCAL(tty))
+					tty_hangup(tty);
 			}
 			break;
 		case VSV_CLOSE_PROTOCOL:
@@ -331,7 +330,8 @@ static void hvsi_recv_query(struct hvsi_struct *hp, uint8_t *packet)
 	}
 }
 
-static void hvsi_insert_chars(struct hvsi_struct *hp, const char *buf, int len)
+static void hvsi_insert_chars(struct hvsi_struct *hp, struct tty_struct *tty,
+		const char *buf, int len)
 {
 	int i;
 
@@ -347,7 +347,7 @@ static void hvsi_insert_chars(struct hvsi_struct *hp, const char *buf, int len)
 			continue;
 		}
 #endif /* CONFIG_MAGIC_SYSRQ */
-		tty_insert_flip_char(hp->tty, c, 0);
+		tty_insert_flip_char(tty, c, 0);
 	}
 }
 
@@ -360,7 +360,7 @@ static void hvsi_insert_chars(struct hvsi_struct *hp, const char *buf, int len)
  * revisited.
  */
 #define TTY_THRESHOLD_THROTTLE 128
-static struct tty_struct *hvsi_recv_data(struct hvsi_struct *hp,
+static bool hvsi_recv_data(struct hvsi_struct *hp, struct tty_struct *tty,
 		const uint8_t *packet)
 {
 	const struct hvsi_header *header = (const struct hvsi_header *)packet;
@@ -371,14 +371,14 @@ static struct tty_struct *hvsi_recv_data(struct hvsi_struct *hp,
 	pr_debug("queueing %i chars '%.*s'\n", datalen, datalen, data);
 
 	if (datalen == 0)
-		return NULL;
+		return false;
 
 	if (overflow > 0) {
 		pr_debug("%s: got >TTY_THRESHOLD_THROTTLE bytes\n", __func__);
 		datalen = TTY_THRESHOLD_THROTTLE;
 	}
 
-	hvsi_insert_chars(hp, data, datalen);
+	hvsi_insert_chars(hp, tty, data, datalen);
 
 	if (overflow > 0) {
 		/*
@@ -390,7 +390,7 @@ static struct tty_struct *hvsi_recv_data(struct hvsi_struct *hp,
 		hp->n_throttle = overflow;
 	}
 
-	return hp->tty;
+	return true;
 }
 
 /*
@@ -399,14 +399,13 @@ static struct tty_struct *hvsi_recv_data(struct hvsi_struct *hp,
  * machine during console handshaking (in which case tty = NULL and we ignore
  * incoming data).
  */
-static int hvsi_load_chunk(struct hvsi_struct *hp, struct tty_struct **flip,
-		struct tty_struct **hangup, struct hvsi_struct **handshake)
+static int hvsi_load_chunk(struct hvsi_struct *hp, struct tty_struct *tty,
+		struct hvsi_struct **handshake)
 {
 	uint8_t *packet = hp->inbuf;
 	int chunklen;
+	bool flip = false;
 
-	*flip = NULL;
-	*hangup = NULL;
 	*handshake = NULL;
 
 	chunklen = hvsi_read(hp, hp->inbuf_end, HVSI_MAX_READ);
@@ -440,12 +439,12 @@ static int hvsi_load_chunk(struct hvsi_struct *hp, struct tty_struct **flip,
 			case VS_DATA_PACKET_HEADER:
 				if (!is_open(hp))
 					break;
-				if (hp->tty == NULL)
+				if (tty == NULL)
 					break; /* no tty buffer to put data in */
-				*flip = hvsi_recv_data(hp, packet);
+				flip = hvsi_recv_data(hp, tty, packet);
 				break;
 			case VS_CONTROL_PACKET_HEADER:
-				hvsi_recv_control(hp, packet, hangup, handshake);
+				hvsi_recv_control(hp, packet, tty, handshake);
 				break;
 			case VS_QUERY_RESPONSE_PACKET_HEADER:
 				hvsi_recv_response(hp, packet);
@@ -462,28 +461,26 @@ static int hvsi_load_chunk(struct hvsi_struct *hp, struct tty_struct **flip,
 
 		packet += len_packet(packet);
 
-		if (*hangup || *handshake) {
-			pr_debug("%s: hangup or handshake\n", __func__);
-			/*
-			 * we need to send the hangup now before receiving any more data.
-			 * If we get "data, hangup, data", we can't deliver the second
-			 * data before the hangup.
-			 */
+		if (*handshake) {
+			pr_debug("%s: handshake\n", __func__);
 			break;
 		}
 	}
 
 	compact_inbuf(hp, packet);
 
+	if (flip)
+		tty_flip_buffer_push(tty);
+
 	return 1;
 }
 
-static void hvsi_send_overflow(struct hvsi_struct *hp)
+static void hvsi_send_overflow(struct hvsi_struct *hp, struct tty_struct *tty)
 {
 	pr_debug("%s: delivering %i bytes overflow\n", __func__,
 			hp->n_throttle);
 
-	hvsi_insert_chars(hp, hp->throttle_buf, hp->n_throttle);
+	hvsi_insert_chars(hp, tty, hp->throttle_buf, hp->n_throttle);
 	hp->n_throttle = 0;
 }
 
@@ -494,8 +491,6 @@ static void hvsi_send_overflow(struct hvsi_struct *hp)
 static irqreturn_t hvsi_interrupt(int irq, void *arg)
 {
 	struct hvsi_struct *hp = (struct hvsi_struct *)arg;
-	struct tty_struct *flip;
-	struct tty_struct *hangup;
 	struct hvsi_struct *handshake;
 	unsigned long flags;
 	int again = 1;
@@ -504,25 +499,9 @@ static irqreturn_t hvsi_interrupt(int irq, void *arg)
 
 	while (again) {
 		spin_lock_irqsave(&hp->lock, flags);
-		again = hvsi_load_chunk(hp, &flip, &hangup, &handshake);
+		again = hvsi_load_chunk(hp, hp->tty, &handshake);
 		spin_unlock_irqrestore(&hp->lock, flags);
 
-		/*
-		 * we have to call tty_flip_buffer_push() and tty_hangup() outside our
-		 * spinlock. But we also have to keep going until we've read all the
-		 * available data.
-		 */
-
-		if (flip) {
-			/* there was data put in the tty flip buffer */
-			tty_flip_buffer_push(flip);
-			flip = NULL;
-		}
-
-		if (hangup) {
-			tty_hangup(hangup);
-		}
-
 		if (handshake) {
 			pr_debug("hvsi%i: attempting re-handshake\n", handshake->index);
 			schedule_work(&handshake->handshaker);
@@ -534,15 +513,11 @@ static irqreturn_t hvsi_interrupt(int irq, void *arg)
 			&& (!test_bit(TTY_THROTTLED, &hp->tty->flags))) {
 		/* we weren't hung up and we weren't throttled, so we can deliver the
 		 * rest now */
-		flip = hp->tty;
-		hvsi_send_overflow(hp);
+		hvsi_send_overflow(hp, hp->tty);
+		tty_flip_buffer_push(hp->tty);
 	}
 	spin_unlock_irqrestore(&hp->lock, flags);
 
-	if (flip) {
-		tty_flip_buffer_push(flip);
-	}
-
 	return IRQ_HANDLED;
 }
 
@@ -966,8 +941,8 @@ static int hvsi_write(struct tty_struct *tty,
 	 * and hvsi_write_worker will be scheduled. subsequent hvsi_write() calls
 	 * will see there is no room in outbuf and return.
 	 */
-	while ((count > 0) && (hvsi_write_room(hp->tty) > 0)) {
-		int chunksize = min(count, hvsi_write_room(hp->tty));
+	while ((count > 0) && (hvsi_write_room(tty) > 0)) {
+		int chunksize = min(count, hvsi_write_room(tty));
 
 		BUG_ON(hp->n_outbuf < 0);
 		memcpy(hp->outbuf + hp->n_outbuf, source, chunksize);
@@ -1014,19 +989,16 @@ static void hvsi_unthrottle(struct tty_struct *tty)
 {
 	struct hvsi_struct *hp = tty->driver_data;
 	unsigned long flags;
-	int shouldflip = 0;
 
 	pr_debug("%s\n", __func__);
 
 	spin_lock_irqsave(&hp->lock, flags);
 	if (hp->n_throttle) {
-		hvsi_send_overflow(hp);
-		shouldflip = 1;
+		hvsi_send_overflow(hp, tty);
+		tty_flip_buffer_push(tty);
 	}
 	spin_unlock_irqrestore(&hp->lock, flags);
 
-	if (shouldflip)
-		tty_flip_buffer_push(hp->tty);
 
 	h_vio_signal(hp->vtermno, VIO_IRQ_ENABLE);
 }
-- 
1.7.9.2


