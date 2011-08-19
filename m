Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1HSVdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 17:33:25 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11619 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab1HSVdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 17:33:23 -0400
Date: Fri, 19 Aug 2011 23:33:56 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-ntfs-dev@lists.sourceforge.net,
        Anton Altaparmakov <anton@tuxera.com>
Subject: [PATCH 3/3] Remove no longer needed NULL checks before calls to
 ntfs_free()
In-Reply-To: <alpine.LNX.2.00.1108192321130.31857@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1108192332490.31857@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1108192321130.31857@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>

ntfs_free() can deal with NULL pointers, it's redundant to check first.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 fs/ntfs/inode.c   |   18 ++++++------------
 fs/ntfs/logfile.c |    3 +--
 fs/ntfs/runlist.c |    3 +--
 fs/ntfs/super.c   |   36 ++++++++++++------------------------
 4 files changed, 20 insertions(+), 40 deletions(-)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 1371487..bcc298f 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -2197,22 +2197,16 @@ static void __ntfs_clear_inode(ntfs_inode *ni)
 {
 	/* Free all alocated memory. */
 	down_write(&ni->runlist.lock);
-	if (ni->runlist.rl) {
-		ntfs_free(ni->runlist.rl);
-		ni->runlist.rl = NULL;
-	}
+	ntfs_free(ni->runlist.rl);
+	ni->runlist.rl = NULL;
 	up_write(&ni->runlist.lock);
 
-	if (ni->attr_list) {
-		ntfs_free(ni->attr_list);
-		ni->attr_list = NULL;
-	}
+	ntfs_free(ni->attr_list);
+	ni->attr_list = NULL;
 
 	down_write(&ni->attr_list_rl.lock);
-	if (ni->attr_list_rl.rl) {
-		ntfs_free(ni->attr_list_rl.rl);
-		ni->attr_list_rl.rl = NULL;
-	}
+	ntfs_free(ni->attr_list_rl.rl);
+	ni->attr_list_rl.rl = NULL;
 	up_write(&ni->attr_list_rl.lock);
 
 	if (ni->name_len && ni->name != I30) {
diff --git a/fs/ntfs/logfile.c b/fs/ntfs/logfile.c
index c71de29..14a9e09 100644
--- a/fs/ntfs/logfile.c
+++ b/fs/ntfs/logfile.c
@@ -651,8 +651,7 @@ is_empty:
 	ntfs_debug("Done.");
 	return true;
 err_out:
-	if (rstr1_ph)
-		ntfs_free(rstr1_ph);
+	ntfs_free(rstr1_ph);
 	return false;
 }
 
diff --git a/fs/ntfs/runlist.c b/fs/ntfs/runlist.c
index eac7d67..98aaba9 100644
--- a/fs/ntfs/runlist.c
+++ b/fs/ntfs/runlist.c
@@ -1509,8 +1509,7 @@ int ntfs_rl_truncate_nolock(const ntfs_volume *vol, runlist *const runlist,
 	if (!new_length) {
 		ntfs_debug("Freeing runlist.");
 		runlist->rl = NULL;
-		if (rl)
-			ntfs_free(rl);
+		ntfs_free(rl);
 		return 0;
 	}
 	if (unlikely(!rl)) {
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index b52706d..03e1bf2 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2206,10 +2206,8 @@ iput_lcnbmp_err_out:
 	iput(vol->lcnbmp_ino);
 iput_attrdef_err_out:
 	vol->attrdef_size = 0;
-	if (vol->attrdef) {
-		ntfs_free(vol->attrdef);
-		vol->attrdef = NULL;
-	}
+	ntfs_free(vol->attrdef);
+	vol->attrdef = NULL;
 #ifdef NTFS_RW
 iput_upcase_err_out:
 #endif /* NTFS_RW */
@@ -2220,10 +2218,8 @@ iput_upcase_err_out:
 		vol->upcase = NULL;
 	}
 	mutex_unlock(&ntfs_lock);
-	if (vol->upcase) {
-		ntfs_free(vol->upcase);
-		vol->upcase = NULL;
-	}
+	ntfs_free(vol->upcase);
+	vol->upcase = NULL;
 iput_mftbmp_err_out:
 	iput(vol->mftbmp_ino);
 iput_mirr_err_out:
@@ -2389,10 +2385,8 @@ static void ntfs_put_super(struct super_block *sb)
 
 	/* Throw away the table of attribute definitions. */
 	vol->attrdef_size = 0;
-	if (vol->attrdef) {
-		ntfs_free(vol->attrdef);
-		vol->attrdef = NULL;
-	}
+	ntfs_free(vol->attrdef);
+	vol->attrdef = NULL;
 	vol->upcase_len = 0;
 	/*
 	 * Destroy the global default upcase table if necessary.  Also decrease
@@ -2410,10 +2404,8 @@ static void ntfs_put_super(struct super_block *sb)
 	if (vol->cluster_size <= 4096 && !--ntfs_nr_compression_users)
 		free_compression_buffers();
 	mutex_unlock(&ntfs_lock);
-	if (vol->upcase) {
-		ntfs_free(vol->upcase);
-		vol->upcase = NULL;
-	}
+	ntfs_free(vol->upcase);
+	vol->upcase = NULL;
 
 	unload_nls(vol->nls_map);
 
@@ -2983,10 +2975,8 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const int silent)
 #endif /* NTFS_RW */
 	/* Throw away the table of attribute definitions. */
 	vol->attrdef_size = 0;
-	if (vol->attrdef) {
-		ntfs_free(vol->attrdef);
-		vol->attrdef = NULL;
-	}
+	ntfs_free(vol->attrdef);
+	vol->attrdef = NULL;
 	vol->upcase_len = 0;
 	mutex_lock(&ntfs_lock);
 	if (vol->upcase == default_upcase) {
@@ -2994,10 +2984,8 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const int silent)
 		vol->upcase = NULL;
 	}
 	mutex_unlock(&ntfs_lock);
-	if (vol->upcase) {
-		ntfs_free(vol->upcase);
-		vol->upcase = NULL;
-	}
+	ntfs_free(vol->upcase);
+	vol->upcase = NULL;
 	if (vol->nls_map) {
 		unload_nls(vol->nls_map);
 		vol->nls_map = NULL;
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

