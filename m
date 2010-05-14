Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab0ENNfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 09:35:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27232 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab0ENNfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 09:35:37 -0400
Date: Fri, 14 May 2010 09:33:15 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@suse.de>, Josef Bacik <josef@redhat.com>,
       linux-fsdevel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100514133315.GN30710@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>, Nick Piggin <npiggin@suse.de>,
	Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	hch@infradead.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20100512212403.GE3597@localhost.localdomain>
 <20100513013926.GD27011@dhcp231-156.rdu.redhat.com>
 <20100514010042.GI13617@dastard>
 <20100514033057.GL27011@dhcp231-156.rdu.redhat.com>
 <20100514064145.GJ13617@dastard>
 <20100514072219.GC4706@laptop>
 <20100514083821.GL13617@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514083821.GL13617@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4BED516B.006C:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 06:38:21PM +1000, Dave Chinner wrote:
> On Fri, May 14, 2010 at 05:22:19PM +1000, Nick Piggin wrote:
> > On Fri, May 14, 2010 at 04:41:45PM +1000, Dave Chinner wrote:
> > > On Thu, May 13, 2010 at 11:30:57PM -0400, Josef Bacik wrote:
> > > > So this is what I had envisioned, we make write_begin take a nr_pages pointer
> > > > and tell it how much data we have to write, then in the filesystem we allocate
> > > > as many pages as we feel like, idealy something like
> > > > 
> > > > min(number of pages we need for the write, some arbitrary limit for security)
> > > 
> > > Actually, i was thinking that the RESERVE call determines the size
> > > of the chunk (in the order of 1-4MB maximum). IOWs, we pass in the
> > > start offset of the write, the entire length remaining, and the
> > > RESERVE call determines how much it will allow in one loop.
> > > 
> > > 	written = 0;
> > > 	while (bytes_remaining > 0) {
> > > 		chunklen = ->allocate(off, bytes_remaining, RESERVE);
> > > 		write_begin(&pages, off, chunklen);
> > > 		copied = copy_pages(&pages, iov_iter, chunklen);
> > > 		.....
> > > 		bytes_remaining -= copied;
> > > 		off += copied;
> > > 		written += copied;
> > > 	}
> > 
> > How much benefit are you expecting to get?
> 
> If the max chunk size is 4MB, then three orders of magnitudes fewer
> allocation calls for x86_64 (i.e. one instead of 1024).  For
> filesystems with significant allocation overhead (like gaining
> cluster locks in gfs2), this will be a *massive* win.

It's a pretty big deal in btrfs too.  A 4K write write is much less
expensive than it used to be, but the part where we mark a range of
bytes as delayed allocation goes faster if that range is bigger.

-chris
