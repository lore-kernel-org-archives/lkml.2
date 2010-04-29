Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab0D3QsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:48:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57483 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422Ab0D3Qre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:47:34 -0400
Date: Thu, 29 Apr 2010 13:52:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Anton Blanchard <anton@samba.org>,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20100429135204.eb79a986.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
fs/block_dev.c between commit b8af67e2681c693a21f3933e3bdfce4cf66596d3
("fs/block_dev.c: fix performance regression in O_DIRECT|O_SYNC writes to
block devices") from Linus' tree and commit
fbd9b09a177a481eda256447c881f014f29034fe ("blkdev: generalize flags for
blkdev_issue_fn functions") from the block tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/block_dev.c
index 6dcee88,dd76930..0000000
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@@ -406,23 -406,17 +406,24 @@@ static loff_t block_llseek(struct file 
   
  int blkdev_fsync(struct file *filp, struct dentry *dentry, int datasync)
  {
 -	struct block_device *bdev = I_BDEV(filp->f_mapping->host);
 +	struct inode *bd_inode = filp->f_mapping->host;
 +	struct block_device *bdev = I_BDEV(bd_inode);
  	int error;
  
 -	error = sync_blockdev(bdev);
 -	if (error)
 -		return error;
 -	
 +	/*
 +	 * There is no need to serialise calls to blkdev_issue_flush with
 +	 * i_mutex and doing so causes performance issues with concurrent
 +	 * O_SYNC writers to a block device.
 +	 */
 +	mutex_unlock(&bd_inode->i_mutex);
 +
- 	error = blkdev_issue_flush(bdev, NULL);
+ 	error = blkdev_issue_flush(bdev, GFP_KERNEL, NULL,
+ 				(BLKDEV_IFL_WAIT));
  	if (error == -EOPNOTSUPP)
  		error = 0;
 +
 +	mutex_lock(&bd_inode->i_mutex);
 +
  	return error;
  }
  EXPORT_SYMBOL(blkdev_fsync);
