Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab0EVGcd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 02:32:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42079 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab0EVGcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 02:32:18 -0400
Date: Sat, 22 May 2010 15:45:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jan Kara <jack@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the ext3 tree with Linus' tree
Message-Id: <20100522154532.bc0f8008.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

Today's linux-next merge of the ext3 tree got a conflict in fs/super.c
between commits b20bd1a5e78af267dc4b6e1ffed48d5d776302c5 ("get rid of
S_BIAS"), 1712ac8fda7d8bc4dc921f5777b7423aacad7263 ("Saner locking around
deactivate_super()") and e1e46bf1866317d4f86f66bf18d3f07317d9f9ee ("Trim
includes in fs/super.c") from Linus' tree and commits
c3134141c78d5ea233a08b703b553e70cfb5c585 ("quota: move unmount handling
into the filesystem") and cdb89ca659f5a39edf88f3c55e545ea3347533d1
("quota: explicitly set ->dq_op and ->s_qcop") from the ext3 tree.

I fixed it all up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/super.c
index 69688b1,2e0811f..0000000
--- a/fs/super.c
+++ b/fs/super.c
@@@ -22,15 -22,22 +22,14 @@@
  
  #include <linux/module.h>
  #include <linux/slab.h>
 -#include <linux/init.h>
 -#include <linux/smp_lock.h>
  #include <linux/acct.h>
  #include <linux/blkdev.h>
- #include <linux/quotaops.h>
 -#include <linux/namei.h>
  #include <linux/mount.h>
  #include <linux/security.h>
 -#include <linux/syscalls.h>
 -#include <linux/vfs.h>
  #include <linux/writeback.h>		/* for the emergency remount stuff */
  #include <linux/idr.h>
 -#include <linux/kobject.h>
  #include <linux/mutex.h>
 -#include <linux/file.h>
  #include <linux/backing-dev.h>
 -#include <asm/uaccess.h>
  #include "internal.h"
  
  
@@@ -146,21 -175,21 +143,20 @@@ void put_super(struct super_block *sb
  
  
  /**
 - *	deactivate_super	-	drop an active reference to superblock
 + *	deactivate_locked_super	-	drop an active reference to superblock
   *	@s: superblock to deactivate
   *
 - *	Drops an active reference to superblock, acquiring a temprory one if
 - *	there is no active references left.  In that case we lock superblock,
 + *	Drops an active reference to superblock, converting it into a temprory
 + *	one if there is no other active references left.  In that case we
   *	tell fs driver to shut it down and drop the temporary reference we
   *	had just acquired.
 + *
 + *	Caller holds exclusive lock on superblock; that lock is released.
   */
 -void deactivate_super(struct super_block *s)
 +void deactivate_locked_super(struct super_block *s)
  {
  	struct file_system_type *fs = s->s_type;
 -	if (atomic_dec_and_lock(&s->s_active, &sb_lock)) {
 -		s->s_count -= S_BIAS-1;
 -		spin_unlock(&sb_lock);
 -		down_write(&s->s_umount);
 +	if (atomic_dec_and_test(&s->s_active)) {
- 		vfs_dq_off(s, 0);
  		fs->kill_sb(s);
  		put_filesystem(fs);
  		put_super(s);
