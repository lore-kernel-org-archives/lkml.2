Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab1CYXyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:54:41 -0400
Received: from kroah.org ([198.145.64.141]:42021 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932672Ab1CYXxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:53:16 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:48:44 2011
Message-Id: <20110325234844.780045218@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:47:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Amir Goldstein <amir73il@users.sf.net>, "Theodore Tso" <tytso@mit.edu>
Subject: [55/55] ext4: skip orphan cleanup if fs has unknown ROCOMPAT features
In-Reply-To: <20110325234853.GA21145@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit d39195c33bb1b5fdcb0f416e8a0b34bfdb07a027 upstream.

Orphan cleanup is currently executed even if the file system has some
number of unknown ROCOMPAT features, which deletes inodes and frees
blocks, which could be very bad for some RO_COMPAT features,
especially the SNAPSHOT feature.

This patch skips the orphan cleanup if it contains readonly compatible
features not known by this ext4 implementation, which would prevent
the fs from being mounted (or remounted) readwrite.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -75,6 +75,7 @@ static void ext4_write_super(struct supe
 static int ext4_freeze(struct super_block *sb);
 static struct dentry *ext4_mount(struct file_system_type *fs_type, int flags,
 		       const char *dev_name, void *data);
+static int ext4_feature_set_ok(struct super_block *sb, int readonly);
 static void ext4_destroy_lazyinit_thread(void);
 static void ext4_unregister_li_request(struct super_block *sb);
 static void ext4_clear_request_list(void);
@@ -2107,6 +2108,13 @@ static void ext4_orphan_cleanup(struct s
 		return;
 	}
 
+	/* Check if feature set would not allow a r/w mount */
+	if (!ext4_feature_set_ok(sb, 0)) {
+		ext4_msg(sb, KERN_INFO, "Skipping orphan cleanup due to "
+			 "unknown ROCOMPAT features");
+		return;
+	}
+
 	if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
 		if (es->s_last_orphan)
 			jbd_debug(1, "Errors on filesystem, "


