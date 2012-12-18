Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab2LRVav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:30:51 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:10739 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754203Ab2LRVat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:30:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYMABXg0FB5LGZj/2dsb2JhbABFhVKyVYV+F3OCHgEBBScTHCMQCAMOCi4UJQMhE4gSuEoUjDWDYmEDlgmJToZ7gwg
Date: Wed, 19 Dec 2012 08:30:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: Are there u32 atomic bitops? (or dealing w/ i_flags)
Message-ID: <20121218213043.GF15182@dastard>
References: <CALCETrXs15M-cJRGD_R7fXBxOXR=Pyqsh2dVC78DgShxwn60nA@mail.gmail.com>
 <20121218015705.GH4939@ZenIV.linux.org.uk>
 <CALCETrUHF40CJYi1=aWpqhW9qkxUDQNt9LAAGoWA57YXowdr_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUHF40CJYi1=aWpqhW9qkxUDQNt9LAAGoWA57YXowdr_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 06:42:44PM -0800, Andy Lutomirski wrote:
> On Mon, Dec 17, 2012 at 5:57 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Mon, Dec 17, 2012 at 05:10:21PM -0800, Andy Lutomirski wrote:
> >> I want to change inode->i_flags access to be atomic -- there are some
> >> locking oddities right now, I think, and I want to use a new inode
> >> flag to signal mtime updates from page_mkwrite.  The problem is that
> >> i_flags is an unsigned int, and making it an unsigned long seems like
> >> a waste, but there aren't any u32 atomic bitops.
> >
> > ... and atomic accesses cost more.  A lot more on some architectures.
> > FWIW, atomic_t *is* 32bit on 32bit architectures, which still doesn't
> > make it a good idea.
> 
> Are atomic_set_mask and atomic_clear_mask as fast as set_bit and
> friends on all archs?
> 
> In any case, i_flags looks like it's rarely written, so I find it a
> bit hard to believe that making it atomic would hurt.  Isn't
> atomic_read equivalent to non-atomic reads everywhere?
> 
> I want page_mkwrite to set a flag (without taking i_mutex) but *not*
> call file_update_time and then to have the writeback paths update the
> inode time.

Deadlocks ahoy!

We don't currently take the i_mutex anywhere in the writeback path
as the writeback path is nested inside the i_mutex. Hence this seems
like an extremely dangerous thing to do...

> (This, along with stable pages, is the major cause of
> long sleeps in my application.)  OTOH, maybe I should just use i_state
> and i_lock for this.

Or, perhaps, export O_CMTIME to fcntl and/or open?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
