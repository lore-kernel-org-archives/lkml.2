Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030696Ab2HWSpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:45:51 -0400
Received: from noserose.net ([66.220.18.76]:36282 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030674Ab2HWSp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:45:28 -0400
Message-Id: <37bcaea47c309d20e3663704bc6f86ff2c3e1d5d.1345743802.git.ecashin@coraid.com>
In-Reply-To: <cover.1345743800.git.ecashin@coraid.com>
References: <cover.1345743800.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Date: Tue, 21 Aug 2012 10:58:52 -0400
Subject: [PATCH 09/14] aoe: associate frames with the AoE storage target
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the driver code, "target" and aoetgt refer to a particular remote
interface on the AoE storage target.  The latter is identified by its
AoE major and minor addresses.  Commands that are being sent to an AoE
storage target {major, minor} can be sent or retransmitted to any of
the remote MAC addresses associated with the AoE storage target.

That is, frames are naturally associated with not an aoetgt (AoE
major, AoE minor, remote MAC address) but an aoedev (AoE major, AoE
minor).  Making the code reflect that reality simplifies the driver,
especially when the path to a remote MAC address becomes unusable.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h    |    8 +++---
 drivers/block/aoe/aoecmd.c |   65 +++++++++++++++++++-------------------------
 drivers/block/aoe/aoedev.c |   30 +++++++++++---------
 3 files changed, 49 insertions(+), 54 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index d17b727..dab7258 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -91,7 +91,7 @@ enum {
 	NTARGETS = 8,
 	NAOEIFS = 8,
 	NSKBPOOLMAX = 256,
-	NFACTIVE = 17,
+	NFACTIVE = 61,
 
 	TIMERTICK = HZ / 10,
 	MINTIMER = HZ >> 2,
@@ -132,14 +132,11 @@ struct aoetgt {
 	unsigned char addr[6];
 	ushort nframes;
 	struct aoedev *d;			/* parent device I belong to */
-	struct list_head factive[NFACTIVE];	/* hash of active frames */
 	struct list_head ffree;			/* list of free frames */
 	struct aoeif ifs[NAOEIFS];
 	struct aoeif *ifp;	/* current aoeif in use */
 	ushort nout;
 	ushort maxout;
-	u16 lasttag;		/* last tag sent */
-	u16 useme;
 	ulong falloc;
 	ulong lastwadj;		/* last window adjustment */
 	int minbcnt;
@@ -156,6 +153,8 @@ struct aoedev {
 	u16 rttavg;		/* round trip average of requests/responses */
 	u16 mintimer;
 	u16 fw_ver;		/* version of blade's firmware */
+	u16 lasttag;		/* last tag sent */
+	u16 useme;
 	ulong ref;
 	struct work_struct work;/* disk create work struct */
 	struct gendisk *gd;
@@ -172,6 +171,7 @@ struct aoedev {
 		struct request *rq;
 	} ip;
 	ulong maxbcnt;
+	struct list_head factive[NFACTIVE];	/* hash of active frames */
 	struct aoetgt *targets[NTARGETS];
 	struct aoetgt **tgt;	/* target in use when working */
 	struct aoetgt *htgt;	/* target needing rexmit assistance */
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 3eeef3a..fec28738 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -58,14 +58,14 @@ new_skb(ulong len)
 }
 
 static struct frame *
-getframe(struct aoetgt *t, u32 tag)
+getframe(struct aoedev *d, u32 tag)
 {
 	struct frame *f;
 	struct list_head *head, *pos, *nx;
 	u32 n;
 
 	n = tag % NFACTIVE;
-	head = &t->factive[n];
+	head = &d->factive[n];
 	list_for_each_safe(pos, nx, head) {
 		f = list_entry(pos, struct frame, head);
 		if (f->tag == tag) {
@@ -82,18 +82,18 @@ getframe(struct aoetgt *t, u32 tag)
  * This driver reserves tag -1 to mean "unused frame."
  */
 static int
-newtag(struct aoetgt *t)
+newtag(struct aoedev *d)
 {
 	register ulong n;
 
 	n = jiffies & 0xffff;
-	return n |= (++t->lasttag & 0x7fff) << 16;
+	return n |= (++d->lasttag & 0x7fff) << 16;
 }
 
 static u32
 aoehdr_atainit(struct aoedev *d, struct aoetgt *t, struct aoe_hdr *h)
 {
-	u32 host_tag = newtag(t);
+	u32 host_tag = newtag(d);
 
 	memcpy(h->src, t->ifp->nd->dev_addr, sizeof h->src);
 	memcpy(h->dst, t->addr, sizeof h->dst);
@@ -269,11 +269,11 @@ loop:
 static void
 fhash(struct frame *f)
 {
-	struct aoetgt *t = f->t;
+	struct aoedev *d = f->t->d;
 	u32 n;
 
 	n = f->tag % NFACTIVE;
-	list_add_tail(&f->head, &t->factive[n]);
+	list_add_tail(&f->head, &d->factive[n]);
 }
 
 static int
@@ -432,7 +432,7 @@ resend(struct aoedev *d, struct frame *f)
 	u32 n;
 
 	t = f->t;
-	n = newtag(t);
+	n = newtag(d);
 	skb = f->skb;
 	if (ifrotate(t) == NULL) {
 		/* probably can't happen, but set it up to fail anyway */
@@ -511,9 +511,12 @@ sthtith(struct aoedev *d)
 	int i;
 
 	for (i = 0; i < NFACTIVE; i++) {
-		head = &ht->factive[i];
+		head = &d->factive[i];
 		list_for_each_safe(pos, nx, head) {
 			f = list_entry(pos, struct frame, head);
+			if (f->t != ht)
+				continue;
+
 			nf = newframe(d);
 			if (!nf)
 				return 0;
@@ -584,22 +587,20 @@ rexmit_timer(ulong vp)
 	}
 
 	/* collect all frames to rexmit into flist */
-	tt = d->targets;
-	te = tt + NTARGETS;
-	for (; tt < te && *tt; tt++) {
-		t = *tt;
-		for (i = 0; i < NFACTIVE; i++) {
-			head = &t->factive[i];
-			list_for_each_safe(pos, nx, head) {
-				f = list_entry(pos, struct frame, head);
-				if (tsince(f->tag) < timeout)
-					continue;
-				/* move to flist for later processing */
-				list_move_tail(pos, &flist);
-			}
+	for (i = 0; i < NFACTIVE; i++) {
+		head = &d->factive[i];
+		list_for_each_safe(pos, nx, head) {
+			f = list_entry(pos, struct frame, head);
+			if (tsince(f->tag) < timeout)
+				break;	/* end of expired frames */
+			/* move to flist for later processing */
+			list_move_tail(pos, &flist);
 		}
-
-		/* window check */
+	}
+	/* window check */
+	tt = d->targets;
+	te = tt + d->ntargets;
+	for (; tt < te && (t = *tt); tt++) {
 		if (t->nout == t->maxout
 		&& t->maxout < t->nframes
 		&& (jiffies - t->lastwadj)/HZ > 10) {
@@ -625,7 +626,7 @@ rexmit_timer(ulong vp)
 			 * Hang all frames on first hash bucket for downdev
 			 * to clean up.
 			 */
-			list_splice(&flist, &f->t->factive[0]);
+			list_splice(&flist, &d->factive[0]);
 			aoedev_downdev(d);
 			break;
 		}
@@ -1169,15 +1170,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	spin_lock_irqsave(&d->lock, flags);
 
 	n = be32_to_cpu(get_unaligned(&h->tag));
-	t = gettgt(d, h->src);
-	if (t == NULL) {
-		printk(KERN_INFO "aoe: can't find target e%ld.%d:%pm\n",
-		       d->aoemajor, d->aoeminor, h->src);
-		spin_unlock_irqrestore(&d->lock, flags);
-		aoedev_put(d);
-		return skb;
-	}
-	f = getframe(t, n);
+	f = getframe(d, n);
 	if (f == NULL) {
 		calc_rttavg(d, -tsince(n));
 		spin_unlock_irqrestore(&d->lock, flags);
@@ -1192,6 +1185,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 		aoechr_error(ebuf);
 		return skb;
 	}
+	t = f->t;
 	calc_rttavg(d, tsince(f->tag));
 	t->nout--;
 	aoecmd_work(d);
@@ -1260,7 +1254,6 @@ static struct aoetgt *
 addtgt(struct aoedev *d, char *addr, ulong nframes)
 {
 	struct aoetgt *t, **tt, **te;
-	int i;
 
 	tt = d->targets;
 	te = tt + NTARGETS;
@@ -1286,8 +1279,6 @@ addtgt(struct aoedev *d, char *addr, ulong nframes)
 	t->ifp = t->ifs;
 	t->maxout = t->nframes;
 	INIT_LIST_HEAD(&t->ffree);
-	for (i = 0; i < NFACTIVE; ++i)
-		INIT_LIST_HEAD(&t->factive[i]);
 	return *tt = t;
 }
 
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 635dc98..3968fe6 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -103,22 +103,23 @@ aoedev_downdev(struct aoedev *d)
 
 	d->flags &= ~DEVFL_UP;
 
-	/* clean out active buffers on all targets */
+	/* clean out active buffers */
+	for (i = 0; i < NFACTIVE; i++) {
+		head = &d->factive[i];
+		list_for_each_safe(pos, nx, head) {
+			f = list_entry(pos, struct frame, head);
+			list_del(pos);
+			if (f->buf) {
+				f->buf->nframesout--;
+				aoe_failbuf(d, f->buf);
+			}
+			aoe_freetframe(f);
+		}
+	}
+	/* reset window dressings */
 	tt = d->targets;
 	te = tt + NTARGETS;
 	for (; tt < te && (t = *tt); tt++) {
-		for (i = 0; i < NFACTIVE; i++) {
-			head = &t->factive[i];
-			list_for_each_safe(pos, nx, head) {
-				list_del(pos);
-				f = list_entry(pos, struct frame, head);
-				if (f->buf) {
-					f->buf->nframesout--;
-					aoe_failbuf(d, f->buf);
-				}
-				aoe_freetframe(f);
-			}
-		}
 		t->maxout = t->nframes;
 		t->nout = 0;
 	}
@@ -250,6 +251,7 @@ struct aoedev *
 aoedev_by_sysminor_m(ulong sysminor)
 {
 	struct aoedev *d;
+	int i;
 	ulong flags;
 
 	spin_lock_irqsave(&devlist_lock, flags);
@@ -275,6 +277,8 @@ aoedev_by_sysminor_m(ulong sysminor)
 	d->bufpool = NULL;	/* defer to aoeblk_gdalloc */
 	d->tgt = d->targets;
 	d->ref = 1;
+	for (i = 0; i < NFACTIVE; i++)
+		INIT_LIST_HEAD(&d->factive[i]);
 	d->sysminor = sysminor;
 	d->aoemajor = AOEMAJOR(sysminor);
 	d->aoeminor = AOEMINOR(sysminor);
-- 
1.7.2.5

