Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab0GGMZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 08:25:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014Ab0GGMZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 08:25:15 -0400
Date: Wed, 7 Jul 2010 22:25:10 +1000
From: Nick Piggin <npiggin@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
       Frank Mayhar <fmayhar@google.com>, John Stultz <johnstul@us.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 2/2] tty fix fu_list abuse
Message-ID: <20100707122510.GM11732@laptop>
References: <20100707122406.GL11732@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707122406.GL11732@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty: fix fu_list abuse

tty code abuses fu_list, which causes a bug in remount,ro handling.

If a tty device node is opened on a filesystem, then the name unlinked, the
filesystem will be allowed to be remounted readonly. This is because
fs_may_remount_ro does not find the 0 link tty inode on the file sb list
(because the tty code incorrectly removed it to use for its own purpose). This
can result in a filesystem with errors after it is marked "clean".  So add a
new private list for ttys and leave tty files on the sb list so they are caught
by this check. This makes tty nodes behave the same way as other device nodes.

The next step is to allocate a tty private structure at private_data and get
rid of f_ttyonly_list, but the error handling is not trivial in the tty code.
Hence this intermediate step.

[ Arguably on-disk device inode would not be referenced by driver's pseudo
inode once it is open, but in practice it's not clear whether that will ever
be worth implementing. ]

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 drivers/char/pty.c       |    3 +--
 drivers/char/tty_io.c    |    9 +++------
 fs/internal.h            |    2 ++
 include/linux/fs.h       |    3 +--
 security/selinux/hooks.c |    3 ++-
 5 files changed, 9 insertions(+), 11 deletions(-)

Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -939,6 +939,7 @@ struct file {
 #endif
 	/* needed for tty driver, and maybe others */
 	void			*private_data;
+	struct list_head	f_ttyonly_list; /* No new users! */
 
 #ifdef CONFIG_EPOLL
 	/* Used by fs/eventpoll.c to link all the hooks to this file */
@@ -2179,8 +2180,6 @@ static inline void insert_inode_hash(str
 	__insert_inode_hash(inode, inode->i_ino);
 }
 
-extern void file_sb_list_add(struct file *f, struct super_block *sb);
-extern void file_sb_list_del(struct file *f);
 #ifdef CONFIG_BLOCK
 struct bio;
 extern void submit_bio(int, struct bio *);
Index: linux-2.6/drivers/char/pty.c
===================================================================
--- linux-2.6.orig/drivers/char/pty.c
+++ linux-2.6/drivers/char/pty.c
@@ -651,9 +651,8 @@ static int __ptmx_open(struct inode *ino
 	set_bit(TTY_PTY_LOCK, &tty->flags); /* LOCK THE SLAVE */
 	filp->private_data = tty;
 
-	file_sb_list_del(filp); /* __dentry_open has put it on the sb list */
 	spin_lock(&tty_files_lock);
-	list_add(&filp->f_u.fu_list, &tty->tty_files);
+	list_add(&filp->f_ttyonly_list, &tty->tty_files);
 	spin_unlock(&tty_files_lock);
 
 	retval = devpts_pty_new(inode, tty->link);
Index: linux-2.6/drivers/char/tty_io.c
===================================================================
--- linux-2.6.orig/drivers/char/tty_io.c
+++ linux-2.6/drivers/char/tty_io.c
@@ -522,7 +522,7 @@ static void do_tty_hangup(struct work_st
 
 	spin_lock(&tty_files_lock);
 	/* This breaks for file handles being sent over AF_UNIX sockets ? */
-	list_for_each_entry(filp, &tty->tty_files, f_u.fu_list) {
+	list_for_each_entry(filp, &tty->tty_files, f_ttyonly_list) {
 		if (filp->f_op->write == redirected_tty_write)
 			cons_filp = filp;
 		if (filp->f_op->write != tty_write)
@@ -1670,8 +1670,7 @@ int tty_release(struct inode *inode, str
 	 *    something that needs to be handled for hangups.
 	 */
 	spin_lock(&tty_files_lock);
-	BUG_ON(list_empty(&filp->f_u.fu_list));
-	list_del_init(&filp->f_u.fu_list);
+	list_del(&filp->f_ttyonly_list);
 	spin_unlock(&tty_files_lock);
 	filp->private_data = NULL;
 
@@ -1841,10 +1840,8 @@ got_driver:
 	}
 
 	filp->private_data = tty;
-	BUG_ON(list_empty(&filp->f_u.fu_list));
-	file_sb_list_del(filp); /* __dentry_open has put it on the sb list */
 	spin_lock(&tty_files_lock);
-	list_add(&filp->f_u.fu_list, &tty->tty_files);
+	list_add(&filp->f_ttyonly_list, &tty->tty_files);
 	spin_unlock(&tty_files_lock);
 	check_tty_count(tty, "tty_open");
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c
+++ linux-2.6/security/selinux/hooks.c
@@ -2228,7 +2228,8 @@ static inline void flush_unauthorized_fi
 			   than using file_has_perm, as this particular open
 			   file may belong to another process and we are only
 			   interested in the inode-based check here. */
-			file = list_first_entry(&tty->tty_files, struct file, f_u.fu_list);
+			file = list_first_entry(&tty->tty_files,
+					struct file, f_ttyonly_list);
 			inode = file->f_path.dentry->d_inode;
 			if (inode_has_perm(cred, inode,
 					   FILE__READ | FILE__WRITE, NULL)) {
Index: linux-2.6/fs/internal.h
===================================================================
--- linux-2.6.orig/fs/internal.h
+++ linux-2.6/fs/internal.h
@@ -80,6 +80,8 @@ extern void chroot_fs_refs(struct path *
 /*
  * file_table.c
  */
+extern void file_sb_list_add(struct file *f, struct super_block *sb);
+extern void file_sb_list_del(struct file *f);
 extern void mark_files_ro(struct super_block *);
 extern struct file *get_empty_filp(void);
 
