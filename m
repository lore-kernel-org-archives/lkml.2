Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945898Ab2K1WxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 17:53:00 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51247 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509Ab2K1Ww6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 17:52:58 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1211281540200.5283@file.rdu.redhat.com>
References: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com>
 <CA+55aFyvT3R3kgwJzp9mY5eE1fwMnzXnmBpHSbqjd-eJRVDkJw@mail.gmail.com>
 <50AF7901.20401@kernel.dk> <CAAJw_ZvXGKcjfOAS_tRdXJ9SjpCKw1t7rNt+Q=ieCkVJwN2qcg@mail.gmail.com>
 <Pine.LNX.4.64.1211241555470.4300@file.rdu.redhat.com> <CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
 <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
 <50B46E05.70906@kernel.dk> <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
 <50B4B313.3030707@kernel.dk> <Pine.LNX.4.64.1211272252260.18338@file.rdu.redhat.com>
 <50B5CC5A.8060607@kernel.dk> <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <Pine.LNX.4.64.1211281422360.26389@file.rdu.redhat.com> <CA+55aFyXdtVJ=SG9bU4qfggCR6DPvz4vOFYxKJZx_WdyFv+3Fw@mail.gmail.com>
 <CA+55aFyXS0nkDB95c3pcdg1ctrNnUGO8aDuRNhKSEg3JrOqWhA@mail.gmail.com> <Pine.LNX.4.64.1211281540200.5283@file.rdu.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Nov 2012 14:52:36 -0800
X-Google-Sender-Auth: ofyVYOviIjyq2yV87LnltoCPf8s
Message-ID: <CA+55aFwbnQsvpsOLS6w_G35d4w+Ezv5tOx2SE7dShJhX4iP_0Q@mail.gmail.com>
Subject: Re: [PATCH] Introduce a method to catch mmap_region (was: Recent
 kernel "mount" slow)
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 1:29 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> The problem with this approach is that it is very easy to miss points
> where it is assumed that the block size doesn't change - and if you miss a
> point, it results in a hidden bug that has a little possibility of being
> found.

Umm. Mikulas, *your* approach has resulted in bugs. So let's not throw
stones in glass houses, shall we?

The whole reason for this long thread (and several threads before it)
is that your model isn't working and is causing problems. I already
pointed out how bogus your arguments about mmap() locking were, and
then you have the gall to talk about potential bugs, when I have
pointed you to *actual* bugs, and actual mistakes.

> For example, __block_write_full_page and __block_write_begin do
>         if (!page_has_buffers(page)) { create_empty_buffers... }
> and then they do
>         WARN_ON(bh->b_size != blocksize)
>         err = get_block(inode, block, bh, 1)

Right. And none of this is new.

> ... so if the buffers were left over from some previous call to
> create_empty_buffers with a different blocksize, that WARN_ON is trigged.

None of this can happen.

> Locking the whole read/write/mmap operations is crude, but at least it can
> be done without thorough review of all the memory management code.

Umm. Which you clearly didn't do, and raised totally crap arguments for.

In contrast, I have a very simple argument for the correctness of my
patch: every single user of the "get_block[s]()" interface now takes
the lock for as long as get_block[s]() is passed off to somebody else.
And since get_block[s]() is the only way to create those empty
buffers, I think I pretty much proved exactly what you ask for.

And THAT is the whole point and advantage of making locking sane. Sane
locking you can actually *think* about!

In contrast, locking around "mmap()" is absolutely *guaranteed* to be
insane, because mmap() doesn't actually do any of the IO that the lock
is supposed to protect against!

So Mikulas, quite frankly, your arguments argue against you. When you
say "Locking the whole read/write/mmap operations is crude, but at
least it can
be done without thorough", you are doubly correct: it *is* crude, and
it clearly *was* done without thought, since it's a f*cking idiotic
AND INCORRECT thing to do.

Seriously. Locking around "mmap()" is insane. It leads to insane
semantics (the whole EBUSY thing is purely because of that problem)
and it leads to bad code (your "let's add a new "mmap_region" hook is
just disgusting, and while Al's idea of doing it in the existing
"->open" method is at least not nasty, it's definitely extra code and
complexity).

There are serious *CORRECTNESS* advantages to simplicity and
directness. And locking at the right point is definitely very much
part of that.

Anyway, as far as block size goes, we have exactly two cases:

 - random IO that does not care about the block size, and will just do
whatever the current block size is (ie normal anonymous accesses to
the block device).  This is the case that needs the locking - but it
only needs it around the individual page operations, ie exactly where
I put it. In fact, they can happily deal with different block sizes
for different pages, they don't really care.

 - mounted filesystems etc that require a particular block size and
set it at mount time, and they have exclusivity rules

The second case is the case that actually calls set_blocksize(), and
if "kill_bdev()" doesn't get rid of the old blocksizes, then they have
always been in trouble, and would always _continue_ to be in trouble,
regardless of locking.

                    Linus
