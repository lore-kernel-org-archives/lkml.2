Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab0G3RT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:19:27 -0400
Received: from kroah.org ([198.145.64.141]:51870 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758647Ab0G3RTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:22 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:08 2010
Message-Id: <20100730171508.575432999@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Tso" <tytso@mit.edu>
Subject: [099/165] ext4: Handle non empty on-disk orphan link
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 6e3617e579e070d3655a93ee9ed7149113e795e0 upstream (as of v2.6.33-git11)

In case of truncate errors we explicitly remove inode from in-core
orphan list via orphan_del(NULL, inode) without modifying the on-disk list.

But later on, the same inode may be inserted in the orphan list again
which will result the on-disk linked list getting corrupted.  If inode
i_dtime contains valid value, then skip on-disk list modification.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/namei.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2020,6 +2020,13 @@ int ext4_orphan_add(handle_t *handle, st
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
 	if (err)
 		goto out_unlock;
+	/*
+	 * Due to previous errors inode may be already a part of on-disk
+	 * orphan list. If so skip on-disk list modification.
+	 */
+	if (NEXT_ORPHAN(inode) && NEXT_ORPHAN(inode) <=
+		(le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count)))
+			goto mem_insert;
 
 	/* Insert this inode at the head of the on-disk orphan list... */
 	NEXT_ORPHAN(inode) = le32_to_cpu(EXT4_SB(sb)->s_es->s_last_orphan);
@@ -2037,6 +2044,7 @@ int ext4_orphan_add(handle_t *handle, st
 	 *
 	 * This is safe: on error we're going to ignore the orphan list
 	 * anyway on the next recovery. */
+mem_insert:
 	if (!err)
 		list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->s_orphan);
 


