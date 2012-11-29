Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2K2RvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 12:51:08 -0500
Received: from mx2.fusionio.com ([66.114.96.31]:41135 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab2K2RvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 12:51:05 -0500
X-ASG-Debug-ID: 1354211464-0421b52b7d4a760001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Thu, 29 Nov 2012 12:51:02 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chris Mason <clmason@fusionio.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] Introduce a method to catch mmap_region (was: Recent
 kernel "mount" slow)
Message-ID: <20121129175102.GA3490@shiny>
X-ASG-Orig-Subj: Re: [PATCH] Introduce a method to catch mmap_region (was: Recent
 kernel "mount" slow)
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clmason@fusionio.com>,
	Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Jeff Chua <jeff.chua.linux@gmail.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <CA+55aFyXdtVJ=SG9bU4qfggCR6DPvz4vOFYxKJZx_WdyFv+3Fw@mail.gmail.com>
 <CA+55aFyXS0nkDB95c3pcdg1ctrNnUGO8aDuRNhKSEg3JrOqWhA@mail.gmail.com>
 <Pine.LNX.4.64.1211281540200.5283@file.rdu.redhat.com>
 <CA+55aFwbnQsvpsOLS6w_G35d4w+Ezv5tOx2SE7dShJhX4iP_0Q@mail.gmail.com>
 <Pine.LNX.4.64.1211281904010.3957@file.rdu.redhat.com>
 <CA+55aFz1Wv2S+3XVmZE1cfiN0TZ4gNA8yWbNgufDLTMc8sKf2A@mail.gmail.com>
 <CA+55aFxYCxsRM==WMGihQGOA7f5u2X_8boJypsxS2v=WMnr70g@mail.gmail.com>
 <CA+55aFxrkX_=4yNQ1TwjqU9=pkRY=ud+Kw3YnADJMJxA-ZqQUg@mail.gmail.com>
 <20121129141249.GB30766@shiny>
 <CA+55aFzYzLKGfb3vw7A4y1NU2XB4DFmVp4UnYqPJafufaNqhEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+55aFzYzLKGfb3vw7A4y1NU2XB4DFmVp4UnYqPJafufaNqhEg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1354211464
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.115619
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 10:26:56AM -0700, Linus Torvalds wrote:
> On Thu, Nov 29, 2012 at 6:12 AM, Chris Mason <chris.mason@fusionio.com> wrote:
> >
> > Jumping in based on Linus original patch, which is doing something like
> > this:
> >
> > set_blocksize() {
> >         block new calls to writepage, prepare/commit_write
> >         set the block size
> >         unblock
> >
> >         < --- can race in here and find bad buffers --->
> >
> >         sync_blockdev()
> >         kill_bdev()
> >
> >         < --- now we're safe --- >
> > }
> >
> > We could add a second semaphore and a page_mkwrite call:
> 
> Yeah, we could be fancy, but the more I think about it, the less I can
> say I care.
> 
> After all, the only things that do the whole set_blocksize() thing should be:
> 
>  - filesystems at mount-time
> 
>  - things like loop/md at block device init time.
> 
> and quite frankly, if there are any *concurrent* writes with either of
> the above, I really *really* don't think we should care. I mean,
> seriously.
> 
> So the _only_ real reason for the locking in the first place is to
> make sure of internal kernel consistency. We do not want to oops or
> corrupt memory if people do odd things. But we really *really* don't
> care if somebody writes to a partition at the same time as somebody
> else mounts it. Not enough to do extra work to please insane people.
> 
> It's also worth noting that NONE OF THIS HAS EVER WORKED IN THE PAST.
> The whole sequence always used to be unlocked. The locking is entirely
> new. There is certainly not any legacy users that can possibly rely on
> "I did writes at the same time as the mount with no serialization, and
> it worked". It never has worked.
> 
> So I think this is a case of "perfect is the enemy of good".
> Especially since I think that with the fs/buffer.c approach, we don't
> actually need any locking at all at higher levels.

The bigger question is do we have users that expect to be able to set
the blocksize after mmaping the block device (no writes required)?  I
actually feel a little bad for taking up internet bandwidth asking, but
it is a change in behaviour.

Regardless, changing mmap for a race in the page cache is just backwards, and
with the current 3.7 code, we can still trigger the race with fadvise ->
readpage in the middle of set_blocksize()

Obviously nobody does any of this, otherwise we'd have tons of reports
from those handy WARN_ONs in fs/buffer.c.  So its definitely hard to be
worried one way or another.

-chris
