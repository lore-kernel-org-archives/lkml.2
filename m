Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030683Ab2HWSqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:46:47 -0400
Received: from noserose.net ([66.220.18.76]:42180 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752341Ab2HWSqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:46:43 -0400
Message-Id: <b69df1218efec7fb33cfc94985fc3503f9af3267.1345743802.git.ecashin@coraid.com>
In-Reply-To: <cover.1345743800.git.ecashin@coraid.com>
References: <cover.1345743800.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Date: Fri, 17 Aug 2012 21:27:57 -0400
Subject: [PATCH 11/14] aoe: remove unused code and add cosmetic improvements
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change removes some unused code and attempts to increase code
consistency.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h    |   10 +++-------
 drivers/block/aoe/aoechr.c |    1 +
 drivers/block/aoe/aoecmd.c |   13 ++++---------
 drivers/block/aoe/aoenet.c |    3 ++-
 4 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index dab7258..eb41fc5 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -75,18 +75,14 @@ enum {
 	DEVFL_UP = 1,	/* device is installed in system and ready for AoE->ATA commands */
 	DEVFL_TKILL = (1<<1),	/* flag for timer to know when to kill self */
 	DEVFL_EXT = (1<<2),	/* device accepts lba48 commands */
-	DEVFL_CLOSEWAIT = (1<<3), /* device is waiting for all closes to revalidate */
-	DEVFL_GDALLOC = (1<<4),	/* need to alloc gendisk */
-	DEVFL_KICKME = (1<<5),	/* slow polling network card catch */
-	DEVFL_NEWSIZE = (1<<6),	/* need to update dev size in block layer */
-
-	BUFFL_FAIL = 1,
+	DEVFL_GDALLOC = (1<<3),	/* need to alloc gendisk */
+	DEVFL_KICKME = (1<<4),	/* slow polling network card catch */
+	DEVFL_NEWSIZE = (1<<5),	/* need to update dev size in block layer */
 };
 
 enum {
 	DEFAULTBCNT = 2 * 512,	/* 2 sectors */
 	NPERSHELF = 16,		/* number of slots per shelf address */
-	FREETAG = -1,
 	MIN_BUFS = 16,
 	NTARGETS = 8,
 	NAOEIFS = 8,
diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index acdd0ad..723e604 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -174,6 +174,7 @@ aoechr_write(struct file *filp, const char __user *buf, size_t cnt, loff_t *offp
 		break;
 	case MINOR_FLUSH:
 		ret = aoedev_flush(buf, cnt);
+		break;
 	}
 	if (ret == 0)
 		ret = cnt;
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index c985b50..1010c4e 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -283,7 +283,6 @@ aoecmd_ata_rw(struct aoedev *d)
 	struct aoe_hdr *h;
 	struct aoe_atahdr *ah;
 	struct buf *buf;
-	struct bio_vec *bv;
 	struct aoetgt *t;
 	struct sk_buff *skb;
 	struct sk_buff_head queue;
@@ -300,7 +299,6 @@ aoecmd_ata_rw(struct aoedev *d)
 	if (f == NULL)
 		return 0;
 	t = *d->tgt;
-	bv = buf->bv;
 	bcnt = d->maxbcnt;
 	if (bcnt == 0)
 		bcnt = DEFAULTBCNT;
@@ -787,28 +785,25 @@ void
 aoecmd_sleepwork(struct work_struct *work)
 {
 	struct aoedev *d = container_of(work, struct aoedev, work);
+	struct block_device *bd;
+	u64 ssize;
 
 	if (d->flags & DEVFL_GDALLOC)
 		aoeblk_gdalloc(d);
 
 	if (d->flags & DEVFL_NEWSIZE) {
-		struct block_device *bd;
-		unsigned long flags;
-		u64 ssize;
-
 		ssize = get_capacity(d->gd);
 		bd = bdget_disk(d->gd, 0);
-
 		if (bd) {
 			mutex_lock(&bd->bd_inode->i_mutex);
 			i_size_write(bd->bd_inode, (loff_t)ssize<<9);
 			mutex_unlock(&bd->bd_inode->i_mutex);
 			bdput(bd);
 		}
-		spin_lock_irqsave(&d->lock, flags);
+		spin_lock_irq(&d->lock);
 		d->flags |= DEVFL_UP;
 		d->flags &= ~DEVFL_NEWSIZE;
-		spin_unlock_irqrestore(&d->lock, flags);
+		spin_unlock_irq(&d->lock);
 	}
 }
 
diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index 5f43710..3c923e5 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -175,7 +175,8 @@ aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt,
 	default:
 		if (h->cmd >= AOECMD_VEND_MIN)
 			break;	/* don't complain about vendor commands */
-		printk(KERN_INFO "aoe: unknown cmd %d\n", h->cmd);
+		pr_info("aoe: unknown AoE command type 0x%02x\n", h->cmd);
+		break;
 	}
 
 	if (!skb)
-- 
1.7.2.5

