Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1HZQad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 12:30:33 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49953 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab1HZQab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 12:30:31 -0400
From: Zhao Jin <cronozhj@gmail.com>
To: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com
Cc: linux-kernel@vger.kernel.org, Zhao Jin <cronozhj@gmail.com>
Subject: [PATCH 2/2][RESEND] slab: avoid unnecessary touching of a partial slab
Date: Sat, 27 Aug 2011 00:28:15 +0800
Message-Id: <1314376095-14991-1-git-send-email-cronozhj@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cache_alloc_refill(), after refilling from a partial slab, if the
slab remains partial, it would be deleted from and then added again to
the partial list. As the slab is the first element in the list before
deletion, such behavior has no effect. This patch avoids touching the
slab in this case.

Signed-off-by: Zhao Jin <cronozhj@gmail.com>
---
 mm/slab.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 82e0a0e..2d7a0f4 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3121,11 +3121,10 @@ retry:
 		check_slabp(cachep, slabp);
 
 		/* move slabp to correct slabp list: */
-		list_del(&slabp->list);
 		if (slabp->free == BUFCTL_END)
-			list_add(&slabp->list, &l3->slabs_full);
-		else
-			list_add(&slabp->list, &l3->slabs_partial);
+			list_move(entry, &l3->slabs_full);
+		else if (entry != l3->slabs_partial.next)
+			list_move(entry, &l3->slabs_partial);
 	}
 
 must_grow:
-- 
1.7.4.1

