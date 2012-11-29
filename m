Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab2K2CNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 21:13:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab2K2CNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 21:13:52 -0500
Date: Wed, 28 Nov 2012 20:20:14 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jens Axboe <axboe@kernel.dk>, Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] Introduce a method to catch mmap_region (was: Recent
 kernel "mount" slow)
In-Reply-To: <CA+55aFy_i2HzrXoKsLwuvUbF6=GSGsWxHDczi_grZ7u022xYJw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1211282011110.3957@file.rdu.redhat.com>
References: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com>
 <CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
 <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
 <50B46E05.70906@kernel.dk> <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
 <50B4B313.3030707@kernel.dk> <Pine.LNX.4.64.1211272252260.18338@file.rdu.redhat.com>
 <50B5CC5A.8060607@kernel.dk> <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <Pine.LNX.4.64.1211281422360.26389@file.rdu.redhat.com>
 <CA+55aFyXdtVJ=SG9bU4qfggCR6DPvz4vOFYxKJZx_WdyFv+3Fw@mail.gmail.com>
 <CA+55aFyXS0nkDB95c3pcdg1ctrNnUGO8aDuRNhKSEg3JrOqWhA@mail.gmail.com>
 <Pine.LNX.4.64.1211281540200.5283@file.rdu.redhat.com>
 <CA+55aFwbnQsvpsOLS6w_G35d4w+Ezv5tOx2SE7dShJhX4iP_0Q@mail.gmail.com>
 <CA+55aFy_i2HzrXoKsLwuvUbF6=GSGsWxHDczi_grZ7u022xYJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Nov 2012, Linus Torvalds wrote:

> A bigger issue is for things that emulate what blkdev.c does, and
> doesn't do the locking. I see code in md/bitmap.c that seems a bit
> suspicious, for example. That said, it's not *new* breakage, and the
> "lock at mmap/read/write() time" approach doesn't fix it either (since
> the mapping will be different for the underlying MD device). So I do
> think that we should take a look at all the users of
> "alloc_page_buffers()" and "create_empty_buffers()" to see what *they*
> do to protect the block-size, but I think that's an independent issue
> from the raw device access case in fs/block_dev.c..
> 
> I guess I have to actually test my patch. I don't have very
> interesting test-cases, though.
> 
>                        Linus

Yes, it md looks suspicious. It disables write access in 
deny_bitmap_write_access (that functions looks buggy on its own - what 
happens if i_writecount == 0 or if it is already negative on entry?).

So we could disallow changing block size if i_writecount < 0, that should 
do the trick.

Mikulas
