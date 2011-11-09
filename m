Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935488Ab1KJDcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:32:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935461Ab1KJDc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:32:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:23 2011
Message-Id: <20111109212723.626968174@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:29:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: [229/262] VFS: we need to set LOOKUP_JUMPED on mountpoint crossing
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit a3fbbde70a0cec017f2431e8f8de208708c76acc upstream.

Mountpoint crossing is similar to following procfs symlinks - we do
not get ->d_revalidate() called for dentry we have arrived at, with
unpleasant consequences for NFS4.

Simple way to reproduce the problem in mainline:

    cat >/tmp/a.c <<'EOF'
    #include <unistd.h>
    #include <fcntl.h>
    #include <stdio.h>
    main()
    {
            struct flock fl = {.l_type = F_RDLCK, .l_whence = SEEK_SET, .l_len = 1};
            if (fcntl(0, F_SETLK, &fl))
                    perror("setlk");
    }
    EOF
    cc /tmp/a.c -o /tmp/test

then on nfs4:

    mount --bind file1 file2
    /tmp/test < file1		# ok
    /tmp/test < file2		# spews "setlk: No locks available"...

What happens is the missing call of ->d_revalidate() after mountpoint
crossing and that's where NFS4 would issue OPEN request to server.

The fix is simple - treat mountpoint crossing the same way we deal with
following procfs-style symlinks.  I.e.  set LOOKUP_JUMPED...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namei.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -910,7 +910,7 @@ static int follow_managed(struct path *p
 		mntput(path->mnt);
 	if (ret == -EISDIR)
 		ret = 0;
-	return ret;
+	return ret < 0 ? ret : need_mntput;
 }
 
 int follow_down_one(struct path *path)
@@ -958,6 +958,7 @@ static bool __follow_mount_rcu(struct na
 			break;
 		path->mnt = mounted;
 		path->dentry = mounted->mnt_root;
+		nd->flags |= LOOKUP_JUMPED;
 		nd->seq = read_seqcount_begin(&path->dentry->d_seq);
 		/*
 		 * Update the inode too. We don't need to re-check the
@@ -1232,6 +1233,8 @@ retry:
 		path_put_conditional(path, nd);
 		return err;
 	}
+	if (err)
+		nd->flags |= LOOKUP_JUMPED;
 	*inode = path->dentry->d_inode;
 	return 0;
 }
@@ -2118,6 +2121,10 @@ static struct file *do_last(struct namei
 	}
 
 	/* create side of things */
+	/*
+	 * This will *only* deal with leaving RCU mode - LOOKUP_JUMPED has been
+	 * cleared when we got to the last component we are about to look up
+	 */
 	error = complete_walk(nd);
 	if (error)
 		return ERR_PTR(error);
@@ -2186,6 +2193,9 @@ static struct file *do_last(struct namei
 	if (error < 0)
 		goto exit_dput;
 
+	if (error)
+		nd->flags |= LOOKUP_JUMPED;
+
 	error = -ENOENT;
 	if (!path->dentry->d_inode)
 		goto exit_dput;
@@ -2195,6 +2205,10 @@ static struct file *do_last(struct namei
 
 	path_to_nameidata(path, nd);
 	nd->inode = path->dentry->d_inode;
+	/* Why this, you ask?  _Now_ we might have grown LOOKUP_JUMPED... */
+	error = complete_walk(nd);
+	if (error)
+		goto exit;
 	error = -EISDIR;
 	if (S_ISDIR(nd->inode->i_mode))
 		goto exit;


