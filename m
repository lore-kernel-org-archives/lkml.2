Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab0D3Qsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:48:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57482 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932449Ab0D3Qre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:47:34 -0400
Date: Thu, 29 Apr 2010 13:51:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Monakhov <dmonakhov@openvz.org>, Theodore Tso <tytso@MIT.EDU>
Subject: linux-next: manual merge of the block tree with the ext4 tree
Message-Id: <20100429135151.70e2a841.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
fs/ext4/fsync.c between commit a68513a1c88248ee9167a25e32ee8164c3dde02b
("ext4: check missed return value in ext4_sync_file()") from the ext4
tree and commit fbd9b09a177a481eda256447c881f014f29034fe ("blkdev:
generalize flags for blkdev_issue_fn functions") from the block tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext4/fsync.c
index 42bd94a,ef3d980e6..0000000
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@@ -100,9 -100,11 +100,11 @@@ int ext4_sync_file(struct file *file, s
  		if (ext4_should_writeback_data(inode) &&
  		    (journal->j_fs_dev != journal->j_dev) &&
  		    (journal->j_flags & JBD2_BARRIER))
- 			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+ 			blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL,
+ 					NULL, BLKDEV_IFL_WAIT);
 -		jbd2_log_wait_commit(journal, commit_tid);
 +		ret = jbd2_log_wait_commit(journal, commit_tid);
  	} else if (journal->j_flags & JBD2_BARRIER)
- 		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+ 		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL,
+ 			BLKDEV_IFL_WAIT);
  	return ret;
  }
