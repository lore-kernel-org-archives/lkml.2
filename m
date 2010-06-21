Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab0FUTU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:20:27 -0400
Received: from verein.lst.de ([213.95.11.210]:55520 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab0FUTU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:20:26 -0400
Date: Mon, 21 Jun 2010 21:20:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
Message-ID: <20100621192024.GA24555@lst.de>
References: <20100621094828.GA30748@lst.de> <4C1F3916.4070608@kernel.dk> <20100621110436.GA4056@lst.de> <4C1FB5F7.3070908@kernel.dk> <20100621191410.GA24213@lst.de> <4C1FBA91.3040601@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1FBA91.3040601@kernel.dk>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0.001 () BAYES_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 09:16:33PM +0200, Jens Axboe wrote:
> Yes, but that's a separate thing. The point is that boosting meta data
> IO is done by others as well. That we don't fully do the same on the
> hw side is a different story. That doesn't mean that the io scheduler
> boost isn't useful.

Well, the FUA bit is useful for writes.  And I agree that we need to
prioritize log I/O metadata.  On the other hand at least for XFS most
other metadata writes actually are asynchronous - there's no need to
prioritize those.

> > We use the explicit unplugging, yes - but READ_META also includes
> > REQ_SYNC which is not used anywhere.
> 
> That does look superfluous.

The above should READ_SYNC, but the same still applies.

> > We've only started using any kind of sync tag last year in ->writepage in
> > commit a64c8610bd3b753c6aff58f51c04cdf0ae478c18 "block_write_full_page:
> > Use synchronous writes for WBC_SYNC_ALL writebacks", switching from
> > WRITE_SYNC to WRITE_SYNC_PLUG a bit later in commit
> > 6e34eeddf7deec1444bbddab533f03f520d8458c "block_write_full_page: switch
> > synchronous writes to use WRITE_SYNC_PLUG"
> > 
> > Before that we used plain WRITE, which had the normal idling logic.
> 
> Plain write does not idle.

Well, whatever logic we use for normal files.  Note that all the commits
above were introduced in 2.6.29.  That's where the horrible fsync
latency regressions due to the idling logic that Jeff is fighting were
introduced.  So there's defintively something wrong going on here.

