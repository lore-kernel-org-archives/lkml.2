Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab2K2SM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 13:12:57 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:39064 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab2K2SMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 13:12:53 -0500
MIME-Version: 1.0
In-Reply-To: <20121129175102.GA3490@shiny>
References: <CA+55aFyXdtVJ=SG9bU4qfggCR6DPvz4vOFYxKJZx_WdyFv+3Fw@mail.gmail.com>
 <CA+55aFyXS0nkDB95c3pcdg1ctrNnUGO8aDuRNhKSEg3JrOqWhA@mail.gmail.com>
 <Pine.LNX.4.64.1211281540200.5283@file.rdu.redhat.com> <CA+55aFwbnQsvpsOLS6w_G35d4w+Ezv5tOx2SE7dShJhX4iP_0Q@mail.gmail.com>
 <Pine.LNX.4.64.1211281904010.3957@file.rdu.redhat.com> <CA+55aFz1Wv2S+3XVmZE1cfiN0TZ4gNA8yWbNgufDLTMc8sKf2A@mail.gmail.com>
 <CA+55aFxYCxsRM==WMGihQGOA7f5u2X_8boJypsxS2v=WMnr70g@mail.gmail.com>
 <CA+55aFxrkX_=4yNQ1TwjqU9=pkRY=ud+Kw3YnADJMJxA-ZqQUg@mail.gmail.com>
 <20121129141249.GB30766@shiny> <CA+55aFzYzLKGfb3vw7A4y1NU2XB4DFmVp4UnYqPJafufaNqhEg@mail.gmail.com>
 <20121129175102.GA3490@shiny>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Nov 2012 10:12:30 -0800
X-Google-Sender-Auth: 15LEIywonH80M2xM6pqqFwF5Cm8
Message-ID: <CA+55aFzh_8HExAxaivwVFyyHTJu2R3Y=QL2r7T_7ht+yYPfzLw@mail.gmail.com>
Subject: Re: [PATCH] Introduce a method to catch mmap_region (was: Recent
 kernel "mount" slow)
To: Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clmason@fusionio.com>,
        Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 9:51 AM, Chris Mason <chris.mason@fusionio.com> wrote:
>
> The bigger question is do we have users that expect to be able to set
> the blocksize after mmaping the block device (no writes required)?  I
> actually feel a little bad for taking up internet bandwidth asking, but
> it is a change in behaviour.

Yeah, it is. That said, I don't think people will really notice.
Nobody mmap's block devices outside of some databases, afaik, and
nobody sane mounts a partition at the same time a DB is using it. So I
think the new EBUSY check is *ugly*, but I don't realistically believe
that it is a problem.  The ugliness of the locking is why I'm not a
huge fan of it, but if it works I can live with it.

But yes, the mmap tests are new with the locking, and could in theory
be problematic if somebody reports that it breaks anything.

And like the locking, they'd just go away if we just do the
fs/buffer.c approach instead. Because doing things in fs/buffer.c
simply means that we don't care (and serialization is provided by the
page lock on a per-page basis, which is what mmap relies on anyway).

So doing the per-page fs/buffer.c approach (along with the
"ACCESS_ONCE()" on inode->i_blkbits to make sure we get *one*
consistent value, even if we don't care *which* value it is) would
basically revert to all the old semantics. The only thing it would
change is that we wouldn't see oopses.

(And in theory, it would allow us to actively mix-and-match different
block sizes for a block device, but realistically I don't think there
are any actual users of that - although I could imagine that a
filesystem would use a smaller block size for file tail-blocks etc,
and still want to use the fs/buffer.c code, so it's *possible* that it
would be useful, but filesystems have been able to do things like that
by just doing their buffers by hand anyway, so it's not really
fundamentally new, just a possible generalization of code)

                    Linus
