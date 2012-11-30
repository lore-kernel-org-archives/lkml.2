Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118Ab2K3ObP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 09:31:15 -0500
Received: from mx2.fusionio.com ([66.114.96.31]:58192 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933011Ab2K3ObN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 09:31:13 -0500
X-ASG-Debug-ID: 1354285872-0421b508a94d5a0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Fri, 30 Nov 2012 09:31:10 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Dave Chinner <david@fromorbit.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clmason@fusionio.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Do a proper locking for mmap and block size change
Message-ID: <20121130143110.GD11004@shiny.int.fusionio.com>
X-ASG-Orig-Subj: Re: [PATCH v2] Do a proper locking for mmap and block size change
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Dave Chinner <david@fromorbit.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clmason@fusionio.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Jeff Chua <jeff.chua.linux@gmail.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121130024910.GF6434@dastard>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1354285872
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.115701
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 07:49:10PM -0700, Dave Chinner wrote:
> On Thu, Nov 29, 2012 at 02:16:50PM -0800, Linus Torvalds wrote:
> > On Thu, Nov 29, 2012 at 1:29 PM, Chris Mason <chris.mason@fusionio.com> wrote:
> > >
> > > Just reading the new blkdev_get_blocks, it looks like we're mixing
> > > shifts.  In direct-io.c map_bh->b_size is how much we'd like to map, and
> > > it has no relation at all to the actual block size of the device.  The
> > > interface is abusing b_size to ask for as large a mapping as possible.
> > 
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

I guess the good news is that block devices don't have readpages.  The
bad news would be that we can't put readpages in without much bigger
changes.

-chris
