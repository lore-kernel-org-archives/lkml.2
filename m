Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab0JGRtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:49:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51850 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab0JGRtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:49:49 -0400
Date: Thu, 7 Oct 2010 18:49:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: aranym bug, manifests as "ida_remove called for id=13" on recent
 kernels
Message-ID: <20101007174948.GT19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	I've spent quite a while hunting that crap down; reverting VFS fix
mentioned in original thread *does* get rid of the symptoms, but so does the
patch below.

	What happens is this: if ->follow_link() (usually something like
stat("/proc/2/fd", ...) done by pidof(8)) return ERR_PTR(-....), we return
to __do_follow_link() and do the following:
        *p = dentry->d_inode->i_op->follow_link(dentry, nd);
        error = PTR_ERR(*p);
        if (!IS_ERR(*p)) {
                char *s = nd_get_link(nd);
                error = 0;
                if (s)
                        error = __vfs_follow_link(nd, s);
                else if (nd->last_type == LAST_BIND) {
                        error = force_reval_path(&nd->path, nd);
                        if (error)
                                path_put(&nd->path);
                }
        }
        return error;

We _should_ return non-zero value; IS_ERR(ERR_PTR(-n)) is 1 and
PTR_ERR(ERR_PTR(n)) is -n.  What happens instead is that this thing
actually returns 0.  And no, it's not a miscompile.  Patch below
removes the symptoms of the bug, but only if both parts are present.
I.e. *not* doing "report = 1" in proc_pid_follow_link() gives us
visible breakage, despite the fact that report is initialized as
1 and nothing except proc_pid_follow_link() ever tries to assign
anything to it.  Seeing that fs/namei.c and fs/proc/base.c are
compiled separately, we can exclude gcc problems.

The cheapest way to reproduce is to boot with init=/bin/sh, then
mount /proc and have stat("/proc/2/exe", &st) called; if stat()
returns 0, we are fscked.  The critical part is between return
from proc_exe_link() (we'll leave it via if (!mm) return -ENOENT;)
to return from __do_follow_link() -> do_follow_link() -> link_path_walk().

If somebody familiar with aranym guts are up to debugging that, more
power to them.  If I would've seen it on real hardware, I'd suspect
something weird going on with caches, but...

FWIW, it's observable on amd64 host; I haven't tried it on x86.  Version
of aranym is 0.9.6beta2-1 (one in lenny).  Have fun...

Patch [*NOT* for inclusion into mainline, obviously] follows:

diff --git a/fs/namei.c b/fs/namei.c
index 24896e8..da5bb7f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -524,6 +524,8 @@ static inline void path_to_nameidata(struct path *path, struct nameidata *nd)
 	nd->path.dentry = path->dentry;
 }
 
+int report = 1;
+
 static __always_inline int
 __do_follow_link(struct path *path, struct nameidata *nd, void **p)
 {
@@ -552,6 +554,8 @@ __do_follow_link(struct path *path, struct nameidata *nd, void **p)
 				path_put(&nd->path);
 		}
 	}
+	if (report && !error && IS_ERR(*p))
+		printk("fucked: %d %p\n", error, *p);
 	return error;
 }
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index a1c43e7..24579de 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1513,6 +1513,7 @@ static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
 		goto out;
 
 	error = PROC_I(inode)->op.proc_get_link(inode, &nd->path);
+	{extern int report; report = 1;}
 out:
 	return ERR_PTR(error);
 }
