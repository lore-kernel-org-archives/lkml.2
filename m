Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab2KIA2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 19:28:04 -0500
Received: from dupo.coraid.com ([208.71.232.133]:40958 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752864Ab2KIA2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 19:28:02 -0500
Message-Id: <846b893d27939c10c4f49a8e4d22f0029bebbd20.1352410985.git.ecashin@coraid.com>
In-Reply-To: <cover.1352410985.git.ecashin@coraid.com>
References: <cover.1352410985.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 6/8] aoe: use high-resolution RTTs with fallback to low-res
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Thu, 8 Nov 2012 19:27:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes improve the accuracy of the decision about whether
it's time to retransmit an AoE command by using the
microsecond-resolution gettimeofday instead of jiffies.

Because the system time can jump suddenly, the decision reverts
to using jiffies if the high-resolution time difference is
relatively large.  Otherwise the AoE targets could be considered
failed inappropriately.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h    |    9 ++++---
 drivers/block/aoe/aoecmd.c |   57 ++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 9e884ac..9fb68fc 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -88,8 +88,7 @@ enum {
 	TIMERTICK = HZ / 10,
 	RTTSCALE = 8,
 	RTTDSCALE = 3,
-	MAXTIMER = HZ << 1,
-	RTTAVG_INIT = HZ / 4 << RTTSCALE,
+	RTTAVG_INIT = USEC_PER_SEC / 4 << RTTSCALE,
 	RTTDEV_INIT = RTTAVG_INIT / 4,
 };
 
@@ -106,6 +105,8 @@ struct buf {
 struct frame {
 	struct list_head head;
 	u32 tag;
+	struct timeval sent;	/* high-res time packet was sent */
+	u32 sent_jiffs;		/* low-res jiffies-based sent time */
 	ulong waited;
 	struct aoetgt *t;		/* parent target I belong to */
 	sector_t lba;
@@ -143,11 +144,11 @@ struct aoedev {
 	struct aoedev *next;
 	ulong sysminor;
 	ulong aoemajor;
+	u32 rttavg;		/* scaled AoE round trip time average */
+	u32 rttdev;		/* scaled round trip time mean deviation */
 	u16 aoeminor;
 	u16 flags;
 	u16 nopen;		/* (bd_openers isn't available without sleeping) */
-	u16 rttavg;		/* scaled AoE round trip time average */
-	u16 rttdev;		/* scaled round trip time mean deviation */
 	u16 fw_ver;		/* version of blade's firmware */
 	u16 lasttag;		/* last tag sent */
 	u16 useme;
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 9aefbe3..a99220a 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -387,6 +387,8 @@ aoecmd_ata_rw(struct aoedev *d)
 	skb->dev = t->ifp->nd;
 	skb = skb_clone(skb, GFP_ATOMIC);
 	if (skb) {
+		do_gettimeofday(&f->sent);
+		f->sent_jiffs = (u32) jiffies;
 		__skb_queue_head_init(&queue);
 		__skb_queue_tail(&queue, skb);
 		aoenet_xmit(&queue);
@@ -475,12 +477,46 @@ resend(struct aoedev *d, struct frame *f)
 	skb = skb_clone(skb, GFP_ATOMIC);
 	if (skb == NULL)
 		return;
+	do_gettimeofday(&f->sent);
+	f->sent_jiffs = (u32) jiffies;
 	__skb_queue_head_init(&queue);
 	__skb_queue_tail(&queue, skb);
 	aoenet_xmit(&queue);
 }
 
 static int
+tsince_hr(struct frame *f)
+{
+	struct timeval now;
+	int n;
+
+	do_gettimeofday(&now);
+	n = now.tv_usec - f->sent.tv_usec;
+	n += (now.tv_sec - f->sent.tv_sec) * USEC_PER_SEC;
+
+	if (n < 0)
+		n = -n;
+
+	/* For relatively long periods, use jiffies to avoid
+	 * discrepancies caused by updates to the system time.
+	 *
+	 * On system with HZ of 1000, 32-bits is over 49 days
+	 * worth of jiffies, or over 71 minutes worth of usecs.
+	 *
+	 * Jiffies overflow is handled by subtraction of unsigned ints:
+	 * (gdb) print (unsigned) 2 - (unsigned) 0xfffffffe
+	 * $3 = 4
+	 * (gdb)
+	 */
+	if (n > USEC_PER_SEC / 4) {
+		n = ((u32) jiffies) - f->sent_jiffs;
+		n *= USEC_PER_SEC / HZ;
+	}
+
+	return n;
+}
+
+static int
 tsince(u32 tag)
 {
 	int n;
@@ -489,7 +525,7 @@ tsince(u32 tag)
 	n -= tag & 0xffff;
 	if (n < 0)
 		n += 1<<16;
-	return n;
+	return jiffies_to_usecs(n + 1);
 }
 
 static struct aoeif *
@@ -552,6 +588,7 @@ sthtith(struct aoedev *d)
 			nf->bv = f->bv;
 			nf->bv_off = f->bv_off;
 			nf->waited = 0;
+			nf->sent_jiffs = f->sent_jiffs;
 			f->skb = skb;
 			aoe_freetframe(f);
 			ht->nout--;
@@ -621,7 +658,7 @@ rexmit_timer(ulong vp)
 		head = &d->factive[i];
 		list_for_each_safe(pos, nx, head) {
 			f = list_entry(pos, struct frame, head);
-			if (tsince(f->tag) < timeout)
+			if (tsince_hr(f) < timeout)
 				break;	/* end of expired frames */
 			/* move to flist for later processing */
 			list_move_tail(pos, &flist);
@@ -632,8 +669,8 @@ rexmit_timer(ulong vp)
 	while (!list_empty(&flist)) {
 		pos = flist.next;
 		f = list_entry(pos, struct frame, head);
-		n = f->waited += tsince(f->tag);
-		n /= HZ;
+		n = f->waited += tsince_hr(f);
+		n /= USEC_PER_SEC;
 		if (n > aoe_deadsecs) {
 			/* Waited too long.  Device failure.
 			 * Hang all frames on first hash bucket for downdev
@@ -1193,12 +1230,12 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	n = be32_to_cpu(get_unaligned(&h->tag));
 	f = getframe(d, n);
 	if (f) {
-		calc_rttavg(d, f->t, tsince(n));
+		calc_rttavg(d, f->t, tsince_hr(f));
 		f->t->nout--;
 	} else {
 		f = getframe_deferred(d, n);
 		if (f) {
-			calc_rttavg(d, NULL, tsince(n));
+			calc_rttavg(d, NULL, tsince_hr(f));
 		} else {
 			calc_rttavg(d, NULL, tsince(n));
 			spin_unlock_irqrestore(&d->lock, flags);
@@ -1276,7 +1313,13 @@ aoecmd_ata_id(struct aoedev *d)
 	d->rttdev = RTTDEV_INIT;
 	d->timer.function = rexmit_timer;
 
-	return skb_clone(skb, GFP_ATOMIC);
+	skb = skb_clone(skb, GFP_ATOMIC);
+	if (skb) {
+		do_gettimeofday(&f->sent);
+		f->sent_jiffs = (u32) jiffies;
+	}
+
+	return skb;
 }
 
 static struct aoetgt *
-- 
1.7.1

