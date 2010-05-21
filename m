Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab0EUJiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:38:00 -0400
Received: from b.painless.aaisp.net.uk ([81.187.30.52]:50160 "EHLO
	b.painless.aaisp.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab0EUJh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:37:59 -0400
X-Greylist: delayed 2229 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 May 2010 05:37:58 EDT
Subject: Re: [RFC] new ->perform_write fop
From: Steven Whitehouse <steve@chygwyn.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100520230524.GU8120@dastard>
References: <20100514064145.GJ13617@dastard> <20100514072219.GC4706@laptop>
	 <20100514083821.GL13617@dastard> <20100518063647.GD2516@laptop>
	 <20100518080503.GF2150@dastard> <20100518104351.GF2516@laptop>
	 <20100518122714.GG2150@dastard> <20100518150912.GI2516@laptop>
	 <20100519235054.GS8120@dastard> <20100520201232.GP3395@quack.suse.cz>
	 <20100520230524.GU8120@dastard>
Content-Type: text/plain; charset="UTF-8"
Organization: ChyGwyn Limited
Date: Fri, 21 May 2010 10:05:10 +0100
Message-ID: <1274432710.2578.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2010-05-21 at 09:05 +1000, Dave Chinner wrote:
> On Thu, May 20, 2010 at 10:12:32PM +0200, Jan Kara wrote:
> > On Thu 20-05-10 09:50:54, Dave Chinner wrote:
> > > On Wed, May 19, 2010 at 01:09:12AM +1000, Nick Piggin wrote:
> > > > On Tue, May 18, 2010 at 10:27:14PM +1000, Dave Chinner wrote:
> > > > 
> > > > Is it really going to be a problem to implement block hole punching
> > > > in ext4 and gfs2?
> > > 
[snip]
> >   b) E.g. ext4 can do even without hole punching. It can allocate extent
> >      as 'unwritten' and when something during the write fails, it just
> >      leaves the extent allocated and the 'unwritten' flag makes sure that
> >      any read will see zeros. I suppose that other filesystems that care
> >      about multipage writes are able to do similar things (e.g. btrfs can
> >      do the same as far as I remember, I'm not sure about gfs2).
> 
> Allocating multipage writes as unwritten extents turns off delayed
> allocation and hence we'd lose all the benefits that this gives...

It should be possible to implement hole punching in GFS2 I think. The
main issue is locking order of resource groups. We have on our todo list
a rewrite of the truncate/delete code which is currently used to
deallocate data blocks and metadata tree blocks. The current algorithm
is a rather inefficient recursive scanning of the tree which is done
multiple times depending on the tree height.

Adapting that to punch holes should be possible without too much effort
if we need to do that. We do need to allow for the possibility that such
a deallocation might have to be split into multiple transactions
depending on the amount of metadata involved (for large files, this
could be larger than the size of the log for example). Currently the
code will split up truncates into multiple transactions which allows the
deallocation to be restartable from any transaction boundary.

GFS2 does not have any way to mark unwritten extents, so we cannot do
delayed allocation or implement an efficient fallocate. We can do better
performance-wise than just dd'ing zeros to a file for fallocate, but
we'll never be able to match a fs that can mark extents unwritten in
performance terms,

Steve.


