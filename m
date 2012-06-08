Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab2FHAgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:36:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42716 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537Ab2FHAgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:36:11 -0400
Date: Fri, 8 Jun 2012 01:36:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>, Sage Weil <sage@newdream.net>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120608003604.GK30000@ZenIV.linux.org.uk>
References: <20120606230040.GA18089@redhat.com>
 <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk>
 <20120607002914.GB22223@redhat.com>
 <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
 <20120607011915.GA17566@redhat.com>
 <20120607012900.GE30000@ZenIV.linux.org.uk>
 <20120607193607.GI30000@ZenIV.linux.org.uk>
 <873966n2c2.fsf@xmission.com>
 <CA+55aFxxS3+NmZacr76qNmEu9=-=aw61gW1Ebugg8hdMNgKiJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxxS3+NmZacr76qNmEu9=-=aw61gW1Ebugg8hdMNgKiJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 04:57:13PM -0700, Linus Torvalds wrote:

> Any per-filesystem mutex should do, so if sysfs always holds the
> sysfs_mutex - and never allows user-initiated renames - it should be
> safe.

Frankly, I would very much prefer to have the same locking rules wherever
possible.  The locking system is already overcomplicated and making its
analysis fs-dependent as well... <shudder>  Sure, we can do that, and that
might even work, until we find out that some piece of code that started
as a helper to some function never called on sysfs dentries had been
reused on the path that *is* reachable on sysfs.  At which point we are
suddenly in trouble.

I wouldn't be bothered so much if the overall picture had been simpler;
unfortunately, it isn't.

Eric, how about this - if nothing else, that makes code in there simpler
and less dependent on details of VFS guts:

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index e6bb9b2..5579826 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -363,7 +363,7 @@ static void sysfs_dentry_iput(struct dentry *dentry, struct inode *inode)
 	iput(inode);
 }
 
-static const struct dentry_operations sysfs_dentry_ops = {
+const struct dentry_operations sysfs_dentry_ops = {
 	.d_revalidate	= sysfs_dentry_revalidate,
 	.d_delete	= sysfs_dentry_delete,
 	.d_iput		= sysfs_dentry_iput,
@@ -795,16 +795,8 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 	}
 
 	/* instantiate and hash dentry */
-	ret = d_find_alias(inode);
-	if (!ret) {
-		d_set_d_op(dentry, &sysfs_dentry_ops);
-		dentry->d_fsdata = sysfs_get(sd);
-		d_add(dentry, inode);
-	} else {
-		d_move(ret, dentry);
-		iput(inode);
-	}
-
+	dentry->d_fsdata = sysfs_get(sd);
+	ret = d_materialise_unique(dentry, inode);
  out_unlock:
 	mutex_unlock(&sysfs_mutex);
 	return ret;
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 52c3bdb..c15a7a3 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -68,6 +68,7 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	root->d_fsdata = &sysfs_root;
 	sb->s_root = root;
+	sb->s_d_op = &sysfs_dentry_ops;
 	return 0;
 }
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 661a963..d73c093 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -157,6 +157,7 @@ extern struct kmem_cache *sysfs_dir_cachep;
  */
 extern struct mutex sysfs_mutex;
 extern spinlock_t sysfs_assoc_lock;
+extern const struct dentry_operations sysfs_dentry_ops;
 
 extern const struct file_operations sysfs_dir_operations;
 extern const struct inode_operations sysfs_dir_inode_operations;
