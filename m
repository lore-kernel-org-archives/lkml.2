Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab2LPE0k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 23:26:40 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:56271 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752295Ab2LPE0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 23:26:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak4MACJMzVB5LIoV/2dsb2JhbABFhVKyeoYGF3OCHgEBBAE6HCMFCwgDDgouFCUDIROIDQW7CRSMSYRDA5YJkEmDBw
Date: Sun, 16 Dec 2012 15:26:36 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fadvise: perform WILLNEED readahead in a workqueue
Message-ID: <20121216042636.GL9806@dastard>
References: <20121215005448.GA7698@dcvr.yhbt.net>
 <20121216024520.GH9806@dastard>
 <20121216030442.GA28172@dcvr.yhbt.net>
 <20121216033601.GJ9806@dastard>
 <20121216035953.GA30689@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121216035953.GA30689@dcvr.yhbt.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 03:59:53AM +0000, Eric Wong wrote:
> Dave Chinner <david@fromorbit.com> wrote:
> > On Sun, Dec 16, 2012 at 03:04:42AM +0000, Eric Wong wrote:
> > > Dave Chinner <david@fromorbit.com> wrote:
> > > > On Sat, Dec 15, 2012 at 12:54:48AM +0000, Eric Wong wrote:
> > > > > 
> > > > >  Before: fadvise64(3, 0, 0, POSIX_FADV_WILLNEED) = 0 <2.484832>
> > > > >   After: fadvise64(3, 0, 0, POSIX_FADV_WILLNEED) = 0 <0.000061>
> > > > 
> > > > You've basically asked fadvise() to readahead the entire file if it
> > > > can. That means it is likely to issue enough readahead to fill the
> > > > IO queue, and that's where all the latency is coming from. If all
> > > > you are trying to do is reduce the latency of the first read, then
> > > > only readahead the initial range that you are going to need to read...
> > > 
> > > Yes, I do want to read the whole file, eventually.  So I want to put
> > > the file into the page cache ASAP and allow the disk to spin down.
> > 
> > Issuing readahead is not going to speed up the first read. Either
> > you will spend more time issuing all the readahead, or you block
> > waiting for the first read to complete. And the way you are issuing
> > readahead does not guarantee the entire file is brought into the
> > page cache....
> 
> I'm not relying on readahead to speed up the first read.
> 
> By using fadvise/readahead, I want a _best-effort_ attempt to
> keep the file in cache.
> 
> > > But I also want the first read() to be fast.
> > 
> > You can't have a pony, sorry.
> 
> I want the first read() to happen sooner than it would under current
> fadvise. 

You're not listening.  You do not need the kernel to be modified to
avoid the latency of issuing 1GB of readahead on a file.

You don't need to do readahead before the first read. Nor do you do
need to wait for 1GB of readhead to be issued before you do the
first read.

You could do readahead *concurrently* with the first read, so the
first read only blocks until the readahead of the first part of the
file completes.  i.e. just do readahead() in a background thread and
don't wait for it to complete before doing the first read.

You could even do readahead *after* the first read, when the time it
takes *doesn't matter* to the processing of the incoming data...

> I want "less-bad" initial latency than I was getting.

And you can do that by changing how you issue readahead from
userspace.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
