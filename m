Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab0DVTjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:39:00 -0400
Received: from kroah.org ([198.145.64.141]:41427 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756815Ab0DVT3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:37 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:21 2010
Message-Id: <20100422190921.044113426@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Mahoney <jeffm@suse.com>, Dustin Kirkland <kirkland@canonical.com>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [153/197] ecryptfs: fix use with tmpfs by removing d_drop from ecryptfs_destroy_inode
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Mahoney <jeffm@jeffreymahoney.com>

commit 133b8f9d632cc23715c6d72d1c5ac449e054a12a upstream.

Since tmpfs has no persistent storage, it pins all its dentries in memory
so they have d_count=1 when other file systems would have d_count=0.
->lookup is only used to create new dentries. If the caller doesn't
instantiate it, it's freed immediately at dput(). ->readdir reads
directly from the dcache and depends on the dentries being hashed.

When an ecryptfs mount is mounted, it associates the lower file and dentry
with the ecryptfs files as they're accessed. When it's umounted and
destroys all the in-memory ecryptfs inodes, it fput's the lower_files and
d_drop's the lower_dentries. Commit 4981e081 added this and a d_delete in
2008 and several months later commit caeeeecf removed the d_delete. I
believe the d_drop() needs to be removed as well.

The d_drop effectively hides any file that has been accessed via ecryptfs
from the underlying tmpfs since it depends on it being hashed for it to
be accessible. I've removed the d_drop on my development node and see no
ill effects with basic testing on both tmpfs and persistent storage.

As a side effect, after ecryptfs d_drops the dentries on tmpfs, tmpfs
BUGs on umount. This is due to the dentries being unhashed.
tmpfs->kill_sb is kill_litter_super which calls d_genocide to drop
the reference pinning the dentry. It skips unhashed and negative dentries,
but shrink_dcache_for_umount_subtree doesn't. Since those dentries
still have an elevated d_count, we get a BUG().

This patch removes the d_drop call and fixes both issues.

This issue was reported at:
https://bugzilla.novell.com/show_bug.cgi?id=567887

Reported-by:  Árpád Bíró <biroa@demasz.hu>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Dustin Kirkland <kirkland@canonical.com>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/super.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ecryptfs/super.c
+++ b/fs/ecryptfs/super.c
@@ -85,7 +85,6 @@ static void ecryptfs_destroy_inode(struc
 		if (lower_dentry->d_inode) {
 			fput(inode_info->lower_file);
 			inode_info->lower_file = NULL;
-			d_drop(lower_dentry);
 		}
 	}
 	ecryptfs_destroy_crypt_stat(&inode_info->crypt_stat);


