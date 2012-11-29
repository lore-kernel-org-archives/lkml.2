Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab2K2GeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:34:21 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:53947 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2K2GeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:34:20 -0500
MIME-Version: 1.0
In-Reply-To: <20121129062519.GI4939@ZenIV.linux.org.uk>
References: <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <Pine.LNX.4.64.1211281422360.26389@file.rdu.redhat.com> <CA+55aFyXdtVJ=SG9bU4qfggCR6DPvz4vOFYxKJZx_WdyFv+3Fw@mail.gmail.com>
 <CA+55aFyXS0nkDB95c3pcdg1ctrNnUGO8aDuRNhKSEg3JrOqWhA@mail.gmail.com>
 <Pine.LNX.4.64.1211281540200.5283@file.rdu.redhat.com> <CA+55aFwbnQsvpsOLS6w_G35d4w+Ezv5tOx2SE7dShJhX4iP_0Q@mail.gmail.com>
 <Pine.LNX.4.64.1211281904010.3957@file.rdu.redhat.com> <CA+55aFz1Wv2S+3XVmZE1cfiN0TZ4gNA8yWbNgufDLTMc8sKf2A@mail.gmail.com>
 <CA+55aFxYCxsRM==WMGihQGOA7f5u2X_8boJypsxS2v=WMnr70g@mail.gmail.com>
 <CA+55aFxrkX_=4yNQ1TwjqU9=pkRY=ud+Kw3YnADJMJxA-ZqQUg@mail.gmail.com> <20121129062519.GI4939@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Nov 2012 22:33:58 -0800
X-Google-Sender-Auth: yjXSR3r_R7cKgvEKgW3lYkOXNVk
Message-ID: <CA+55aFwOLQg38wp8bdwBYo=c6xr0RcztgpXW0UJstk7+v8WpTg@mail.gmail.com>
Subject: Re: [PATCH] Introduce a method to catch mmap_region (was: Recent
 kernel "mount" slow)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 10:25 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>         Umm...  set_blocksize() is calling kill_bdev(), which does
> truncate_inode_pages(mapping, 0).  What's going to happen to data in
> the dirty pages?  IO in progress is not the only thing to worry about...

Hmm. Yes. I think it works by virtue of "if you change the blocksize
while there is active IO, you're insane and you deserve whatever you
get".

It shouldn't even be fundamentally hard to make it work, although I
suspect it would be more code than it would be worth. The sane model
would be to not use truncate_inode_pages(), but instead just walk the
pages and get rid of the buffer heads with the wrong size. Preferably
*combining* that with the sync_blockdev().

We have no real reason to even invalidate the page cache, it's just
the buffers we want to get rid of.

But I suspect it's true that none of that is really *worth* it,
considering that nobody likely wants to do any concurrent IO. We don't
want to crash, or corrupt the data structures, but I suspect "you get
what you deserve" might actually be the right model ;)

So the current "sync_blockdev()+kill_bdev()" takes care of the *sane*
case (we flush any data that happened *before* the block size change),
and any concurrent writes with block-size changes are "good luck with
that".

              Linus
