Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab2K2Gpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:45:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55387 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab2K2Gpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:45:51 -0500
Date: Thu, 29 Nov 2012 06:45:39 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Introduce a method to catch mmap_region (was: Recent
 kernel "mount" slow)
Message-ID: <20121129064539.GL4939@ZenIV.linux.org.uk>
References: <CA+55aFyXS0nkDB95c3pcdg1ctrNnUGO8aDuRNhKSEg3JrOqWhA@mail.gmail.com>
 <Pine.LNX.4.64.1211281540200.5283@file.rdu.redhat.com>
 <CA+55aFwbnQsvpsOLS6w_G35d4w+Ezv5tOx2SE7dShJhX4iP_0Q@mail.gmail.com>
 <Pine.LNX.4.64.1211281904010.3957@file.rdu.redhat.com>
 <CA+55aFz1Wv2S+3XVmZE1cfiN0TZ4gNA8yWbNgufDLTMc8sKf2A@mail.gmail.com>
 <CA+55aFxYCxsRM==WMGihQGOA7f5u2X_8boJypsxS2v=WMnr70g@mail.gmail.com>
 <CA+55aFxrkX_=4yNQ1TwjqU9=pkRY=ud+Kw3YnADJMJxA-ZqQUg@mail.gmail.com>
 <20121129062519.GI4939@ZenIV.linux.org.uk>
 <20121129063043.GJ4939@ZenIV.linux.org.uk>
 <CA+55aFwL9-yOfCHskXyiCJ3YKB0MgaOJ5-XrvWBtH+URCowfcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwL9-yOfCHskXyiCJ3YKB0MgaOJ5-XrvWBtH+URCowfcg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 10:37:27PM -0800, Linus Torvalds wrote:
> On Wed, Nov 28, 2012 at 10:30 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Note that sync_blockdev() a few lines prior to that is good only if we
> > have no other processes doing write(2) (or dirtying the mmapped pages,
> > for that matter).  The window isn't too wide, but...
> 
> So with Mikulas' patches, the write actually would block (at write
> level) due to the locking. The mmap'ed patches may be around and
> flushed, but the logic to not allow currently *active* mmaps (with the
> rather nasty random -EBUSY return value) should mean that there is no
> race.
> 
> Or rather, there's a race, but it results in that EBUSY thing.

Same as with fs mounted on it, or the sucker having been claimed for
RAID array, etc.  Frankly, I'm more than slightly tempted to make
bdev mmap() just claim the sodding device exclusive for as long as
it's mmapped...

In principle, I agree, but...  I still have nightmares from mmap/truncate
races way back.  You are stepping into what used to be a really nasty
minefield.  I'll look into that, but it's *definitely* not -rc8 fodder.
