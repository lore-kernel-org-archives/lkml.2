Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab0DVT2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:28:21 -0400
Received: from kroah.org ([198.145.64.141]:40697 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281Ab0DVT2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:17 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:13 2010
Message-Id: <20100422190913.109630735@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
       maximilian attems <max@stro.at>
Subject: [064/197] ext3: journal all modifications in ext3_xattr_set_handle
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit d965736b8cb42ae51ba9c3f13488035a98d025c6 upstream.

ext3_xattr_set_handle() was zeroing out an inode outside
of journaling constraints; this is one of the accesses that
was causing the crc errors in journal replay as seen in
kernel.org bugzilla #14354.

Although ext3 doesn't have the crc issue, modifications
out of journal control are a Bad Thing.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext3/xattr.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -960,6 +960,10 @@ ext3_xattr_set_handle(handle_t *handle,
 	if (error)
 		goto cleanup;
 
+	error = ext3_journal_get_write_access(handle, is.iloc.bh);
+	if (error)
+		goto cleanup;
+
 	if (EXT3_I(inode)->i_state & EXT3_STATE_NEW) {
 		struct ext3_inode *raw_inode = ext3_raw_inode(&is.iloc);
 		memset(raw_inode, 0, EXT3_SB(inode->i_sb)->s_inode_size);
@@ -985,9 +989,6 @@ ext3_xattr_set_handle(handle_t *handle,
 		if (flags & XATTR_CREATE)
 			goto cleanup;
 	}
-	error = ext3_journal_get_write_access(handle, is.iloc.bh);
-	if (error)
-		goto cleanup;
 	if (!value) {
 		if (!is.s.not_found)
 			error = ext3_xattr_ibody_set(handle, inode, &i, &is);


