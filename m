Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab1HZFNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 01:13:20 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53928 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab1HZFNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 01:13:20 -0400
MIME-Version: 1.0
Date: Fri, 26 Aug 2011 13:13:19 +0800
Message-ID: <CADqbE97Vj0UV-2XvpkoELwdey_Xw7iCsF1AhQNFjwxY583SUwg@mail.gmail.com>
Subject: [PATCH] slab: avoid unnecessary touching of a partial slab
From: Zhao Jin <cronozhj@gmail.com>
To: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com,
        trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
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
 mm/slab.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 6d90a09..3469c6f 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3121,11 +3121,14 @@ retry:
 		check_slabp(cachep, slabp);

 		/* move slabp to correct slabp list: */
-		list_del(&slabp->list);
-		if (slabp->free == BUFCTL_END)
+		if (slabp->free == BUFCTL_END) {
+			list_del(&slabp->list);
 			list_add(&slabp->list, &l3->slabs_full);
-		else
+		}
+		else if (&slabp->list != l3->slabs_partial.next) {
+			list_del(&slabp->list);
 			list_add(&slabp->list, &l3->slabs_partial);
+		}
 	}

 must_grow:
-- 
1.7.4.1
