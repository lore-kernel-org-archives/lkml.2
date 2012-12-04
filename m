Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab2LDBpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 20:45:03 -0500
Received: from dupo.coraid.com ([208.71.232.133]:35349 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751545Ab2LDBpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 20:45:02 -0500
Message-Id: <a8a9da6ea81987972a4ede6531adf6e45263c4f0.1354501189.git.ecashin@coraid.com>
In-Reply-To: <cover.1354501189.git.ecashin@coraid.com>
References: <cover.1354501189.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 3/7] aoe: use dynamic number of remote ports for AoE storage target
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Mon, 3 Dec 2012 20:44:56 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many AoE targets have four or fewer network ports, but some
existing storage devices have many, and the AoE protocol sets no
limit.

This patch allows the use of more than eight remote MAC addresses
per AoE target, while reducing the amount of memory used by the
aoe driver in cases where there are many AoE targets with fewer
than eight MAC addresses each.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h    |    6 ++--
 drivers/block/aoe/aoeblk.c |    2 +-
 drivers/block/aoe/aoecmd.c |   50 ++++++++++++++++++++++++++++++-------------
 drivers/block/aoe/aoedev.c |   12 ++++++++-
 4 files changed, 49 insertions(+), 21 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index d50e945..0f478dc 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -84,7 +84,7 @@ enum {
 enum {
 	DEFAULTBCNT = 2 * 512,	/* 2 sectors */
 	MIN_BUFS = 16,
-	NTARGETS = 8,
+	NTARGETS = 4,
 	NAOEIFS = 8,
 	NSKBPOOLMAX = 256,
 	NFACTIVE = 61,
@@ -185,9 +185,9 @@ struct aoedev {
 	ulong maxbcnt;
 	struct list_head factive[NFACTIVE];	/* hash of active frames */
 	struct list_head rexmitq; /* deferred retransmissions */
-	struct aoetgt *targets[NTARGETS];
+	struct aoetgt **targets;
+	ulong ntargets;		/* number of allocated aoetgt pointers */
 	struct aoetgt **tgt;	/* target in use when working */
-	ulong ntargets;
 	ulong kicked;
 	char ident[512];
 };
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 6b5b787..a129f8c 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -67,7 +67,7 @@ static ssize_t aoedisk_show_netif(struct device *dev,
 	nd = nds;
 	ne = nd + ARRAY_SIZE(nds);
 	t = d->targets;
-	te = t + NTARGETS;
+	te = t + d->ntargets;
 	for (; t < te && *t; t++) {
 		ifp = (*t)->ifs;
 		e = ifp + NAOEIFS;
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 000f7fb..da360f9 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -242,14 +242,14 @@ newframe(struct aoedev *d)
 	int use_tainted;
 	int has_untainted;
 
-	if (d->targets[0] == NULL) {	/* shouldn't happen, but I'm paranoid */
+	if (!d->targets || !d->targets[0]) {
 		printk(KERN_ERR "aoe: NULL TARGETS!\n");
 		return NULL;
 	}
 	tt = d->tgt;	/* last used target */
 	for (use_tainted = 0, has_untainted = 0;;) {
 		tt++;
-		if (tt >= &d->targets[NTARGETS] || !*tt)
+		if (tt >= &d->targets[d->ntargets] || !*tt)
 			tt = d->targets;
 		t = *tt;
 		if (!t->taint) {
@@ -1104,7 +1104,7 @@ gettgt(struct aoedev *d, char *addr)
 	struct aoetgt **t, **e;
 
 	t = d->targets;
-	e = t + NTARGETS;
+	e = t + d->ntargets;
 	for (; t < e && *t; t++)
 		if (memcmp((*t)->addr, addr, sizeof((*t)->addr)) == 0)
 			return *t;
@@ -1479,28 +1479,44 @@ aoecmd_ata_id(struct aoedev *d)
 	return skb;
 }
 
+static struct aoetgt **
+grow_targets(struct aoedev *d)
+{
+	ulong oldn, newn;
+	struct aoetgt **tt;
+
+	oldn = d->ntargets;
+	newn = oldn * 2;
+	tt = kcalloc(newn, sizeof(*d->targets), GFP_ATOMIC);
+	if (!tt)
+		return NULL;
+	memmove(tt, d->targets, sizeof(*d->targets) * oldn);
+	d->tgt = tt + (d->tgt - d->targets);
+	kfree(d->targets);
+	d->targets = tt;
+	d->ntargets = newn;
+
+	return &d->targets[oldn];
+}
+
 static struct aoetgt *
 addtgt(struct aoedev *d, char *addr, ulong nframes)
 {
 	struct aoetgt *t, **tt, **te;
 
 	tt = d->targets;
-	te = tt + NTARGETS;
+	te = tt + d->ntargets;
 	for (; tt < te && *tt; tt++)
 		;
 
 	if (tt == te) {
-		printk(KERN_INFO
-			"aoe: device addtgt failure; too many targets\n");
-		return NULL;
+		tt = grow_targets(d);
+		if (!tt)
+			goto nomem;
 	}
 	t = kzalloc(sizeof(*t), GFP_ATOMIC);
-	if (!t) {
-		printk(KERN_INFO "aoe: cannot allocate memory to add target\n");
-		return NULL;
-	}
-
-	d->ntargets++;
+	if (!t)
+		goto nomem;
 	t->nframes = nframes;
 	t->d = d;
 	memcpy(t->addr, addr, sizeof t->addr);
@@ -1509,6 +1525,10 @@ addtgt(struct aoedev *d, char *addr, ulong nframes)
 	t->maxout = t->nframes / 2;
 	INIT_LIST_HEAD(&t->ffree);
 	return *tt = t;
+
+ nomem:
+	pr_info("aoe: cannot allocate memory to add target\n");
+	return NULL;
 }
 
 static void
@@ -1518,7 +1538,7 @@ setdbcnt(struct aoedev *d)
 	int bcnt = 0;
 
 	t = d->targets;
-	e = t + NTARGETS;
+	e = t + d->ntargets;
 	for (; t < e && *t; t++)
 		if (bcnt == 0 || bcnt > (*t)->minbcnt)
 			bcnt = (*t)->minbcnt;
@@ -1662,7 +1682,7 @@ aoecmd_cleanslate(struct aoedev *d)
 	d->maxbcnt = 0;
 
 	t = d->targets;
-	te = t + NTARGETS;
+	te = t + d->ntargets;
 	for (; t < te && *t; t++)
 		aoecmd_wreset(*t);
 }
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 3776715..e66ccbf 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -214,7 +214,7 @@ aoedev_downdev(struct aoedev *d)
 
 	/* reset window dressings */
 	tt = d->targets;
-	te = tt + NTARGETS;
+	te = tt + d->ntargets;
 	for (; tt < te && (t = *tt); tt++) {
 		aoecmd_wreset(t);
 		t->nout = 0;
@@ -284,7 +284,7 @@ freedev(struct aoedev *d)
 		blk_cleanup_queue(d->blkq);
 	}
 	t = d->targets;
-	e = t + NTARGETS;
+	e = t + d->ntargets;
 	for (; t < e && *t; t++)
 		freetgt(d, *t);
 	if (d->bufpool)
@@ -376,6 +376,8 @@ restart:
 			dd = &d->next;
 		}
 		spin_unlock(&d->lock);
+		if (doomed)
+			kfree(doomed->targets);
 		kfree(doomed);
 	}
 	spin_unlock_irqrestore(&devlist_lock, flags);
@@ -456,6 +458,12 @@ aoedev_by_aoeaddr(ulong maj, int min, int do_alloc)
 	d = kcalloc(1, sizeof *d, GFP_ATOMIC);
 	if (!d)
 		goto out;
+	d->targets = kcalloc(NTARGETS, sizeof(*d->targets), GFP_ATOMIC);
+	if (!d->targets) {
+		kfree(d);
+		goto out;
+	}
+	d->ntargets = NTARGETS;
 	INIT_WORK(&d->work, aoecmd_sleepwork);
 	spin_lock_init(&d->lock);
 	skb_queue_head_init(&d->skbpool);
-- 
1.7.1

