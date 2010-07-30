Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278Ab0G3Rcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:32:54 -0400
Received: from kroah.org ([198.145.64.141]:51925 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757949Ab0G3RTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:30 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:09 2010
Message-Id: <20100730171509.206431183@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Curt Wohlgemuth <curtw@google.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [106/165] ext4: Fix possible lost inode write in no journal mode
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 8b472d739b2ddd8ab7fb278874f696cd95b25a5e upstream (as of v2.6.34-rc6)

In the no-journal case, ext4_write_inode() will fetch the bh and call
sync_dirty_buffer() on it.  However, if the bh has already been
written and the bh reclaimed for some other purpose, AND if the inode
is the only one in the inode table block in use, then
ext4_get_inode_loc() will not read the inode table block from disk,
but as an optimization, fill the block with zero's assuming that its
caller will copy in the on-disk version of the inode.  This is not
done by ext4_write_inode(), so the contents of the inode can simply
get lost.  The fix is to use __ext4_get_inode_loc() with in_mem set to
0, instead of ext4_get_inode_loc().  Long term the API needs to be
fixed so it's obvious why latter is not safe.

Addresses-Google-Bug: #2526446

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5260,7 +5260,7 @@ int ext4_write_inode(struct inode *inode
 	} else {
 		struct ext4_iloc iloc;
 
-		err = ext4_get_inode_loc(inode, &iloc);
+		err = __ext4_get_inode_loc(inode, &iloc, 0);
 		if (err)
 			return err;
 		if (wait)


