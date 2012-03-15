Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032063Ab2COSjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:39:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44304 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031532Ab2COSjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:39:42 -0400
Date: Thu, 15 Mar 2012 18:39:40 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch 0/5] seqlock consolidation
Message-ID: <20120315183940.GE8943@ZenIV.linux.org.uk>
References: <20120314170736.617746873@linutronix.de>
 <20120315122112.GB8943@ZenIV.linux.org.uk>
 <alpine.LFD.2.02.1203151322020.2466@ionos>
 <20120315174305.GD8943@ZenIV.linux.org.uk>
 <alpine.LFD.2.02.1203151854110.2466@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1203151854110.2466@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 06:55:18PM +0100, Thomas Gleixner wrote:
> > If that's it, I suggest to look for a solution that would express just that...
> > Or do you want something on the reader side as well?
> 
> The problem is the reader side. If the reader preempts the writer then
> the only way to make progress is to take the lock, but therefor I need
> to know which lock I should take.

So just make writers non-preemptable in those sections.  Really, the
worst non-deterministic behaviour you get for d_seq ones is memcpy()
of up to ->d_name.len bytes.  And on the fs_struct side it's trivial
to reduce the work done in those sections to several comparisons and
assignments.  Not even path_get_longterm() needs to be there - see
below for how it can be done:

diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index 78b519c..f5818c4 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -26,11 +26,11 @@ void set_fs_root(struct fs_struct *fs, struct path *path)
 {
 	struct path old_root;
 
+	path_get_longterm(path);
 	spin_lock(&fs->lock);
 	write_seqcount_begin(&fs->seq);
 	old_root = fs->root;
 	fs->root = *path;
-	path_get_longterm(path);
 	write_seqcount_end(&fs->seq);
 	spin_unlock(&fs->lock);
 	if (old_root.dentry)
@@ -45,11 +45,11 @@ void set_fs_pwd(struct fs_struct *fs, struct path *path)
 {
 	struct path old_pwd;
 
+	path_get_longterm(path);
 	spin_lock(&fs->lock);
 	write_seqcount_begin(&fs->seq);
 	old_pwd = fs->pwd;
 	fs->pwd = *path;
-	path_get_longterm(path);
 	write_seqcount_end(&fs->seq);
 	spin_unlock(&fs->lock);
 
@@ -57,6 +57,14 @@ void set_fs_pwd(struct fs_struct *fs, struct path *path)
 		path_put_longterm(&old_pwd);
 }
 
+static inline int replace_path(struct path *p, const struct path *old, const struct path *new)
+{
+	if (likely(p->dentry != old->dentry || p->mnt != old->mnt))
+		return 0;
+	*p = *new;
+	return 1;
+}
+
 void chroot_fs_refs(struct path *old_root, struct path *new_root)
 {
 	struct task_struct *g, *p;
@@ -68,21 +76,16 @@ void chroot_fs_refs(struct path *old_root, struct path *new_root)
 		task_lock(p);
 		fs = p->fs;
 		if (fs) {
+			int hits = 0;
 			spin_lock(&fs->lock);
 			write_seqcount_begin(&fs->seq);
-			if (fs->root.dentry == old_root->dentry
-			    && fs->root.mnt == old_root->mnt) {
-				path_get_longterm(new_root);
-				fs->root = *new_root;
+			hits += replace_path(&fs->root, old_root, new_root);
+			hits += replace_path(&fs->pwd, old_root, new_root);
+			write_seqcount_end(&fs->seq);
+			while (hits--) {
 				count++;
-			}
-			if (fs->pwd.dentry == old_root->dentry
-			    && fs->pwd.mnt == old_root->mnt) {
 				path_get_longterm(new_root);
-				fs->pwd = *new_root;
-				count++;
 			}
-			write_seqcount_end(&fs->seq);
 			spin_unlock(&fs->lock);
 		}
 		task_unlock(p);
