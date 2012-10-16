Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab2JPBot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 21:44:49 -0400
Received: from noserose.net ([66.220.18.76]:55194 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755532Ab2JPBos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 21:44:48 -0400
Date: Mon, 15 Oct 2012 18:44:43 -0700
Message-Id: <5c877eabcdaaa1ee37f1410598ff9b1999aaef1a.1350331035.git.ecashin@coraid.com>
In-Reply-To: <cover.1350331035.git.ecashin@coraid.com>
References: <cover.1350331035.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 3/9] aoe: update cap on outstanding commands based on config query response
To: akpm@linux-foundation.org
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ATA over Ethernet config query response contains a "buffer count"
field reflecting the AoE target's capacity to buffer incoming AoE
commands.

By taking the current value of this field into accound, we increase
performance throughput or avoid network congestion, when the value
has increased or decreased, respectively.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h    |    6 +++---
 drivers/block/aoe/aoecmd.c |    6 +++++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index d2ed7f1..52f75c0 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -122,14 +122,14 @@ struct aoeif {
 
 struct aoetgt {
 	unsigned char addr[6];
-	ushort nframes;
+	ushort nframes;		/* cap on frames to use */
 	struct aoedev *d;			/* parent device I belong to */
 	struct list_head ffree;			/* list of free frames */
 	struct aoeif ifs[NAOEIFS];
 	struct aoeif *ifp;	/* current aoeif in use */
 	ushort nout;
-	ushort maxout;
-	ulong falloc;
+	ushort maxout;		/* current value for max outstanding */
+	ulong falloc;		/* number of allocated frames */
 	ulong lastwadj;		/* last window adjustment */
 	int minbcnt;
 	int wpkts, rpkts;
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 3804a0a..2bb8c7d 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1373,7 +1373,11 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	spin_lock_irqsave(&d->lock, flags);
 
 	t = gettgt(d, h->src);
-	if (!t) {
+	if (t) {
+		t->nframes = n;
+		if (n < t->maxout)
+			t->maxout = n;
+	} else {
 		t = addtgt(d, h->src, n);
 		if (!t)
 			goto bail;
-- 
1.7.1

