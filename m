Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256Ab0FAENa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 00:13:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59724 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab0FAEN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 00:13:28 -0400
Date: Tue, 1 Jun 2010 14:13:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Philipp Reisner <philipp.reisner@linbit.com>, <drbd-dev@linbit.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>, Al Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: linux-next: manual merge of the drbd tree with Linus' tree
Message-Id: <20100601141324.edf41f7f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the drbd tree got a conflict in fs/pipe.c
between commit cc967be54710d97c05229b2e5ba2d00df84ddd64 ("fs: Add missing
mutex_unlock") from Linus' tree and commits
0191f8697bbdfefcd36e7b8dc3eeddfe82893e4b ("pipe: F_SETPIPE_SZ should
return -EPERM for non-root") and b9598db3401282bb27b4aef77e3eee12015f7f29
("pipe: make F_{GET,SET}PIPE_SZ deal with byte sizes") from the drbd tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/pipe.c
index db6eaab,bdd3f96..0000000
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@@ -1174,23 -1162,30 +1168,34 @@@ long pipe_fcntl(struct file *file, unsi
  	mutex_lock(&pipe->inode->i_mutex);
  
  	switch (cmd) {
- 	case F_SETPIPE_SZ:
- 		if (!capable(CAP_SYS_ADMIN) && arg > pipe_max_pages) {
- 			ret = -EINVAL;
+ 	case F_SETPIPE_SZ: {
+ 		unsigned long nr_pages;
+ 
+ 		/*
+ 		 * Currently the array must be a power-of-2 size, so adjust
+ 		 * upwards if needed.
+ 		 */
+ 		nr_pages = (arg + PAGE_SIZE - 1) >> PAGE_SHIFT;
+ 		nr_pages = roundup_pow_of_two(nr_pages);
+ 
 -		if (!capable(CAP_SYS_ADMIN) && nr_pages > pipe_max_pages)
 -			return -EPERM;
++		if (!capable(CAP_SYS_ADMIN) && nr_pages > pipe_max_pages) {
++			ret = -EPERM;
 +			goto out;
 +		}
+ 
  		/*
  		 * The pipe needs to be at least 2 pages large to
  		 * guarantee POSIX behaviour.
  		 */
- 		if (arg < 2) {
 -		if (nr_pages < 2)
 -			return -EINVAL;
++		if (nr_pages < 2) {
 +			ret = -EINVAL;
 +			goto out;
 +		}
- 		ret = pipe_set_size(pipe, arg);
+ 		ret = pipe_set_size(pipe, nr_pages);
  		break;
+ 		}
  	case F_GETPIPE_SZ:
- 		ret = pipe->buffers;
+ 		ret = pipe->buffers * PAGE_SIZE;
  		break;
  	default:
  		ret = -EINVAL;
