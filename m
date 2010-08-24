Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab0HXW6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:58:33 -0400
Received: from kroah.org ([198.145.64.141]:40311 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758Ab0HXW6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:58:22 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:13 2010
Message-Id: <20100824224213.611367283@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:41:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [18/91] nilfs2: fix list corruption after ifile creation failure
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

commit af4e36318edb848fcc0a8d5f75000ca00cdc7595 upstream.

If nilfs_attach_checkpoint() gets a memory allocation failure during
creation of ifile, it will return without removing nilfs_sb_info
struct from ns_supers list.  When a concurrently mounted snapshot is
unmounted or another new snapshot is mounted after that, this causes
kernel oops as below:

> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<f83662ff>] nilfs_find_sbinfo+0x74/0xa4 [nilfs2]
> *pde = 00000000
> Oops: 0000 [#1] SMP
<snip>
> Call Trace:
>  [<f835dc29>] ? nilfs_get_sb+0x165/0x532 [nilfs2]
>  [<c1173c87>] ? ida_get_new_above+0x16d/0x187
>  [<c109a7f8>] ? alloc_vfsmnt+0x7e/0x10a
>  [<c1070790>] ? kstrdup+0x2c/0x40
>  [<c1089041>] ? vfs_kern_mount+0x96/0x14e
>  [<c108913d>] ? do_kern_mount+0x32/0xbd
>  [<c109b331>] ? do_mount+0x642/0x6a1
>  [<c101a415>] ? do_page_fault+0x0/0x2d1
>  [<c1099c00>] ? copy_mount_options+0x80/0xe2
>  [<c10705d8>] ? strndup_user+0x48/0x67
>  [<c109b3f1>] ? sys_mount+0x61/0x90
>  [<c10027cc>] ? sysenter_do_call+0x12/0x22

This fixes the problem.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nilfs2/super.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -360,9 +360,10 @@ int nilfs_attach_checkpoint(struct nilfs
 	list_add(&sbi->s_list, &nilfs->ns_supers);
 	up_write(&nilfs->ns_super_sem);
 
+	err = -ENOMEM;
 	sbi->s_ifile = nilfs_ifile_new(sbi, nilfs->ns_inode_size);
 	if (!sbi->s_ifile)
-		return -ENOMEM;
+		goto delist;
 
 	down_read(&nilfs->ns_segctor_sem);
 	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, cno, 0, &raw_cp,
@@ -393,6 +394,7 @@ int nilfs_attach_checkpoint(struct nilfs
 	nilfs_mdt_destroy(sbi->s_ifile);
 	sbi->s_ifile = NULL;
 
+ delist:
 	down_write(&nilfs->ns_super_sem);
 	list_del_init(&sbi->s_list);
 	up_write(&nilfs->ns_super_sem);


