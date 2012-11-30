Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab2K3BQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 20:16:14 -0500
Received: from mx1.fusionio.com ([66.114.96.30]:58997 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813Ab2K3BQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 20:16:12 -0500
X-ASG-Debug-ID: 1354238170-03d6a50cb5c82330001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Thu, 29 Nov 2012 20:16:08 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chris Mason <clmason@fusionio.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Do a proper locking for mmap and block size change
Message-ID: <20121130011608.GA11004@shiny.int.fusionio.com>
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
References: <Pine.LNX.4.64.1211281630150.5283@file.rdu.redhat.com>
 <CA+55aFziCW_ywZACGoVyNSgy8mToAGhSbdo0VoUAaGvgSb2XxQ@mail.gmail.com>
 <CA+55aFxt655WfuhjOCnu3esg3gt=L37v=ofWfjs+qpXjn-F2uA@mail.gmail.com>
 <20121129191503.GB3490@shiny>
 <CA+55aFxaHuxaEezkpmGRi4kFGaQFTv9S89N-hJhxBjVa6ZwnbQ@mail.gmail.com>
 <20121129194840.GC3490@shiny>
 <CA+55aFwGLExQGhhzStMobWzLju0tVjKW9SZphrxp3AJ6w_ZH9g@mail.gmail.com>
 <20121129212931.GD3490@shiny>
 <CA+55aFzeq1HZvEZdmx=f8at2UOWcyp4oZv0RCX4dd0+dthuM1w@mail.gmail.com>
 <CA+55aFwoM3wje+XS60=kE3eVndWQD6szfgYa9MyfSp=itdr9Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+55aFwoM3wje+XS60=kE3eVndWQD6szfgYa9MyfSp=itdr9Vg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1354238170
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.115647
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 03:36:38PM -0700, Linus Torvalds wrote:
> On Thu, Nov 29, 2012 at 2:16 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > But you're right. The direct-IO code really *is* violating that, and
> > knows that get_block() ends up being defined in i_blkbits regardless
> > of b_size.
> 
> It turns out fs/ioctl.c does the same - it fills in the buffer head
> with some random bh->b_size too. I think it's not even a power of two
> in that case.
> 
> And I guess it's understandable - they don't actually *use* the
> buffer, they just want the offset. So the b_size field really is just
> random crap to the users of the get_block interfaces, since they've
> never cared before.
> 
> Ugh, this was definitely a dark and disgusting underbelly of the VFS
> layer. We've not had to really touch it for a *looong* time..

I searched through filemap.c for the magic i_size check that would let
us get away with ignoring i_blkbits in get_blocks, but its just not
there.  The whole fallback-to-buffered scheme seems to rely on
get_blocks checking for i_size.  I really hope I'm just missing
something.

If we're going to change this, I'd vote for something non-bh based.  I
didn't check every single FS, but I don't think direct-IO really wants
or needs buffer heads at all.

One less wart in direct-io.c would really be nice, but I'm assuming
it'll take us at least one full release to hammer out a shiny new
get_blocks.  Passing i_blkbits would be more mechanical, since all the
filesystems would just ignore it.

-chris
