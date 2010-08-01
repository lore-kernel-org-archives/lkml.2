Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab0HARkq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 13:40:46 -0400
Received: from mx2.netapp.com ([216.240.18.37]:60068 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab0HARkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 13:40:45 -0400
X-IronPort-AV: E=Sophos;i="4.55,299,1278313200"; 
   d="scan'208";a="417025553"
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Randy Dunlap <rdunlap@xenotime.net>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH] NFS: Fix a typo in include/linux/nfs_fs.h
Date: Sun,  1 Aug 2010 13:40:40 -0400
Message-Id: <1280684440-5763-1-git-send-email-Trond.Myklebust@netapp.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1280684100.4430.8.camel@heimdal.trondhjem.org>
References: <1280684100.4430.8.camel@heimdal.trondhjem.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nfs_commit_inode() needs to be defined irrespectively of whether or not
we are supporting NFSv3 and NFSv4.
Allow the compiler to optimise away code in the NFSv2-only case by
converting it into an inlined stub function.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/write.c         |    5 -----
 include/linux/nfs_fs.h |    6 ++++++
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index bb72ad3..9f81bdd 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1454,11 +1454,6 @@ out_mark_dirty:
 	return ret;
 }
 #else
-int nfs_commit_inode(struct inode *inode, int how)
-{
-	return 0;
-}
-
 static int nfs_commit_unstable_pages(struct inode *inode, struct writeback_control *wbc)
 {
 	return 0;
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index f6e2455..bad4d12 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -496,6 +496,12 @@ extern int nfs_wb_page_cancel(struct inode *inode, struct page* page);
 extern int  nfs_commit_inode(struct inode *, int);
 extern struct nfs_write_data *nfs_commitdata_alloc(void);
 extern void nfs_commit_free(struct nfs_write_data *wdata);
+#else
+static inline int
+nfs_commit_inode(struct inode *inode, int how)
+{
+	return 0;
+}
 #endif
 
 static inline int
-- 
1.7.2

