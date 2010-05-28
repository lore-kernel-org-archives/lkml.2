Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0E1BbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 21:31:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42788 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260Ab0E1BbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 21:31:11 -0400
Date: Fri, 28 May 2010 11:31:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Frank Mayhar <fmayhar@google.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: linux-next: manual merge of the vfs tree with Linus' tree
Message-Id: <20100528113106.9c77165c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/ext4/fsync.c between commit 14ece1028b3ed53ffec1b1213ffc6acaf79ad77c
("ext4: Make fsync sync new parent directories in no-journal mode") from
Linus' tree and commits 05b2fc7d1f1046fef1199e1a4d2f63df998ef3aa ("drop
unused dentry argument to ->fsync") and
8f1edffdb5a76f205cf45070e1552ee8b2239a2b ("rename the generic fsync
implementations") from the vfs tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext4/fsync.c
index b6a74f9,8000c7a..0000000
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@@ -89,13 -66,9 +89,13 @@@ int ext4_sync_file(struct file *file, i
  	ret = flush_completed_IO(inode);
  	if (ret < 0)
  		return ret;
 -	
 -	if (!journal)
 -		return generic_file_fsync(file, datasync);
 +
 +	if (!journal) {
- 		ret = simple_fsync(file, dentry, datasync);
++		ret = generic_file_fsync(file, datasync);
 +		if (!ret && !list_empty(&inode->i_dentry))
 +			ext4_sync_parent(inode);
 +		return ret;
 +	}
  
  	/*
  	 * data=writeback,ordered:
