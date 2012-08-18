Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030628Ab2HWSpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:45:21 -0400
Received: from noserose.net ([66.220.18.76]:33178 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934187Ab2HWSoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:44:44 -0400
Message-Id: <752ecb77a67b4ba55e8f3ebddd745491aacc8818.1345743801.git.ecashin@coraid.com>
In-Reply-To: <cover.1345743800.git.ecashin@coraid.com>
References: <cover.1345743800.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Date: Fri, 17 Aug 2012 21:24:08 -0400
Subject: [PATCH 02/14] aoe: kernel thread handles I/O completions for simple locking
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the frames the aoe driver uses to track the
relationship between bios and packets more flexible and detached, so
that they can be passed to an "aoe_ktio" thread for completion of I/O.

The frames are handled much like skbs, with a capped amount of
preallocation so that real-world use cases are likely to run smoothly
and degenerate gracefully even under memory pressure.

Decoupling I/O completion from the receive path and serializing it in
a process makes it easier to think about the correctness of the
locking in the driver, especially in the case of a remote MAC address
becoming unusable.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h     |   33 ++-
 drivers/block/aoe/aoechr.c  |    3 +-
 drivers/block/aoe/aoecmd.c  |  737 ++++++++++++++++++++++++++++---------------
 drivers/block/aoe/aoedev.c  |   84 +++--
 drivers/block/aoe/aoemain.c |    8 +-
 drivers/block/aoe/aoenet.c  |    6 +-
 6 files changed, 567 insertions(+), 304 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 8ca8c8a..0cd6c0f 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -91,6 +91,7 @@ enum {
 	NTARGETS = 8,
 	NAOEIFS = 8,
 	NSKBPOOLMAX = 128,
+	NFACTIVE = 17,
 
 	TIMERTICK = HZ / 10,
 	MINTIMER = HZ >> 2,
@@ -112,13 +113,16 @@ struct buf {
 };
 
 struct frame {
-	int tag;
+	struct list_head head;
+	u32 tag;
 	ulong waited;
 	struct buf *buf;
+	struct aoetgt *t;		/* parent target I belong to */
 	char *bufaddr;
 	ulong bcnt;
 	sector_t lba;
-	struct sk_buff *skb;
+	struct sk_buff *skb;		/* command skb freed on module exit */
+	struct sk_buff *r_skb;		/* response skb for async processing */
 	struct bio_vec *bv;
 	ulong bv_off;
 };
@@ -133,16 +137,18 @@ struct aoeif {
 struct aoetgt {
 	unsigned char addr[6];
 	ushort nframes;
-	struct frame *frames;
+	struct aoedev *d;			/* parent device I belong to */
+	struct list_head factive[NFACTIVE];	/* hash of active frames */
+	struct list_head ffree;			/* list of free frames */
 	struct aoeif ifs[NAOEIFS];
 	struct aoeif *ifp;	/* current aoeif in use */
 	ushort nout;
 	ushort maxout;
 	u16 lasttag;		/* last tag sent */
 	u16 useme;
+	ulong falloc;
 	ulong lastwadj;		/* last window adjustment */
 	int wpkts, rpkts;
-	int dataref;
 };
 
 struct aoedev {
@@ -169,9 +175,20 @@ struct aoedev {
 	struct buf *inprocess;	/* the one we're currently working on */
 	struct aoetgt *targets[NTARGETS];
 	struct aoetgt **tgt;	/* target in use when working */
-	struct aoetgt **htgt;	/* target needing rexmit assistance */
+	struct aoetgt *htgt;	/* target needing rexmit assistance */
+	ulong ntargets;
+	ulong kicked;
 };
 
+/* kthread tracking */
+struct ktstate {
+	struct completion rendez;
+	struct task_struct *task;
+	wait_queue_head_t *waitq;
+	int (*fn) (void);
+	char *name;
+	spinlock_t *lock;
+};
 
 int aoeblk_init(void);
 void aoeblk_exit(void);
@@ -184,11 +201,14 @@ void aoechr_error(char *);
 
 void aoecmd_work(struct aoedev *d);
 void aoecmd_cfg(ushort aoemajor, unsigned char aoeminor);
-void aoecmd_ata_rsp(struct sk_buff *);
+struct sk_buff *aoecmd_ata_rsp(struct sk_buff *);
 void aoecmd_cfg_rsp(struct sk_buff *);
 void aoecmd_sleepwork(struct work_struct *);
 void aoecmd_cleanslate(struct aoedev *);
+void aoecmd_exit(void);
+int aoecmd_init(void);
 struct sk_buff *aoecmd_ata_id(struct aoedev *);
+void aoe_freetframe(struct frame *);
 
 int aoedev_init(void);
 void aoedev_exit(void);
@@ -196,6 +216,7 @@ struct aoedev *aoedev_by_aoeaddr(int maj, int min);
 struct aoedev *aoedev_by_sysminor_m(ulong sysminor);
 void aoedev_downdev(struct aoedev *d);
 int aoedev_flush(const char __user *str, size_t size);
+void aoe_failbuf(struct aoedev *d, struct buf *buf);
 
 int aoenet_init(void);
 void aoenet_exit(void);
diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index e86d206..f145388 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -86,10 +86,9 @@ revalidate(const char __user *str, size_t size)
 	if (copy_from_user(buf, str, size))
 		return -EFAULT;
 
-	/* should be e%d.%d format */
 	n = sscanf(buf, "e%d.%d", &major, &minor);
 	if (n != 2) {
-		printk(KERN_ERR "aoe: invalid device specification\n");
+		pr_err("aoe: invalid device specification %s\n", buf);
 		return -EINVAL;
 	}
 	d = aoedev_by_aoeaddr(major, minor);
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index f10ab49..d0fc53f 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -12,10 +12,17 @@
 #include <linux/netdevice.h>
 #include <linux/genhd.h>
 #include <linux/moduleparam.h>
+#include <linux/workqueue.h>
+#include <linux/kthread.h>
 #include <net/net_namespace.h>
 #include <asm/unaligned.h>
+#include <linux/uio.h>
 #include "aoe.h"
 
+#define MAXIOC (8192)	/* default meant to avoid most soft lockups */
+
+static void ktcomplete(struct frame *, struct sk_buff *);
+
 static int aoe_deadsecs = 60 * 3;
 module_param(aoe_deadsecs, int, 0644);
 MODULE_PARM_DESC(aoe_deadsecs, "After aoe_deadsecs seconds, give up and fail dev.");
@@ -25,6 +32,15 @@ module_param(aoe_maxout, int, 0644);
 MODULE_PARM_DESC(aoe_maxout,
 	"Only aoe_maxout outstanding packets for every MAC on eX.Y.");
 
+static wait_queue_head_t ktiowq;
+static struct ktstate kts;
+
+/* io completion queue */
+static struct {
+	struct list_head head;
+	spinlock_t lock;
+} iocq;
+
 static struct sk_buff *
 new_skb(ulong len)
 {
@@ -40,15 +56,21 @@ new_skb(ulong len)
 }
 
 static struct frame *
-getframe(struct aoetgt *t, int tag)
+getframe(struct aoetgt *t, u32 tag)
 {
-	struct frame *f, *e;
+	struct frame *f;
+	struct list_head *head, *pos, *nx;
+	u32 n;
 
-	f = t->frames;
-	e = f + t->nframes;
-	for (; f<e; f++)
-		if (f->tag == tag)
+	n = tag % NFACTIVE;
+	head = &t->factive[n];
+	list_for_each_safe(pos, nx, head) {
+		f = list_entry(pos, struct frame, head);
+		if (f->tag == tag) {
+			list_del(pos);
 			return f;
+		}
+	}
 	return NULL;
 }
 
@@ -66,7 +88,7 @@ newtag(struct aoetgt *t)
 	return n |= (++t->lasttag & 0x7fff) << 16;
 }
 
-static int
+static u32
 aoehdr_atainit(struct aoedev *d, struct aoetgt *t, struct aoe_hdr *h)
 {
 	u32 host_tag = newtag(t);
@@ -128,75 +150,96 @@ skb_pool_get(struct aoedev *d)
 	return NULL;
 }
 
-/* freeframe is where we do our load balancing so it's a little hairy. */
+void
+aoe_freetframe(struct frame *f)
+{
+	struct aoetgt *t;
+
+	t = f->t;
+	f->buf = NULL;
+	f->bv = NULL;
+	f->r_skb = NULL;
+	list_add(&f->head, &t->ffree);
+}
+
 static struct frame *
-freeframe(struct aoedev *d)
+newtframe(struct aoedev *d, struct aoetgt *t)
 {
-	struct frame *f, *e, *rf;
-	struct aoetgt **t;
+	struct frame *f;
 	struct sk_buff *skb;
+	struct list_head *pos;
+
+	if (list_empty(&t->ffree)) {
+		if (t->falloc >= NSKBPOOLMAX*2)
+			return NULL;
+		f = kcalloc(1, sizeof(*f), GFP_ATOMIC);
+		if (f == NULL)
+			return NULL;
+		t->falloc++;
+		f->t = t;
+	} else {
+		pos = t->ffree.next;
+		list_del(pos);
+		f = list_entry(pos, struct frame, head);
+	}
+
+	skb = f->skb;
+	if (skb == NULL) {
+		f->skb = skb = new_skb(ETH_ZLEN);
+		if (!skb) {
+bail:			aoe_freetframe(f);
+			return NULL;
+		}
+	}
+
+	if (atomic_read(&skb_shinfo(skb)->dataref) != 1) {
+		skb = skb_pool_get(d);
+		if (skb == NULL)
+			goto bail;
+		skb_pool_put(d, f->skb);
+		f->skb = skb;
+	}
+
+	skb->truesize -= skb->data_len;
+	skb_shinfo(skb)->nr_frags = skb->data_len = 0;
+	skb_trim(skb, 0);
+	return f;
+}
+
+static struct frame *
+newframe(struct aoedev *d)
+{
+	struct frame *f;
+	struct aoetgt *t, **tt;
+	int totout = 0;
 
 	if (d->targets[0] == NULL) {	/* shouldn't happen, but I'm paranoid */
 		printk(KERN_ERR "aoe: NULL TARGETS!\n");
 		return NULL;
 	}
-	t = d->tgt;
-	t++;
-	if (t >= &d->targets[NTARGETS] || !*t)
-		t = d->targets;
+	tt = d->tgt;	/* last used target */
 	for (;;) {
-		if ((*t)->nout < (*t)->maxout
+		tt++;
+		if (tt >= &d->targets[NTARGETS] || !*tt)
+			tt = d->targets;
+		t = *tt;
+		totout += t->nout;
+		if (t->nout < t->maxout
 		&& t != d->htgt
-		&& (*t)->ifp->nd) {
-			rf = NULL;
-			f = (*t)->frames;
-			e = f + (*t)->nframes;
-			for (; f < e; f++) {
-				if (f->tag != FREETAG)
-					continue;
-				skb = f->skb;
-				if (!skb
-				&& !(f->skb = skb = new_skb(ETH_ZLEN)))
-					continue;
-				if (atomic_read(&skb_shinfo(skb)->dataref)
-					!= 1) {
-					if (!rf)
-						rf = f;
-					continue;
-				}
-gotone:				skb->truesize -= skb->data_len;
-				skb_shinfo(skb)->nr_frags = skb->data_len = 0;
-				skb_trim(skb, 0);
-				d->tgt = t;
-				ifrotate(*t);
+		&& t->ifp->nd) {
+			f = newtframe(d, t);
+			if (f) {
+				d->tgt = tt;
+				ifrotate(t);
 				return f;
 			}
-			/* Work can be done, but the network layer is
-			   holding our precious packets.  Try to grab
-			   one from the pool. */
-			f = rf;
-			if (f == NULL) {	/* more paranoia */
-				printk(KERN_ERR
-					"aoe: freeframe: %s.\n",
-					"unexpected null rf");
-				d->flags |= DEVFL_KICKME;
-				return NULL;
-			}
-			skb = skb_pool_get(d);
-			if (skb) {
-				skb_pool_put(d, f->skb);
-				f->skb = skb;
-				goto gotone;
-			}
-			(*t)->dataref++;
-			if ((*t)->nout == 0)
-				d->flags |= DEVFL_KICKME;
 		}
-		if (t == d->tgt)	/* we've looped and found nada */
+		if (tt == d->tgt)	/* we've looped and found nada */
 			break;
-		t++;
-		if (t >= &d->targets[NTARGETS] || !*t)
-			t = d->targets;
+	}
+	if (totout == 0) {
+		d->kicked++;
+		d->flags |= DEVFL_KICKME;
 	}
 	return NULL;
 }
@@ -219,6 +262,16 @@ loop:
 	goto loop;
 }
 
+static void
+fhash(struct frame *f)
+{
+	struct aoetgt *t = f->t;
+	u32 n;
+
+	n = f->tag % NFACTIVE;
+	list_add_tail(&f->head, &t->factive[n]);
+}
+
 static int
 aoecmd_ata_rw(struct aoedev *d)
 {
@@ -235,7 +288,7 @@ aoecmd_ata_rw(struct aoedev *d)
 	writebit = 0x10;
 	extbit = 0x4;
 
-	f = freeframe(d);
+	f = newframe(d);
 	if (f == NULL)
 		return 0;
 	t = *d->tgt;
@@ -273,6 +326,7 @@ aoecmd_ata_rw(struct aoedev *d)
 	skb_put(skb, sizeof *h + sizeof *ah);
 	memset(h, 0, skb->len);
 	f->tag = aoehdr_atainit(d, t, h);
+	fhash(f);
 	t->nout++;
 	f->waited = 0;
 	f->buf = buf;
@@ -357,14 +411,16 @@ cont:
 }
 
 static void
-resend(struct aoedev *d, struct aoetgt *t, struct frame *f)
+resend(struct aoedev *d, struct frame *f)
 {
 	struct sk_buff *skb;
 	struct aoe_hdr *h;
 	struct aoe_atahdr *ah;
+	struct aoetgt *t;
 	char buf[128];
 	u32 n;
 
+	t = f->t;
 	ifrotate(t);
 	n = newtag(t);
 	skb = f->skb;
@@ -378,28 +434,11 @@ resend(struct aoedev *d, struct aoetgt *t, struct frame *f)
 	aoechr_error(buf);
 
 	f->tag = n;
+	fhash(f);
 	h->tag = cpu_to_be32(n);
 	memcpy(h->dst, t->addr, sizeof h->dst);
 	memcpy(h->src, t->ifp->nd->dev_addr, sizeof h->src);
 
-	switch (ah->cmdstat) {
-	default:
-		break;
-	case ATA_CMD_PIO_READ:
-	case ATA_CMD_PIO_READ_EXT:
-	case ATA_CMD_PIO_WRITE:
-	case ATA_CMD_PIO_WRITE_EXT:
-		put_lba(ah, f->lba);
-
-		n = f->bcnt;
-		ah->scnt = n >> 9;
-		if (ah->aflags & AOEAFL_WRITE) {
-			skb_fillup(skb, f->bv, f->bv_off, n);
-			skb->len = sizeof *h + sizeof *ah + n;
-			skb->data_len = n;
-			skb->truesize += n;
-		}
-	}
 	skb->dev = t->ifp->nd;
 	skb = skb_clone(skb, GFP_ATOMIC);
 	if (skb == NULL)
@@ -408,7 +447,7 @@ resend(struct aoedev *d, struct aoetgt *t, struct frame *f)
 }
 
 static int
-tsince(int tag)
+tsince(u32 tag)
 {
 	int n;
 
@@ -462,26 +501,38 @@ ejectif(struct aoetgt *t, struct aoeif *ifp)
 static int
 sthtith(struct aoedev *d)
 {
-	struct frame *f, *e, *nf;
+	struct frame *f, *nf;
+	struct list_head *nx, *pos, *head;
 	struct sk_buff *skb;
-	struct aoetgt *ht = *d->htgt;
-
-	f = ht->frames;
-	e = f + ht->nframes;
-	for (; f < e; f++) {
-		if (f->tag == FREETAG)
-			continue;
-		nf = freeframe(d);
-		if (!nf)
-			return 0;
-		skb = nf->skb;
-		*nf = *f;
-		f->skb = skb;
-		f->tag = FREETAG;
-		nf->waited = 0;
-		ht->nout--;
-		(*d->tgt)->nout++;
-		resend(d, *d->tgt, nf);
+	struct aoetgt *ht = d->htgt;
+	int i;
+
+	for (i = 0; i < NFACTIVE; i++) {
+		head = &ht->factive[i];
+		list_for_each_safe(pos, nx, head) {
+			f = list_entry(pos, struct frame, head);
+			nf = newframe(d);
+			if (!nf)
+				return 0;
+
+			/* remove frame from active list */
+			list_del(pos);
+
+			/* reassign all pertinent bits to new outbound frame */
+			skb = nf->skb;
+			nf->skb = f->skb;
+			nf->buf = f->buf;
+			nf->bcnt = f->bcnt;
+			nf->lba = f->lba;
+			nf->bv = f->bv;
+			nf->bv_off = f->bv_off;
+			nf->waited = 0;
+			f->skb = skb;
+			aoe_freetframe(f);
+			ht->nout--;
+			nf->t->nout++;
+			resend(d, nf);
+		}
 	}
 	/* he's clean, he's useless.  take away his interfaces */
 	memset(ht->ifs, 0, sizeof ht->ifs);
@@ -506,9 +557,12 @@ rexmit_timer(ulong vp)
 	struct aoedev *d;
 	struct aoetgt *t, **tt, **te;
 	struct aoeif *ifp;
-	struct frame *f, *e;
+	struct frame *f;
+	struct list_head *head, *pos, *nx;
+	LIST_HEAD(flist);
 	register long timeout;
 	ulong flags, n;
+	int i;
 
 	d = (struct aoedev *) vp;
 
@@ -522,41 +576,21 @@ rexmit_timer(ulong vp)
 		spin_unlock_irqrestore(&d->lock, flags);
 		return;
 	}
+
+	/* collect all frames to rexmit into flist */
 	tt = d->targets;
 	te = tt + NTARGETS;
 	for (; tt < te && *tt; tt++) {
 		t = *tt;
-		f = t->frames;
-		e = f + t->nframes;
-		for (; f < e; f++) {
-			if (f->tag == FREETAG
-			|| tsince(f->tag) < timeout)
-				continue;
-			n = f->waited += timeout;
-			n /= HZ;
-			if (n > aoe_deadsecs) {
-				/* waited too long.  device failure. */
-				aoedev_downdev(d);
-				break;
-			}
-
-			if (n > HELPWAIT /* see if another target can help */
-			&& (tt != d->targets || d->targets[1]))
-				d->htgt = tt;
-
-			if (t->nout == t->maxout) {
-				if (t->maxout > 1)
-					t->maxout--;
-				t->lastwadj = jiffies;
-			}
-
-			ifp = getif(t, f->skb->dev);
-			if (ifp && ++ifp->lost > (t->nframes << 1)
-			&& (ifp != t->ifs || t->ifs[1].nd)) {
-				ejectif(t, ifp);
-				ifp = NULL;
+		for (i = 0; i < NFACTIVE; i++) {
+			head = &t->factive[i];
+			list_for_each_safe(pos, nx, head) {
+				f = list_entry(pos, struct frame, head);
+				if (tsince(f->tag) < timeout)
+					continue;
+				/* move to flist for later processing */
+				list_move_tail(pos, &flist);
 			}
-			resend(d, t, f);
 		}
 
 		/* window check */
@@ -568,6 +602,44 @@ rexmit_timer(ulong vp)
 		}
 	}
 
+	/* process expired frames */
+	while (!list_empty(&flist)) {
+		pos = flist.next;
+		f = list_entry(pos, struct frame, head);
+		n = f->waited += timeout;
+		n /= HZ;
+		if (n > aoe_deadsecs) {
+			/* Waited too long.  Device failure.
+			 * Hang all frames on first hash bucket for downdev
+			 * to clean up.
+			 */
+			list_splice(&flist, &f->t->factive[0]);
+			aoedev_downdev(d);
+			break;
+		}
+		list_del(pos);
+
+		t = f->t;
+		if (n > HELPWAIT) {
+			/* see if another target can help */
+			if (d->ntargets > 1)
+				d->htgt = t;
+		}
+		if (t->nout == t->maxout) {
+			if (t->maxout > 1)
+				t->maxout--;
+			t->lastwadj = jiffies;
+		}
+
+		ifp = getif(t, f->skb->dev);
+		if (ifp && ++ifp->lost > (t->nframes << 1)
+		&& (ifp != t->ifs || t->ifs[1].nd)) {
+			ejectif(t, ifp);
+			ifp = NULL;
+		}
+		resend(d, f);
+	}
+
 	if (!skb_queue_empty(&d->sendq)) {
 		n = d->rttavg <<= 1;
 		if (n > MAXTIMER)
@@ -749,7 +821,7 @@ diskstats(struct gendisk *disk, struct bio *bio, ulong duration, sector_t sector
 }
 
 static void
-bvcpy(struct bio_vec *bv, ulong off, struct sk_buff *skb, ulong cnt)
+bvcpy(struct bio_vec *bv, ulong off, struct sk_buff *skb, long cnt)
 {
 	ulong fcnt;
 	char *p;
@@ -770,60 +842,233 @@ loop:
 }
 
 static void
-fadvance(struct frame *f, ulong cnt)
+ktiocomplete(struct frame *f)
 {
-	ulong fcnt;
+	struct aoe_hdr *hin, *hout;
+	struct aoe_atahdr *ahin, *ahout;
+	struct buf *buf;
+	struct sk_buff *skb;
+	struct aoetgt *t;
+	struct aoeif *ifp;
+	struct aoedev *d;
+	long n;
 
-	f->lba += cnt >> 9;
-loop:
-	fcnt = f->bv->bv_len - (f->bv_off - f->bv->bv_offset);
-	if (fcnt > cnt) {
-		f->bv_off += cnt;
+	if (f == NULL)
 		return;
+
+	t = f->t;
+	d = t->d;
+
+	hout = (struct aoe_hdr *) skb_mac_header(f->skb);
+	ahout = (struct aoe_atahdr *) (hout+1);
+	buf = f->buf;
+	skb = f->r_skb;
+	if (skb == NULL)
+		goto noskb;	/* just fail the buf. */
+
+	hin = (struct aoe_hdr *) skb->data;
+	skb_pull(skb, sizeof(*hin));
+	ahin = (struct aoe_atahdr *) skb->data;
+	skb_pull(skb, sizeof(*ahin));
+	if (ahin->cmdstat & 0xa9) {	/* these bits cleared on success */
+		pr_err("aoe: ata error cmd=%2.2Xh stat=%2.2Xh from e%ld.%d\n",
+			ahout->cmdstat, ahin->cmdstat,
+			d->aoemajor, d->aoeminor);
+noskb:	if (buf)
+			buf->flags |= BUFFL_FAIL;
+		goto badrsp;
 	}
-	cnt -= fcnt;
-	f->bv++;
-	f->bv_off = f->bv->bv_offset;
-	goto loop;
+
+	n = ahout->scnt << 9;
+	switch (ahout->cmdstat) {
+	case ATA_CMD_PIO_READ:
+	case ATA_CMD_PIO_READ_EXT:
+		if (skb->len < n) {
+			pr_err("aoe: runt data size in read.  skb->len=%d need=%ld\n",
+				skb->len, n);
+			buf->flags |= BUFFL_FAIL;
+			break;
+		}
+		bvcpy(f->bv, f->bv_off, skb, n);
+	case ATA_CMD_PIO_WRITE:
+	case ATA_CMD_PIO_WRITE_EXT:
+		spin_lock_irq(&d->lock);
+		ifp = getif(t, skb->dev);
+		if (ifp) {
+			ifp->lost = 0;
+			if (n > DEFAULTBCNT)
+				ifp->lostjumbo = 0;
+		}
+		if (d->htgt == t) /* I'll help myself, thank you. */
+			d->htgt = NULL;
+		spin_unlock_irq(&d->lock);
+		break;
+	case ATA_CMD_ID_ATA:
+		if (skb->len < 512) {
+			pr_info("aoe: runt data size in ataid.  skb->len=%d\n",
+				skb->len);
+			break;
+		}
+		if (skb_linearize(skb))
+			break;
+		spin_lock_irq(&d->lock);
+		ataid_complete(d, t, skb->data);
+		spin_unlock_irq(&d->lock);
+		break;
+	default:
+		pr_info("aoe: unrecognized ata command %2.2Xh for %d.%d\n",
+			ahout->cmdstat,
+			be16_to_cpu(get_unaligned(&hin->major)),
+			hin->minor);
+	}
+badrsp:
+	spin_lock_irq(&d->lock);
+
+	aoe_freetframe(f);
+
+	if (buf && --buf->nframesout == 0 && buf->resid == 0) {
+		struct bio *bio = buf->bio;
+
+		diskstats(d->gd, bio, jiffies - buf->stime, buf->sector);
+		n = (buf->flags & BUFFL_FAIL) ? -EIO : 0;
+		mempool_free(buf, d->bufpool);
+		spin_unlock_irq(&d->lock);
+		if (n != -EIO)
+			bio_flush_dcache_pages(buf->bio);
+		bio_endio(bio, n);
+	} else
+		spin_unlock_irq(&d->lock);
+	dev_kfree_skb(skb);
 }
 
-void
+/* Enters with iocq.lock held.
+ * Returns true iff responses needing processing remain.
+ */
+static int
+ktio(void)
+{
+	struct frame *f;
+	struct list_head *pos;
+	int i;
+
+	for (i = 0; ; ++i) {
+		if (i == MAXIOC)
+			return 1;
+		if (list_empty(&iocq.head))
+			return 0;
+		pos = iocq.head.next;
+		list_del(pos);
+		spin_unlock_irq(&iocq.lock);
+		f = list_entry(pos, struct frame, head);
+		ktiocomplete(f);
+		spin_lock_irq(&iocq.lock);
+	}
+}
+
+static int
+kthread(void *vp)
+{
+	struct ktstate *k;
+	DECLARE_WAITQUEUE(wait, current);
+	sigset_t blocked;
+	int more;
+
+	k = vp;
+#ifdef PF_NOFREEZE
+	current->flags |= PF_NOFREEZE;
+#endif
+	set_user_nice(current, -10);
+	sigfillset(&blocked);
+	sigprocmask(SIG_BLOCK, &blocked, NULL);
+	flush_signals(current);
+	complete(&k->rendez);
+	do {
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		spin_lock_irq(k->lock);
+		more = k->fn();
+		if (!more) {
+			add_wait_queue(k->waitq, &wait);
+			__set_current_state(TASK_INTERRUPTIBLE);
+		}
+		spin_unlock_irq(k->lock);
+		if (!more) {
+			schedule();
+			remove_wait_queue(k->waitq, &wait);
+		} else
+			cond_resched();
+	} while (!kthread_should_stop());
+	__set_current_state(TASK_RUNNING);
+	complete(&k->rendez);
+	return 0;
+}
+
+static void
+aoe_ktstop(struct ktstate *k)
+{
+	kthread_stop(k->task);
+	wait_for_completion(&k->rendez);
+}
+
+static int
+aoe_ktstart(struct ktstate *k)
+{
+	struct task_struct *task;
+
+	init_completion(&k->rendez);
+	task = kthread_run(kthread, k, k->name);
+	if (task == NULL || IS_ERR(task))
+		return -EFAULT;
+	k->task = task;
+	wait_for_completion(&k->rendez);
+	init_completion(&k->rendez);	/* for exit */
+	return 0;
+}
+
+/* pass it off to kthreads for processing */
+static void
+ktcomplete(struct frame *f, struct sk_buff *skb)
+{
+	ulong flags;
+
+	f->r_skb = skb;
+	spin_lock_irqsave(&iocq.lock, flags);
+	list_add_tail(&f->head, &iocq.head);
+	spin_unlock_irqrestore(&iocq.lock, flags);
+	wake_up(&ktiowq);
+}
+
+struct sk_buff *
 aoecmd_ata_rsp(struct sk_buff *skb)
 {
-	struct sk_buff_head queue;
 	struct aoedev *d;
-	struct aoe_hdr *hin, *hout;
-	struct aoe_atahdr *ahin, *ahout;
+	struct aoe_hdr *h;
 	struct frame *f;
-	struct buf *buf;
 	struct aoetgt *t;
-	struct aoeif *ifp;
-	register long n;
+	u32 n;
 	ulong flags;
 	char ebuf[128];
 	u16 aoemajor;
 
-	hin = (struct aoe_hdr *) skb_mac_header(skb);
-	skb_pull(skb, sizeof(*hin));
-	aoemajor = get_unaligned_be16(&hin->major);
-	d = aoedev_by_aoeaddr(aoemajor, hin->minor);
+	h = (struct aoe_hdr *) skb->data;
+	aoemajor = be16_to_cpu(get_unaligned(&h->major));
+	d = aoedev_by_aoeaddr(aoemajor, h->minor);
 	if (d == NULL) {
 		snprintf(ebuf, sizeof ebuf, "aoecmd_ata_rsp: ata response "
 			"for unknown device %d.%d\n",
-			 aoemajor, hin->minor);
+			aoemajor, h->minor);
 		aoechr_error(ebuf);
-		return;
+		return skb;
 	}
 
 	spin_lock_irqsave(&d->lock, flags);
 
-	n = get_unaligned_be32(&hin->tag);
-	t = gettgt(d, hin->src);
+	n = be32_to_cpu(get_unaligned(&h->tag));
+	t = gettgt(d, h->src);
 	if (t == NULL) {
 		printk(KERN_INFO "aoe: can't find target e%ld.%d:%pm\n",
-			d->aoemajor, d->aoeminor, hin->src);
+		       d->aoemajor, d->aoeminor, h->src);
 		spin_unlock_irqrestore(&d->lock, flags);
-		return;
+		return skb;
 	}
 	f = getframe(t, n);
 	if (f == NULL) {
@@ -832,102 +1077,26 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 		snprintf(ebuf, sizeof ebuf,
 			"%15s e%d.%d    tag=%08x@%08lx\n",
 			"unexpected rsp",
-			get_unaligned_be16(&hin->major),
-			hin->minor,
-			get_unaligned_be32(&hin->tag),
+			get_unaligned_be16(&h->major),
+			h->minor,
+			get_unaligned_be32(&h->tag),
 			jiffies);
 		aoechr_error(ebuf);
-		return;
+		return skb;
 	}
-
 	calc_rttavg(d, tsince(f->tag));
-
-	ahin = (struct aoe_atahdr *) skb->data;
-	skb_pull(skb, sizeof(*ahin));
-	hout = (struct aoe_hdr *) skb_mac_header(f->skb);
-	ahout = (struct aoe_atahdr *) (hout+1);
-	buf = f->buf;
-
-	if (ahin->cmdstat & 0xa9) {	/* these bits cleared on success */
-		printk(KERN_ERR
-			"aoe: ata error cmd=%2.2Xh stat=%2.2Xh from e%ld.%d\n",
-			ahout->cmdstat, ahin->cmdstat,
-			d->aoemajor, d->aoeminor);
-		if (buf)
-			buf->flags |= BUFFL_FAIL;
-	} else {
-		if (d->htgt && t == *d->htgt) /* I'll help myself, thank you. */
-			d->htgt = NULL;
-		n = ahout->scnt << 9;
-		switch (ahout->cmdstat) {
-		case ATA_CMD_PIO_READ:
-		case ATA_CMD_PIO_READ_EXT:
-			if (skb->len < n) {
-				printk(KERN_ERR
-					"aoe: %s.  skb->len=%d need=%ld\n",
-					"runt data size in read", skb->len, n);
-				/* fail frame f?  just returning will rexmit. */
-				spin_unlock_irqrestore(&d->lock, flags);
-				return;
-			}
-			bvcpy(f->bv, f->bv_off, skb, n);
-		case ATA_CMD_PIO_WRITE:
-		case ATA_CMD_PIO_WRITE_EXT:
-			ifp = getif(t, skb->dev);
-			if (ifp) {
-				ifp->lost = 0;
-				if (n > DEFAULTBCNT)
-					ifp->lostjumbo = 0;
-			}
-			if (f->bcnt -= n) {
-				fadvance(f, n);
-				resend(d, t, f);
-				goto xmit;
-			}
-			break;
-		case ATA_CMD_ID_ATA:
-			if (skb->len < 512) {
-				printk(KERN_INFO
-					"aoe: runt data size in ataid.  skb->len=%d\n",
-					skb->len);
-				spin_unlock_irqrestore(&d->lock, flags);
-				return;
-			}
-			if (skb_linearize(skb))
-				break;
-			ataid_complete(d, t, skb->data);
-			break;
-		default:
-			printk(KERN_INFO
-				"aoe: unrecognized ata command %2.2Xh for %d.%d\n",
-				ahout->cmdstat,
-				get_unaligned_be16(&hin->major),
-				hin->minor);
-		}
-	}
-
-	if (buf && --buf->nframesout == 0 && buf->resid == 0) {
-		diskstats(d->gd, buf->bio, jiffies - buf->stime, buf->sector);
-		if (buf->flags & BUFFL_FAIL)
-			bio_endio(buf->bio, -EIO);
-		else {
-			bio_flush_dcache_pages(buf->bio);
-			bio_endio(buf->bio, 0);
-		}
-		mempool_free(buf, d->bufpool);
-	}
-
-	f->buf = NULL;
-	f->tag = FREETAG;
 	t->nout--;
-
 	aoecmd_work(d);
-xmit:
-	__skb_queue_head_init(&queue);
-	skb_queue_splice_init(&d->sendq, &queue);
 
 	spin_unlock_irqrestore(&d->lock, flags);
-	aoenet_xmit(&queue);
+
+	ktcomplete(f, skb);
+
+	/*
+	 * Note here that we do not perform an aoedev_put, as we are
+	 * leaving this reference for the ktio to release.
+	 */
+	return NULL;
 }
 
 void
@@ -949,7 +1118,7 @@ aoecmd_ata_id(struct aoedev *d)
 	struct sk_buff *skb;
 	struct aoetgt *t;
 
-	f = freeframe(d);
+	f = newframe(d);
 	if (f == NULL)
 		return NULL;
 
@@ -962,6 +1131,7 @@ aoecmd_ata_id(struct aoedev *d)
 	skb_put(skb, sizeof *h + sizeof *ah);
 	memset(h, 0, skb->len);
 	f->tag = aoehdr_atainit(d, t, h);
+	fhash(f);
 	t->nout++;
 	f->waited = 0;
 
@@ -982,7 +1152,7 @@ static struct aoetgt *
 addtgt(struct aoedev *d, char *addr, ulong nframes)
 {
 	struct aoetgt *t, **tt, **te;
-	struct frame *f, *e;
+	int i;
 
 	tt = d->targets;
 	te = tt + NTARGETS;
@@ -995,22 +1165,21 @@ addtgt(struct aoedev *d, char *addr, ulong nframes)
 		return NULL;
 	}
 	t = kcalloc(1, sizeof *t, GFP_ATOMIC);
-	f = kcalloc(nframes, sizeof *f, GFP_ATOMIC);
-	if (!t || !f) {
-		kfree(f);
+	if (!t) {
 		kfree(t);
 		printk(KERN_INFO "aoe: cannot allocate memory to add target\n");
 		return NULL;
 	}
 
+	d->ntargets++;
 	t->nframes = nframes;
-	t->frames = f;
-	e = f + nframes;
-	for (; f < e; f++)
-		f->tag = FREETAG;
+	t->d = d;
 	memcpy(t->addr, addr, sizeof t->addr);
 	t->ifp = t->ifs;
 	t->maxout = t->nframes;
+	INIT_LIST_HEAD(&t->ffree);
+	for (i = 0; i < NFACTIVE; ++i)
+		INIT_LIST_HEAD(&t->factive[i]);
 	return *tt = t;
 }
 
@@ -1135,3 +1304,53 @@ aoecmd_cleanslate(struct aoedev *d)
 		}
 	}
 }
+
+static void
+flush_iocq(void)
+{
+	struct frame *f;
+	struct aoedev *d;
+	LIST_HEAD(flist);
+	struct list_head *pos;
+	struct sk_buff *skb;
+	ulong flags;
+
+	spin_lock_irqsave(&iocq.lock, flags);
+	list_splice_init(&iocq.head, &flist);
+	spin_unlock_irqrestore(&iocq.lock, flags);
+	while (!list_empty(&flist)) {
+		pos = flist.next;
+		list_del(pos);
+		f = list_entry(pos, struct frame, head);
+		d = f->t->d;
+		skb = f->r_skb;
+		spin_lock_irqsave(&d->lock, flags);
+		if (f->buf) {
+			f->buf->nframesout--;
+			aoe_failbuf(d, f->buf);
+		}
+		aoe_freetframe(f);
+		spin_unlock_irqrestore(&d->lock, flags);
+		dev_kfree_skb(skb);
+	}
+}
+
+int __init
+aoecmd_init(void)
+{
+	INIT_LIST_HEAD(&iocq.head);
+	spin_lock_init(&iocq.lock);
+	init_waitqueue_head(&ktiowq);
+	kts.name = "aoe_ktio";
+	kts.fn = ktio;
+	kts.waitq = &ktiowq;
+	kts.lock = &iocq.lock;
+	return aoe_ktstart(&kts);
+}
+
+void
+aoecmd_exit(void)
+{
+	aoe_ktstop(&kts);
+	flush_iocq();
+}
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index b2d1fd3..40bae1a 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -48,47 +48,60 @@ dummy_timer(ulong vp)
 }
 
 void
-aoedev_downdev(struct aoedev *d)
+aoe_failbuf(struct aoedev *d, struct buf *buf)
 {
-	struct aoetgt **t, **te;
-	struct frame *f, *e;
-	struct buf *buf;
 	struct bio *bio;
 
-	t = d->targets;
-	te = t + NTARGETS;
-	for (; t < te && *t; t++) {
-		f = (*t)->frames;
-		e = f + (*t)->nframes;
-		for (; f < e; f->tag = FREETAG, f->buf = NULL, f++) {
-			if (f->tag == FREETAG || f->buf == NULL)
-				continue;
-			buf = f->buf;
-			bio = buf->bio;
-			if (--buf->nframesout == 0
-			&& buf != d->inprocess) {
-				mempool_free(buf, d->bufpool);
-				bio_endio(bio, -EIO);
-			}
-		}
-		(*t)->maxout = (*t)->nframes;
-		(*t)->nout = 0;
-	}
-	buf = d->inprocess;
-	if (buf) {
+	if (buf == NULL)
+		return;
+	buf->flags |= BUFFL_FAIL;
+	if (buf->nframesout == 0) {
+		if (buf == d->inprocess) /* ensure we only process this once */
+			d->inprocess = NULL;
 		bio = buf->bio;
 		mempool_free(buf, d->bufpool);
 		bio_endio(bio, -EIO);
 	}
+}
+
+void
+aoedev_downdev(struct aoedev *d)
+{
+	struct aoetgt *t, **tt, **te;
+	struct frame *f;
+	struct list_head *head, *pos, *nx;
+	int i;
+
+	/* clean out active buffers on all targets */
+	tt = d->targets;
+	te = tt + NTARGETS;
+	for (; tt < te && (t = *tt); tt++) {
+		for (i = 0; i < NFACTIVE; i++) {
+			head = &t->factive[i];
+			list_for_each_safe(pos, nx, head) {
+				list_del(pos);
+				f = list_entry(pos, struct frame, head);
+				if (f->buf) {
+					f->buf->nframesout--;
+					aoe_failbuf(d, f->buf);
+				}
+				aoe_freetframe(f);
+			}
+		}
+		t->maxout = t->nframes;
+		t->nout = 0;
+	}
+
+	/* clean out the in-process buffer (if any) */
+	aoe_failbuf(d, d->inprocess);
 	d->inprocess = NULL;
 	d->htgt = NULL;
 
+	/* clean out all pending I/O */
 	while (!list_empty(&d->bufq)) {
-		buf = container_of(d->bufq.next, struct buf, bufs);
+		struct buf *buf = container_of(d->bufq.next, struct buf, bufs);
 		list_del(d->bufq.next);
-		bio = buf->bio;
-		mempool_free(buf, d->bufpool);
-		bio_endio(bio, -EIO);
+		aoe_failbuf(d, buf);
 	}
 
 	if (d->gd)
@@ -242,13 +255,16 @@ aoedev_by_sysminor_m(ulong sysminor)
 static void
 freetgt(struct aoedev *d, struct aoetgt *t)
 {
-	struct frame *f, *e;
+	struct frame *f;
+	struct list_head *pos, *nx, *head;
 
-	f = t->frames;
-	e = f + t->nframes;
-	for (; f < e; f++)
+	head = &t->ffree;
+	list_for_each_safe(pos, nx, head) {
+		list_del(pos);
+		f = list_entry(pos, struct frame, head);
 		skbfree(f->skb);
-	kfree(t->frames);
+		kfree(f);
+	}
 	kfree(t);
 }
 
diff --git a/drivers/block/aoe/aoemain.c b/drivers/block/aoe/aoemain.c
index 7f83ad9..6fc4b05 100644
--- a/drivers/block/aoe/aoemain.c
+++ b/drivers/block/aoe/aoemain.c
@@ -61,6 +61,7 @@ aoe_exit(void)
 
 	aoenet_exit();
 	unregister_blkdev(AOE_MAJOR, DEVICE_NAME);
+	aoecmd_exit();
 	aoechr_exit();
 	aoedev_exit();
 	aoeblk_exit();		/* free cache after de-allocating bufs */
@@ -83,17 +84,20 @@ aoe_init(void)
 	ret = aoenet_init();
 	if (ret)
 		goto net_fail;
+	ret = aoecmd_init();
+	if (ret)
+		goto cmd_fail;
 	ret = register_blkdev(AOE_MAJOR, DEVICE_NAME);
 	if (ret < 0) {
 		printk(KERN_ERR "aoe: can't register major\n");
 		goto blkreg_fail;
 	}
-
 	printk(KERN_INFO "aoe: AoE v%s initialised.\n", VERSION);
 	discover_timer(TINIT);
 	return 0;
-
  blkreg_fail:
+	aoecmd_exit();
+ cmd_fail:
 	aoenet_exit();
  net_fail:
 	aoeblk_exit();
diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index 0787807..000eff2 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -142,7 +142,8 @@ aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt,
 
 	switch (h->cmd) {
 	case AOECMD_ATA:
-		aoecmd_ata_rsp(skb);
+		/* ata_rsp may keep skb for later processing or give it back */
+		skb = aoecmd_ata_rsp(skb);
 		break;
 	case AOECMD_CFG:
 		aoecmd_cfg_rsp(skb);
@@ -152,6 +153,9 @@ aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt,
 			break;	/* don't complain about vendor commands */
 		printk(KERN_INFO "aoe: unknown cmd %d\n", h->cmd);
 	}
+
+	if (!skb)
+		return 0;
 exit:
 	dev_kfree_skb(skb);
 	return 0;
-- 
1.7.2.5

