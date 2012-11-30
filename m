Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab2K3CtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 21:49:15 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:21428 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753467Ab2K3CtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 21:49:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AskLANkduFB5LN4a/2dsb2JhbABEhUO0SYV7F3OCHgEBBScTHBwHEAgDGC4UJQMhE4gPvzAUjCyDYGEDlgCQRYMG
Date: Fri, 30 Nov 2012 13:49:10 +1100
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <chris.mason@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Do a proper locking for mmap and block size change
Message-ID: <20121130024910.GF6434@dastard>
References: <20121128194314.GF4939@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.1211281630150.5283@file.rdu.redhat.com>
 <CA+55aFziCW_ywZACGoVyNSgy8mToAGhSbdo0VoUAaGvgSb2XxQ@mail.gmail.com>
 <CA+55aFxt655WfuhjOCnu3esg3gt=L37v=ofWfjs+qpXjn-F2uA@mail.gmail.com>
 <20121129191503.GB3490@shiny>
 <CA+55aFxaHuxaEezkpmGRi4kFGaQFTv9S89N-hJhxBjVa6ZwnbQ@mail.gmail.com>
 <20121129194840.GC3490@shiny>
 <CA+55aFwGLExQGhhzStMobWzLju0tVjKW9SZphrxp3AJ6w_ZH9g@mail.gmail.com>
 <20121129212931.GD3490@shiny>
 <CA+55aFzeq1HZvEZdmx=f8at2UOWcyp4oZv0RCX4dd0+dthuM1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzeq1HZvEZdmx=f8at2UOWcyp4oZv0RCX4dd0+dthuM1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 02:16:50PM -0800, Linus Torvalds wrote:
> On Thu, Nov 29, 2012 at 1:29 PM, Chris Mason <chris.mason@fusionio.com> wrote:
> >
> > Just reading the new blkdev_get_blocks, it looks like we're mixing
> > shifts.  In direct-io.c map_bh->b_size is how much we'd like to map, and
> > it has no relation at all to the actual block size of the device.  The
> > interface is abusing b_size to ask for as large a mapping as possible.
> 
> Ugh. That's a big violation of how buffer-heads are supposed to work:
> the block number is very much defined to be in multiples of b_size
> (see for example "submit_bh()" that turns it into a sector number).
> 
> But you're right. The direct-IO code really *is* violating that, and
> knows that get_block() ends up being defined in i_blkbits regardless
> of b_size.

Same with mpage_readpages(), so it's not just direct IO that has
this problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
