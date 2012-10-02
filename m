Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab2JBCDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 22:03:18 -0400
Received: from noserose.net ([66.220.18.76]:49288 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752827Ab2JBCDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 22:03:17 -0400
Date: Mon, 1 Oct 2012 19:03:15 -0700
Message-Id: <3aa187919581b068e22ac11c65281c9168e68220.1349104674.git.ecashin@coraid.com>
In-Reply-To: <3c9c2338b9c963e1d5f19cc9ed51b01cf829eeee.1349104674.git.ecashin@coraid.com>
References: <3c9c2338b9c963e1d5f19cc9ed51b01cf829eeee.1349104674.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 3/7] aoe: update and specify AoE address guards and error messages
To: akpm@linux-foundation.org
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In general, specific is better when it comes to messages about
AoE usage problems.  Also, explicit checks for the AoE broadcast
addresses are added.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h    |    2 --
 drivers/block/aoe/aoecmd.c |   17 +++++++++++------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 7b694f7..4ae2468 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -49,8 +49,6 @@ struct aoe_hdr {
 	__be32 tag;
 };
 
-#define AOE_MAXSHELF (0xffff-1)	/* one less than the broadcast shelf address */
-
 struct aoe_atahdr {
 	unsigned char aflags;
 	unsigned char errfeat;
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 94e810c..3804a0a 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1349,15 +1349,14 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 			"Check shelf dip switches.\n");
 		return;
 	}
-	if (aoemajor > AOE_MAXSHELF) {
-		pr_info("aoe: e%ld.%d: shelf number too large\n",
+	if (aoemajor == 0xffff) {
+		pr_info("aoe: e%ld.%d: broadcast shelf number invalid\n",
 			aoemajor, (int) h->minor);
 		return;
 	}
-
-	d = aoedev_by_aoeaddr(aoemajor, h->minor, 1);
-	if (d == NULL) {
-		pr_info("aoe: device allocation failure\n");
+	if (h->minor == 0xff) {
+		pr_info("aoe: e%ld.%d: broadcast slot number invalid\n",
+			aoemajor, (int) h->minor);
 		return;
 	}
 
@@ -1365,6 +1364,12 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	if (n > aoe_maxout)	/* keep it reasonable */
 		n = aoe_maxout;
 
+	d = aoedev_by_aoeaddr(aoemajor, h->minor, 1);
+	if (d == NULL) {
+		pr_info("aoe: device allocation failure\n");
+		return;
+	}
+
 	spin_lock_irqsave(&d->lock, flags);
 
 	t = gettgt(d, h->src);
-- 
1.7.1

