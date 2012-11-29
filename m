Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab2K2V3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:29:36 -0500
Received: from mx2.fusionio.com ([66.114.96.31]:60419 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879Ab2K2V3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:29:34 -0500
X-ASG-Debug-ID: 1354224573-0421b549eb4c1f0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Thu, 29 Nov 2012 16:29:31 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chris Mason <clmason@fusionio.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Do a proper locking for mmap and block size change
Message-ID: <20121129212931.GD3490@shiny>
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
References: <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <20121128194314.GF4939@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.1211281630150.5283@file.rdu.redhat.com>
 <CA+55aFziCW_ywZACGoVyNSgy8mToAGhSbdo0VoUAaGvgSb2XxQ@mail.gmail.com>
 <CA+55aFxt655WfuhjOCnu3esg3gt=L37v=ofWfjs+qpXjn-F2uA@mail.gmail.com>
 <20121129191503.GB3490@shiny>
 <CA+55aFxaHuxaEezkpmGRi4kFGaQFTv9S89N-hJhxBjVa6ZwnbQ@mail.gmail.com>
 <20121129194840.GC3490@shiny>
 <CA+55aFwGLExQGhhzStMobWzLju0tVjKW9SZphrxp3AJ6w_ZH9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+55aFwGLExQGhhzStMobWzLju0tVjKW9SZphrxp3AJ6w_ZH9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1354224573
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.115633
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 01:52:22PM -0700, Linus Torvalds wrote:
> On Thu, Nov 29, 2012 at 11:48 AM, Chris Mason <chris.mason@fusionio.com> wrote:
> >
> > It was all a trick to get you to say the AIO code was sane.
> 
> It's only sane compared to the DIO code.
> 
> That said, I hate AIO much less these days that we've largely merged
> the code with the regular IO. It's still a horrible interface, but at
> least it is no longer a really disgusting separate implementation in
> the kernel of that horrible interface.
> 
> So yeah, I guess AIO really is pretty sane these days.
> 
> > It looks like we could use the private copy of i_blkbits that DIO is
> > already recording.
> 
> Yes. But that didn't fix the blkdev_get_blocks() mess you pointed out.
> 
> I've pushed out two more commits to the 'block-dev' branch at
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux block-dev
> 
> in case anybody wants to take a look.
> 
> It is - as usual - entirely untested. It compiles, and I *think* that
> blkdev_get_blocks() makes a whole lot more sense this way - as you
> said, it should be byte-based (although it actually does the block
> number conversion because I worried about overflow - probably
> unnecessarily).
> 
> Comments?

Your blkdev_get_blocks emails were great reading while at the dentist,
thanks for helping me pass the time.

Just reading the new blkdev_get_blocks, it looks like we're mixing
shifts.  In direct-io.c map_bh->b_size is how much we'd like to map, and
it has no relation at all to the actual block size of the device.  The
interface is abusing b_size to ask for as large a mapping as possible.

Most importantly, it has no relation to the fs_startblk that we pass in,
which is based on inode->i_blkbits.

So your new check in blkdev_get_blocks:

               if (iblock >= end_block) {

Is wrong because iblock and end_block are based on different sizes.  I
think we have to do the eof checks inside fs/direct-io.c or change the
get_blocks interface completely.

I really thought fs/direct-io.c was already doing eof checks, but I'm
reading harder.

-chris

