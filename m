Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab2K1UsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:48:23 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49042 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab2K1UsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:48:20 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFw+9FRKZRe4-eSE3m9rGNfiUMM4-QETHizwYCRso_=bsg@mail.gmail.com>
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
 <CA+55aFyXS0nkDB95c3pcdg1ctrNnUGO8aDuRNhKSEg3JrOqWhA@mail.gmail.com> <CA+55aFw+9FRKZRe4-eSE3m9rGNfiUMM4-QETHizwYCRso_=bsg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Nov 2012 12:47:58 -0800
X-Google-Sender-Auth: LMNmL3FB1_phV3ZW7YEDlrVuxno
Message-ID: <CA+55aFwzEs3F6-n-Q=DrJgCScYwQ29PVZdCrGAO2y+FPC3Eq=Q@mail.gmail.com>
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

On Wed, Nov 28, 2012 at 12:32 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Here is a *COMPLETELY* untested patch. Caveat emptor. It will probably
> do unspeakable things to your family and pets.

Btw, *if* this approach works, I suspect we could just switch the
bd_block_size_semaphore semaphore to be a regular rw-sem.

Why? Because now it's no longer ever gotten in the cached IO paths, we
only get it when we're doing much more expensive things (ie actual IO,
and buffer head allocations etc etc). As long as we just work with the
page cache, we never get to the whole lock at all.

Which means that the whole percpu-optimized thing is likely no longer
all that relevant.

But that's an independent thing, and it's only true *if* my patch
works. It looks fine on paper, but maybe there's something
fundamentally broken about it.

One big change my patch does is to move the sync_bdev/kill_bdev to
*after* changing the block size. It does that so that it can guarantee
that any old data (which didn't see the new block size) will be
sync'ed even if there is new IO coming in as we change the block size.

The old code locked the whole sync() region, which doesn't work with
my approach, since the sync will do IO and would thus cause potential
deadlocks while holding the rwsem for writing.

So with this patch, as the block size changes, you can actually have
some old pages with the old block size *and* some different new pages
with the new  block size all at the same time. It should all be
perfectly fine, but it's worth pointing out.

(It probably won't trigger in practice, though, since doing IO while
somebody else is changing the blocksize is fundamentally an odd thing
to do, but whatever. I also suspect that we *should* perhaps use the
inode->i_sem thing to serialize concurrent block size changes, but
that's again an independent issue)

                           Linus
