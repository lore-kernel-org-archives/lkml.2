Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab1CAFGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:06:49 -0500
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.104]:29594
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752069Ab1CAFGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:06:48 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKYLbE18qV3C/2dsb2JhbACEJ6IjdKookHSBJ4NEdgSFEIpn
X-IronPort-AV: E=Sophos;i="4.62,245,1297008000"; 
   d="scan'208";a="637553983"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 2/4] autofs4 - fix rootless multi-mount race
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Nick Piggin <npiggin@gmail.com>, David Howells <dhowells@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 01 Mar 2011 12:57:07 +0800
Message-ID: <20110301045707.4615.87450.stgit@localhost6.localdomain6>
In-Reply-To: <20110301044457.4615.40333.stgit@localhost6.localdomain6>
References: <20110301044457.4615.40333.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there is no mount at the base of a mount tree (rootless multi-mount)
there is a small amount of time when both DCACHE_MANAGE_TRANSIT and
DCACHE_NEED_AUTOMOUNT are clear. This occassionally alows a process
to pass instead of bock leading to an incorrect fail return. Keeping
the DCACHE_MANAGE_TRANSIT set all the time resolves the problem.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/expire.c |   13 ++-----------
 fs/autofs4/root.c   |   20 ++++----------------
 2 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index f43100b..c896dd6 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -294,7 +294,6 @@ struct dentry *autofs4_expire_direct(struct super_block *sb,
 		spin_unlock(&sbi->fs_lock);
 		return NULL;
 	}
-	managed_dentry_set_transit(root);
 	if (!autofs4_direct_busy(mnt, root, timeout, do_now)) {
 		struct autofs_info *ino = autofs4_dentry_ino(root);
 		ino->flags |= AUTOFS_INF_EXPIRING;
@@ -302,7 +301,6 @@ struct dentry *autofs4_expire_direct(struct super_block *sb,
 		spin_unlock(&sbi->fs_lock);
 		return root;
 	}
-	managed_dentry_clear_transit(root);
 	spin_unlock(&sbi->fs_lock);
 	dput(root);
 
@@ -341,8 +339,7 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 		ino = autofs4_dentry_ino(dentry);
 		/* No point expiring a pending mount */
 		if (ino->flags & AUTOFS_INF_PENDING)
-			goto cont;
-		managed_dentry_set_transit(dentry);
+			goto next;
 
 		/*
 		 * Case 1: (i) indirect mount or top level pseudo direct mount
@@ -402,8 +399,6 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 			}
 		}
 next:
-		managed_dentry_clear_transit(dentry);
-cont:
 		spin_unlock(&sbi->fs_lock);
 	}
 	return NULL;
@@ -484,8 +479,6 @@ int autofs4_expire_run(struct super_block *sb,
 	spin_lock(&sbi->fs_lock);
 	ino = autofs4_dentry_ino(dentry);
 	ino->flags &= ~AUTOFS_INF_EXPIRING;
-	if (!d_unhashed(dentry))
-		managed_dentry_clear_transit(dentry);
 	complete_all(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
 
@@ -513,9 +506,7 @@ int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 		spin_lock(&sbi->fs_lock);
 		ino->flags &= ~AUTOFS_INF_EXPIRING;
 		spin_lock(&dentry->d_lock);
-		if (ret)
-			__managed_dentry_clear_transit(dentry);
-		else {
+		if (!ret) {
 			if ((IS_ROOT(dentry) ||
 			    (autofs_type_indirect(sbi->type) &&
 			     IS_ROOT(dentry->d_parent))) &&
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 014e7ab..ad11a44 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -338,18 +338,6 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
 	DPRINTK("dentry=%p %.*s",
 		dentry, dentry->d_name.len, dentry->d_name.name);
 
-	/*
-	 * Someone may have manually umounted this or it was a submount
-	 * that has gone away.
-	 */
-	spin_lock(&dentry->d_lock);
-	if (!d_mountpoint(dentry) && list_empty(&dentry->d_subdirs)) {
-		if (!(dentry->d_flags & DCACHE_MANAGE_TRANSIT) &&
-		     (dentry->d_flags & DCACHE_NEED_AUTOMOUNT))
-			__managed_dentry_set_transit(path->dentry);
-	}
-	spin_unlock(&dentry->d_lock);
-
 	/* The daemon never triggers a mount. */
 	if (autofs4_oz_mode(sbi))
 		return NULL;
@@ -418,12 +406,12 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
 done:
 	if (!(ino->flags & AUTOFS_INF_EXPIRING)) {
 		/*
-		 * Any needed mounting has been completed and the path updated
-		 * so turn this into a normal dentry so we don't continually
-		 * call ->d_automount() and ->d_manage().
+		 * Any needed mounting has been completed and the path
+		 * updated so clear DCACHE_NEED_AUTOMOUNT so we don't
+		 * call ->d_automount() on rootless multi-mounts since
+		 * it can lead to an incorrect ELOOP error return.
 		 */
 		spin_lock(&dentry->d_lock);
-		__managed_dentry_clear_transit(dentry);
 		/*
 		 * Only clear DMANAGED_AUTOMOUNT for rootless multi-mounts and
 		 * symlinks as in all other cases the dentry will be covered by

