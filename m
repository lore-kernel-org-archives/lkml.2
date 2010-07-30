Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab0G3RTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:19:50 -0400
Received: from kroah.org ([198.145.64.141]:51993 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758779Ab0G3RTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:40 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:10 2010
Message-Id: <20100730171510.018458238@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [115/165] ext4: check s_log_groups_per_flex in online resize code
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 42007efd569f1cf3bfb9a61da60ef6c2179508ca upstream (as of v2.6.34-git13)

If groups_per_flex < 2, sbi->s_flex_groups[] doesn't get filled out,
and every other access to this first tests s_log_groups_per_flex;
same thing needs to happen in resize or we'll wander off into
a null pointer when doing an online resize of the file system.

Thanks to Christoph Biedl, who came up with the trivial testcase:

# truncate --size 128M fsfile
# mkfs.ext3 -F fsfile
# tune2fs -O extents,uninit_bg,dir_index,flex_bg,huge_file,dir_nlink,extra_isize fsfile
# e2fsck -yDf -C0 fsfile
# truncate --size 132M fsfile
# losetup /dev/loop0 fsfile
# mount /dev/loop0 mnt
# resize2fs -p /dev/loop0

	https://bugzilla.kernel.org/show_bug.cgi?id=13549

Reported-by: Alessandro Polverini <alex@nibbles.it>
Test-case-by: Christoph Biedl  <bugzilla.kernel.bpeb@manchmal.in-ulm.de>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/resize.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -930,7 +930,8 @@ int ext4_group_add(struct super_block *s
 	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT4_INODES_PER_GROUP(sb));
 
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+	    sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group;
 		flex_group = ext4_flex_group(sbi, input->group);
 		atomic_add(input->free_blocks_count,


