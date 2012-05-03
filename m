Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab2ECRa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:30:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52362 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab2ECRa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:30:27 -0400
Date: Thu, 3 May 2012 18:30:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@gmail.com>, Jana Saout <jana@saout.de>,
        Joel Becker <jlbec@evilplan.org>, linux-kernel@vger.kernel.org
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
Message-ID: <20120503173025.GQ6871@ZenIV.linux.org.uk>
References: <1335788867.29087.19.camel@localhost>
 <20120501110024.GC6649@dhcp-172-17-9-228.mtv.corp.google.com>
 <1335875321.26671.15.camel@localhost>
 <CAPa8GCANv=-c7HsYvDqM+8JqJq6Gr9muxAivU2Ni16x9Ru5EXw@mail.gmail.com>
 <CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com>
 <20120503064722.GN6871@ZenIV.linux.org.uk>
 <CA+55aFx0EUgXCE9CfUGz6zde-6iYgUKZRxB1=-VOEG0kSX2qEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx0EUgXCE9CfUGz6zde-6iYgUKZRxB1=-VOEG0kSX2qEA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 09:15:41AM -0700, Linus Torvalds wrote:
> I don't know the Xen paravirtualization code, but it looks like it is
> punching holes in the kernel memory map, so you get the same issue you
> get with DEBUG_PAGEALLOC.
> 
> Actually, looking at things, I think there's another case that can do
> it: the AMD gart_64 code also does set_memory_np(), which can cause
> problems.
> 
> So I guess I need to do the exception handling that I was hoping I
> wouldn't have to. Give me a jiffy.

BTW, I've looked through the ->readlink()/->follow_link() instances and
there's an interesting picture:
	* "slow" ocfs2 symlinks could bloody well use generic_readlink();
page_readlink() doesn't buy us anything when we have page_follow_link_light()
as ->follow_link().
	* "fast" ocfs2 symlinks would probably be better off if they just
added ->readlink() of their own and used the same inode_operations as
the rest of them.  And to hell with those dances with kmalloc and special
->readlink().
	* ecryptfs is *definitely* better off by switching to generic_readlink()
and having ecryptfs_follow_link() call ecryptfs_readlink_lower() directly;
we get rid of one of the rounds of kmalloc/memcpy/kfree on that, not to mention
that memcpy being killed is actually copy_to_user() wrapped into set_fs().

I've done (completely untested) patches for those - see vfs.git#symlinks;
if ocfs2 folks can live with that, I'll drop those into #for-next.

BTW, after that we have generic_readlink() for _everything_ with normal symlink
semantics.  Places that are different:
	* /proc/<pid>/{*,fd/*} - magical symlinks, ->follow_link() actually
does a direct jump.
	* /proc/self - different target for every process; we _could_ have
switched it to generic_readlink(), but I'm actually tempted to make it
a "direct jump" kind of symlink instead - its ->follow_link() would be
nicer (and faster) if we did that.
	* hppfs symlinks - those are bounced to procfs, so they inherit
the weirdness
	* afs automount points.  Those are not symlinks at all; we are
probably tied by avoiding userland breakage here, but readlink(2) on those
is badly abusing the syscall.  It's basically "which syscall could we use
to tell what'll get mounted when we step on automount point? aha, readlink()
returns a string, let's use it".
	* bad_inode - actually, we could use generic_readlink() there as well,
it'll fail with the right error ;-)  Again, this one is not quite a garden
variety symlink.
And that's it...
