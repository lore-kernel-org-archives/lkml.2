Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab2BCBQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 20:16:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39115 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab2BCBQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 20:16:18 -0500
Date: Fri, 3 Feb 2012 01:16:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joel Becker <jlbec@evilplan.org>, Chris Mason <chris.mason@oracle.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [RFC] killing boilerplate checks in ->link/->mkdir/->rename
Message-ID: <20120203011612.GS23916@ZenIV.linux.org.uk>
References: <4F27C6EB.2070305@suse.cz>
 <m14nvc82jo.fsf@fess.ebiederm.org>
 <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
 <m1wr87ywex.fsf@fess.ebiederm.org>
 <m1ehueyz20.fsf_-_@fess.ebiederm.org>
 <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
 <20120202012258.GQ23916@ZenIV.linux.org.uk>
 <20120202212400.GR23916@ZenIV.linux.org.uk>
 <CA+55aFzHSv2eHKenVhxnSFMJMXtJCnxD2xu6QjMiMLEGLCZ2uQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzHSv2eHKenVhxnSFMJMXtJCnxD2xu6QjMiMLEGLCZ2uQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 03:46:06PM -0800, Linus Torvalds wrote:
> On Thu, Feb 2, 2012 at 1:24 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Comments? ?Boilerplate removal follows (22 files changed, 45 insertions(+),
> > 120 deletions(-)), but it's *not* for immediate merge; it's really completely
> > untested.
> 
> Looks ok to me. Historically, the more things we can check at the VFS
> layer, the better.

After looking a bit more: nlink_t is a f*cking mess.  Almost any code
using that type kernel-side is broken.  Crap galore:
	* sometimes it's 32 bits, sometimes 16, sometimes 64.  Essentially
at random.
	* almost all have it unsigned, except for sparc32, where it's
signed short [inherited from v7 via SunOS?  BTW, in v6 it used to be even
funnier - char, which is where ridiculous LINK_MAX == 127 comes from]

IOW, nlink_t is an attractive nuisance - it's nearly impossible to use in
a portable way and we are lucky that almost nobody tries to.  Exceptions:
ocfs2_rename() does
        nlink_t old_dir_nlink = old_dir->i_nlink;
	...
followed later by comparison with old_dir->i_nlink.  And no, it's not to
handle truncation - it's "what if i_nlink changed while ocfs2_rename()
had been grabbing the cluster lock" kind of thing.  OCFS2 can have up
to 2^32 links to file, so truncation is really possible...  AFAICS,
that one is a genuine bug - this nlink_t should be u32...
Another one is proc_dir_entry ->nlink and it would cause Bad Things(tm)
on architecture with 16bit nlink_t if we could end up with 65534
subdirectories in some procfs dir.  Might be possible, might be not -
doing that under /proc/sys is definitely possible, but that won't be
enough; needs to be proc_dir_entry-backed directory.  Again, solution
is to use explicit u32 anyway.

	* compat_nlink_t is even funnier - it's signed in *two* cases; sparc
and ppc.  No, nlink_t on ppc32 is unsigned.  Not that anyone cared, really,
since the _only_ use of that type is in struct compat_stat.  For exactly
one field.  Only used as left-hand side of assignment, which is actually
broken since unlike cp_new_stat(), cp_compat_stat() does *not* check if the
value fits into st_nlink.  Bug, needs to be fixed.  Incidentally, just what
should we do on sparc32 if we run into a file with 4G-10 links?  -EOVERFLOW
or silently put 65536-10 in st_nlink and be done with that?  Note that
filesystems allowing that many links *do* exist...

	* when does jfs dtInsert() return -EMLINK?  Can it ever get triggered?
	* WTF is XFS doing with these checks?  Note that we have them
done _twice_ on all paths - explictly from xfs_create(), xfs_link(),
xfs_rename() and then from xfs_bumplink() called by exactly the same
set of functions.

	* what's up with btrfs_insert_inode_ref()?  I've tried to trace
the codepaths around there, but... Incidentally, when could fixup_low_keys()
return non-zero?  I don't see any candidates for that in there...  Chris?

	* ubifs, hfsplus, jffs2 - definitely broken if you create enough
links.  i_nlink wraparound to zero, confused inode eviction logics.
