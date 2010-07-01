Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab0GAVE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:04:28 -0400
Received: from kroah.org ([198.145.64.141]:47850 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932608Ab0GAUvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:12 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:37 2010
Message-Id: <20100701173437.686473133@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Theodore Tso" <tytso@mit.edu>,
       Dan Rosenberg <dan.j.rosenberg@gmail.com>
Subject: [patch 129/164] ext4: Make sure the MOVE_EXT ioctl cant overwrite append-only files
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 1f5a81e41f8b1a782c68d3843e9ec1bfaadf7d72 upstream.

Dan Roseberg has reported a problem with the MOVE_EXT ioctl.  If the
donor file is an append-only file, we should not allow the operation
to proceed, lest we end up overwriting the contents of an append-only
file.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/move_extent.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -964,6 +964,9 @@ mext_check_arguments(struct inode *orig_
 		return -EINVAL;
 	}
 
+	if (IS_IMMUTABLE(donor_inode) || IS_APPEND(donor_inode))
+		return -EPERM;
+
 	/* Ext4 move extent does not support swapfile */
 	if (IS_SWAPFILE(orig_inode) || IS_SWAPFILE(donor_inode)) {
 		ext4_debug("ext4 move extent: The argument files should "


