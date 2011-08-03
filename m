Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab1HCXj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:39:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33837 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085Ab1HCX2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:28:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:51 2011
Message-Id: <20110803221251.188535402@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiaying Zhang <jiayingz@google.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [071/102] ext4: free allocated and pre-allocated blocks when check_eofblocks_fl fails
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiaying Zhang <jiayingz@google.com>

commit 575a1d4bdfa2ea9fc10733013136145b497e1be0 upstream.

Upon corrupted inode or disk failures, we may fail after we already
allocate some blocks from the inode or take some blocks from the
inode's preallocation list, but before we successfully insert the
corresponding extent to the extent tree. In this case, we should free
any allocated blocks and discard the inode's preallocated blocks
because the entries in the inode's preallocation list may be in an
inconsistent state.

Signed-off-by: Jiaying Zhang <jiayingz@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/extents.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3596,10 +3596,9 @@ int ext4_ext_map_blocks(handle_t *handle
 	}
 
 	err = check_eofblocks_fl(handle, inode, map->m_lblk, path, ar.len);
-	if (err)
-		goto out2;
-
-	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
+	if (!err)
+		err = ext4_ext_insert_extent(handle, inode, path,
+					     &newex, flags);
 	if (err) {
 		int fb_flags = flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE ?
 			EXT4_FREE_BLOCKS_NO_QUOT_UPDATE : 0;


