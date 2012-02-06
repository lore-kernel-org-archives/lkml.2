Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab2BFNz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 08:55:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241Ab2BFNz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 08:55:56 -0500
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, hare@suse.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] vfs: Avoid IPI storm due to bh LRU invalidation
Date: Mon,  6 Feb 2012 14:55:31 +0100
Message-Id: <1328536531-19034-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When discovery of lots of disks happen in parallel, we call
invalidate_bh_lrus() once for each disk from partitioning code resulting in a
storm of IPIs and causing a softlockup detection to fire (it takes several
*minutes* for a machine to execute all the invalidate_bh_lrus() calls).

Fix the issue by allowing only single invalidation to run using a mutex and let
waiters for mutex figure out whether someone invalidated LRUs for them while
they were waiting.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

  I feel this is slightly hacky approach but it works. If someone has better
idea, please speak up.

diff --git a/fs/buffer.c b/fs/buffer.c
index 1a30db7..56b0d2b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1384,10 +1384,31 @@ static void invalidate_bh_lru(void *arg)
 	}
 	put_cpu_var(bh_lrus);
 }
-	
+
+/*
+ * Invalidate all buffers in LRUs. Since we have to signal all CPUs to
+ * invalidate their per-cpu local LRU lists this is rather expensive operation.
+ * So we optimize the case of several parallel calls to invalidate_bh_lrus()
+ * which happens from partitioning code when lots of disks appear in the
+ * system during boot.
+ */
 void invalidate_bh_lrus(void)
 {
+	static DEFINE_MUTEX(bh_invalidate_mutex);
+	static long bh_invalidate_sequence;
+
+	long my_bh_invalidate_sequence = bh_invalidate_sequence;
+
+	mutex_lock(&bh_invalidate_mutex);
+	/* Someone did bh invalidation while we were sleeping? */
+	if (my_bh_invalidate_sequence != bh_invalidate_sequence)
+		goto out;
+	bh_invalidate_sequence++;
+	/* Inc of bh_invalidate_sequence must happen before we invalidate bhs */
+	smp_wmb();
 	on_each_cpu(invalidate_bh_lru, NULL, 1);
+out:
+	mutex_unlock(&bh_invalidate_mutex);
 }
 EXPORT_SYMBOL_GPL(invalidate_bh_lrus);
 
-- 
1.7.1

