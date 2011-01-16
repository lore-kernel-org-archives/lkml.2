Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1APVgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 16:36:54 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59812 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab1APVgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 16:36:53 -0500
Date: Sun, 16 Jan 2011 21:36:50 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Joachim Eastwood <manabian@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs pile 2 (automount work)
Message-ID: <20110116213650.GC22723@ZenIV.linux.org.uk>
References: <20110116185745.GB22723@ZenIV.linux.org.uk>
 <AANLkTim1SS2Y1EL9iB2jDSUbqofoaWXig-xHa12Ogm95@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim1SS2Y1EL9iB2jDSUbqofoaWXig-xHa12Ogm95@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 10:15:31PM +0100, Joachim Eastwood wrote:
> Hi,
> 
> On 1/16/11, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > Al Viro (3):
> >       sanitize vfsmount refcounting changes
> 
> f03c65993b98eeb909a4012ce7833c5857d74755 - sanitize vfsmount refcounting changes
> 
> Breaks my ARM !CONFIG_SMP compile
> 
>   CC      fs/namespace.o
> fs/namespace.c: In function 'commit_tree':
> fs/namespace.c:629: error: 'struct vfsmount' has no member named 'mnt_longterm'
> fs/namespace.c: In function 'umount_tree':
> fs/namespace.c:1192: error: 'struct vfsmount' has no member named 'mnt_longterm'
> fs/namespace.c: In function 'mnt_make_longterm':
> fs/namespace.c:2246: error: 'struct vfsmount' has no member named 'mnt_longterm'
> fs/namespace.c: In function 'mnt_make_shortterm':
> fs/namespace.c:2251: error: 'struct vfsmount' has no member named 'mnt_longterm'
> fs/namespace.c:2254: error: 'struct vfsmount' has no member named 'mnt_longterm'
> fs/namespace.c: In function 'dup_mnt_ns':
> fs/namespace.c:2295: error: 'struct vfsmount' has no member named 'mnt_longterm'
> fs/namespace.c:2299: error: 'struct vfsmount' has no member named 'mnt_longterm'
> fs/namespace.c:2305: error: 'struct vfsmount' has no member named 'mnt_longterm'
> fs/namespace.c: In function 'create_mnt_ns':
> fs/namespace.c:2351: error: 'struct vfsmount' has no member named 'mnt_longterm'

Aaaaargh... Brown paperbag time - all testing was on SMP boxen ;-/  The fix
follows.  Linus, I've dropped that into for-linus in usual place
(git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/), so if you
prefer to pull it, it's there.

commit 91ed228ab50daa7aca54faa8bf5208b97e3448b8
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sun Jan 16 16:32:11 2011 -0500

    mnt_longterm is there only on SMP
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/fs/namespace.c b/fs/namespace.c
index 48809e2..9f544f3 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -611,6 +611,21 @@ static void attach_mnt(struct vfsmount *mnt, struct path *path)
 	list_add_tail(&mnt->mnt_child, &path->mnt->mnt_mounts);
 }
 
+static inline void __mnt_make_longterm(struct vfsmount *mnt)
+{
+#ifdef CONFIG_SMP
+	atomic_inc(&mnt->mnt_longterm);
+#endif
+}
+
+/* needs vfsmount lock for write */
+static inline void __mnt_make_shortterm(struct vfsmount *mnt)
+{
+#ifdef CONFIG_SMP
+	atomic_dec(&mnt->mnt_longterm);
+#endif
+}
+
 /*
  * vfsmount lock must be held for write
  */
@@ -626,7 +641,7 @@ static void commit_tree(struct vfsmount *mnt)
 	list_add_tail(&head, &mnt->mnt_list);
 	list_for_each_entry(m, &head, mnt_list) {
 		m->mnt_ns = n;
-		atomic_inc(&m->mnt_longterm);
+		__mnt_make_longterm(m);
 	}
 
 	list_splice(&head, n->list.prev);
@@ -1189,7 +1204,7 @@ void umount_tree(struct vfsmount *mnt, int propagate, struct list_head *kill)
 		list_del_init(&p->mnt_list);
 		__touch_mnt_namespace(p->mnt_ns);
 		p->mnt_ns = NULL;
-		atomic_dec(&p->mnt_longterm);
+		__mnt_make_shortterm(p);
 		list_del_init(&p->mnt_child);
 		if (p->mnt_parent != p) {
 			p->mnt_parent->mnt_ghosts++;
@@ -2243,16 +2258,18 @@ static struct mnt_namespace *alloc_mnt_ns(void)
 
 void mnt_make_longterm(struct vfsmount *mnt)
 {
-	atomic_inc(&mnt->mnt_longterm);
+	__mnt_make_longterm(mnt);
 }
 
 void mnt_make_shortterm(struct vfsmount *mnt)
 {
+#ifdef CONFIG_SMP
 	if (atomic_add_unless(&mnt->mnt_longterm, -1, 1))
 		return;
 	br_write_lock(vfsmount_lock);
 	atomic_dec(&mnt->mnt_longterm);
 	br_write_unlock(vfsmount_lock);
+#endif
 }
 
 /*
@@ -2292,17 +2309,17 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
 	q = new_ns->root;
 	while (p) {
 		q->mnt_ns = new_ns;
-		atomic_inc(&q->mnt_longterm);
+		__mnt_make_longterm(q);
 		if (fs) {
 			if (p == fs->root.mnt) {
 				fs->root.mnt = mntget(q);
-				atomic_inc(&q->mnt_longterm);
+				__mnt_make_longterm(q);
 				mnt_make_shortterm(p);
 				rootmnt = p;
 			}
 			if (p == fs->pwd.mnt) {
 				fs->pwd.mnt = mntget(q);
-				atomic_inc(&q->mnt_longterm);
+				__mnt_make_longterm(q);
 				mnt_make_shortterm(p);
 				pwdmnt = p;
 			}
@@ -2348,7 +2365,7 @@ struct mnt_namespace *create_mnt_ns(struct vfsmount *mnt)
 	new_ns = alloc_mnt_ns();
 	if (!IS_ERR(new_ns)) {
 		mnt->mnt_ns = new_ns;
-		atomic_inc(&mnt->mnt_longterm);
+		__mnt_make_longterm(mnt);
 		new_ns->root = mnt;
 		list_add(&new_ns->list, &new_ns->root->mnt_list);
 	}
