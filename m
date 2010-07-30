Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab0G3RaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:30:19 -0400
Received: from kroah.org ([198.145.64.141]:52039 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758800Ab0G3RTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:46 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:10 2010
Message-Id: <20100730171510.584273650@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Monakhov <dmonakhov@openvz.org>, Jan Kara <jack@suse.cz>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [121/165] ext4: init statistics after journal recovery
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 84061e07c5fbbbf9dc8aef8fb750fc3a2dfc31f3 upstream (as of v2.6.34-git13)

Currently block/inode/dir counters initialized before journal was
recovered. In fact after journal recovery this info will probably
change. And freeblocks it critical for correct delalloc mode
accounting.

https://bugzilla.kernel.org/show_bug.cgi?id=15768

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/super.c |   41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2695,24 +2695,6 @@ static int ext4_fill_super(struct super_
 	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
 	spin_lock_init(&sbi->s_next_gen_lock);
 
-	err = percpu_counter_init(&sbi->s_freeblocks_counter,
-			ext4_count_free_blocks(sb));
-	if (!err) {
-		err = percpu_counter_init(&sbi->s_freeinodes_counter,
-				ext4_count_free_inodes(sb));
-	}
-	if (!err) {
-		err = percpu_counter_init(&sbi->s_dirs_counter,
-				ext4_count_dirs(sb));
-	}
-	if (!err) {
-		err = percpu_counter_init(&sbi->s_dirtyblocks_counter, 0);
-	}
-	if (err) {
-		ext4_msg(sb, KERN_ERR, "insufficient memory");
-		goto failed_mount3;
-	}
-
 	sbi->s_stripe = ext4_get_stripe_size(sbi);
 	sbi->s_max_writeback_mb_bump = 128;
 
@@ -2832,7 +2814,20 @@ static int ext4_fill_super(struct super_
 	set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
 
 no_journal:
-
+	err = percpu_counter_init(&sbi->s_freeblocks_counter,
+				  ext4_count_free_blocks(sb));
+	if (!err)
+		err = percpu_counter_init(&sbi->s_freeinodes_counter,
+					  ext4_count_free_inodes(sb));
+	if (!err)
+		err = percpu_counter_init(&sbi->s_dirs_counter,
+					  ext4_count_dirs(sb));
+	if (!err)
+		err = percpu_counter_init(&sbi->s_dirtyblocks_counter, 0);
+	if (err) {
+		ext4_msg(sb, KERN_ERR, "insufficient memory");
+		goto failed_mount_wq;
+	}
 	if (test_opt(sb, NOBH)) {
 		if (!(test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)) {
 			ext4_msg(sb, KERN_WARNING, "Ignoring nobh option - "
@@ -2965,6 +2960,10 @@ failed_mount_wq:
 		jbd2_journal_destroy(sbi->s_journal);
 		sbi->s_journal = NULL;
 	}
+	percpu_counter_destroy(&sbi->s_freeblocks_counter);
+	percpu_counter_destroy(&sbi->s_freeinodes_counter);
+	percpu_counter_destroy(&sbi->s_dirs_counter);
+	percpu_counter_destroy(&sbi->s_dirtyblocks_counter);
 failed_mount3:
 	if (sbi->s_flex_groups) {
 		if (is_vmalloc_addr(sbi->s_flex_groups))
@@ -2972,10 +2971,6 @@ failed_mount3:
 		else
 			kfree(sbi->s_flex_groups);
 	}
-	percpu_counter_destroy(&sbi->s_freeblocks_counter);
-	percpu_counter_destroy(&sbi->s_freeinodes_counter);
-	percpu_counter_destroy(&sbi->s_dirs_counter);
-	percpu_counter_destroy(&sbi->s_dirtyblocks_counter);
 failed_mount2:
 	for (i = 0; i < db_count; i++)
 		brelse(sbi->s_group_desc[i]);


