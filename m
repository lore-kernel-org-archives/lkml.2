Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab2K2OM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:12:56 -0500
Received: from mx2.fusionio.com ([66.114.96.31]:32913 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566Ab2K2OMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:12:53 -0500
X-ASG-Debug-ID: 1354198371-0421b549eb49f30001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Thu, 29 Nov 2012 09:12:49 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] Introduce a method to catch mmap_region (was: Recent
 kernel "mount" slow)
Message-ID: <20121129141249.GB30766@shiny>
X-ASG-Orig-Subj: Re: [PATCH] Introduce a method to catch mmap_region (was: Recent
 kernel "mount" slow)
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Jeff Chua <jeff.chua.linux@gmail.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <Pine.LNX.4.64.1211281422360.26389@file.rdu.redhat.com>
 <CA+55aFyXdtVJ=SG9bU4qfggCR6DPvz4vOFYxKJZx_WdyFv+3Fw@mail.gmail.com>
 <CA+55aFyXS0nkDB95c3pcdg1ctrNnUGO8aDuRNhKSEg3JrOqWhA@mail.gmail.com>
 <Pine.LNX.4.64.1211281540200.5283@file.rdu.redhat.com>
 <CA+55aFwbnQsvpsOLS6w_G35d4w+Ezv5tOx2SE7dShJhX4iP_0Q@mail.gmail.com>
 <Pine.LNX.4.64.1211281904010.3957@file.rdu.redhat.com>
 <CA+55aFz1Wv2S+3XVmZE1cfiN0TZ4gNA8yWbNgufDLTMc8sKf2A@mail.gmail.com>
 <CA+55aFxYCxsRM==WMGihQGOA7f5u2X_8boJypsxS2v=WMnr70g@mail.gmail.com>
 <CA+55aFxrkX_=4yNQ1TwjqU9=pkRY=ud+Kw3YnADJMJxA-ZqQUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+55aFxrkX_=4yNQ1TwjqU9=pkRY=ud+Kw3YnADJMJxA-ZqQUg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1354198371
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.115603
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 11:16:21PM -0700, Linus Torvalds wrote:
> On Wed, Nov 28, 2012 at 6:58 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > But the fact that the code wants to do things like
> >
> >         block = (sector_t)page->index << (PAGE_CACHE_SHIFT - bbits);
> >
> > seriously seems to be the main thing that keeps us using
> > 'inode->i_blkbits'. Calculating bbits from bh->b_size is just costly
> > enough to hurt (not everywhere, but on some machines).
> >
> > Very annoying.
> 
> Hmm. Here's a patch that does that anyway. I'm not 100% happy with the
> whole ilog2 thing, but at the same time, in other cases it actually
> seems to improve code generation (ie gets rid of the whole unnecessary
> two dereferences through page->mapping->host just to get the block
> size, when we have it in the buffer-head that we have to touch
> *anyway*).
> 
> Comments? Again, untested.

Jumping in based on Linus original patch, which is doing something like
this:

set_blocksize() {
	block new calls to writepage, prepare/commit_write
	set the block size
	unblock

	< --- can race in here and find bad buffers --->

	sync_blockdev()
	kill_bdev() 
	
	< --- now we're safe --- >
}

We could add a second semaphore and a page_mkwrite call:

set_blocksize() {

	block new calls to prepare/commit_write and page_mkwrite(), but
	leave writepage unblocked.

	sync_blockev()

	<--- now we're safe.  There are no dirty pages and no ways to
	make new ones ---> 

	block new calls to readpage (writepage too for good luck?)

	kill_bdev()
	set the block size

	unblock readpage/writepage
	unblock prepare/commit_write and page_mkwrite

}

Another way to look at things:

As Linus said in a different email, we don't need to drop the pages, just
the buffers.  Once we've blocked prepare/commit_write,
there is no way to make a partially up to date page with dirty data.
We may make fully uptodate dirty pages, but for those we can
just create dirty buffers for the whole page.

As long as we had prepare/commit write blocked while we ran
sync_blockdev, we can blindly detach any buffers that are the wrong size
and just make new ones.

This may or may not apply to loop.c, I'd have to read that more
carefully.

-chris

