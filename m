Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab0GAVNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:13:20 -0400
Received: from kroah.org ([198.145.64.141]:33655 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758804Ab0GAVMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:12:47 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:47 2010
Message-Id: <20100701174247.109103770@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:41:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [008/200] VFS: fix recent breakage of FS_REVAL_DOT
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Brown <neilb@suse.de>

commit 176306f59ac7a35369cbba87aff13e14c5916074 upstream.

Commit 1f36f774b22a0ceb7dd33eca626746c81a97b6a5 broke FS_REVAL_DOT semantics.

In particular, before this patch, the command
   ls -l
in an NFS mounted directory would always check if the directory on the server
had changed and if so would flush and refill the pagecache for the dir.
After this patch, the same "ls -l" will repeatedly return stale date until
the cached attributes for the directory time out.

The following patch fixes this by ensuring the d_revalidate is called by
do_last when "." is being looked-up.
link_path_walk has already called d_revalidate, but in that case LOOKUP_OPEN
is not set so nfs_lookup_verify_inode chooses not to do any validation.

The following patch restores the original behaviour.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1620,6 +1620,7 @@ static struct file *do_last(struct namei
 	case LAST_DOTDOT:
 		follow_dotdot(nd);
 		dir = nd->path.dentry;
+	case LAST_DOT:
 		if (nd->path.mnt->mnt_sb->s_type->fs_flags & FS_REVAL_DOT) {
 			if (!dir->d_op->d_revalidate(dir, nd)) {
 				error = -ESTALE;
@@ -1627,7 +1628,6 @@ static struct file *do_last(struct namei
 			}
 		}
 		/* fallthrough */
-	case LAST_DOT:
 	case LAST_ROOT:
 		if (open_flag & O_CREAT)
 			goto exit;


