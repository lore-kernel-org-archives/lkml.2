Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab2K1XOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 18:14:15 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64081 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab2K1XOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 18:14:14 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwbnQsvpsOLS6w_G35d4w+Ezv5tOx2SE7dShJhX4iP_0Q@mail.gmail.com>
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
 <CA+55aFyXS0nkDB95c3pcdg1ctrNnUGO8aDuRNhKSEg3JrOqWhA@mail.gmail.com>
 <Pine.LNX.4.64.1211281540200.5283@file.rdu.redhat.com> <CA+55aFwbnQsvpsOLS6w_G35d4w+Ezv5tOx2SE7dShJhX4iP_0Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Nov 2012 15:13:52 -0800
X-Google-Sender-Auth: HXJUXJWQ1SX9ci0ltEK_G-NpdFw
Message-ID: <CA+55aFy_i2HzrXoKsLwuvUbF6=GSGsWxHDczi_grZ7u022xYJw@mail.gmail.com>
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

On Wed, Nov 28, 2012 at 2:52 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>> For example, __block_write_full_page and __block_write_begin do
>>         if (!page_has_buffers(page)) { create_empty_buffers... }
>> and then they do
>>         WARN_ON(bh->b_size != blocksize)
>>         err = get_block(inode, block, bh, 1)
>
> Right. And none of this is new.

.. which, btw, is not to say that *other* things aren't new. They are.

The change to actually change the block device buffer size before then
calling "sync_bdev()" is definitely a real change, and as mentioned, I
have not tested the patch in any way. If any block device driver were
to actually compare the IO size they get against the bdev->block_size
thing, they'd see very different behavior (ie they'd see the new block
size as they are asked to write old the old blocks with the old block
size).

So it does change semantics, no question about that. I don't think any
block device does it, though.

A bigger issue is for things that emulate what blkdev.c does, and
doesn't do the locking. I see code in md/bitmap.c that seems a bit
suspicious, for example. That said, it's not *new* breakage, and the
"lock at mmap/read/write() time" approach doesn't fix it either (since
the mapping will be different for the underlying MD device). So I do
think that we should take a look at all the users of
"alloc_page_buffers()" and "create_empty_buffers()" to see what *they*
do to protect the block-size, but I think that's an independent issue
from the raw device access case in fs/block_dev.c..

I guess I have to actually test my patch. I don't have very
interesting test-cases, though.

                       Linus
