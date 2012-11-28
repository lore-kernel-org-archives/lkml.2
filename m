Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab2K1Tvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:51:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294Ab2K1Tvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:51:46 -0500
Date: Wed, 28 Nov 2012 14:50:56 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jens Axboe <axboe@kernel.dk>, Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Introduce a method to catch mmap_region (was: Recent
 kernel "mount" slow)
In-Reply-To: <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1211281422360.26389@file.rdu.redhat.com>
References: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com>
 <20121120180949.GG1408@quack.suse.cz> <CAAJw_ZsQdLO5qLdGPzmPf+N2D6CZw+S-4mvRGnxfARL71LuRaw@mail.gmail.com>
 <CAAJw_ZsAyB0z0TF1mqPz1Z+H+tg7W6LVzNLKf0BkuF3u8TTMuQ@mail.gmail.com>
 <CA+55aFyvT3R3kgwJzp9mY5eE1fwMnzXnmBpHSbqjd-eJRVDkJw@mail.gmail.com>
 <50AF7901.20401@kernel.dk> <CAAJw_ZvXGKcjfOAS_tRdXJ9SjpCKw1t7rNt+Q=ieCkVJwN2qcg@mail.gmail.com>
 <Pine.LNX.4.64.1211241555470.4300@file.rdu.redhat.com>
 <CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
 <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
 <50B46E05.70906@kernel.dk> <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
 <50B4B313.3030707@kernel.dk> <Pine.LNX.4.64.1211272252260.18338@file.rdu.redhat.com>
 <50B5CC5A.8060607@kernel.dk> <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Nov 2012, Linus Torvalds wrote:

> No, this is crap.
> 
> We don't introduce random hooks like this just because the block layer
> has shit-for-brains and cannot be bothered to do things right.
> 
> The fact is, the whole locking in the block layer open routine is
> total and utter crap. It doesn't lock the right thing, even with your
> change *anyway* (or with the change Jens had). Absolutely nothing in
> "mmap_region()" cares at all about the block-size anywhere - it's
> generic, after all - so locking around it is f*cking pointless. There
> is no way in hell that the caller of ->mmap can *ever* care about the
> block size, since it never even looks at it.
> 
> Don't do random crap like this.
> 
> Why does the code think that mmap matters so much anyway? As you say,
> the mmap itself does *nothing*. It has no impact for the block size.
> 
>                  Linus

mmap_region() doesn't care about the block size. But a lot of 
page-in/page-out code does.

The problem is that once the block device is mapped, page faults or page 
writeback can happen anytime - so the simplest solution is to not allow 
the block device being mapped while we change block size.

The function set_blocksize takes bd_block_size_semaphore for write (that 
blocks read/write/mmap), then it calls sync_blockdev (now we are sure that 
there is no more writeback), then it changes the block size, then it calls 
kill_bdev (now we are sure that there are no more any pages with buffers 
with the old blocksize).

If you want to allow to change block size while a block device is mapped, 
you'd have to add explicit locks around all mm callbacks (so that the 
block size can't change while the callback is in progress) - and even 
then, there are some unsolvable cases - i.e. what are you going to do if 
the user mlocks a mapped block device and you change block size of that 
device? - you can't drop the pages (that would violate mlock semantics) 
and you can leave them there (because they have buffers with wrong size).

If you don't like what I sent, propose a different solution.

Mikulas
