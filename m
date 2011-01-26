Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1AZHXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:23:38 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37121 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab1AZHXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:23:36 -0500
Date: Tue, 25 Jan 2011 23:23:29 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        axboe@kernel.dk, tytso@mit.edu, shli@kernel.org, neilb@suse.de,
        adilger.kernel@dilger.ca, jack@suse.cz, snitzer@redhat.com,
        linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
        linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
        josef@redhat.com
Subject: [PATCH 3/3] ext4: Deprecate barrier= and nobarrier mount options
Message-ID: <20110126072329.GK27190@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20110126071200.GE32261@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126071200.GE32261@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of migrating the FLUSH/FUA knob to the block layer, remove the support
code for the barrier-related mount options and remove the conditionals around
flushes in favor of always issuing the flush.  The block layer will handle
gracefully the situation where a FLUSH or FUA request is issued to a device
that doesn't support it.  Modify the option parsing code to print a warning if
someone tries to use the old mount option.

Note: The nobarrier bit in the default mount flags is now useless.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext4/ext4.h  |    1 -
 fs/ext4/super.c |   23 ++---------------------
 2 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0c8d97b..fa4c688 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -893,7 +893,6 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_XATTR_USER		0x04000	/* Extended user attributes */
 #define EXT4_MOUNT_POSIX_ACL		0x08000	/* POSIX Access Control Lists */
 #define EXT4_MOUNT_NO_AUTO_DA_ALLOC	0x10000	/* No auto delalloc mapping */
-#define EXT4_MOUNT_BARRIER		0x20000 /* Use block barriers */
 #define EXT4_MOUNT_QUOTA		0x80000 /* Some quota option set */
 #define EXT4_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
 #define EXT4_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7379829..cd8e7b8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1022,13 +1022,6 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 			   (unsigned) sbi->s_min_batch_time);
 	}
 
-	/*
-	 * We're changing the default of barrier mount option, so
-	 * let's always display its mount state so it's clear what its
-	 * status is.
-	 */
-	seq_puts(seq, ",barrier=");
-	seq_puts(seq, test_opt(sb, BARRIER) ? "1" : "0");
 	if (test_opt(sb, JOURNAL_ASYNC_COMMIT))
 		seq_puts(seq, ",journal_async_commit");
 	else if (test_opt(sb, JOURNAL_CHECKSUM))
@@ -1701,18 +1694,9 @@ set_qf_format:
 			sbi->s_mount_flags |= EXT4_MF_FS_ABORTED;
 			break;
 		case Opt_nobarrier:
-			clear_opt(sb, BARRIER);
-			break;
 		case Opt_barrier:
-			if (args[0].from) {
-				if (match_int(&args[0], &option))
-					return 0;
-			} else
-				option = 1;	/* No argument, default to 1 */
-			if (option)
-				set_opt(sb, BARRIER);
-			else
-				clear_opt(sb, BARRIER);
+			ext4_msg(sb, KERN_INFO, "barrier options are "
+				 "deprecated.  Use ignore_flush in sysfs.");
 			break;
 		case Opt_ignore:
 			break;
@@ -3125,9 +3109,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_min_batch_time = EXT4_DEF_MIN_BATCH_TIME;
 	sbi->s_max_batch_time = EXT4_DEF_MAX_BATCH_TIME;
 
-	if ((def_mount_opts & EXT4_DEFM_NOBARRIER) == 0)
-		set_opt(sb, BARRIER);
-
 	/*
 	 * enable delayed allocation by default
 	 * Use -o nodelalloc to turn it off
