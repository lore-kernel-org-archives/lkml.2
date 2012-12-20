Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750972Ab2LTHEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 02:04:24 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:16332 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750781Ab2LTHER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 02:04:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al8LAAK40lB5LG3x/2dsb2JhbAA8CLdrhgcXc4IeAQEEAScTHCMFCwgDDgouFCUDIROIDQW4aRSMORYBhCwDlgmJToZ7gwiBUQ
Date: Thu, 20 Dec 2012 18:03:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: Are there u32 atomic bitops? (or dealing w/ i_flags)
Message-ID: <20121220070323.GU15182@dastard>
References: <CALCETrXs15M-cJRGD_R7fXBxOXR=Pyqsh2dVC78DgShxwn60nA@mail.gmail.com>
 <20121218015705.GH4939@ZenIV.linux.org.uk>
 <CALCETrUHF40CJYi1=aWpqhW9qkxUDQNt9LAAGoWA57YXowdr_w@mail.gmail.com>
 <20121218213043.GF15182@dastard>
 <CALCETrV9fEfTVbiSzai2dvk6MWwDhsD_nAKs7Z1JP0ZkF-eruw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV9fEfTVbiSzai2dvk6MWwDhsD_nAKs7Z1JP0ZkF-eruw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 02:20:06PM -0800, Andy Lutomirski wrote:
> On Tue, Dec 18, 2012 at 1:30 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Dec 17, 2012 at 06:42:44PM -0800, Andy Lutomirski wrote:
> >> On Mon, Dec 17, 2012 at 5:57 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >> > On Mon, Dec 17, 2012 at 05:10:21PM -0800, Andy Lutomirski wrote:
> >> >> I want to change inode->i_flags access to be atomic -- there are some
> >> >> locking oddities right now, I think, and I want to use a new inode
> >> >> flag to signal mtime updates from page_mkwrite.  The problem is that
> >> >> i_flags is an unsigned int, and making it an unsigned long seems like
> >> >> a waste, but there aren't any u32 atomic bitops.
> >> >
> >> > ... and atomic accesses cost more.  A lot more on some architectures.
> >> > FWIW, atomic_t *is* 32bit on 32bit architectures, which still doesn't
> >> > make it a good idea.
> >>
> >> Are atomic_set_mask and atomic_clear_mask as fast as set_bit and
> >> friends on all archs?
> >>
> >> In any case, i_flags looks like it's rarely written, so I find it a
> >> bit hard to believe that making it atomic would hurt.  Isn't
> >> atomic_read equivalent to non-atomic reads everywhere?
> >>
> >> I want page_mkwrite to set a flag (without taking i_mutex) but *not*
> >> call file_update_time and then to have the writeback paths update the
> >> inode time.
> >
> > Deadlocks ahoy!
> >
> > We don't currently take the i_mutex anywhere in the writeback path
> > as the writeback path is nested inside the i_mutex. Hence this seems
> > like an extremely dangerous thing to do...
> 
> Hmm.
> 
> This can all be made fs-specific: page_mkclean_file sets a bit in the
> inode flags or inode state or address_space_flags.  (The latter might
> be nice -- it's already atomic and I think there are plenty of bits
> free.)  Then a filesystem could stop calling file_update_time in
> ->page_mkwrite and instead test-clear that bit in ->writepage.

writepage happens with pages locked. There's a limit to what you can
do in a filesystem while a page is locked, and you most certainly
don't want to be taking the i_mutex at that point...

> At that point, maybe the fs knows it's safe to mark the inode dirty
> and update times.  (The actual time fields don't seem to be uniformly
> protected by any lock.)  Can ext4_mark_inode_dirty be called from
> ->writepage?

Probably, but that's a filesystem internal function that has to be
called from with a valid transaction handle.

The fact you are conerned about this function tells me something
important - that you aren't having problems with i_mutex (show me
where i_mutex is taken on the page_mkwrite path ;), but you are
having latency problems with the ext4 .dirty_inode method starting a
new transaction when it is called from mark_inode_dirty_sync().

So, a filesystem specific problem, perhaps?

> Filesystems that haven't been converted can will continue to update
> times in ->page_mkwrite.

You don't need to change this at all. If you have ext4
implement .update_timestamp to do whatever timestamp trickery you
want and avoid ext4 starting a new transaction in .dirty_inode for
pure timestamp updates, you can move the timestamp update into the
ext4 writeback path. The ext4 writeback path is already quite
special, so I'm sure people would welcome another weird behaviour
being added to it :)

IOWs, what you want to do doesn't seem to require any changes to the
generic code.  Just make it do timestamp updates in a manner similar
to XFS and btrfs, and you can handle it all completely internally to
the filesystem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
