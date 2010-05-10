Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab0EJWwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:52:09 -0400
Received: from kroah.org ([198.145.64.141]:32919 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932324Ab0EJWvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:51:46 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:18 2010
Message-Id: <20100510223318.547476815@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:31:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Mahoney <jeffm@suse.com>,
       Edward Shishkin <edward.shishkin@gmail.com>,
       Jethro Beekman <kernel@jbeekman.nl>,
       Greg Surbey <gregsurbey@hotmail.com>,
       Marco Gatti <marco.gatti@gmail.com>
Subject: [015/117] reiserfs: fix corruption during shrinking of xattrs
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

commit fb2162df74bb19552db3d988fd11c787cf5fad56 upstream.

Commit 48b32a3553a54740d236b79a90f20147a25875e3 ("reiserfs: use generic
xattr handlers") introduced a problem that causes corruption when extended
attributes are replaced with a smaller value.

The issue is that the reiserfs_setattr to shrink the xattr file was moved
from before the write to after the write.

The root issue has always been in the reiserfs xattr code, but was papered
over by the fact that in the shrink case, the file would just be expanded
again while the xattr was written.

The end result is that the last 8 bytes of xattr data are lost.

This patch fixes it to use new_size.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=14826

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Reported-by: Christian Kujau <lists@nerdbynature.de>
Tested-by: Christian Kujau <lists@nerdbynature.de>
Cc: Edward Shishkin <edward.shishkin@gmail.com>
Cc: Jethro Beekman <kernel@jbeekman.nl>
Cc: Greg Surbey <gregsurbey@hotmail.com>
Cc: Marco Gatti <marco.gatti@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/reiserfs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -557,7 +557,7 @@ reiserfs_xattr_set_handle(struct reiserf
 	if (!err && new_size < i_size_read(dentry->d_inode)) {
 		struct iattr newattrs = {
 			.ia_ctime = current_fs_time(inode->i_sb),
-			.ia_size = buffer_size,
+			.ia_size = new_size,
 			.ia_valid = ATTR_SIZE | ATTR_CTIME,
 		};
 


