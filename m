Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab0FZJ0M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 05:26:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:53709 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab0FZJ0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 05:26:10 -0400
Date: Sat, 26 Jun 2010 19:25:56 +1000
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@lst.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
Message-ID: <20100626092556.GH29809@laptop>
References: <20100621094828.GA30748@lst.de>
 <4C1F3916.4070608@kernel.dk>
 <20100621110436.GA4056@lst.de>
 <4C1FB5F7.3070908@kernel.dk>
 <20100621191410.GA24213@lst.de>
 <20100621213618.GC6474@redhat.com>
 <20100623100138.GA9575@lst.de>
 <20100624014420.GB3297@redhat.com>
 <20100625110319.GA12855@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100625110319.GA12855@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 01:03:20PM +0200, Christoph Hellwig wrote:
> On Wed, Jun 23, 2010 at 09:44:20PM -0400, Vivek Goyal wrote:
> > Let me explain the general idling logic and then see if it makes sense in case
> > of WRITE_SYNC.
> > 
> > Once a request has completed, if the cfq queue is empty, we have two choices.
> > Either expire the cfq queue and move on to dispatch requests from a
> > different queue or we idle on the queue hoping we will get more IO from
> > same process/queue.
> 
> queues are basically processes in this context?
> 
> > Idling can help (on SATA disks with high seek cost), if
> > our guess was right and soon we got another request from same process. We
> > cut down on number of seeks hence increased throghput.
> 
> I don't really understand the logic behind this.  If we lots of I/O
> that actually is close to each other we should generally submit it in
> one batch.  That is true for pagecache writeback, that is true for
> metadata (at least in XFS..), and it's true for any sane application
> doing O_DIRECT / O_SYNC style I/O.
> 
> What workloads produde I/O that is local (not random) writes with small
> delays between the I/O requests?

Biggest thing is multiple small files operations like on the same
directory. Best case I measured back when doing AS io scheduler
versus deadline was about 100x improvement on a uncached kernel
grep workload when competing with a streaming writeout (the writeout
probably ended up going somewhat slower naturally, but it is fairer).

