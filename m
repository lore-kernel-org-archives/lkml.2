Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab1FTQXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:23:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980Ab1FTQXO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:23:14 -0400
MIME-Version: 1.0
In-Reply-To: <20110620161352.GT11521@ZenIV.linux.org.uk>
References: <20110619235147.GQ11521@ZenIV.linux.org.uk> <BANLkTimdPT2dbTToTHGVzJr=f3xPKT9tZw@mail.gmail.com>
 <20110620161352.GT11521@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Jun 2011 09:22:32 -0700
Message-ID: <BANLkTikUi9M1Mx4L54vJOP0SK0P3yAz=uQ@mail.gmail.com>
Subject: Re: [RFC] get_write_access()/deny_write_access() without inode->i_lock
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 9:13 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Er...  The current mainline does atomic_read() followed by atomic_inc(),
> so we get the same thing (plus the spin_lock()/spin_unlock()), don't we?

Yes. Unless the spinlock is in the same cacheline. No reason not to
fix that, though.

Of course, if the "ETXTBUSY" case is the common case (which I doubt),
then not doing the write at all would be the optimal case. But I doubt
that case is even worth really worrying about ;)

> For get_write_access() it's probably the right assumption for everything but
> /dev/tty*; for deny_write_access() it's not - a lot of binaries are run by
> more than one process...

Note the fact that EVEN IF WE GUESS INCORRECTLY, performance is likely
better by guessing rather than reading, unless you know the thing is
already in the local CPU cache.

Doing the loop twice instead of once is still *much* faster than an
extra cache transaction that goes to the bus (or L3 or whatever).

> FWIW, I wonder what will the things look like on ll/sc architectures;

There are no ll/sc architectures worth worrying about, so I don't
think that's the primary concern.  That said, I don't disagree with
creating a "atomic_inc_unless_negative()" helper.

                     Linus
