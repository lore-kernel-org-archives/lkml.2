Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab2BBBXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:23:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33978 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab2BBBXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:23:38 -0500
Date: Thu, 2 Feb 2012 01:22:58 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] sysfs: Optionally count subdirectories to support buggy
 applications
Message-ID: <20120202012258.GQ23916@ZenIV.linux.org.uk>
References: <20120130221059.26ab5edf@pyramind.ukuu.org.uk>
 <20120130222717.GA6393@kroah.com>
 <m18vkoirv9.fsf@fess.ebiederm.org>
 <4F27C6EB.2070305@suse.cz>
 <m14nvc82jo.fsf@fess.ebiederm.org>
 <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
 <m1wr87ywex.fsf@fess.ebiederm.org>
 <m1ehueyz20.fsf_-_@fess.ebiederm.org>
 <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 03:18:05PM -0800, Linus Torvalds wrote:
> On Wed, Feb 1, 2012 at 3:15 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > No extra "keep track of inode counts by hand" crap, and no idiotic
> > config options that just make it easy to (conditionally) get things
> > wrong. Just do it right, and do it *unconditionally* right.
> 
> And btw, "nlink shows number of subdirectories" for a directory entry
> really *is* right. It's how Unix filesystems work, like it or not.
> 
> It's mainly lazy/bad filesystems that set nlink to 1. So the whole
> "nlink==1" case is meant for crap like FAT etc, not for a filesystem
> that we control and that could easily just do it right.

It's a bit more complicated than that and it had always been a bit of
a minefield.  v6: link(2) began with
        ip = namei(&uchar, 0);
        if(ip == NULL)
                return;
        if(ip->i_nlink >= 127) {
                u.u_error = EMLINK;
                goto out;
        }
(and mkdir(), of course, was implemented via mknod+link).  Up to 127 links
to any object.  Fine; v7: EMLINK defined, but _never_ returned.  Moreover,
mkdir(1) didn't bother to check link counts either.  Result: 65535 calls
of link(2) and you've got yourself an fs corruption on i_nlink overflow
(it was 16bit in on-disk inode).

Linux implementation of link(2) had exactly the same bug as that of v7 until
0.98.3 (for link(2)) and 0.99.1 (for mkdir(2), rename(2) - didn't exist as
syscalls on v7, but had the same problem as soon as they made it in kernel
at some point in BSD history).  Note that limit for minixfs remained
ridiculously low until '97 or so; for ext2 it was 32000 from the very
beginning but note that e.g. ext had _not_ acquired fixes for link overflows
on mkdir() at all - it had that hole all the way until removal in 2.1.26.
Of course, there was a (completely useless) POSIX-mandated LINK_MAX, but
since the actual limit depends on fs type, well...  the checks remain
in ->link()/->mkdir()/->rename() instances and IIRC I've caught a bunch of
overflows in those circa 2.1.very_late.  

As the result, old stat(2) had 16bit st_nlink - same as v7.  Nobody needed
more, after all.  Alpha port got it 32bit (inherited the struct stat layout
from OSF, presumably?), but other early ports kept 16bit there.

At some point folks started whining about wanting more subdirectories and
that's when the things began to get really convoluted and ugly.  By that
time we had a variant of stat(2) that used 32bit st_nlink, but on-disk
layouts remained a problem.  Some filesystems went for more or less
reasonable "the limit is circa 2^32, EMLINK if we get more than that and
-EOVERFLOW on old_stat(2) if it doesn't fit into 16 bits".  However, it
was _not_ universally true - e.g. reiserfs does _NOT_ do that for mkdir().
There we get "directory link count grows up to 16bit limit and gets stuck
at 1 if it ever grows past that", on the theory that st_nlink == 1
is distinguishable from anything you'd normally get for a directory.  I
have no idea where that invention has come from, but it's been around for
more than a decade.  Of course, Hans being Hans, it had been advertised as
major reiserfs feature - you could get an unlimited amount of subdirectories,
which no other fs on Linux would allow, nevermind that nobody sane would
actually make use of that...

At about the same time somebody had done the same trick on ext2 - Daniel,
probably, since it had been floating in directory index patchset.  It never
got merged into mainline; ext3 port _did_, but without those bits actually
used (EXT3_DIR_LINK_MAX is defined, but never used).  ext4 actually has it
hooked in.

I don't see anything else other than ext4 and reiserfs using that convention,
but then just grepping for inc_nlink/inode_inc_use_count shows a bloody
mess - e.g. jffs2 does not check overflows (32bit there) at all, neither on
link() nor on mkdir()/rename().  It _might_ get away with that (with
non-standard errno, if so), but I don't remember that code well enough
to tell at the quick look.  HFS+ doesn't seem to check for overflows either
and while it doesn't track link count on directories, it does support link(2)
and it does bump i_nlink there.  A _lot_ of filesystems (starting with
ramfs) assumes that we'll get an OOM before we get to 2^32 links to an
inode on purely in-core filesystem; reasonable back in 2001 or so, but
not these days...
