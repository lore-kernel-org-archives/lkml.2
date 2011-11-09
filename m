Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1KJFDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:03:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42535 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934980Ab1KJD2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:28:40 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:13 2011
Message-Id: <20111109212713.777193003@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [131/262] VFS: Fix the remaining automounter semantics regressions
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 815d405ceff0d6964683f033e18b9b23a88fba87 upstream.

The concensus seems to be that system calls such as stat() etc should
not trigger an automount.  Neither should the l* versions.

This patch therefore adds a LOOKUP_AUTOMOUNT flag to tag those lookups
that _should_ trigger an automount on the last path element.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
[ Edited to leave out the cases that are already covered by LOOKUP_OPEN,
  LOOKUP_DIRECTORY and LOOKUP_CREATE - all of which also fundamentally
  force automounting for their own reasons   - Linus ]

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namespace.c   |    2 +-
 fs/nfs/super.c   |    2 +-
 fs/quota/quota.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1758,7 +1758,7 @@ static int do_loopback(struct path *path
 		return err;
 	if (!old_name || !*old_name)
 		return -EINVAL;
-	err = kern_path(old_name, LOOKUP_FOLLOW, &old_path);
+	err = kern_path(old_name, LOOKUP_FOLLOW|LOOKUP_AUTOMOUNT, &old_path);
 	if (err)
 		return err;
 
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2793,7 +2793,7 @@ static struct dentry *nfs_follow_remote_
 		goto out_put_mnt_ns;
 
 	ret = vfs_path_lookup(root_mnt->mnt_root, root_mnt,
-			export_path, LOOKUP_FOLLOW, nd);
+			export_path, LOOKUP_FOLLOW|LOOKUP_AUTOMOUNT, nd);
 
 	nfs_referral_loop_unprotect();
 	put_mnt_ns(ns_private);
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -355,7 +355,7 @@ SYSCALL_DEFINE4(quotactl, unsigned int,
 	 * resolution (think about autofs) and thus deadlocks could arise.
 	 */
 	if (cmds == Q_QUOTAON) {
-		ret = user_path_at(AT_FDCWD, addr, LOOKUP_FOLLOW, &path);
+		ret = user_path_at(AT_FDCWD, addr, LOOKUP_FOLLOW|LOOKUP_AUTOMOUNT, &path);
 		if (ret)
 			pathp = ERR_PTR(ret);
 		else


