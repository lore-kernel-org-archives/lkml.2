Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab2JHDuF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 23:50:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55899 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2JHDuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 23:50:00 -0400
Date: Mon, 8 Oct 2012 04:49:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sage Weil <sage@inktank.com>, Steven Whitehouse <swhiteho@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: vfs: oops on open_by_handle_at() in linux-next
Message-ID: <20121008034955.GP2616@ZenIV.linux.org.uk>
References: <5071837C.30208@gmail.com>
 <alpine.LSU.2.00.1210072027370.11615@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1210072027370.11615@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 08:32:51PM -0700, Hugh Dickins wrote:
> Thank you, Sasha: this should fix it, and similar in other FSes.
> 
> 
> [PATCH] tmpfs,ceph,gfs2,isofs,reiserfs,xfs: fix fh_len checking
> 
> Fuzzing with trinity oopsed on the 1st instruction of shmem_fh_to_dentry(),
> 	u64 inum = fid->raw[2];
> which is unhelpfully reported as at the end of shmem_alloc_inode():
> 
> BUG: unable to handle kernel paging request at ffff880061cd3000
> IP: [<ffffffff812190d0>] shmem_alloc_inode+0x40/0x40
> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> Call Trace:
>  [<ffffffff81488649>] ? exportfs_decode_fh+0x79/0x2d0
>  [<ffffffff812d77c3>] do_handle_open+0x163/0x2c0
>  [<ffffffff812d792c>] sys_open_by_handle_at+0xc/0x10
>  [<ffffffff83a5f3f8>] tracesys+0xe1/0xe6
> 
> Right, tmpfs is being stupid to access fid->raw[2] before validating that
> fh_len includes it: the buffer kmalloc'ed by do_sys_name_to_handle() may
> fall at the end of a page, and the next page not be present.
> 
> But some other filesystems (ceph, gfs2, isofs, reiserfs, xfs) are being
> careless about fh_len too, in fh_to_dentry() and/or fh_to_parent(), and
> could oops in the same way: add the missing fh_len checks to those.

TBH, I really don't like it.  How about putting minimal acceptable fhandle
length into export_operations instead?
