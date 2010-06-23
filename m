Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab0FWKBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:01:54 -0400
Received: from verein.lst.de ([213.95.11.210]:60054 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab0FWKBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:01:53 -0400
Date: Wed, 23 Jun 2010 12:01:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
Message-ID: <20100623100138.GA9575@lst.de>
References: <20100621094828.GA30748@lst.de> <4C1F3916.4070608@kernel.dk> <20100621110436.GA4056@lst.de> <4C1FB5F7.3070908@kernel.dk> <20100621191410.GA24213@lst.de> <20100621213618.GC6474@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621213618.GC6474@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 1.789 (*) BAYES_60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 05:36:18PM -0400, Vivek Goyal wrote:
> I have got very little understanding of file system layer, but if I had
> to guess, i think following might have happened.
> 
> - We switched from WRITE to WRITE_SYNC for fsync() path.

Yes.  WRITE_SYNC_PLUG to be exact.  Note that we don't juse do this
for fsync but also for O_SYNC writes which use ->fsync, and also sync(2)
and the unmount path, which all end up submitting WB_SYNC_ALL writeback
requests.

> - This might have caused issues with idling as for SYNC_WRITE we will idle
>   in CFQ but probably it is not desirable in certain cases where next set
>   of WRITES is going to come from journaling thread. 

I'm still a bit confused about what the idling logic actually does.  Is
it some sort of additional plugging where we wait for more I/O to
accumulate?

> - That might have prompted us to introduce the rq_noidle() to make sure
>   we don't idle in WRITE_SYNC path but direct IO path was avoided to make
>   sure good throughput is maintained. But this left one question open 
>   and that is it good to disable idling on all WRITE_SYNC path in kernel.

I still fail to see why we should make any difference in the I/O
scheduler for O_DIRECT vs O_SYNC/fsync workloads.  In both cases the
caller blocks waiting for the I/O completion. 

> - Slowly cfq code emerged and as it stands today, to me rq_noidle() is
>   practically of not much use. For sync-idle tree (where idling is
>   enabled), we are ignoring the rq_noidle() and always arming the timer.
>   For sync-noidle, we choose not to idle based on if there was some other
>   thread who did even a single IO with rq_noidle=0.
> 
>   I think in practice, there is on thread of other which is doing some
>   read or write with rq_noidle=0 and if that's the case, we will end up
>   idling on sync-noidle tree also and rq_noidle() practically does
>   not take effect.
> 
> So if rq_noidle() was introduced to solve the issue of not idling on 
> fsync() path (as jbd thread will send more data now), then probably slice
> yielding patch of jeff might come handy here and and we can get rid of
> rq_noidle() logic. This is just a guess work and I might be completely
> wrong here...

Getting rid of the noidle logic and more bio flag that us filesystem
developers have real trouble understanding would be a good thing.

After that we're down to three bio modifiers for filesystem use, of
which at least two are very easy to grasp:

 - REQ_SYNC - treat a request as synchronous, implicitly enabled for
   reads anyway
 - REQ_UNPLUG - explicitly unplug the queue after I/O submission

and

 - REQ_META - which we're currenly trying to define in detail


REQ_NOIDLE currenly really is a lot of deep magic.
