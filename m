Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab0DWPTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:19:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab0DWPTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:19:11 -0400
Date: Fri, 23 Apr 2010 11:18:58 -0400
From: Josef Bacik <josef@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josef Bacik <josef@redhat.com>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
Subject: Re: [PATCH] cleanup block based fiemap
Message-ID: <20100423151857.GD2351@localhost.localdomain>
References: <20100423144420.GC2351@localhost.localdomain> <alpine.LFD.2.00.1004230753480.3739@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004230753480.3739@i5.linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 08:00:35AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 23 Apr 2010, Josef Bacik wrote:
> > 
> > I'm resending this patch again since it doesn't seem to have made it in yet.
> > The generic block fiemap stuff doesn't use the right typing and has a problem
> > with not setting the last extent flag properly.  Also there is an issue with
> > GFS2 where it doesn't like non-block aligned requests, so this fixes all these
> > issues.  Thanks,
> 
> I'd really like the patch to clean up the crazy stuff too.
> 
> As-is, there's at least two remaining issues I see from just reading the 
> patch:
> 
> > +	if (len >= i_size_read(inode)) {
> > +		whole_file = true;
> > +		len = i_size_read(inode);
> > +	}
> ...
> >  			if (!past_eof &&
> >  			    blk_to_logical(inode, start_blk) >=
> > -			    blk_to_logical(inode, 0)+i_size_read(inode))
> > +			    blk_to_logical(inode, 0) + i_size_read(inode))
> >  				past_eof = 1;
> 
> Issue #1: it does that i_size_read() several times. What happens if the 
> file grows? Maybe we hold the i_mutex already, although I don't see it. 
> Regardless, it seems bogus to read the size several times.
> 

__generic_block_fiemap is called by generic_block_fiemap which takes the
i_mutex.  The only reason we have __generic_block_fiemap is because gfs2 needs
to do its own locking magic before we go calling get_block.  The idea is that
the file size doesn't change while we're doing this.

As for reading the size several times, I can read it once and store it in a
local variable if you prefer, but theres no way to know if len is smaller than
the size or not, which is why I'm constantly doing i_size_read().  If thats what
you would prefer I can do that, just let me know.

> Issue #2: "blk_to_logical(inode, 0)"? WTF? Since when has shifting zero 
> ever resulted in anything interesting or relevant? There's at least two of 
> those things.
> 

Umm, yeah I'm sorry?  I have no idea why I did that.  I think its because I was
getting the logical offset of the first block + size, which is just stupid
because the logical offset is 0, so all I can say is I'm sorry that me a year
ago was alot dumber than me now :).  Thanks,

Josef
