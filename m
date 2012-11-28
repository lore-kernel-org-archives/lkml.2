Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab2K1UDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:03:47 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55966 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab2K1UDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:03:45 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1211281422360.26389@file.rdu.redhat.com>
References: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com>
 <20121120180949.GG1408@quack.suse.cz> <CAAJw_ZsQdLO5qLdGPzmPf+N2D6CZw+S-4mvRGnxfARL71LuRaw@mail.gmail.com>
 <CAAJw_ZsAyB0z0TF1mqPz1Z+H+tg7W6LVzNLKf0BkuF3u8TTMuQ@mail.gmail.com>
 <CA+55aFyvT3R3kgwJzp9mY5eE1fwMnzXnmBpHSbqjd-eJRVDkJw@mail.gmail.com>
 <50AF7901.20401@kernel.dk> <CAAJw_ZvXGKcjfOAS_tRdXJ9SjpCKw1t7rNt+Q=ieCkVJwN2qcg@mail.gmail.com>
 <Pine.LNX.4.64.1211241555470.4300@file.rdu.redhat.com> <CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
 <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
 <50B46E05.70906@kernel.dk> <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
 <50B4B313.3030707@kernel.dk> <Pine.LNX.4.64.1211272252260.18338@file.rdu.redhat.com>
 <50B5CC5A.8060607@kernel.dk> <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com> <Pine.LNX.4.64.1211281422360.26389@file.rdu.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Nov 2012 12:03:23 -0800
X-Google-Sender-Auth: mDKaFUeQJVHB-RNQSaXjDsVVFck
Message-ID: <CA+55aFyXdtVJ=SG9bU4qfggCR6DPvz4vOFYxKJZx_WdyFv+3Fw@mail.gmail.com>
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

On Wed, Nov 28, 2012 at 11:50 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> mmap_region() doesn't care about the block size. But a lot of
> page-in/page-out code does.

That seems a bogus argument.

mmap() is in *no* way special. The exact same thing happens for
regular read/write. Yet somehow the mmap code is special-cased, while
the normal read-write code is not.

I suspect it might be *easier* to trigger some issues with mmap, but
that still isn't a good enough reason to special-case it. We don't add
locking to one please just because that one place shows some race
condition more easily. We fix the locking.

So for example, maybe the code that *actually* cares about the buffer
size (the stuff that allocates buffers in fs/buffer.c) needs to take
that new percpu read lock. Basically, any caller of
"alloc_page_buffers()/create_empty_buffers()" or whatever.

I also wonder whether we need it *at*all*. I suspect that we could
easily have multiple block-sizes these days for the same block device.
It *used* to be (millions of years ago, when dinosaurs roamed the
earth) that the block buffers were global and shared with all users of
a partition. But that hasn't been true since we started using the page
cache, and I suspect that some of the block size changing issues are
simply entirely stale.

Yeah, yeah, there could be some coherency issues if people write to
the block device through different block sizes, but I think we have
those coherency issues anyway. The page-cache is not coherent across
different mapping inodes anyway.

So I really suspect that some of this is "legacy logic". Or at least
perhaps _should_ be.

                    Linus
