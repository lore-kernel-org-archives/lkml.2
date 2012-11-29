Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab2K2TvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:51:07 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64123 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab2K2TvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:51:04 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxaHuxaEezkpmGRi4kFGaQFTv9S89N-hJhxBjVa6ZwnbQ@mail.gmail.com>
References: <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
 <50B4B313.3030707@kernel.dk> <Pine.LNX.4.64.1211272252260.18338@file.rdu.redhat.com>
 <50B5CC5A.8060607@kernel.dk> <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <20121128194314.GF4939@ZenIV.linux.org.uk> <Pine.LNX.4.64.1211281630150.5283@file.rdu.redhat.com>
 <CA+55aFziCW_ywZACGoVyNSgy8mToAGhSbdo0VoUAaGvgSb2XxQ@mail.gmail.com>
 <CA+55aFxt655WfuhjOCnu3esg3gt=L37v=ofWfjs+qpXjn-F2uA@mail.gmail.com>
 <20121129191503.GB3490@shiny> <CA+55aFxaHuxaEezkpmGRi4kFGaQFTv9S89N-hJhxBjVa6ZwnbQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Nov 2012 11:50:43 -0800
X-Google-Sender-Auth: bGcfawbIc9fdJWLaSiB-qaziCt8
Message-ID: <CA+55aFztXAXB+MQvtUZSv9t1kET+yfFpBELZ7qxcPV-_u80Hew@mail.gmail.com>
Subject: Re: [PATCH v2] Do a proper locking for mmap and block size change
To: Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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

On Thu, Nov 29, 2012 at 11:26 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> (I now realize that Mikulas was talking about this mess, while I
> thought he was talking about the AIO code which is largely sane).

Oh wow.

The direct-IO code really doesn't seem to care at all. I don't think
it needs locking either (it seems to do everything with a private
buffer-head), and the problem appears solely to be that it reads
i_blksize multiple times, so changing it just happens to confuse the
direct-io code.

If it were to read it only once, and then use that value, it looks
like it should all JustWork(tm).

And the right thing to do would seem to just add it to the
"dio_submit" structure, that we already have. And it already *has* a
blkbits field, but that's the "IO blocksize", not the "getblocks
blocksize", if I read that mess correctly.

Of course, it then *ALREADY* has that "blkfactor" thing, which is the
difference between i_blkbits and blktbits, so it effective *does* have
i_blkbits already in the dio_submit structure. But despite it all, it
keeps re-reading i_blksize.

Christ. That code is a mess.

              Linus
