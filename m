Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030687Ab2HWSpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:45:34 -0400
Received: from noserose.net ([66.220.18.76]:34434 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934169Ab2HWSoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:44:44 -0400
Message-Id: <a81fb8ff51f8f715ad8fd8472e763d5919962298.1345743802.git.ecashin@coraid.com>
In-Reply-To: <cover.1345743800.git.ecashin@coraid.com>
References: <cover.1345743800.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Date: Fri, 17 Aug 2012 21:27:02 -0400
Subject: [PATCH 05/14] aoe: use packets that work with the smallest-MTU local interface
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users with several network interfaces dedicated to AoE generally do
not configure them to support different-sized AoE data payloads on
purpose.

For a given AoE target, there will be a set of local network
interfaces that can reach it.  Using only the payload that will fit in
the smallest-sized MTU of all those local interfaces greatly
simplifies the driver, especially in failure scenarios.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h    |    7 +-
 drivers/block/aoe/aoecmd.c |  151 ++++++++++++++++++++++++--------------------
 2 files changed, 87 insertions(+), 71 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index d0087de1..ffded64 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -125,9 +125,8 @@ struct frame {
 
 struct aoeif {
 	struct net_device *nd;
-	unsigned char lost;
-	unsigned char lostjumbo;
-	ushort maxbcnt;
+	ulong lost;
+	int bcnt;
 };
 
 struct aoetgt {
@@ -144,6 +143,7 @@ struct aoetgt {
 	u16 useme;
 	ulong falloc;
 	ulong lastwadj;		/* last window adjustment */
+	int minbcnt;
 	int wpkts, rpkts;
 };
 
@@ -172,6 +172,7 @@ struct aoedev {
 		struct bio *nxbio;
 		struct request *rq;
 	} ip;
+	ulong maxbcnt;
 	struct aoetgt *targets[NTARGETS];
 	struct aoetgt **tgt;	/* target in use when working */
 	struct aoetgt *htgt;	/* target needing rexmit assistance */
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 92eb28a..9bce877 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -118,16 +118,18 @@ put_lba(struct aoe_atahdr *ah, sector_t lba)
 	ah->lba5 = lba >>= 8;
 }
 
-static void
+static struct aoeif *
 ifrotate(struct aoetgt *t)
 {
-	t->ifp++;
-	if (t->ifp >= &t->ifs[NAOEIFS] || t->ifp->nd == NULL)
-		t->ifp = t->ifs;
-	if (t->ifp->nd == NULL) {
-		printk(KERN_INFO "aoe: no interface to rotate to\n");
-		BUG();
-	}
+	struct aoeif *ifp;
+
+	ifp = t->ifp;
+	ifp++;
+	if (ifp >= &t->ifs[NAOEIFS] || ifp->nd == NULL)
+		ifp = t->ifs;
+	if (ifp->nd == NULL)
+		return NULL;
+	return t->ifp = ifp;
 }
 
 static void
@@ -231,8 +233,8 @@ newframe(struct aoedev *d)
 		&& t->ifp->nd) {
 			f = newtframe(d, t);
 			if (f) {
-				d->tgt = tt;
 				ifrotate(t);
+				d->tgt = tt;
 				return f;
 			}
 		}
@@ -299,7 +301,7 @@ aoecmd_ata_rw(struct aoedev *d)
 		return 0;
 	t = *d->tgt;
 	bv = buf->bv;
-	bcnt = t->ifp->maxbcnt;
+	bcnt = d->maxbcnt;
 	if (bcnt == 0)
 		bcnt = DEFAULTBCNT;
 	if (bcnt > buf->resid)
@@ -430,9 +432,14 @@ resend(struct aoedev *d, struct frame *f)
 	u32 n;
 
 	t = f->t;
-	ifrotate(t);
 	n = newtag(t);
 	skb = f->skb;
+	if (ifrotate(t) == NULL) {
+		/* probably can't happen, but set it up to fail anyway */
+		pr_info("aoe: resend: no interfaces to rotate to.\n");
+		ktcomplete(f, NULL);
+		return;
+	}
 	h = (struct aoe_hdr *) skb_mac_header(skb);
 	ah = (struct aoe_atahdr *) (h+1);
 
@@ -482,21 +489,6 @@ getif(struct aoetgt *t, struct net_device *nd)
 	return NULL;
 }
 
-static struct aoeif *
-addif(struct aoetgt *t, struct net_device *nd)
-{
-	struct aoeif *p;
-
-	p = getif(t, NULL);
-	if (!p)
-		return NULL;
-	p->nd = nd;
-	p->maxbcnt = DEFAULTBCNT;
-	p->lost = 0;
-	p->lostjumbo = 0;
-	return p;
-}
-
 static void
 ejectif(struct aoetgt *t, struct aoeif *ifp)
 {
@@ -545,7 +537,11 @@ sthtith(struct aoedev *d)
 			resend(d, nf);
 		}
 	}
-	/* he's clean, he's useless.  take away his interfaces */
+	/* We've cleaned up the outstanding so take away his
+	 * interfaces so he won't be used.  We should remove him from
+	 * the target array here, but cleaning up a target is
+	 * involved.  PUNT!
+	 */
 	memset(ht->ifs, 0, sizeof ht->ifs);
 	d->htgt = NULL;
 	return 1;
@@ -1014,11 +1010,8 @@ noskb:	if (buf)
 	case ATA_CMD_PIO_WRITE_EXT:
 		spin_lock_irq(&d->lock);
 		ifp = getif(t, skb->dev);
-		if (ifp) {
+		if (ifp)
 			ifp->lost = 0;
-			if (n > DEFAULTBCNT)
-				ifp->lostjumbo = 0;
-		}
 		if (d->htgt == t) /* I'll help myself, thank you. */
 			d->htgt = NULL;
 		spin_unlock_irq(&d->lock);
@@ -1300,6 +1293,56 @@ addtgt(struct aoedev *d, char *addr, ulong nframes)
 	return *tt = t;
 }
 
+static void
+setdbcnt(struct aoedev *d)
+{
+	struct aoetgt **t, **e;
+	int bcnt = 0;
+
+	t = d->targets;
+	e = t + NTARGETS;
+	for (; t < e && *t; t++)
+		if (bcnt == 0 || bcnt > (*t)->minbcnt)
+			bcnt = (*t)->minbcnt;
+	if (bcnt != d->maxbcnt) {
+		d->maxbcnt = bcnt;
+		pr_info("aoe: e%ld.%d: setting %d byte data frames\n",
+			d->aoemajor, d->aoeminor, bcnt);
+	}
+}
+
+static void
+setifbcnt(struct aoetgt *t, struct net_device *nd, int bcnt)
+{
+	struct aoedev *d;
+	struct aoeif *p, *e;
+	int minbcnt;
+
+	d = t->d;
+	minbcnt = bcnt;
+	p = t->ifs;
+	e = p + NAOEIFS;
+	for (; p < e; p++) {
+		if (p->nd == NULL)
+			break;		/* end of the valid interfaces */
+		if (p->nd == nd) {
+			p->bcnt = bcnt;	/* we're updating */
+			nd = NULL;
+		} else if (minbcnt > p->bcnt)
+			minbcnt = p->bcnt; /* find the min interface */
+	}
+	if (nd) {
+		if (p == e) {
+			pr_err("aoe: device setifbcnt failure; too many interfaces.\n");
+			return;
+		}
+		p->nd = nd;
+		p->bcnt = bcnt;
+	}
+	t->minbcnt = minbcnt;
+	setdbcnt(d);
+}
+
 void
 aoecmd_cfg_rsp(struct sk_buff *skb)
 {
@@ -1307,7 +1350,6 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	struct aoe_hdr *h;
 	struct aoe_cfghdr *ch;
 	struct aoetgt *t;
-	struct aoeif *ifp;
 	ulong flags, sysminor, aoemajor;
 	struct sk_buff *sl;
 	struct sk_buff_head queue;
@@ -1353,32 +1395,13 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 		if (!t)
 			goto bail;
 	}
-	ifp = getif(t, skb->dev);
-	if (!ifp) {
-		ifp = addif(t, skb->dev);
-		if (!ifp) {
-			printk(KERN_INFO
-				"aoe: device addif failure; "
-				"too many interfaces?\n");
-			goto bail;
-		}
-	}
-	if (ifp->maxbcnt) {
-		n = ifp->nd->mtu;
-		n -= sizeof (struct aoe_hdr) + sizeof (struct aoe_atahdr);
-		n /= 512;
-		if (n > ch->scnt)
-			n = ch->scnt;
-		n = n ? n * 512 : DEFAULTBCNT;
-		if (n != ifp->maxbcnt) {
-			printk(KERN_INFO
-				"aoe: e%ld.%d: setting %d%s%s:%pm\n",
-				d->aoemajor, d->aoeminor, n,
-				" byte data frames on ", ifp->nd->name,
-				t->addr);
-			ifp->maxbcnt = n;
-		}
-	}
+	n = skb->dev->mtu;
+	n -= sizeof(struct aoe_hdr) + sizeof(struct aoe_atahdr);
+	n /= 512;
+	if (n > ch->scnt)
+		n = ch->scnt;
+	n = n ? n * 512 : DEFAULTBCNT;
+	setifbcnt(t, skb->dev, n);
 
 	/* don't change users' perspective */
 	if (d->nopen == 0) {
@@ -1399,22 +1422,14 @@ void
 aoecmd_cleanslate(struct aoedev *d)
 {
 	struct aoetgt **t, **te;
-	struct aoeif *p, *e;
 
 	d->mintimer = MINTIMER;
+	d->maxbcnt = 0;
 
 	t = d->targets;
 	te = t + NTARGETS;
-	for (; t < te && *t; t++) {
+	for (; t < te && *t; t++)
 		(*t)->maxout = (*t)->nframes;
-		p = (*t)->ifs;
-		e = p + NAOEIFS;
-		for (; p < e; p++) {
-			p->lostjumbo = 0;
-			p->lost = 0;
-			p->maxbcnt = DEFAULTBCNT;
-		}
-	}
 }
 
 void
-- 
1.7.2.5

