Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199Ab2JHECW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 00:02:22 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:33932 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2JHECR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 00:02:17 -0400
Date: Sun, 7 Oct 2012 21:02:09 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Al Viro <viro@zeniv.linux.org.uk>
cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sage Weil <sage@inktank.com>, Steven Whitehouse <swhiteho@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: vfs: oops on open_by_handle_at() in linux-next
In-Reply-To: <20121008034955.GP2616@ZenIV.linux.org.uk>
Message-ID: <alpine.LSU.2.00.1210072053020.11669@eggly.anvils>
References: <5071837C.30208@gmail.com> <alpine.LSU.2.00.1210072027370.11615@eggly.anvils> <20121008034955.GP2616@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2012, Al Viro wrote:
> On Sun, Oct 07, 2012 at 08:32:51PM -0700, Hugh Dickins wrote:
> > Thank you, Sasha: this should fix it, and similar in other FSes.
> > 
> > 
> > [PATCH] tmpfs,ceph,gfs2,isofs,reiserfs,xfs: fix fh_len checking
> > 
> > Fuzzing with trinity oopsed on the 1st instruction of shmem_fh_to_dentry(),
> > 	u64 inum = fid->raw[2];
> > which is unhelpfully reported as at the end of shmem_alloc_inode():
> > 
> > BUG: unable to handle kernel paging request at ffff880061cd3000
> > IP: [<ffffffff812190d0>] shmem_alloc_inode+0x40/0x40
> > Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> > Call Trace:
> >  [<ffffffff81488649>] ? exportfs_decode_fh+0x79/0x2d0
> >  [<ffffffff812d77c3>] do_handle_open+0x163/0x2c0
> >  [<ffffffff812d792c>] sys_open_by_handle_at+0xc/0x10
> >  [<ffffffff83a5f3f8>] tracesys+0xe1/0xe6
> > 
> > Right, tmpfs is being stupid to access fid->raw[2] before validating that
> > fh_len includes it: the buffer kmalloc'ed by do_sys_name_to_handle() may
> > fall at the end of a page, and the next page not be present.
> > 
> > But some other filesystems (ceph, gfs2, isofs, reiserfs, xfs) are being
> > careless about fh_len too, in fh_to_dentry() and/or fh_to_parent(), and
> > could oops in the same way: add the missing fh_len checks to those.
> 
> TBH, I really don't like it.

Fair enough.

> How about putting minimal acceptable fhandle
> length into export_operations instead?

Hmm, but different "types" have different length constraints,
and each fh_to_dentry() or fh_to_parent() handles several types.
And the encode operations "encourage" using different lengths.

Perhaps I'm misunderstanding you, but I don't know how to do
as you propose, without multiplying the number of operations
horribly, and changing all (not just these) filesystems.

But hack around to your heart's content, there's no need for
this patch to go in if there's a better.

Hugh
