Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab2K2C7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 21:59:05 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57230 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab2K2C7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 21:59:02 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz1Wv2S+3XVmZE1cfiN0TZ4gNA8yWbNgufDLTMc8sKf2A@mail.gmail.com>
References: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com>
 <Pine.LNX.4.64.1211241555470.4300@file.rdu.redhat.com> <CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
 <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
 <50B46E05.70906@kernel.dk> <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
 <50B4B313.3030707@kernel.dk> <Pine.LNX.4.64.1211272252260.18338@file.rdu.redhat.com>
 <50B5CC5A.8060607@kernel.dk> <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <Pine.LNX.4.64.1211281422360.26389@file.rdu.redhat.com> <CA+55aFyXdtVJ=SG9bU4qfggCR6DPvz4vOFYxKJZx_WdyFv+3Fw@mail.gmail.com>
 <CA+55aFyXS0nkDB95c3pcdg1ctrNnUGO8aDuRNhKSEg3JrOqWhA@mail.gmail.com>
 <Pine.LNX.4.64.1211281540200.5283@file.rdu.redhat.com> <CA+55aFwbnQsvpsOLS6w_G35d4w+Ezv5tOx2SE7dShJhX4iP_0Q@mail.gmail.com>
 <Pine.LNX.4.64.1211281904010.3957@file.rdu.redhat.com> <CA+55aFz1Wv2S+3XVmZE1cfiN0TZ4gNA8yWbNgufDLTMc8sKf2A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Nov 2012 18:58:40 -0800
X-Google-Sender-Auth: 4ceIZ8ozpPvwNHYn7V3BKwLz1eg
Message-ID: <CA+55aFxYCxsRM==WMGihQGOA7f5u2X_8boJypsxS2v=WMnr70g@mail.gmail.com>
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

On Wed, Nov 28, 2012 at 6:04 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Interesting. The code *has* the block size (it's in "bh->b_size"), but
> it actually then uses the inode blocksize instead, and verifies the
> two against each other. It could just have used the block size
> directly (and then used the inode i_blkbits only when no buffers
> existed), avoiding that dependency entirely..

Looking more at this code, that really would be the nicest solution.

There's two cases for the whole get_block() thing:

 - filesystems. The block size will not change randomly, and
"get_block()" seriously depends on the block size.

 - the raw device. The block size *will* change, but to simplify the
problem, "get_block()" is a 1:1 mapping, so it doesn't even care about
the block size because it will always return "bh->b_blocknr = nr".

So we *could* just say that all the fs/buffer.c code should use
"inode->i_blkbits" for creating buffers (because that's the size new
buffers should always use), but use "bh->b_size" for any *existing*
buffer use.

And looking at it, it's even simple. Except for one *very* annoying
thing: several users really don't want the size of the buffer, they
really do want the *shift* of the buffer size.

In fact, that single issue seems to be the reason why
"inode->i_blkbits" is really used in fs/buffer.c.

Otherwise it would be fairly trivial to just make the pattern be just a simple

        if (!page_has_buffers(page))
                create_empty_buffers(page, 1 << inode->i_blkbits, 0);
        head = page_buffers(page);
        blocksize = head->b_size;

and just use the blocksize that way, without any other games. All
done, no silly WARN_ON() to verify against some global block-size, and
the fs/buffer.c code would be perfectly simple, and would have no
problem at all with multiple different blocksizes in different pages
(the page lock serializes the buffers and thus the blocksize at the
per-page level).

But the fact that the code wants to do things like

        block = (sector_t)page->index << (PAGE_CACHE_SHIFT - bbits);

seriously seems to be the main thing that keeps us using
'inode->i_blkbits'. Calculating bbits from bh->b_size is just costly
enough to hurt (not everywhere, but on some machines).

Very annoying.

                       Linus
