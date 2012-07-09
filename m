Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab2GIH1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 03:27:20 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:17378 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187Ab2GIH1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 03:27:19 -0400
X-IronPort-AV: E=Sophos;i="4.77,551,1336341600"; 
   d="scan'208";a="166080972"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs/ubifs/orphan.c: remove invalid reference to list iterator variable
Date: Mon,  9 Jul 2012 09:27:14 +0200
Message-Id: <1341818834-2101-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

If list_for_each_entry, etc complete a traversal of the list, the iterator
variable ends up pointing to an address at an offset from the list head,
and not a meaningful structure.  Thus this value should not be used after
the end of the iterator.  Replace a field access from orphan by NULL in two
places.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier c;
expression E;
iterator name list_for_each_entry;
statement S;
@@

list_for_each_entry(c,...) { ... when != break;
                                 when forall
                                 when strict
}
...
(
c = E
|
*c
)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 fs/ubifs/orphan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/orphan.c b/fs/ubifs/orphan.c
index b02734d..cebf17e 100644
--- a/fs/ubifs/orphan.c
+++ b/fs/ubifs/orphan.c
@@ -176,7 +176,7 @@ int ubifs_orphan_start_commit(struct ubifs_info *c)
 		*last = orphan;
 		last = &orphan->cnext;
 	}
-	*last = orphan->cnext;
+	*last = NULL;
 	c->cmt_orphans = c->new_orphans;
 	c->new_orphans = 0;
 	dbg_cmt("%d orphans to commit", c->cmt_orphans);
@@ -382,7 +382,7 @@ static int consolidate(struct ubifs_info *c)
 			last = &orphan->cnext;
 			cnt += 1;
 		}
-		*last = orphan->cnext;
+		*last = NULL;
 		ubifs_assert(cnt == c->tot_orphans - c->new_orphans);
 		c->cmt_orphans = cnt;
 		c->ohead_lnum = c->orph_first;

