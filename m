Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab1CCGDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:03:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57768 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab1CCGDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:03:54 -0500
Date: Thu, 3 Mar 2011 06:03:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] st_nlink after rmdir() and rename()
Message-ID: <20110303060352.GK22723@ZenIV.linux.org.uk>
References: <20110303032454.GI22723@ZenIV.linux.org.uk>
 <AANLkTin5GpLSvNnLb_=2wMS9w6RjHa=q8p0gOENtNjfq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin5GpLSvNnLb_=2wMS9w6RjHa=q8p0gOENtNjfq@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 09:17:15PM -0800, Linus Torvalds wrote:
> On Wed, Mar 2, 2011 at 7:24 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Surprisingly, the results are *NOT* identical wrt fstat(); for most of
> > the filesystems we will get 0 in both cases (as expected), but some will
> > leave 1 in buf2.st_nlink.
> 
> Why do we care? Some filesystems don't support i_nlink at all, so it's
> always 1. Others won't do the real delete until later (nfs
> sillyrename), so returning 0 would be wrong and insane.
> 
> So the fact is, expecting 0,0 seems to be an incorrect expectation,
> and I don't understand why you would really care. Does it matter?

Umm...  For one thing, "is that sucker deleted" is a reasonable question
to ask.  For another, consistency is a good thing to have - rmdir() and
overwriting rename() being different is unexpected.

Note that it also means that e.g. on jffs2 you do get fsnotify event for
inode removal on rmdir() but not for overwriting rename() over a directory.
And while I have very little sympathy for *notify-style APIs, why the
hell break it if we don't have to?  Sure, anyone trying to use it on FUSE is
going to get what they deserve - there are tons of reasons why it's going
to be completely useless there.  But when we are talking about a local
filesystem, changed only by normal explicit syscalls...

IOW, it's a QoI question - sure, NFS is weird and you lose a lot of usual
warranties there when it comes to object removal.  But why get local
fs behaving strangely?  It's not like "decrement i_nlink from 2 to 1" was
cheaper than "assign 0 to i_nlink", after all.

FWIW, a lot of local filesystems have no notion of links; they tend to
maintain zero/non-zero distinction just fine.  Including those that have
all directories with i_nlink == 1 for as long as directory lives.

Anyway, I'm going to send obvious i_nlink fixes (races a-la ext2 one, plus
reiserfs blowing up if it fails in the right place in mkdir, plus hfs fs
corruptor on rename() over non-empty, plus bogosity in udf max links
calculation) in a few, just need to sanitize commit messages and drop
Josh's ext2 patch you've already merged.  About 3/4th through the
audit, there's going to be more fun at least with omfs and btrfs... ;-/
