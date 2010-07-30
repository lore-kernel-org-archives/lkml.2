Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218Ab0G3R1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:27:43 -0400
Received: from kroah.org ([198.145.64.141]:52097 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758842Ab0G3RTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:55 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:11 2010
Message-Id: <20100730171511.346413145@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Tso" <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>
Subject: [129/165] ext4: restart ext4_ext_remove_space() after transaction restart
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 0617b83fa239db9743a18ce6cc0e556f4d0fd567 upstream (as of v2.6.34-git13)

If i_data_sem was internally dropped due to transaction restart, it is
necessary to restart path look-up because extents tree was possibly
modified by ext4_get_block().

https://bugzilla.kernel.org/show_bug.cgi?id=15827

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/extents.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -107,11 +107,8 @@ static int ext4_ext_truncate_extend_rest
 	if (err <= 0)
 		return err;
 	err = ext4_truncate_restart_trans(handle, inode, needed);
-	/*
-	 * We have dropped i_data_sem so someone might have cached again
-	 * an extent we are going to truncate.
-	 */
-	ext4_ext_invalidate_cache(inode);
+	if (err == 0)
+		err = -EAGAIN;
 
 	return err;
 }
@@ -2263,7 +2260,7 @@ static int ext4_ext_remove_space(struct
 	int depth = ext_depth(inode);
 	struct ext4_ext_path *path;
 	handle_t *handle;
-	int i = 0, err = 0;
+	int i, err;
 
 	ext_debug("truncate since %u\n", start);
 
@@ -2272,23 +2269,26 @@ static int ext4_ext_remove_space(struct
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
+again:
 	ext4_ext_invalidate_cache(inode);
 
 	/*
 	 * We start scanning from right side, freeing all the blocks
 	 * after i_size and walking into the tree depth-wise.
 	 */
+	depth = ext_depth(inode);
 	path = kzalloc(sizeof(struct ext4_ext_path) * (depth + 1), GFP_NOFS);
 	if (path == NULL) {
 		ext4_journal_stop(handle);
 		return -ENOMEM;
 	}
+	path[0].p_depth = depth;
 	path[0].p_hdr = ext_inode_hdr(inode);
 	if (ext4_ext_check(inode, path[0].p_hdr, depth)) {
 		err = -EIO;
 		goto out;
 	}
-	path[0].p_depth = depth;
+	i = err = 0;
 
 	while (i >= 0 && err == 0) {
 		if (i == depth) {
@@ -2382,6 +2382,8 @@ static int ext4_ext_remove_space(struct
 out:
 	ext4_ext_drop_refs(path);
 	kfree(path);
+	if (err == -EAGAIN)
+		goto again;
 	ext4_journal_stop(handle);
 
 	return err;


