Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab2IIXRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:17:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51469 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756351Ab2IIXRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:17:06 -0400
Message-Id: <20120909224151.268014343@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:41:52 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@redhat.com>,
        Bryan Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 02/95] nfs: tear down caches in nfs_init_writepagecache when allocation
 fails
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 3dd4765fce04c0b4af1e0bc4c0b10f906f95fabc upstream.

...and ensure that we tear down the nfs_commit_data cache too when
unloading the module.

Cc: Bryan Schumaker <bjschuma@netapp.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
[bwh: Backported to 3.2: drop the nfs_cdata_cachep cleanup; it doesn't exist]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/write.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1742,12 +1742,12 @@ int __init nfs_init_writepagecache(void)
 	nfs_wdata_mempool = mempool_create_slab_pool(MIN_POOL_WRITE,
 						     nfs_wdata_cachep);
 	if (nfs_wdata_mempool == NULL)
-		return -ENOMEM;
+		goto out_destroy_write_cache;
 
 	nfs_commit_mempool = mempool_create_slab_pool(MIN_POOL_COMMIT,
 						      nfs_wdata_cachep);
 	if (nfs_commit_mempool == NULL)
-		return -ENOMEM;
+		goto out_destroy_write_mempool;
 
 	/*
 	 * NFS congestion size, scale with available memory.
@@ -1770,6 +1770,12 @@ int __init nfs_init_writepagecache(void)
 		nfs_congestion_kb = 256*1024;
 
 	return 0;
+
+out_destroy_write_mempool:
+	mempool_destroy(nfs_wdata_mempool);
+out_destroy_write_cache:
+	kmem_cache_destroy(nfs_wdata_cachep);
+	return -ENOMEM;
 }
 
 void nfs_destroy_writepagecache(void)


