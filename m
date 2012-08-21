Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030680Ab2HWSqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:46:13 -0400
Received: from noserose.net ([66.220.18.76]:44440 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752341Ab2HWSqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:46:07 -0400
Message-Id: <3e100231f8a6be2e831214fc9db8a9226ddc8316.1345743802.git.ecashin@coraid.com>
In-Reply-To: <cover.1345743800.git.ecashin@coraid.com>
References: <cover.1345743800.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Date: Tue, 21 Aug 2012 11:07:43 -0400
Subject: [PATCH 10/14] aoe: increase net_device reference count while using it
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change eliminates the danger that the user could rmmod the driver
for a network interface that is being used for AoE by the aoe driver.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoecmd.c |    4 ++++
 drivers/block/aoe/aoedev.c |    7 +++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index fec28738..c985b50 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -493,12 +493,15 @@ static void
 ejectif(struct aoetgt *t, struct aoeif *ifp)
 {
 	struct aoeif *e;
+	struct net_device *nd;
 	ulong n;
 
+	nd = ifp->nd;
 	e = t->ifs + NAOEIFS - 1;
 	n = (e - ifp) * sizeof *ifp;
 	memmove(ifp, ifp+1, n);
 	e->nd = NULL;
+	dev_put(nd);
 }
 
 static int
@@ -1325,6 +1328,7 @@ setifbcnt(struct aoetgt *t, struct net_device *nd, int bcnt)
 			pr_err("aoe: device setifbcnt failure; too many interfaces.\n");
 			return;
 		}
+		dev_hold(nd);
 		p->nd = nd;
 		p->bcnt = bcnt;
 	}
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 3968fe6..6be7b38 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -295,6 +295,13 @@ freetgt(struct aoedev *d, struct aoetgt *t)
 {
 	struct frame *f;
 	struct list_head *pos, *nx, *head;
+	struct aoeif *ifp;
+
+	for (ifp = t->ifs; ifp < &t->ifs[NAOEIFS]; ++ifp) {
+		if (!ifp->nd)
+			break;
+		dev_put(ifp->nd);
+	}
 
 	head = &t->ffree;
 	list_for_each_safe(pos, nx, head) {
-- 
1.7.2.5

