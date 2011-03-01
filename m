Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab1CAFHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:07:01 -0500
Received: from outbound.icp-qv1-irony-out5.iinet.net.au ([203.59.1.105]:49157
	"EHLO outbound.icp-qv1-irony-out5.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754379Ab1CAFG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:06:59 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAC8LbE18qV3C/2dsb2JhbACEJ6IjdKolkHSBJ4NEdgSFEIpnggM
X-IronPort-AV: E=Sophos;i="4.62,245,1297008000"; 
   d="scan'208";a="246289296"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 1/4] vfs - check non-mountpoint dentry might block in
 __follow_mount_rcu()
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Nick Piggin <npiggin@gmail.com>, David Howells <dhowells@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 01 Mar 2011 12:56:57 +0800
Message-ID: <20110301045657.4615.79048.stgit@localhost6.localdomain6>
In-Reply-To: <20110301044457.4615.40333.stgit@localhost6.localdomain6>
References: <20110301044457.4615.40333.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When following a mount in rcu-walk mode we must check if the incoming dentry
is telling us it may need to block, even if it isn't actually a mountpoint.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/namei.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 0087cf9..a0f2179 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1022,6 +1022,14 @@ int follow_down_one(struct path *path)
 	return 0;
 }
 
+static bool managed_dentry_might_block(struct dentry *dentry)
+{
+	if (dentry->d_flags & DCACHE_MANAGE_TRANSIT &&
+	    dentry->d_op->d_manage(dentry, false, true) < 0)
+		return true;
+	return false;
+}
+
 /*
  * Skip to top of mountpoint pile in rcuwalk mode.  We abort the rcu-walk if we
  * meet a managed dentry and we're not walking to "..".  True is returned to
@@ -1030,12 +1038,17 @@ int follow_down_one(struct path *path)
 static bool __follow_mount_rcu(struct nameidata *nd, struct path *path,
 			       struct inode **inode, bool reverse_transit)
 {
+	/*
+	 * Don't forgat we might have a non-mountpoint managed dentry
+	 * that wants to block transit.
+	 */
+	*inode = path->dentry->d_inode;
+	if (!reverse_transit &&
+	     unlikely(managed_dentry_might_block(path->dentry)))
+		return false;
+
 	while (d_mountpoint(path->dentry)) {
 		struct vfsmount *mounted;
-		if (unlikely(path->dentry->d_flags & DCACHE_MANAGE_TRANSIT) &&
-		    !reverse_transit &&
-		    path->dentry->d_op->d_manage(path->dentry, false, true) < 0)
-			return false;
 		mounted = __lookup_mnt(path->mnt, path->dentry, 1);
 		if (!mounted)
 			break;
@@ -1043,6 +1056,9 @@ static bool __follow_mount_rcu(struct nameidata *nd, struct path *path,
 		path->dentry = mounted->mnt_root;
 		nd->seq = read_seqcount_begin(&path->dentry->d_seq);
 		*inode = path->dentry->d_inode;
+		if (!reverse_transit &&
+		    unlikely(managed_dentry_might_block(path->dentry)))
+			return false;
 	}
 
 	if (unlikely(path->dentry->d_flags & DCACHE_NEED_AUTOMOUNT))

