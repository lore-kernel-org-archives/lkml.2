Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2K2TPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:15:09 -0500
Received: from mx1.fusionio.com ([66.114.96.30]:47923 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab2K2TPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:15:06 -0500
X-ASG-Debug-ID: 1354216505-03d6a57f9b210180001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Thu, 29 Nov 2012 14:15:03 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mikulas Patocka <mpatocka@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Do a proper locking for mmap and block size change
Message-ID: <20121129191503.GB3490@shiny>
X-ASG-Orig-Subj: Re: [PATCH v2] Do a proper locking for mmap and block size change
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Jeff Chua <jeff.chua.linux@gmail.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
 <50B4B313.3030707@kernel.dk>
 <Pine.LNX.4.64.1211272252260.18338@file.rdu.redhat.com>
 <50B5CC5A.8060607@kernel.dk>
 <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <20121128194314.GF4939@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.1211281630150.5283@file.rdu.redhat.com>
 <CA+55aFziCW_ywZACGoVyNSgy8mToAGhSbdo0VoUAaGvgSb2XxQ@mail.gmail.com>
 <CA+55aFxt655WfuhjOCnu3esg3gt=L37v=ofWfjs+qpXjn-F2uA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+55aFxt655WfuhjOCnu3esg3gt=L37v=ofWfjs+qpXjn-F2uA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1354216505
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.115623
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 12:02:17PM -0700, Linus Torvalds wrote:
> On Thu, Nov 29, 2012 at 9:19 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I think I'll apply this for 3.7 (since it's too late to do anything
> > fancier), and then for 3.8 I will rip out all the locking entirely,
> > because looking at the fs/buffer.c patch I wrote up, it's all totally
> > unnecessary.
> >
> > Adding a ACCESS_ONCE() to the read of the i_blkbits value (when
> > creating new buffers) simply makes the whole locking thing pointless.
> > Just make the page lock protect the block size, and make it per-page,
> > and we're done.
> 
> There's a 'block-dev' branch in my git tree, if you guys want to play
> around with it.
> 
> It actually reverts fs/block-dev.c back to the 3.6 state (except for
> some whitespace damage that I refused to re-introduce), so that part
> of the changes should be pretty safe and well tested.
> 
> The fs/buffer.c changes, of course, are new. It's largely the same
> patch I already sent out, with a small helper function to simplify it,
> and to keep the whole ACCESS_ONCE() thing in just a single place.

The fs/buffer.c part makes sense during a quick read.  But
fs/direct-io.c plays with i_blkbits too.  The semaphore was fixing real
bugs there.

-chris
