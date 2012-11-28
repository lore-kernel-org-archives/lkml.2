Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab2K1UNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:13:51 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36797 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab2K1UNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:13:49 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyXdtVJ=SG9bU4qfggCR6DPvz4vOFYxKJZx_WdyFv+3Fw@mail.gmail.com>
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
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <Pine.LNX.4.64.1211281422360.26389@file.rdu.redhat.com> <CA+55aFyXdtVJ=SG9bU4qfggCR6DPvz4vOFYxKJZx_WdyFv+3Fw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Nov 2012 12:13:27 -0800
X-Google-Sender-Auth: sDql_9u7sYM3Asa5ELsQiRObqr8
Message-ID: <CA+55aFyXS0nkDB95c3pcdg1ctrNnUGO8aDuRNhKSEg3JrOqWhA@mail.gmail.com>
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

On Wed, Nov 28, 2012 at 12:03 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> mmap() is in *no* way special. The exact same thing happens for
> regular read/write. Yet somehow the mmap code is special-cased, while
> the normal read-write code is not.

I just double-checked, because it's been a long time since I actually
looked at the code.

But yeah, block device read/write uses the pure page cache functions.
IOW, it has the *exact* same IO engine as mmap() would have.

So here's my suggestion:

 - get rid of *all* the locking in aio_read/write and the splice paths
 - get rid of all the stupid mmap games

 - instead, add them to the functions that actually use
"blkdev_get_block()" and "blkdev_get_blocks()" and nowhere else.

   That's a fairly limited number of functions:
blkdev_{read,write}page(), blkdev_direct_IO() and
blkdev_write_{begin,end}()

Doesn't that sounds simpler? And more logical: it protects the actual
places that use the block size of the device.

I dunno. Maybe there is some fundamental reason why the above is
broken, but it seems to be a much simpler approach. Sure, you need to
guarantee that the people who get the write-lock cannot possibly cause
IO while holding it, but since the only reason to get the write lock
would be to change the block size, that should be pretty simple, no?

Yeah, yeah, I'm probably missing something fundamental, but the above
sounds like the simple approach to fixing things. Aiming for having
the block size read-lock be taken by the things that pass in the
block-size itself.

It would be nice for things to be logical and straightforward.

                   Linus
