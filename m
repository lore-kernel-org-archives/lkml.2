Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab2ICSf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 14:35:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44151 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab2ICSfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 14:35:25 -0400
Date: Mon, 3 Sep 2012 20:35:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Trond.Myklebust@netapp.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix memset in NFS zap caches
Message-ID: <20120903183515.GT16230@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix memset in nfs_zap_caches_locked

This memset overruns the buffer by 4 bytes on 64bit systems.

gcc 4.8 correct complains:

/backup/lsrc/git/linux-lto-2.6/fs/nfs/inode.c: In function
'nfs_zap_caches_locked':
/backup/lsrc/git/linux-lto-2.6/fs/nfs/inode.c:157:41: warning: argument
to 'sizeof' in 'memset' call is the same pointer type '__be32 *' as the
destination; expected '__be32' or an explicit length
[-Wsizeof-pointer-memaccess]
  memset(NFS_COOKIEVERF(inode), 0, sizeof(NFS_COOKIEVERF(inode)));
                                         ^
Add a * to sizeof the correct type.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index c6e895f..69e7f0f 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -154,7 +154,7 @@ static void nfs_zap_caches_locked(struct inode *inode)
 	nfsi->attrtimeo = NFS_MINATTRTIMEO(inode);
 	nfsi->attrtimeo_timestamp = jiffies;
 
-	memset(NFS_COOKIEVERF(inode), 0, sizeof(NFS_COOKIEVERF(inode)));
+	memset(NFS_COOKIEVERF(inode), 0, sizeof(*NFS_COOKIEVERF(inode)));
 	if (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode))
 		nfsi->cache_validity |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA|NFS_INO_INVALID_ACCESS|NFS_INO_INVALID_ACL|NFS_INO_REVAL_PAGECACHE;
 	else
-- 
ak@linux.intel.com -- Speaking for myself only.
