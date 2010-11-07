Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0KGVmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:42:00 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22438 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab0KGVl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:41:59 -0500
Date: Sun, 7 Nov 2010 22:30:39 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-btrfs@vger.kernel.org
cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org
Subject: btrfs: potential null derefs
Message-ID: <alpine.LNX.2.00.1011062302390.24801@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are a number of potential NULL pointer dereferences in BTRFS - see 
below.

Unfortunately I don't know what the best way to deal with these are in 
BTRFS, so I'll leave the bug fixing to others and stick to just reporting 
them.


In fs/btrfs/file.c::btrfs_file_aio_write() we do this:
...
	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
...[skip lots of lines that don't touch 'pages']...
		memset(pages, 0, sizeof(struct page *) * nrptrs);

		ret = btrfs_delalloc_reserve_space(inode, write_bytes);
		if (ret)
			goto out;

		ret = prepare_pages(root, file, pages, num_pages,
				    pos, first_index, last_index,
				    write_bytes);
...

since kmalloc() may fail and return a NULL pointer this could potentially 
go bad.

Also in fs/btrfs/compression.c::btrfs_submit_compressed_write() there's 
this:
...
	cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
	atomic_set(&cb->pending_bios, 0);
	cb->errors = 0;
...

Which will also dereference a NULL pointer when kmalloc() fails.

and in the same function:
...
 	bio = compressed_bio_alloc(bdev, first_byte, GFP_NOFS);
	bio->bi_private = cb;
...
			bio = compressed_bio_alloc(bdev, first_byte, GFP_NOFS);
			bio->bi_private = cb;
...

Which are also potential NULL derefs since (at least as far as I can 
tell) compressed_bio_alloc() can also fail and return NULL.

And then in btrfs_submit_compressed_read() :
...
	cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
	atomic_set(&cb->pending_bios, 0);
	cb->errors = 0;
...
	cb->compressed_pages = kmalloc(sizeof(struct page *) * nr_pages,
				       GFP_NOFS);
	bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;

	for (page_index = 0; page_index < nr_pages; page_index++) {
		cb->compressed_pages[page_index] = alloc_page(GFP_NOFS |
				      			      __GFP_HIGHMEM);
	}
...
			comp_bio = compressed_bio_alloc(bdev, cur_disk_byte,
							GFP_NOFS);
			comp_bio->bi_private = cb;
...

All 3 risk dereferencing a NULL pointer when the allocations fail.


Enjoy ;-)



PS.
  Please CC me on replies.



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

