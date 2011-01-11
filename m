Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab1AKIPC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 03:15:02 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:37159 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab1AKIOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 03:14:54 -0500
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Eric Van Hensbergen <ericvh@gmail.com>,
        Nick Piggin <nickpiggin@yahoo.com.au>
Cc: jvrao@linux.vnet.ibm.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>
Subject: Re: linux-next: manual merge of the vfs-scale tree with the v9fs tree
In-Reply-To: <AANLkTikGhYYJCUGjPDEbCDamDnmwh5O4_ZWmHDY7=BNK@mail.gmail.com>
References: <20110104124054.c767a4ee.sfr@canb.auug.org.au> <4D2363E7.30101@linux.vnet.ibm.com> <20110105064425.GA3161@amd> <4D24F934.7010803@linux.vnet.ibm.com> <AANLkTikGhYYJCUGjPDEbCDamDnmwh5O4_ZWmHDY7=BNK@mail.gmail.com>
User-Agent: Notmuch/0.5-32-gf6c60cc (http://notmuchmail.org) Emacs/23.1.1 (i486-pc-linux-gnu)
Date: Tue, 11 Jan 2011 13:44:47 +0530
Message-ID: <87zkr7zwjs.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011 15:49:37 -0600, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> Hmm...
> 
> I've merged up our for-next patch series with Linus' tree which now
> has the vfs-scalability patches in it.
> Unfortunately, it seems something has been introduced which changes
> underlying assumptions in the v9fs code causing certain operations to
> fail with a segfault in the dentry code.  We are digging into now and
> will keep folks apprised of the situation.  Some quick checks have
> shown that the problem wasn't there in 2.6.37 but are in linus' tree
> as of today.  I'm in the process of bisecting further -- it may not be
> the fault of the concerns below, but I figured I should post and let
> folks know about the problem.
> 
> For what its worth, here's the failure we see:
> sh-2.05b# mount -t 9p 10.0.2.2 /mnt -o port=5670
> [   49.044605] mount used greatest stack depth: 4664 bytes left
> sh-2.05b# ls /mnt
> bin    dev         initrd.img.old  lost+found  n1   opt   selinux  usr
> boot   etc         lib             media       n2   proc  srv      var
> cdrom  home        lib32           mnt         nas  root  sys      vmlinuz
> csrv   initrd.img  lib64           n0          net  sbin  tmp      vmlinuz.old
> sh-2.05b# ls /mnt/tmp
> cscope.9130  error.txt  ns.ericvh.:1  orbit-gdm  pulse-PKdhtXMmr18n
> sh-2.05b# cd /mnt/tmp
> sh-2.05b# ls -l
> total 1
> drwx------    1 501      266594          0 Jan  7 14:54 cscope.9130
> -rw-r--r--    1 501      266594        806 Jan  7 15:03 error.txt
> drwx------    1 501      266594          0 Jan  6 21:19 ns.ericvh.:1
> drwx------    1 114      124             0 Jan  6 21:24 orbit-gdm
> drwx------    1 114      124             0 Jan  6 21:09 pulse-PKdhtXMmr18n
> sh-2.05b# mkdir test
> [   61.764123] ------------[ cut here ]------------
> [   61.765045] kernel BUG at /home/ericvh/src/linux/v9fs-devel/fs/dcache.c:1358!
> [   61.765045] invalid opcode: 0000 [#1] SMP
> [   61.765045] last sysfs file:
> [   61.765045] CPU 0
> [   61.765045] Pid: 853, comm: mkdir Not tainted 2.6.37+ #124 /Bochs
> [   61.765045] RIP: 0010:[<ffffffff8111dda8>]  [<ffffffff8111dda8>]
> d_set_d_op+0xb/0x58
> [   61.765045] RSP: 0000:ffff880016a0bdb8  EFLAGS: 00010282
> [   61.765045] RAX: ffff880016d43440 RBX: ffff880016d4a9c0 RCX: ffff880017b23880
> [   61.765045] RDX: 0000000000000000 RSI: ffffffff81636d40 RDI: ffff880016d4a9c0
> [   61.765045] RBP: ffff880016a0bdb8 R08: 0000000000004000 R09: ffff880016a0bcf8
> [   61.765045] R10: 0000000000000004 R11: ffff880017925d30 R12: ffff880016946d80
> [   61.765045] R13: ffff880016946de0 R14: 0000000000000000 R15: ffff880016a0c400
> [   61.765045] FS:  0000000000000000(0000) GS:ffff880017c00000(0000)
> knlGS:0000000000000000
> [   61.765045] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> [   61.765045] CR2: 00000000f76f23c0 CR3: 0000000016814000 CR4: 00000000000006f0
> [   61.765045] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   61.765045] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   61.765045] Process mkdir (pid: 853, threadinfo ffff880016a0a000,
> task ffff88001695a490)
> [   61.765045] Stack:
> [   61.765045]  ffff880016a0be28 ffffffff812071bc ffff880016d43440
> 800001ed00000000
> [   61.765045]  0000000000000000 ffff880016d42fc0 0000000000000000
> ffff880016d4a9f8
> [   61.765045]  0000000000000000 ffff880016d42fc0 ffff880016d4a9c0
> ffff880016a0c400
> [   61.765045] Call Trace:
> [   61.765045]  [<ffffffff812071bc>] v9fs_create+0x21e/0x273
> [   61.765045]  [<ffffffff812075a5>] v9fs_vfs_mkdir+0x77/0x9a
> [   61.765045]  [<ffffffff81117b68>] vfs_mkdir+0x5a/0x96
> [   61.765045]  [<ffffffff81119c7c>] sys_mkdirat+0x91/0xe2
> [   61.765045]  [<ffffffff81119ce0>] sys_mkdir+0x13/0x15
> [   61.765045]  [<ffffffff810599b3>] ia32_sysret+0x0/0x5
> [   61.765045] Code: cc 39 53 20 0f 84 4a ff ff ff eb e5 31 db 48 83
> c4 48 48 89 d8 5b 41 5c 41 5d 41 5e 41 5f c9 c3 48 83 7f 60 00 55 48
> 89 e5 74 04 <0f> 0b eb fe 66 f7 07 00 f0 74 04 0f 0b eb fe 48 85 f6 48
> 89 77
> [   61.765045] RIP  [<ffffffff8111dda8>] d_set_d_op+0xb/0x58
> [   61.765045]  RSP <ffff880016a0bdb8>
> [   61.802265] ---[ end trace af62980550ad7d9c ]---
> Segmentation fault
> 
> 

This should fix

commit 69da74b14b1e6f9a69e02fada08a1df932907d65
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Tue Jan 11 13:42:28 2011 +0530

    fs/9p: Don't set dentry->d_op in create routines
    
    We do set dentry->d_op in lookup even in case of EOENT entries.
    That implies we should have dentry->d_op already set when
    create/mkdir/mknod/link/symlink routines are called
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 3923586..5076eeb 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -537,12 +537,6 @@ v9fs_create(struct v9fs_session_info *v9ses, struct inode *dir,
 		P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n", err);
 		goto error;
 	}
-
-	if (v9ses->cache)
-		d_set_d_op(dentry, &v9fs_cached_dentry_operations);
-	else
-		d_set_d_op(dentry, &v9fs_dentry_operations);
-
 	d_instantiate(dentry, inode);
 	err = v9fs_fid_add(dentry, fid);
 	if (err < 0)
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index b7f8dcb..8cb1eb8 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -211,11 +211,6 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 		P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n", err);
 		goto error;
 	}
-	if (v9ses->cache)
-		dentry->d_op = &v9fs_cached_dentry_operations;
-	else
-		dentry->d_op = &v9fs_dentry_operations;
-
 	d_instantiate(dentry, inode);
 	err = v9fs_fid_add(dentry, fid);
 	if (err < 0)
@@ -312,7 +307,6 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir,
 				err);
 			goto error;
 		}
-		d_set_d_op(dentry, &v9fs_cached_dentry_operations);
 		d_instantiate(dentry, inode);
 		err = v9fs_fid_add(dentry, fid);
 		if (err < 0)
@@ -329,7 +323,6 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir,
 			err = PTR_ERR(inode);
 			goto error;
 		}
-		d_set_d_op(dentry, &v9fs_dentry_operations);
 		d_instantiate(dentry, inode);
 	}
 	/* Now set the ACL based on the default value */
@@ -560,7 +553,6 @@ v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
 					err);
 			goto error;
 		}
-		d_set_d_op(dentry, &v9fs_cached_dentry_operations);
 		d_instantiate(dentry, inode);
 		err = v9fs_fid_add(dentry, fid);
 		if (err < 0)
@@ -573,7 +565,6 @@ v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
 			err = PTR_ERR(inode);
 			goto error;
 		}
-		d_set_d_op(dentry, &v9fs_dentry_operations);
 		d_instantiate(dentry, inode);
 	}
 
@@ -648,8 +639,6 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
 		 */
 		ihold(old_dentry->d_inode);
 	}
-
-	d_set_d_op(dentry, old_dentry->d_op);
 	d_instantiate(dentry, old_dentry->d_inode);
 
 	return err;
@@ -728,7 +717,6 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int omode,
 				err);
 			goto error;
 		}
-		d_set_d_op(dentry, &v9fs_cached_dentry_operations);
 		d_instantiate(dentry, inode);
 		err = v9fs_fid_add(dentry, fid);
 		if (err < 0)
@@ -744,7 +732,6 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int omode,
 			err = PTR_ERR(inode);
 			goto error;
 		}
-		d_set_d_op(dentry, &v9fs_dentry_operations);
 		d_instantiate(dentry, inode);
 	}
 	/* Now set the ACL based on the default value */
