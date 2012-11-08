Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab2KHQtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 11:49:04 -0500
Received: from dupo.coraid.com ([208.71.232.133]:50574 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751323Ab2KHQtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 11:49:03 -0500
Message-Id: <344deb52dcb4623748fa480a62b8a31d6d991bec.1352316179.git.ecashin@coraid.com>
In-Reply-To: <d63a612e77d92e4f7c13fc2bb545a762a664522d.1352316179.git.ecashin@coraid.com>
References: <d63a612e77d92e4f7c13fc2bb545a762a664522d.1352316179.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 7/8] aoe: commands in retransmit queue use new destination on failure
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Thu, 8 Nov 2012 11:48:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When one remote MAC address isn't working as a destination for
AoE commands, the frames used to track information associated
with the AoE commands are moved to a new aoetgt (defined by the
tuple of {AoE major, AoE minor, target MAC address}).

This patch makes sure that the frames on the queue for
retransmits that need to be done are updated to use the new
destination, so that retransmits will be sent through a working
network path.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h    |    1 +
 drivers/block/aoe/aoecmd.c |   75 +++++++++++++++++++++++++++++++-------------
 drivers/block/aoe/aoedev.c |   32 ++++++++++++------
 3 files changed, 75 insertions(+), 33 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 9fb68fc..c253cca 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -108,6 +108,7 @@ struct frame {
 	struct timeval sent;	/* high-res time packet was sent */
 	u32 sent_jiffs;		/* low-res jiffies-based sent time */
 	ulong waited;
+	ulong waited_total;
 	struct aoetgt *t;		/* parent target I belong to */
 	sector_t lba;
 	struct sk_buff *skb;		/* command skb freed on module exit */
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index a99220a..d9bc6ff 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -352,6 +352,7 @@ aoecmd_ata_rw(struct aoedev *d)
 	fhash(f);
 	t->nout++;
 	f->waited = 0;
+	f->waited_total = 0;
 	f->buf = buf;
 	f->bcnt = bcnt;
 	f->lba = buf->sector;
@@ -556,46 +557,69 @@ ejectif(struct aoetgt *t, struct aoeif *ifp)
 	dev_put(nd);
 }
 
+static struct frame *
+reassign_frame(struct list_head *pos)
+{
+	struct frame *f;
+	struct frame *nf;
+	struct sk_buff *skb;
+
+	f = list_entry(pos, struct frame, head);
+	nf = newframe(f->t->d);
+	if (!nf)
+		return NULL;
+
+	list_del(pos);
+
+	skb = nf->skb;
+	nf->skb = f->skb;
+	nf->buf = f->buf;
+	nf->bcnt = f->bcnt;
+	nf->lba = f->lba;
+	nf->bv = f->bv;
+	nf->bv_off = f->bv_off;
+	nf->waited = 0;
+	nf->waited_total = f->waited_total;
+	nf->sent = f->sent;
+	f->skb = skb;
+	aoe_freetframe(f);
+	f->t->nout--;
+	nf->t->nout++;
+
+	return nf;
+}
+
 static int
 sthtith(struct aoedev *d)
 {
 	struct frame *f, *nf;
 	struct list_head *nx, *pos, *head;
-	struct sk_buff *skb;
 	struct aoetgt *ht = d->htgt;
 	int i;
 
+	/* look through the active and pending retransmit frames */
 	for (i = 0; i < NFACTIVE; i++) {
 		head = &d->factive[i];
 		list_for_each_safe(pos, nx, head) {
 			f = list_entry(pos, struct frame, head);
 			if (f->t != ht)
 				continue;
-
-			nf = newframe(d);
+			nf = reassign_frame(pos);
 			if (!nf)
 				return 0;
-
-			/* remove frame from active list */
-			list_del(pos);
-
-			/* reassign all pertinent bits to new outbound frame */
-			skb = nf->skb;
-			nf->skb = f->skb;
-			nf->buf = f->buf;
-			nf->bcnt = f->bcnt;
-			nf->lba = f->lba;
-			nf->bv = f->bv;
-			nf->bv_off = f->bv_off;
-			nf->waited = 0;
-			nf->sent_jiffs = f->sent_jiffs;
-			f->skb = skb;
-			aoe_freetframe(f);
-			ht->nout--;
-			nf->t->nout++;
 			resend(d, nf);
 		}
 	}
+	head = &d->rexmitq;
+	list_for_each_safe(pos, nx, head) {
+		f = list_entry(pos, struct frame, head);
+		if (f->t != ht)
+			continue;
+		nf = reassign_frame(pos);
+		if (!nf)
+			return 0;
+		resend(d, nf);
+	}
 	/* We've cleaned up the outstanding so take away his
 	 * interfaces so he won't be used.  We should remove him from
 	 * the target array here, but cleaning up a target is
@@ -612,6 +636,7 @@ rexmit_deferred(struct aoedev *d)
 	struct aoetgt *t;
 	struct frame *f;
 	struct list_head *pos, *nx, *head;
+	int since;
 
 	head = &d->rexmitq;
 	list_for_each_safe(pos, nx, head) {
@@ -621,6 +646,9 @@ rexmit_deferred(struct aoedev *d)
 			continue;
 		list_del(pos);
 		t->nout++;
+		since = tsince_hr(f);
+		f->waited += since;
+		f->waited_total += since;
 		resend(d, f);
 	}
 }
@@ -637,6 +665,7 @@ rexmit_timer(ulong vp)
 	register long timeout;
 	ulong flags, n;
 	int i;
+	int since;
 
 	d = (struct aoedev *) vp;
 
@@ -669,7 +698,8 @@ rexmit_timer(ulong vp)
 	while (!list_empty(&flist)) {
 		pos = flist.next;
 		f = list_entry(pos, struct frame, head);
-		n = f->waited += tsince_hr(f);
+		since = tsince_hr(f);
+		n = f->waited_total + since;
 		n /= USEC_PER_SEC;
 		if (n > aoe_deadsecs) {
 			/* Waited too long.  Device failure.
@@ -1301,6 +1331,7 @@ aoecmd_ata_id(struct aoedev *d)
 	fhash(f);
 	t->nout++;
 	f->waited = 0;
+	f->waited_total = 0;
 
 	/* set up ata header */
 	ah->scnt = 1;
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 3c3aef2..91f7c99 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -170,30 +170,40 @@ aoe_failip(struct aoedev *d)
 		aoe_end_request(d, rq, 0);
 }
 
+static void
+downdev_frame(struct list_head *pos)
+{
+	struct frame *f;
+
+	f = list_entry(pos, struct frame, head);
+	list_del(pos);
+	if (f->buf) {
+		f->buf->nframesout--;
+		aoe_failbuf(f->t->d, f->buf);
+	}
+	aoe_freetframe(f);
+}
+
 void
 aoedev_downdev(struct aoedev *d)
 {
 	struct aoetgt *t, **tt, **te;
-	struct frame *f;
 	struct list_head *head, *pos, *nx;
 	struct request *rq;
 	int i;
 
 	d->flags &= ~DEVFL_UP;
 
-	/* clean out active buffers */
+	/* clean out active and to-be-retransmitted buffers */
 	for (i = 0; i < NFACTIVE; i++) {
 		head = &d->factive[i];
-		list_for_each_safe(pos, nx, head) {
-			f = list_entry(pos, struct frame, head);
-			list_del(pos);
-			if (f->buf) {
-				f->buf->nframesout--;
-				aoe_failbuf(d, f->buf);
-			}
-			aoe_freetframe(f);
-		}
+		list_for_each_safe(pos, nx, head)
+			downdev_frame(pos);
 	}
+	head = &d->rexmitq;
+	list_for_each_safe(pos, nx, head)
+		downdev_frame(pos);
+
 	/* reset window dressings */
 	tt = d->targets;
 	te = tt + NTARGETS;
-- 
1.7.1

