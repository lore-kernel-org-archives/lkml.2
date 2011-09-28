Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab1I1WoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:44:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54262 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911Ab1I1Wn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:43:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:35 2011
Message-Id: <20110928220135.572017891@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [097/244] fs/9p: Always ask new inode in lookup for cache mode disabled
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

commit 73f507171cfa407b19f254aef95cbb058c8180cf upstream.

This make sure we don't end up reusing the unlinked inode object.
The ideal way is to use inode i_generation. But i_generation is
not available in userspace always.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/9p/vfs_inode.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -799,6 +799,7 @@ static int v9fs_vfs_mkdir(struct inode *
 struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 				      struct nameidata *nameidata)
 {
+	struct dentry *res;
 	struct super_block *sb;
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *dfid, *fid;
@@ -830,22 +831,35 @@ struct dentry *v9fs_vfs_lookup(struct in
 
 		return ERR_PTR(result);
 	}
-
-	inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb);
+	/*
+	 * Make sure we don't use a wrong inode due to parallel
+	 * unlink. For cached mode create calls request for new
+	 * inode. But with cache disabled, lookup should do this.
+	 */
+	if (v9ses->cache)
+		inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb);
+	else
+		inode = v9fs_get_new_inode_from_fid(v9ses, fid, dir->i_sb);
 	if (IS_ERR(inode)) {
 		result = PTR_ERR(inode);
 		inode = NULL;
 		goto error;
 	}
-
 	result = v9fs_fid_add(dentry, fid);
 	if (result < 0)
 		goto error_iput;
-
 inst_out:
-	d_add(dentry, inode);
-	return NULL;
-
+	/*
+	 * If we had a rename on the server and a parallel lookup
+	 * for the new name, then make sure we instantiate with
+	 * the new name. ie look up for a/b, while on server somebody
+	 * moved b under k and client parallely did a lookup for
+	 * k/b.
+	 */
+	res = d_materialise_unique(dentry, inode);
+	if (!IS_ERR(res))
+		return res;
+	result = PTR_ERR(res);
 error_iput:
 	iput(inode);
 error:


