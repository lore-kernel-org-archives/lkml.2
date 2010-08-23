Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0HWPB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 11:01:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50561 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab0HWPBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 11:01:25 -0400
Date: Mon, 23 Aug 2010 11:00:23 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, npiggin@kernel.dk
Subject: Re: aio: bump i_count instead of using igrab
Message-ID: <20100823150023.GR21975@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
	npiggin@kernel.dk
References: <20100823144755.GP21975@think>
 <20100823145031.GA1279@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100823145031.GA1279@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 10:50:31AM -0400, Christoph Hellwig wrote:
> On Mon, Aug 23, 2010 at 10:47:55AM -0400, Chris Mason wrote:
> > The aio batching code is using igrab to get an extra reference on the
> > inode so it can safely batch.  igrab will go ahead and take the global
> > inode spinlock, which can be a bottleneck on large machines doing lots
> > of AIO.
> > 
> > In this case, igrab isn't required because we already have a reference
> > on the file handle.  It is safe to just bump the i_count directly
> > on the inode.
> > 
> > Benchmarking shows this patch brings IOP/s on tons of flash up by about
> > 2.5X.
> 
> There's some places in XFS where we do the same, and it showed up as a
> bottle neck before.  Instead of open coding the increment we have
> a wrapper that includes and assert that the numbers is always positive.
> 
> I think we really want a proper helper for general use instead of
> completly opencoding it.
> 

Nick, this is about a 1 liner to fs/aio.c replacing igrab with
atomic_inc directly on the inode reference count.

I know your scalability tree gets rid of the global, but in this case I
think it still makes sense to avoid the locking completely when the
caller knows it is safe.  Do you already have something similar hiding
in the scalability tree?

-chris
