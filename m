Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab0DVUfC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:35:02 -0400
Received: from kroah.org ([198.145.64.141]:40691 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273Ab0DVT2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:16 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:13 2010
Message-Id: <20100422190913.020515685@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
       maximilian attems <max@stro.at>
Subject: [063/197] ext3: Dont update the superblock in ext3_statfs()
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit b918397542388de75bd86c32fbfa820e5d629fa9 upstream.

commit a71ce8c6c9bf269b192f352ea555217815cf027e updated ext3_statfs()
to update the on-disk superblock counters, but modified this buffer
directly without any journaling of the change.  This is one of the
accesses that was causing the crc errors in journal replay as seen in
kernel.org bugzilla #14354.

The modifications were originally to keep the sb "more" in sync,
so that a readonly fsck of the device didn't flag this as an
error (as often), but apparently e2fsprogs deals with this differently
now, anyway.

Based on Ted's patch for ext4, which was in turn based on my
work on that bug and another preliminary patch...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext3/super.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2686,13 +2686,11 @@ static int ext3_statfs (struct dentry *
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = le32_to_cpu(es->s_blocks_count) - sbi->s_overhead_last;
 	buf->f_bfree = percpu_counter_sum_positive(&sbi->s_freeblocks_counter);
-	es->s_free_blocks_count = cpu_to_le32(buf->f_bfree);
 	buf->f_bavail = buf->f_bfree - le32_to_cpu(es->s_r_blocks_count);
 	if (buf->f_bfree < le32_to_cpu(es->s_r_blocks_count))
 		buf->f_bavail = 0;
 	buf->f_files = le32_to_cpu(es->s_inodes_count);
 	buf->f_ffree = percpu_counter_sum_positive(&sbi->s_freeinodes_counter);
-	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
 	buf->f_namelen = EXT3_NAME_LEN;
 	fsid = le64_to_cpup((void *)es->s_uuid) ^
 	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));


