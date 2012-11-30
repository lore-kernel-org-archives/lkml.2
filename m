Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab2K3Qgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:36:37 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50511
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932954Ab2K3Qgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:36:36 -0500
Date: Fri, 30 Nov 2012 11:36:01 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Chris Mason <clmason@fusionio.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Do a proper locking for mmap and block size change
Message-ID: <20121130163601.GA32238@infradead.org>
References: <Pine.LNX.4.64.1211281630150.5283@file.rdu.redhat.com>
 <CA+55aFziCW_ywZACGoVyNSgy8mToAGhSbdo0VoUAaGvgSb2XxQ@mail.gmail.com>
 <CA+55aFxt655WfuhjOCnu3esg3gt=L37v=ofWfjs+qpXjn-F2uA@mail.gmail.com>
 <20121129191503.GB3490@shiny>
 <CA+55aFxaHuxaEezkpmGRi4kFGaQFTv9S89N-hJhxBjVa6ZwnbQ@mail.gmail.com>
 <20121129194840.GC3490@shiny>
 <CA+55aFwGLExQGhhzStMobWzLju0tVjKW9SZphrxp3AJ6w_ZH9g@mail.gmail.com>
 <20121129212931.GD3490@shiny>
 <CA+55aFzeq1HZvEZdmx=f8at2UOWcyp4oZv0RCX4dd0+dthuM1w@mail.gmail.com>
 <20121130024910.GF6434@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130024910.GF6434@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 01:49:10PM +1100, Dave Chinner wrote:
> > Ugh. That's a big violation of how buffer-heads are supposed to work:
> > the block number is very much defined to be in multiples of b_size
> > (see for example "submit_bh()" that turns it into a sector number).
> > 
> > But you're right. The direct-IO code really *is* violating that, and
> > knows that get_block() ends up being defined in i_blkbits regardless
> > of b_size.
> 
> Same with mpage_readpages(), so it's not just direct IO that has
> this problem....

The mpage code may actually fall back to BHs.

I have a version of the direct I/O code that uses the iomap_ops from the
multi-page write code that you originally started.  It uses the new op
as primary interface for direct I/O and provides a helper for
filesystems that still use buffer heads internally.  I'll try to dust it
off and send out a version for the current kernel.

