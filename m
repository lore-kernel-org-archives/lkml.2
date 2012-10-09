Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2JIWod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 18:44:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48202 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab2JIWob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 18:44:31 -0400
Date: Tue, 9 Oct 2012 15:44:28 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 4/5] aio: vmap ringbuffer
Message-ID: <20121009224428.GH29494@google.com>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-4-git-send-email-koverstreet@google.com>
 <20121009182949.GO26187@lenny.home.zabbo.net>
 <20121009213111.GE29494@google.com>
 <20121009223210.GR26187@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009223210.GR26187@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 03:32:10PM -0700, Zach Brown wrote:
> > If it is measurable I'll take another stab at using memory from
> > __get_free_pages() for the ringbuffer. That really would be the ideal
> > solution.
> 
> No, then you'll run into high order allocation failures with rings that
> don't fit in a single page.

Not if we decouple the ringbuffer size from max_requests.

This would be useful to do anyways because right now, allocating a kiocb
has to take a global refcount and check head and tail in the ringbuffer
just so it can avoid overflowing the ringbuffer.

If we change aio_complete() so that if the ringbuffer is full then the
kiocb just goes on a linked list - we can size the ringbuffer so this
doesn't happen normally and avoid the global synchronization in the fast
path.

> > The other reason I wanted to do this was for the aio attributes stuff -
> > for return values, I think the only sane way is for the return values to
> > go in the ringbuffer, which means records are no longer fixed size so
> > dealing with pages is even more of a pain.
> 
> Then let's see that, please.

I was starting on that, but then I got sidetracked with refactoring...
:P

> And can we please stop calling them attributes?  They're inputs and
> outputs that change behaviour -- they're interfaces.

Attributes isn't a good name but neither is interfaces, because they
don't exist on their own; they're always attached to some other
interface.

I dunno.

> And no, just for the record, I don't think generic packed variable size
> structs are worth the trouble.
> 
> If we're going to do a generic interface extension mechanism then we
> should put it in its own well thought out system calls, not staple it on
> to the side of aio because it's there.  It's a really crummy base to
> work from.

Not arguing with you about aio, but most of the use cases I have for it
want aio.

So unless we're going to deprecate the existing aio interfaces and make
something better (I wouldn't complain about that!) I do need to make it
work with aio.

Not that I'm opposed to new syscalls passing attributes to sync versions
of read/write/etc, I just haven't started that yet or really thought
about it.
