Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0GJN5r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 09:57:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34753 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab0GJN5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 09:57:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O4DI35dnQez1XHuLkQMz5y0SyEZuhJGmFQZkSxq6sRub7iZW/7oB+ovb4T25N+Yfcn
         baGRKWjVlEVn651RRKw8pCmzfTVgf87SvODJ8GP+GzwEVWR4PkFp8VIl/1q1khEDFQMx
         SG//AyDoPW1yIcKl42PcmX6VzPWHB9hjcwmT4=
Date: Sat, 10 Jul 2010 15:57:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>,
       Jeff Mahoney <jeffm@jeffreymahoney.com>
Subject: Re: reiserfs locking (v2)
Message-ID: <20100710135735.GC5306@nowhere>
References: <20100702093451.GA3973@swordfish.minsk.epam.com> <20100702131248.GA5324@nowhere> <20100703092441.GM31073@ZenIV.linux.org.uk> <20100703094323.GN31073@ZenIV.linux.org.uk> <20100704091523.GP31073@ZenIV.linux.org.uk> <20100709031622.GL6405@nowhere> <20100709104047.GA3965@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100709104047.GA3965@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 01:42:06PM +0300, Sergey Senozhatsky wrote:
> On (07/09/10 05:16), Frederic Weisbecker wrote:
> > On Sun, Jul 04, 2010 at 10:15:23AM +0100, Al Viro wrote:
> > > On Sat, Jul 03, 2010 at 10:43:23AM +0100, Al Viro wrote:
> > > > On Sat, Jul 03, 2010 at 10:24:42AM +0100, Al Viro wrote:
> > > > 
> > > > > Gyah...  For the 1001st time: readdir() is far from being the only thing that
> > > > > nests mmap_sem inside i_mutex.  In particular, write() does the same thing.
> > > > > 
> > > > > So yes, it *is* a real deadlock, TYVM, with no directories involved.  Open the
> > > > > same file twice, mmap one fd, close it, then have munmap() hitting i_mutex
> > > > > in reiserfs_file_release() race with write() through another fd.
> > > > > 
> > > > > Incidentally, reiserfs_file_release() checks in the fastpath look completely
> > > > > bogus.  Checking i_count?  What the hell is that one about?  And no, these
> > > > > checks won't stop open() coming between them and grabbing i_mutex, so they
> > > > > couldn't prevent the deadlock in question anyway.
> > > > 
> > > > ... and unfortunately it's been that way since the the initial merge in 2.4.early.
> > > > FWIW, it seems that i_count check was a misguided attempt to check that no other
> > > > opened struct file are there, but it's
> > > > 	a) wrong, since way, _way_ back - open() affects d_count, not i_count
> > > > 	b) wrong even with such modification (consider hardlinks)
> > > > 	c) wrong for even more reasons since forever - i_count and d_count could
> > > > be bumped by many things at any time
> > > > 	d) hopelessly racy anyway, since another open() could very well have
> > > > happened just as we'd finished these checks.
> > > 
> > > OK...  See 22093b8f3d387f77 in vfs-2.6.git for-next (should propagate to
> > > git.kernel.org shortly).  That ought to deal with this crap, assuming I hadn't
> > > fucked up somewhere...
> > 
> > 
> > Looks good. Thanks for fixing this!
> > 
> 
> Seems to work fine with my test app.
> 
> Reported-by/Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>


Great!

