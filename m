Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935157Ab1KJDaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:30:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935143Ab1KJDaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:30:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:19 2011
Message-Id: <20111109212718.960968852@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [183/262] can bcm: fix incomplete tx_setup fix
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 12d0d0d3a7349daa95dbfd5d7df8146255bc7c67 upstream.

The commit aabdcb0b553b9c9547b1a506b34d55a764745870 ("can bcm: fix tx_setup
off-by-one errors") fixed only a part of the original problem reported by
Andre Naujoks. It turned out that the original code needed to be re-ordered
to reduce complexity and to finally fix the reported frame counting issues.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/can/bcm.c |   48 +++++++++++++++++++++---------------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -343,6 +343,18 @@ static void bcm_send_to_user(struct bcm_
 	}
 }
 
+static void bcm_tx_start_timer(struct bcm_op *op)
+{
+	if (op->kt_ival1.tv64 && op->count)
+		hrtimer_start(&op->timer,
+			      ktime_add(ktime_get(), op->kt_ival1),
+			      HRTIMER_MODE_ABS);
+	else if (op->kt_ival2.tv64)
+		hrtimer_start(&op->timer,
+			      ktime_add(ktime_get(), op->kt_ival2),
+			      HRTIMER_MODE_ABS);
+}
+
 static void bcm_tx_timeout_tsklet(unsigned long data)
 {
 	struct bcm_op *op = (struct bcm_op *)data;
@@ -364,23 +376,12 @@ static void bcm_tx_timeout_tsklet(unsign
 
 			bcm_send_to_user(op, &msg_head, NULL, 0);
 		}
-
-		/* send (next) frame */
 		bcm_can_tx(op);
-		hrtimer_start(&op->timer,
-			      ktime_add(ktime_get(), op->kt_ival1),
-			      HRTIMER_MODE_ABS);
 
-	} else {
-		if (op->kt_ival2.tv64) {
+	} else if (op->kt_ival2.tv64)
+		bcm_can_tx(op);
 
-			/* send (next) frame */
-			bcm_can_tx(op);
-			hrtimer_start(&op->timer,
-				      ktime_add(ktime_get(), op->kt_ival2),
-				      HRTIMER_MODE_ABS);
-		}
-	}
+	bcm_tx_start_timer(op);
 }
 
 /*
@@ -960,28 +961,21 @@ static int bcm_tx_setup(struct bcm_msg_h
 			hrtimer_cancel(&op->timer);
 	}
 
-	if ((op->flags & STARTTIMER) &&
-	    ((op->kt_ival1.tv64 && op->count) || op->kt_ival2.tv64)) {
-
+	if (op->flags & STARTTIMER) {
+		hrtimer_cancel(&op->timer);
 		/* spec: send can_frame when starting timer */
 		op->flags |= TX_ANNOUNCE;
-
-		/* only start timer when having more frames than sent below */
-		if (op->kt_ival1.tv64 && (op->count > 1)) {
-			/* op->count-- is done in bcm_tx_timeout_tsklet */
-			hrtimer_start(&op->timer, op->kt_ival1,
-				      HRTIMER_MODE_REL);
-		} else
-			hrtimer_start(&op->timer, op->kt_ival2,
-				      HRTIMER_MODE_REL);
 	}
 
 	if (op->flags & TX_ANNOUNCE) {
 		bcm_can_tx(op);
-		if (op->kt_ival1.tv64 && (op->count > 0))
+		if (op->count)
 			op->count--;
 	}
 
+	if (op->flags & STARTTIMER)
+		bcm_tx_start_timer(op);
+
 	return msg_head->nframes * CFSIZ + MHSIZ;
 }
 


