Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab2CEVdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:33:50 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37261 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab2CEVdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:33:49 -0500
Date: Mon, 5 Mar 2012 21:33:44 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linus GIT (3.3.0-rc6+) -- INFO: possible circular locking
 dependency detected
Message-ID: <20120305213343.GN23916@ZenIV.linux.org.uk>
References: <CAHFgRy-V3ZFK6QrC2++Rvyi4e_f-03Xdr9sj4PUJORVq21GiEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHFgRy-V3ZFK6QrC2++Rvyi4e_f-03Xdr9sj4PUJORVq21GiEw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 04:08:55PM -0500, Miles Lane wrote:

> [  107.839634] -> #1 (&mm->mmap_sem){++++++}:
[readdir() grabs ->mmap_sem under ->i_mutex - true, but irrelevant; more
to the point, write() on just about anything will grab ->mmap_sem under
->i_mutex, and that one happens for non-directories]

> [  107.839665] -> #0 (&sb->s_type->i_mutex_key#13){+.+.+.}:
[generic_file_aio_write() grabs ->i_mutex after being called from
vfs_write(), called from...]
> [  107.839691]        [<ffffffff810e6333>] vfs_write+0xa7/0xee
> [  107.839694]        [<ffffffffa037f266>]
> ecryptfs_write_lower+0x4e/0x73 [ecryptfs]
> [  107.839700]        [<ffffffffa03803d3>]
> ecryptfs_encrypt_page+0x11c/0x182 [ecryptfs]
> [  107.839704]        [<ffffffffa037e967>]
> ecryptfs_writepage+0x31/0x73 [ecryptfs]
> [  107.839708]        [<ffffffff810b448b>] __writepage+0x12/0x31
> [  107.839710]        [<ffffffff810b4b25>] write_cache_pages+0x1e6/0x310
> [  107.839713]        [<ffffffff810b4c8d>] generic_writepages+0x3e/0x54
> [  107.839716]        [<ffffffff810b5e05>] do_writepages+0x26/0x28
> [  107.839719]        [<ffffffff810ae1e4>] __filemap_fdatawrite_range+0x4e/0x50
> [  107.839722]        [<ffffffff810aed55>] filemap_fdatawrite+0x1a/0x1c
> [  107.839725]        [<ffffffff810aed72>] filemap_write_and_wait+0x1b/0x36
> [  107.839727]        [<ffffffffa037c1bb>]
> ecryptfs_vma_close+0x17/0x19 [ecryptfs]

Bloody wonderful...  That would do it, all right.  Forget about readdir(),
the deadlock is real and has nothing to do with directories.  Ecryptfs bug,
AFAICS.

Thread A:
	mmap something on ecryptfs, dirty it.
Thread B: open underlying file for write, 
	later
Thread A: munmap() | Thread B: write() (from unrelated buffer)

A holds ->mmap_sem, B holds ->i_mutex.
A is blocked essentially on attempt to do what B is doing (write to underlying
file; any mutex whatever_fs_write() might be holding around copy_from_user()
will do for that deadlock).
B is blocked trying to fault some pages in.

Fun...
