Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1FTQN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:13:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35352 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1FTQNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:13:53 -0400
Date: Mon, 20 Jun 2011 17:13:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] get_write_access()/deny_write_access() without
 inode->i_lock
Message-ID: <20110620161352.GT11521@ZenIV.linux.org.uk>
References: <20110619235147.GQ11521@ZenIV.linux.org.uk>
 <BANLkTimdPT2dbTToTHGVzJr=f3xPKT9tZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimdPT2dbTToTHGVzJr=f3xPKT9tZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 08:55:38AM -0700, Linus Torvalds wrote:
> On Sun, Jun 19, 2011 at 4:51 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > ? ? ? ?I'm seriously tempted to throw away i_lock uses in
> > {get,deny}_write_access(), as in the patch below. ?The question is, how
> > badly will it suck on various architectures? ?I'd expect it to be not
> > worse than the current version, but...
> 
> It might be worse, because doing a read-before-write can turn a single
> cache operation ("get for write") into multiple cache operations ("get
> for read" followed by "make exclusive").

Er...  The current mainline does atomic_read() followed by atomic_inc(),
so we get the same thing (plus the spin_lock()/spin_unlock()), don't we?

> We had that exact issue with some other users of the "read + cmpxchg" model.
> 
> The way we fixed it before was to simply omit the read, and turn that
> into a "guess".
>
> In other words, I'd suggest you get rid of the "atomic_read()"
> entirely, and just assume that the write counter was zero to begin
> with. Even if that is a wrong assumption (and it probably isn't all
> that wrong), it can actually be more efficient to essentiall go
> through the loop twice: the first time yoou use the cmpxchg as just an
> odd way to do a read. It basically bcomes a read-with-write-intent,
> and solves the cacheline issue.

For get_write_access() it's probably the right assumption for everything but
/dev/tty*; for deny_write_access() it's not - a lot of binaries are run by
more than one process...

FWIW, I wonder what will the things look like on ll/sc architectures;
maybe it's really better to turn that into atomic_inc_unless_negative()
and let the architectures override the default...
