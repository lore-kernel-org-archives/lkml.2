Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab0FSTL4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 15:11:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622Ab0FSTLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 15:11:54 -0400
Date: Sat, 19 Jun 2010 21:10:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] procfs: kill the global proc_mnt variable
Message-ID: <20100619191002.GC3424@redhat.com>
References: <1276706068-18567-1-git-send-email-louis.rilling@kerlabs.com> <20100617212003.GA4182@redhat.com> <20100618082033.GD16877@hawkmoon.kerlabs.com> <20100618111554.GA3252@redhat.com> <20100618160849.GA7404@redhat.com> <20100618173320.GG16877@hawkmoon.kerlabs.com> <20100618175541.GA13680@redhat.com> <20100618212355.GA29478@redhat.com> <20100619190840.GA3424@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100619190840.GA3424@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the previous cleanup in proc_get_sb() the global proc_mnt has
no reasons to exists, kill it.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/proc/internal.h |    1 -
 fs/proc/inode.c    |    2 --
 fs/proc/root.c     |    5 +++--
 3 files changed, 3 insertions(+), 5 deletions(-)

--- 35-rc3/fs/proc/internal.h~PNS_2_KILL_ROOT_MNT	2010-06-19 19:20:23.000000000 +0200
+++ 35-rc3/fs/proc/internal.h	2010-06-19 19:21:39.000000000 +0200
@@ -106,7 +106,6 @@ static inline struct proc_dir_entry *pde
 }
 void pde_put(struct proc_dir_entry *pde);
 
-extern struct vfsmount *proc_mnt;
 int proc_fill_super(struct super_block *);
 struct inode *proc_get_inode(struct super_block *, unsigned int, struct proc_dir_entry *);
 
--- 35-rc3/fs/proc/inode.c~PNS_2_KILL_ROOT_MNT	2010-06-19 19:20:23.000000000 +0200
+++ 35-rc3/fs/proc/inode.c	2010-06-19 19:21:39.000000000 +0200
@@ -43,8 +43,6 @@ static void proc_delete_inode(struct ino
 	clear_inode(inode);
 }
 
-struct vfsmount *proc_mnt;
-
 static struct kmem_cache * proc_inode_cachep;
 
 static struct inode *proc_alloc_inode(struct super_block *sb)
--- 35-rc3/fs/proc/root.c~PNS_2_KILL_ROOT_MNT	2010-06-19 19:21:38.000000000 +0200
+++ 35-rc3/fs/proc/root.c	2010-06-19 19:21:39.000000000 +0200
@@ -94,14 +94,15 @@ static struct file_system_type proc_fs_t
 
 void __init proc_root_init(void)
 {
+	struct vfsmount *mnt;
 	int err;
 
 	proc_init_inodecache();
 	err = register_filesystem(&proc_fs_type);
 	if (err)
 		return;
-	proc_mnt = kern_mount_data(&proc_fs_type, &init_pid_ns);
-	if (IS_ERR(proc_mnt)) {
+	mnt = kern_mount_data(&proc_fs_type, &init_pid_ns);
+	if (IS_ERR(mnt)) {
 		unregister_filesystem(&proc_fs_type);
 		return;
 	}

