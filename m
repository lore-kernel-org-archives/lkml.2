Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1FTQmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:42:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53612 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab1FTQmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:42:13 -0400
Date: Mon, 20 Jun 2011 17:42:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] get_write_access()/deny_write_access() without
 inode->i_lock
Message-ID: <20110620164211.GV11521@ZenIV.linux.org.uk>
References: <20110619235147.GQ11521@ZenIV.linux.org.uk>
 <BANLkTimdPT2dbTToTHGVzJr=f3xPKT9tZw@mail.gmail.com>
 <20110620161352.GT11521@ZenIV.linux.org.uk>
 <BANLkTikUi9M1Mx4L54vJOP0SK0P3yAz=uQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikUi9M1Mx4L54vJOP0SK0P3yAz=uQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 09:22:32AM -0700, Linus Torvalds wrote:
> On Mon, Jun 20, 2011 at 9:13 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Er... ?The current mainline does atomic_read() followed by atomic_inc(),
> > so we get the same thing (plus the spin_lock()/spin_unlock()), don't we?
> 
> Yes. Unless the spinlock is in the same cacheline. No reason not to
> fix that, though.
> 
> Of course, if the "ETXTBUSY" case is the common case (which I doubt),
> then not doing the write at all would be the optimal case. But I doubt
> that case is even worth really worrying about ;)

It isn't, unless your box is spinning in attempts to do something like
opening /bin/sh for write.  In which case you've got worse problems ;-)
> 
> > For get_write_access() it's probably the right assumption for everything but
> > /dev/tty*; for deny_write_access() it's not - a lot of binaries are run by
> > more than one process...
> 
> Note the fact that EVEN IF WE GUESS INCORRECTLY, performance is likely
> better by guessing rather than reading, unless you know the thing is
> already in the local CPU cache.
> 
> Doing the loop twice instead of once is still *much* faster than an
> extra cache transaction that goes to the bus (or L3 or whatever).
> 
> > FWIW, I wonder what will the things look like on ll/sc architectures;
> 
> There are no ll/sc architectures worth worrying about, so I don't
> think that's the primary concern.  That said, I don't disagree with
> creating a "atomic_inc_unless_negative()" helper.

OK...  Let me see if I got it right:
static inline int atomic_inc_unless_negative(atomic_t *p)
{
	int v, v1;
	for (v = 0; v >= 0; v = v1) {
		v1 = atomic_cmpxchg(p, v, v + 1);
		if (v == v1)
			return 1;
	}
	return 0;
}
with get_write_access(inode) becoming
	return atomic_inc_unless_negative(&inode->i_writecount) ? 0 : -ETXTBUSY;
and similar for atomic_dec_unless_positive()/deny_write_access()?

BTW, atomic_add_unless/atomic_inc_not_zero is done as read/cmpxchg on
everything I've checked, including alpha and sparc.  I suspect that
it's seriously suboptimal there...
