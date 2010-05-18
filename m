Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0ERWZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:25:05 -0400
Received: from smtp.nokia.com ([192.100.122.230]:19140 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab0ERWZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:25:01 -0400
From: imre.deak@nokia.com
To: Tejun Heo <tj@kernel.org>
Cc: Imre Deak <imre.deak@nokia.com>, Tejun Heo <tj@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Paris <eparis@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] idr: fix backtrack logic in idr_remove_all
Date: Wed, 19 May 2010 01:23:24 +0300
Message-Id: <30085ac65a8087d98d8a6683c4f1f909d362ca46.1274217927.git.imre.deak@nokia.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <20100518205914.GA11667@localhost>
References: <20100518205914.GA11667@localhost>
X-OriginalArrivalTime: 18 May 2010 22:24:03.0822 (UTC) FILETIME=[D27C70E0:01CAF6D8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Imre Deak <imre.deak@nokia.com>

Currently idr_remove_all will fail with a use after free error if
idr::layers is bigger than 2, which on 32 bit systems corresponds to
items more than 1024. This is due to stepping back too many levels
during backtracking. For simplicity let's assume that IDR_BITS=1 -> we
have 2 nodes at each level below the root node and each leaf node stores
two IDs. (In reality for 32 bit systems IDR_BITS=5, with 32 nodes at
each sub-root level and 32 IDs in each leaf node). The sequence of
freeing the nodes at the moment is as follows:

layer
1 ->                       a(7)
2 ->            b(3)                  c(5)
3 ->        d(1)   e(2)           f(4)    g(6)

Until step 4 things go fine, but then node c is freed, whereas node g
should be freed first. Since node c contains the pointer to node g we'll
have a use after free error at step 6.

How many levels we step back after visiting the leaf nodes is currently
determined by the msb of the id we are currently visiting:

Step
1.          node d with IDs 0,1 is freed, current ID is advanced to 2.
            msb of the current ID bit 1. This means we need to step back
            1 level to node b and take the next sibling, node e.
2-3.        node e with IDs 2,3 is freed, current ID is 4, msb is bit 2.
            This means we need to step back 2 levels to node a, freeing
            node b on the way.
4-5.        node f with IDs 4,5 is freed, current ID is 6, msb is still
            bit 2. This means we again need to step back 2 levels to node
            a and free c on the way.
6.          We should visit node g, but its pointer is not available as
            node c was freed.

The fix changes how we determine the number of levels to step back.
Instead of deducting this merely from the msb of the current ID, we
should really check if advancing the ID causes an overflow to a bit
position corresponding to a given layer. In the above example overflow
from bit 0 to bit 1 should mean stepping back 1 level. Overflow from
bit 1 to bit 2 should mean stepping back 2 levels and so on.

The fix was tested with IDs up to 1 << 20, which corresponds to 4
layers on 32 bit systems.

Signed-off-by: Imre Deak <imre.deak@nokia.com>
Reviewed-by: Tejun Heo <tj@kernel.org>

---
 lib/idr.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

Changes since v1:
- changed nand to xor to save an instruction
- add note on how we calculate the backtrack level

diff --git a/lib/idr.c b/lib/idr.c
index 2eb1dca..dc847c5 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -445,6 +445,7 @@ EXPORT_SYMBOL(idr_remove);
 void idr_remove_all(struct idr *idp)
 {
 	int n, id, max;
+	int bt_mask;
 	struct idr_layer *p;
 	struct idr_layer *pa[MAX_LEVEL];
 	struct idr_layer **paa = &pa[0];
@@ -462,8 +463,10 @@ void idr_remove_all(struct idr *idp)
 			p = p->ary[(id >> n) & IDR_MASK];
 		}
 
+		bt_mask = id;
 		id += 1 << n;
-		while (n < fls(id)) {
+		/* Get the highest bit that the above add changed from 0->1. */
+		while (n < fls(id ^ bt_mask)) {
 			if (p)
 				free_layer(p);
 			n += IDR_BITS;
-- 
1.7.0.2

