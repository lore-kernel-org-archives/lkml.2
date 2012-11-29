Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab2K2Tsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:48:45 -0500
Received: from mx1.fusionio.com ([66.114.96.30]:41616 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab2K2Tsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:48:43 -0500
X-ASG-Debug-ID: 1354218522-03d6a57f9b2125c0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Thu, 29 Nov 2012 14:48:40 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chris Mason <clmason@fusionio.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Do a proper locking for mmap and block size change
Message-ID: <20121129194840.GC3490@shiny>
X-ASG-Orig-Subj: Re: [PATCH v2] Do a proper locking for mmap and block size change
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clmason@fusionio.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Jeff Chua <jeff.chua.linux@gmail.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <Pine.LNX.4.64.1211272252260.18338@file.rdu.redhat.com>
 <50B5CC5A.8060607@kernel.dk>
 <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <20121128194314.GF4939@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.1211281630150.5283@file.rdu.redhat.com>
 <CA+55aFziCW_ywZACGoVyNSgy8mToAGhSbdo0VoUAaGvgSb2XxQ@mail.gmail.com>
 <CA+55aFxt655WfuhjOCnu3esg3gt=L37v=ofWfjs+qpXjn-F2uA@mail.gmail.com>
 <20121129191503.GB3490@shiny>
 <CA+55aFxaHuxaEezkpmGRi4kFGaQFTv9S89N-hJhxBjVa6ZwnbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+55aFxaHuxaEezkpmGRi4kFGaQFTv9S89N-hJhxBjVa6ZwnbQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1354218522
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.115625
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 12:26:06PM -0700, Linus Torvalds wrote:
> On Thu, Nov 29, 2012 at 11:15 AM, Chris Mason <chris.mason@fusionio.com> wrote:
> >
> > The fs/buffer.c part makes sense during a quick read.  But
> > fs/direct-io.c plays with i_blkbits too.  The semaphore was fixing real
> > bugs there.
> 
> Ugh. I _hate_ direct-IO. What a mess. And yeah, it seems to be
> incestuously playing games that should be in fs/buffer.c. I thought it
> was doing the sane thing with the page cache.
> 
> (I now realize that Mikulas was talking about this mess, while I
> thought he was talking about the AIO code which is largely sane).

It was all a trick to get you to say the AIO code was sane.

It looks like we could use the private copy of i_blkbits that DIO is
already recording.

blkdev_get_blocks (called during DIO) is also checking i_blkbits, but I
really don't get why that isn't byte based instead.  DIO is already
doing the shift & mask game.

I think only clean_blockdev_aliases is intentionally using the inode's
i_blkbits, but again that shouldn't be changing for filesystems so it
seems safe to use the DIO copy.

-chris

