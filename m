Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab1EKQN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:13:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:51685 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215Ab1EKPsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:48:22 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3/3] mm: slub: Default slub_max_order to 0
Date: Wed, 11 May 2011 16:29:33 +0100
Message-Id: <1305127773-10570-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305127773-10570-1-git-send-email-mgorman@suse.de>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid locking and per-cpu overhead, SLUB optimisically uses
high-order allocations up to order-3 by default and falls back to
lower allocations if they fail. While care is taken that the caller
and kswapd take no unusual steps in response to this, there are
further consequences like shrinkers who have to free more objects to
release any memory. There is anecdotal evidence that significant time
is being spent looping in shrinkers with insufficient progress being
made (https://lkml.org/lkml/2011/4/28/361) and keeping kswapd awake.

SLUB is now the default allocator and some bug reports have been
pinned down to SLUB using high orders during operations like
copying large amounts of data. SLUBs use of high-orders benefits
applications that are sized to memory appropriately but this does not
necessarily apply to large file servers or desktops.  This patch
causes SLUB to use order-0 pages like SLAB does by default.
There is further evidence that this keeps kswapd's usage lower
(https://lkml.org/lkml/2011/5/10/383).

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 Documentation/vm/slub.txt |    2 +-
 mm/slub.c                 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/vm/slub.txt b/Documentation/vm/slub.txt
index 07375e7..778e9fa 100644
--- a/Documentation/vm/slub.txt
+++ b/Documentation/vm/slub.txt
@@ -117,7 +117,7 @@ can be influenced by kernel parameters:
 
 slub_min_objects=x		(default 4)
 slub_min_order=x		(default 0)
-slub_max_order=x		(default 1)
+slub_max_order=x		(default 0)
 
 slub_min_objects allows to specify how many objects must at least fit
 into one slab in order for the allocation order to be acceptable.
diff --git a/mm/slub.c b/mm/slub.c
index 1071723..23a4789 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2198,7 +2198,7 @@ EXPORT_SYMBOL(kmem_cache_free);
  * take the list_lock.
  */
 static int slub_min_order;
-static int slub_max_order = PAGE_ALLOC_COSTLY_ORDER;
+static int slub_max_order;
 static int slub_min_objects;
 
 /*
-- 
1.7.3.4

