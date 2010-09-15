Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048Ab0IOEBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 00:01:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36775 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab0IOEBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 00:01:18 -0400
Date: Wed, 15 Sep 2010 14:01:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Blunck <jblunck@infradead.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: linux-next: manual merge of the bkl-vfs tree with the nilfs2 tree
Message-Id: <20100915140114.81406c4f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Today's linux-next merge of the bkl-vfs tree got a conflict in
fs/nilfs2/super.c between commit 38999dca4fdc4a0d1b92a540bc0772a32b07388a
("nilfs2: do not allocate multiple super block instances for a device")
from the nilfs2 tree and commit 3fec873dc6e9026d98e2359202fa50fd06ee7b64
("BKL: Remove BKL from NILFS2") from the bkl-vfs tree.

I fixed it up (I think - see below) and can carry the fix as necessary.

P.S. Arndt, the first of the above bkl/vfs commits does not have a SOB
line from you and has a bug (missing open brace) that is fixed in the
second.  Just in case you decide to rebase this branch at any point ...

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/nilfs2/super.c
index 3a78f6c,9f4913f..0000000
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@@ -345,17 -348,16 +342,15 @@@ static void nilfs_put_super(struct supe
  		nilfs_cleanup_super(sbi);
  		up_write(&nilfs->ns_sem);
  	}
 -	down_write(&nilfs->ns_super_sem);
 -	if (nilfs->ns_current == sbi)
 -		nilfs->ns_current = NULL;
 -	up_write(&nilfs->ns_super_sem);
  
 -	nilfs_detach_checkpoint(sbi);
 -	put_nilfs(sbi->s_nilfs);
 +	iput(nilfs->ns_sufile);
 +	iput(nilfs->ns_cpfile);
 +	iput(nilfs->ns_dat);
 +
 +	destroy_nilfs(nilfs);
  	sbi->s_super = NULL;
  	sb->s_fs_info = NULL;
 -	nilfs_put_sbinfo(sbi);
 +	kfree(sbi);
- 
- 	unlock_kernel();
  }
  
  static int nilfs_sync_fs(struct super_block *sb, int wait)
@@@ -970,12 -942,13 +965,10 @@@ static int nilfs_remount(struct super_b
  	struct the_nilfs *nilfs = sbi->s_nilfs;
  	unsigned long old_sb_flags;
  	struct nilfs_mount_options old_opts;
 -	int was_snapshot, err;
 +	int err;
  
- 	lock_kernel();
- 
 -	down_write(&nilfs->ns_super_sem);
  	old_sb_flags = sb->s_flags;
  	old_opts.mount_opt = sbi->s_mount_opt;
 -	old_opts.snapshot_cno = sbi->s_snapshot_cno;
 -	was_snapshot = nilfs_test_opt(sbi, SNAPSHOT);
  
  	if (!parse_options(data, sb, 1)) {
  		err = -EINVAL;
@@@ -1040,13 -1016,14 +1033,11 @@@
  		up_write(&nilfs->ns_sem);
  	}
   out:
- 	unlock_kernel();
 -	up_write(&nilfs->ns_super_sem);
  	return 0;
  
   restore_opts:
  	sb->s_flags = old_sb_flags;
  	sbi->s_mount_opt = old_opts.mount_opt;
- 	unlock_kernel();
 -	sbi->s_snapshot_cno = old_opts.snapshot_cno;
 -	up_write(&nilfs->ns_super_sem);
  	return err;
  }
  
