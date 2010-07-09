Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab0GIDQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:16:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48037 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab0GIDQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:16:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i2wo/+ExLaUOfmR1C5eYf64siA2jVp6Ch7xs8dVw6jjJVTX1XOHYIym8qwKsByVhID
         DvJYzI7C21mL0fKpTOxIWsL88KHxRGwXKzI7uL+5DDUAcMeO3IhsUUH+3Sq5/IkQ+w1d
         Mi9buzTaMMBT9hSXNlLlXhvoHbZ7R1cFDfV50=
Date: Fri, 9 Jul 2010 05:16:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Jeff Mahoney <jeffm@jeffreymahoney.com>
Subject: Re: reiserfs locking (v2)
Message-ID: <20100709031622.GL6405@nowhere>
References: <20100702093451.GA3973@swordfish.minsk.epam.com> <20100702131248.GA5324@nowhere> <20100703092441.GM31073@ZenIV.linux.org.uk> <20100703094323.GN31073@ZenIV.linux.org.uk> <20100704091523.GP31073@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100704091523.GP31073@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 04, 2010 at 10:15:23AM +0100, Al Viro wrote:
> On Sat, Jul 03, 2010 at 10:43:23AM +0100, Al Viro wrote:
> > On Sat, Jul 03, 2010 at 10:24:42AM +0100, Al Viro wrote:
> > 
> > > Gyah...  For the 1001st time: readdir() is far from being the only thing that
> > > nests mmap_sem inside i_mutex.  In particular, write() does the same thing.
> > > 
> > > So yes, it *is* a real deadlock, TYVM, with no directories involved.  Open the
> > > same file twice, mmap one fd, close it, then have munmap() hitting i_mutex
> > > in reiserfs_file_release() race with write() through another fd.
> > > 
> > > Incidentally, reiserfs_file_release() checks in the fastpath look completely
> > > bogus.  Checking i_count?  What the hell is that one about?  And no, these
> > > checks won't stop open() coming between them and grabbing i_mutex, so they
> > > couldn't prevent the deadlock in question anyway.
> > 
> > ... and unfortunately it's been that way since the the initial merge in 2.4.early.
> > FWIW, it seems that i_count check was a misguided attempt to check that no other
> > opened struct file are there, but it's
> > 	a) wrong, since way, _way_ back - open() affects d_count, not i_count
> > 	b) wrong even with such modification (consider hardlinks)
> > 	c) wrong for even more reasons since forever - i_count and d_count could
> > be bumped by many things at any time
> > 	d) hopelessly racy anyway, since another open() could very well have
> > happened just as we'd finished these checks.
> 
> OK...  See 22093b8f3d387f77 in vfs-2.6.git for-next (should propagate to
> git.kernel.org shortly).  That ought to deal with this crap, assuming I hadn't
> fucked up somewhere...


Looks good. Thanks for fixing this!

