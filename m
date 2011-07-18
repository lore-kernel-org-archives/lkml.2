Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab1GRDgx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 23:36:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34866 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756153Ab1GRDgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 23:36:48 -0400
Date: Mon, 18 Jul 2011 13:36:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josef Bacik <josef@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: linux-next: manual merge of the vfs tree with the ext3 tree
Message-Id: <20110718133645.7a4a21bb51c690034ecc6d58@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/ext3/fsync.c between commit 785c4bcc0d88 ("ext3: Add fixed
tracepoints") from the ext3 tree and commit 62ec115d5b9c ("fs: push
i_mutex and filemap_write_and_wait down into ->fsync() handlers") from
the vfs tree.

I fixed it up (see below) but am not sure of the ordering of these two
separate changes.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext3/fsync.c
index 06a4394,0bcf63a..0000000
--- a/fs/ext3/fsync.c
+++ b/fs/ext3/fsync.c
@@@ -52,14 -51,22 +52,24 @@@ int ext3_sync_file(struct file *file, l
  	int ret, needs_barrier = 0;
  	tid_t commit_tid;
  
 -	if (inode->i_sb->s_flags & MS_RDONLY)
 -		return 0;
 -
+ 	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
+ 	if (ret)
+ 		return ret;
+ 
+ 	/*
+ 	 * Taking the mutex here just to keep consistent with how fsync was
+ 	 * called previously, however it looks like we don't need to take
+ 	 * i_mutex at all.
+ 	 */
+ 	mutex_lock(&inode->i_mutex);
+ 
  	J_ASSERT(ext3_journal_current_handle() == NULL);
  
 +	trace_ext3_sync_file_enter(file, datasync);
 +
 +	if (inode->i_sb->s_flags & MS_RDONLY)
 +		return 0;
 +
- 
  	/*
  	 * data=writeback,ordered:
  	 *  The caller's filemap_fdatawrite()/wait will sync the data.
@@@ -75,8 -82,8 +85,9 @@@
  	 *  safe in-journal, which is all fsync() needs to ensure.
  	 */
  	if (ext3_should_journal_data(inode)) {
+ 		mutex_unlock(&inode->i_mutex);
 -		return ext3_force_commit(inode->i_sb);
 +		ret = ext3_force_commit(inode->i_sb);
 +		goto out;
  	}
  
  	if (datasync)
@@@ -97,8 -104,6 +108,9 @@@
  	 */
  	if (needs_barrier)
  		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+ 	mutex_unlock(&inode->i_mutex);
 +
 +out:
 +	trace_ext3_sync_file_exit(inode, ret);
  	return ret;
  }
