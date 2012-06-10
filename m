Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab2FJB6K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 21:58:10 -0400
Received: from nm10.access.bullet.mail.sp2.yahoo.com ([98.139.44.137]:20744
	"HELO nm10.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753353Ab2FJB6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 21:58:08 -0400
X-Yahoo-Newman-Id: 58883.89803.bm@omp1018.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: LQEYMVAVM1mTcTNvSHs.wFgUKig_eidStPfVlzdm61zw7IF
 J0Hd1rXZ9cTWGUDKYEjf5PM7fJhLWQAkMmDMBWT0aSEyrcZNTb0fFitI5a1F
 zfDTKHEv3LM37CIiEK82AyG8AHssIrAwGK3kcHh9a8nXmwKuAOYfNWKhxpSs
 AxJvGWeg8bKhptowHB54KskoNU_F6iPsdpzDqyxU6L9DTSHXPXATyFlFOt5Z
 lUM4UpaipfvB4JIkDjna7nttPApknbE1pPIWSJubwqG1aGsvc7gUIFkK_yr0
 6M_e3SbGoMMsOnMxYAEYp4aWTchqgu6ezCRlSFPf92k3x9.Px89lW4YUoXTj
 PL.By7LJfTYW5fnLCUjHAqpPGYriq1OGcbXjAxXcStyETBtZwf7ioa4yGIBr
 daMZ96hy_
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Richard Weinberger <richard@nod.at>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH] drivers/mtd/ubi/wl.c: optimization for in_wl_tree()
Date: Sat,  9 Jun 2012 20:57:53 -0500
Message-Id: <1339293473-29444-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Essentially, instead of performing a search through the tree from the
top down, like we would when doing a lookup, we can just search from the
node up and then check to see if the root of the tree that the node is
in is the same as the one supplied.  Note that if you call this passing
a ubi_wl_entry who's u.rb member has not been inited with rb_init_node()
or added to a tree, the results are undefined.

This should be a little faster, but mostly, it'll be smaller.
---
 drivers/mtd/ubi/wl.c |   32 ++++++++------------------------
 1 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 9df100a..d415011 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -287,33 +287,17 @@ static int produce_free_peb(struct ubi_device *ubi)
  */
 static int in_wl_tree(struct ubi_wl_entry *e, struct rb_root *root)
 {
-	struct rb_node *p;
-
-	p = root->rb_node;
-	while (p) {
-		struct ubi_wl_entry *e1;
+	struct rb_node *p = &e->u.rb, *parent = rb_parent(&e->u.rb);
 
-		e1 = rb_entry(p, struct ubi_wl_entry, u.rb);
-
-		if (e->pnum == e1->pnum) {
-			ubi_assert(e == e1);
-			return 1;
-		}
+	if (parent == p)
+		return 0;
 
-		if (e->ec < e1->ec)
-			p = p->rb_left;
-		else if (e->ec > e1->ec)
-			p = p->rb_right;
-		else {
-			ubi_assert(e->pnum != e1->pnum);
-			if (e->pnum < e1->pnum)
-				p = p->rb_left;
-			else
-				p = p->rb_right;
-		}
-	}
+	do {
+		p = parent;
+		parent = rb_parent(parent);
+	} while (parent);
 
-	return 0;
+	return p == root->rb_node;
 }
 
 /**
-- 
1.7.3.4

