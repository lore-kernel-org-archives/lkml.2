Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab0CaAIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:08:22 -0400
Received: from kroah.org ([198.145.64.141]:52081 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab0C3XSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:14 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:36 2010
Message-Id: <20100330225636.015008727@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [058/116] NFSv4: Dont ignore the NFS_INO_REVAL_FORCED flag in nfs_revalidate_inode()
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit b4d2314bb88b07e5a04e6c75b442a1dfcd60e340 upstream.

If the NFS_INO_REVAL_FORCED flag is set, that means that we don't yet have
an up to date attribute cache. Even if we hold a delegation, we must
put a GETATTR on the wire.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/delegation.h |    6 ++++++
 fs/nfs/dir.c        |    2 +-
 fs/nfs/inode.c      |    2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

--- a/fs/nfs/delegation.h
+++ b/fs/nfs/delegation.h
@@ -68,4 +68,10 @@ static inline int nfs_inode_return_deleg
 }
 #endif
 
+static inline int nfs_have_delegated_attributes(struct inode *inode)
+{
+	return nfs_have_delegation(inode, FMODE_READ) &&
+		!(NFS_I(inode)->cache_validity & NFS_INO_REVAL_FORCED);
+}
+
 #endif
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1797,7 +1797,7 @@ static int nfs_access_get_cached(struct
 	cache = nfs_access_search_rbtree(inode, cred);
 	if (cache == NULL)
 		goto out;
-	if (!nfs_have_delegation(inode, FMODE_READ) &&
+	if (!nfs_have_delegated_attributes(inode) &&
 	    !time_in_range_open(jiffies, cache->jiffies, cache->jiffies + nfsi->attrtimeo))
 		goto out_stale;
 	res->jiffies = cache->jiffies;
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -759,7 +759,7 @@ int nfs_attribute_timeout(struct inode *
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
 
-	if (nfs_have_delegation(inode, FMODE_READ))
+	if (nfs_have_delegated_attributes(inode))
 		return 0;
 	return !time_in_range_open(jiffies, nfsi->read_cache_jiffies, nfsi->read_cache_jiffies + nfsi->attrtimeo);
 }


