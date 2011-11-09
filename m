Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935194Ab1KJE5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:57:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935171Ab1KJDaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:30:25 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:16 2011
Message-Id: <20111109212716.806212792@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Sandeen <sandeen@redhat.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [161/262] ext4: fix race in xattr block allocation path
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit 6d6a435190bdf2e04c9465cde5bdc3ac68cf11a4 upstream.

Ceph users reported that when using Ceph on ext4, the filesystem
would often become corrupted, containing inodes with incorrect
i_blocks counters.

I managed to reproduce this with a very hacked-up "streamtest"
binary from the Ceph tree.

Ceph is doing a lot of xattr writes, to out-of-inode blocks.
There is also another thread which does sync_file_range and close,
of the same files.  The problem appears to happen due to this race:

sync/flush thread               xattr-set thread
-----------------               ----------------

do_writepages                   ext4_xattr_set
ext4_da_writepages              ext4_xattr_set_handle
mpage_da_map_blocks             ext4_xattr_block_set
        set DELALLOC_RESERVE
                                ext4_new_meta_blocks
                                        ext4_mb_new_blocks
                                                if (!i_delalloc_reserved_flag)
                                                        vfs_dq_alloc_block
ext4_get_blocks
	down_write(i_data_sem)
        set i_delalloc_reserved_flag
	...
	up_write(i_data_sem)
                                        if (i_delalloc_reserved_flag)
                                                vfs_dq_alloc_block_nofail


In other words, the sync/flush thread pops in and sets
i_delalloc_reserved_flag on the inode, which makes the xattr thread
think that it's in a delalloc path in ext4_new_meta_blocks(),
and add the block for a second time, after already having added
it once in the !i_delalloc_reserved_flag case in ext4_mb_new_blocks

The real problem is that we shouldn't be using the DELALLOC_RESERVED
state flag, and instead we should be passing
EXT4_GET_BLOCKS_DELALLOC_RESERVE down to ext4_map_blocks() instead of
using an inode state flag.  We'll fix this for now with using
i_data_sem to prevent this race, but this is really not the right way
to fix things.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/xattr.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -820,8 +820,14 @@ inserted:
 			if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
 				goal = goal & EXT4_MAX_BLOCK_FILE_PHYS;
 
+			/*
+			 * take i_data_sem because we will test
+			 * i_delalloc_reserved_flag in ext4_mb_new_blocks
+			 */
+			down_read((&EXT4_I(inode)->i_data_sem));
 			block = ext4_new_meta_blocks(handle, inode, goal, 0,
 						     NULL, &error);
+			up_read((&EXT4_I(inode)->i_data_sem));
 			if (error)
 				goto cleanup;
 


