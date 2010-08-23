Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0HWOso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 10:48:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59638 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab0HWOsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 10:48:42 -0400
Date: Mon, 23 Aug 2010 10:47:55 -0400
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>
Subject: aio: bump i_count instead of using igrab
Message-ID: <20100823144755.GP21975@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jeff Moyer <jmoyer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The aio batching code is using igrab to get an extra reference on the
inode so it can safely batch.  igrab will go ahead and take the global
inode spinlock, which can be a bottleneck on large machines doing lots
of AIO.

In this case, igrab isn't required because we already have a reference
on the file handle.  It is safe to just bump the i_count directly
on the inode.

Benchmarking shows this patch brings IOP/s on tons of flash up by about
2.5X.

Signed-off-by: Chris Mason <chris.mason@oracle.com>

diff --git a/fs/aio.c b/fs/aio.c
index cf0bef4..0be69fa 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1558,7 +1558,20 @@ static void aio_batch_add(struct address_space *mapping,
 	}
 
 	abe = mempool_alloc(abe_pool, GFP_KERNEL);
-	BUG_ON(!igrab(mapping->host));
+
+	/*
+	 * we should be using igrab here, but
+	 * we don't want to hammer on the global
+	 * inode spinlock just to take an extra
+	 * reference on a file that we must already
+	 * have a reference to.
+	 *
+	 * When we're called, we always have a reference
+	 * on the file, so we must always have a reference
+	 * on the inode, so igrab must always just
+	 * bump the count and move on.
+	 */
+	atomic_inc(&mapping->host->i_count);
 	abe->mapping = mapping;
 	hlist_add_head(&abe->list, &batch_hash[bucket]);
 	return;
