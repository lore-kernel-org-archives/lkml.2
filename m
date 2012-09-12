Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2IMAll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:41:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64318 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab2ILXbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:31:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Bryan Schumaker <bjschuma@netapp.com>,
        Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 031/108] nfs: tear down caches in nfs_init_writepagecache when allocation fails
Date: Wed, 12 Sep 2012 16:28:29 -0700
Message-Id: <20120912232453.798131523@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 3dd4765fce04c0b4af1e0bc4c0b10f906f95fabc upstream.

...and ensure that we tear down the nfs_commit_data cache too when
unloading the module.

Cc: Bryan Schumaker <bjschuma@netapp.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/write.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1806,19 +1806,19 @@ int __init nfs_init_writepagecache(void)
 	nfs_wdata_mempool = mempool_create_slab_pool(MIN_POOL_WRITE,
 						     nfs_wdata_cachep);
 	if (nfs_wdata_mempool == NULL)
-		return -ENOMEM;
+		goto out_destroy_write_cache;
 
 	nfs_cdata_cachep = kmem_cache_create("nfs_commit_data",
 					     sizeof(struct nfs_commit_data),
 					     0, SLAB_HWCACHE_ALIGN,
 					     NULL);
 	if (nfs_cdata_cachep == NULL)
-		return -ENOMEM;
+		goto out_destroy_write_mempool;
 
 	nfs_commit_mempool = mempool_create_slab_pool(MIN_POOL_COMMIT,
 						      nfs_wdata_cachep);
 	if (nfs_commit_mempool == NULL)
-		return -ENOMEM;
+		goto out_destroy_commit_cache;
 
 	/*
 	 * NFS congestion size, scale with available memory.
@@ -1841,11 +1841,20 @@ int __init nfs_init_writepagecache(void)
 		nfs_congestion_kb = 256*1024;
 
 	return 0;
+
+out_destroy_commit_cache:
+	kmem_cache_destroy(nfs_cdata_cachep);
+out_destroy_write_mempool:
+	mempool_destroy(nfs_wdata_mempool);
+out_destroy_write_cache:
+	kmem_cache_destroy(nfs_wdata_cachep);
+	return -ENOMEM;
 }
 
 void nfs_destroy_writepagecache(void)
 {
 	mempool_destroy(nfs_commit_mempool);
+	kmem_cache_destroy(nfs_cdata_cachep);
 	mempool_destroy(nfs_wdata_mempool);
 	kmem_cache_destroy(nfs_wdata_cachep);
 }


