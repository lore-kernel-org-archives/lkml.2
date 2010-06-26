Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab0FZKFn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 06:05:43 -0400
Received: from verein.lst.de ([213.95.11.210]:47477 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab0FZKFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 06:05:41 -0400
Date: Sat, 26 Jun 2010 12:05:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       czoccolo@gmail.com
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
Message-ID: <20100626100526.GA27159@lst.de>
References: <20100621094828.GA30748@lst.de> <4C1F3916.4070608@kernel.dk> <20100621110436.GA4056@lst.de> <4C1FB5F7.3070908@kernel.dk> <20100621191410.GA24213@lst.de> <20100621213618.GC6474@redhat.com> <20100623100138.GA9575@lst.de> <20100624014420.GB3297@redhat.com> <20100625110319.GA12855@lst.de> <20100626033509.GA2435@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100626033509.GA2435@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 11:35:10PM -0400, Vivek Goyal wrote:
> This logic was introduced by corrado to ensure WRITE_SYNC does not
> lose fair share. Now we are back to the same question, what is the workload
> which does that.
> 
> 8e55063 cfq-iosched: fix corner cases in idling logic
> 
> Before this patch, we will simply not do any idling on WRITE_SYNC. That
> means no idling on O_SYNC/fsync paths but still idle on direct IO
> WRITE_SYNC. Which is a bit of discrepancy.

Corrado, can you explain what workloads you doing that commit for?
The commit message doesn't really given any useful information.


> - Stop idling on all the WRITE_SYNC IO. There is no reasonable way to 
>   tell whether there will be more IO or not from applicatoin. This will
>   impact direct writes, O_SYNC writes and fsync().
> 
>   If direct IO application is submitting writes with a delay in between
>   it can be starved out in presnce of competing workloads.

So what application does this?

> - Do idling by default on WRITE_SYNC path. Implement Jeff's queue yielding
>   patches. That way O_SYNC/fsyn path will call blk_yield() and stop idling.
>   Direct IO write path will stil continue to idle (I think if file has already
>   been laid out?). 

I don't think this makes much sense.  And O_SYNC write / fsync are
defined to not return before the I/O makes it to disk, and for any
sane filesystem end with a WRITE_BARRIER request because of that.
So we end these with an explicit unplug anyway, no need for idling
logic.

