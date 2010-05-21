Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab0EUS65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 14:58:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:53395 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758279Ab0EUS64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 14:58:56 -0400
Date: Fri, 21 May 2010 20:58:46 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100521185846.GD10149@quack.suse.cz>
References: <20100514072219.GC4706@laptop>
 <20100514083821.GL13617@dastard>
 <20100518063647.GD2516@laptop>
 <20100518080503.GF2150@dastard>
 <20100518104351.GF2516@laptop>
 <20100518122714.GG2150@dastard>
 <20100518150912.GI2516@laptop>
 <20100519235054.GS8120@dastard>
 <20100520201232.GP3395@quack.suse.cz>
 <20100520230524.GU8120@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100520230524.GU8120@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 21-05-10 09:05:24, Dave Chinner wrote:
> On Thu, May 20, 2010 at 10:12:32PM +0200, Jan Kara wrote:
> >   Hmm, I was thinking about it and I see two options how to get out
> > of problems:
> >   a) Filesystems which are not able to handle hole punching will allow
> >      multipage writes only after EOF (which can be easily undone by
> >      truncate in case of failure). That should actually cover lots of
> >      cases we are interested in (I don't expect multipage writes to holes
> >      to be a common case).
> 
> multipage writes to holes is a relatively common operation in the
> HPC space that XFS is designed for (e.g. calculations on huge sparse
> matrices), so I'm not really fond of this idea....
  Well, XFS could still handle them because it is able to do hole punching
but I get your point.

> >   b) E.g. ext4 can do even without hole punching. It can allocate extent
> >      as 'unwritten' and when something during the write fails, it just
> >      leaves the extent allocated and the 'unwritten' flag makes sure that
> >      any read will see zeros. I suppose that other filesystems that care
> >      about multipage writes are able to do similar things (e.g. btrfs can
> >      do the same as far as I remember, I'm not sure about gfs2).
> 
> Allocating multipage writes as unwritten extents turns off delayed
> allocation and hence we'd lose all the benefits that this gives...
  Ah, sorry. That was a short-circuit in my brain. But when we do delayed
I don't see why we should actually do any hole punching... The write needs
to:
  a) reserve enough blocks for the write - I don't know about other
filesystems but for ext4 this means just incrementing a counter.
  b) copy data page by page
  c) release part of reservation (i.e. decrement counter) if we actually
copied less than we originally thought.

  Am I missing something?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
