Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab2K2WRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:17:14 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57446 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab2K2WRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:17:12 -0500
MIME-Version: 1.0
In-Reply-To: <20121129212931.GD3490@shiny>
References: <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <20121128194314.GF4939@ZenIV.linux.org.uk> <Pine.LNX.4.64.1211281630150.5283@file.rdu.redhat.com>
 <CA+55aFziCW_ywZACGoVyNSgy8mToAGhSbdo0VoUAaGvgSb2XxQ@mail.gmail.com>
 <CA+55aFxt655WfuhjOCnu3esg3gt=L37v=ofWfjs+qpXjn-F2uA@mail.gmail.com>
 <20121129191503.GB3490@shiny> <CA+55aFxaHuxaEezkpmGRi4kFGaQFTv9S89N-hJhxBjVa6ZwnbQ@mail.gmail.com>
 <20121129194840.GC3490@shiny> <CA+55aFwGLExQGhhzStMobWzLju0tVjKW9SZphrxp3AJ6w_ZH9g@mail.gmail.com>
 <20121129212931.GD3490@shiny>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Nov 2012 14:16:50 -0800
X-Google-Sender-Auth: eyQWRw1XjVqydrtY-qoR_Gf5pd0
Message-ID: <CA+55aFzeq1HZvEZdmx=f8at2UOWcyp4oZv0RCX4dd0+dthuM1w@mail.gmail.com>
Subject: Re: [PATCH v2] Do a proper locking for mmap and block size change
To: Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clmason@fusionio.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 1:29 PM, Chris Mason <chris.mason@fusionio.com> wrote:
>
> Just reading the new blkdev_get_blocks, it looks like we're mixing
> shifts.  In direct-io.c map_bh->b_size is how much we'd like to map, and
> it has no relation at all to the actual block size of the device.  The
> interface is abusing b_size to ask for as large a mapping as possible.

Ugh. That's a big violation of how buffer-heads are supposed to work:
the block number is very much defined to be in multiples of b_size
(see for example "submit_bh()" that turns it into a sector number).

But you're right. The direct-IO code really *is* violating that, and
knows that get_block() ends up being defined in i_blkbits regardless
of b_size.

What a crock. That direct-IO code is hack-upon-hack. Whoever wrote it
should be shot.

I think the only sane way to fix is is to pass in the block size to
get_blocks(). Which we admittedly should have done long ago, so that's
not a bad fix, but without actually looking at what it involves, I
think it's going to be pretty big patch. All the filesystems that
support the interface need to update it, even if they can then ignore
it, because direct-IO does all these hacks only for the raw device.

And I think it will improve the interface, but damn, direct-IO is
still horrible for playing these kinds of games.

                    Linus
