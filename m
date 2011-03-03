Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059Ab1CCW5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:57:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46950 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758926Ab1CCW5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:57:05 -0500
Date: Thu, 3 Mar 2011 22:57:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] st_nlink after rmdir() and rename()
Message-ID: <20110303225702.GQ22723@ZenIV.linux.org.uk>
References: <20110303032454.GI22723@ZenIV.linux.org.uk>
 <AANLkTin5GpLSvNnLb_=2wMS9w6RjHa=q8p0gOENtNjfq@mail.gmail.com>
 <20110303060352.GK22723@ZenIV.linux.org.uk>
 <AANLkTi=85DJo-Qy0bABKg1J_j0s=8HfTt1m+rq4E5GqS@mail.gmail.com>
 <87tyfk7x0c.fsf@devron.myhome.or.jp>
 <AANLkTinJPQtcBQsBd+OmioywcxSgzWXFgqMBSrfx8e6D@mail.gmail.com>
 <87lj0v9984.fsf@devron.myhome.or.jp>
 <AANLkTinSiD3YakBTNfYXrE12YDsDREHX3GzLzCncduTV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinSiD3YakBTNfYXrE12YDsDREHX3GzLzCncduTV@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 01:52:18PM -0800, Linus Torvalds wrote:
> On Thu, Mar 3, 2011 at 1:37 PM, OGAWA Hirofumi
> <hirofumi@mail.parknet.co.jp> wrote:
> >
> > And I can't only see is why you refuse to make consistent behavior (if
> > you are saying it). It's why I said if it's _really easy_.
> 
> The thing is, it really isn't really easy. As mentioned, it's actually
> impossible on NFS, and it's possibly impossible on other filesystems
> too.
> 
> So what I'm objecting to is "try to make something consistent that
> CANNOT be consistent anyway", and calling it a bug.
> 
> I'm not saying there aren't real bugs there too (the actual races in
> i_nlink handling are real bugs). But I _am_ saying that it's simply
> not true that i_nlink must be zero if you do an "fstat()" after doing
> an rmdir on an fd that you held open. Nobody can reasonably care, and
> anybody who _does_ care is better off getting a nasty surprise early
> rather than late.

Ho-hum...  OK, let me put it that way:
	* pile I've sent a pull request for is really bug-only; none of it
has anything to do with what's discussed in that thread, other than "it's
also about i_nlink and found during the same code review".  i_nlink races,
pair of fs corruptors and a braino in UDF (256 << sizeof(inode->i_nlink)
as a way to spell "maximal allowed number of links"; never really worked,
even before we had switched to 32bit internal i_nlink - the real limit is
0xffff, not 0x3ff or 0xfff).
	* it's trivial to get the same behaviour on all local filesystems;
most of them have it and rely on it to detect the inodes that need to be
freed on final iput().  It has nothing to do with counting subdirs or any
such nonsense.
	* inotify is broken for filesystems that don't get you zero ->i_nlink
when the last dentry pointing to doomed inode is dropped.  Regardless of what
you get in fstat().  Excusable for remote fs, but not nice for local ones.
I'd *LOVE* to get rid of inotife/dnotify/etc., but it's probably not feasible
now.
	* NFS is not hard to handle, actually, especially for directories.
Regular files may be trickier, but then we have many places in that area
where NFS is not quite POSIX-compliant, to put it mildly.
	* I honestly don't know what's the real situation with other
remote filesystems; thus the RFC.  Hopefully, people familiar with that
are on fsdevel...

BTW, I suspect that another exception among the local filesystems (affs)
is actually leaking blocks on rmdir.  Need to experiment to verify that,
but it smells like another genuine bug.
