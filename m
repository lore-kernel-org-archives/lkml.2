Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab2AFCgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 21:36:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42318 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758492Ab2AFCgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 21:36:43 -0500
Date: Thu, 5 Jan 2012 18:36:38 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>,
        Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH block:for-3.3/core] cfq: merged request shouldn't jump
 to a different cfqq
Message-ID: <20120106023638.GC6276@google.com>
References: <20120103173500.GB31746@google.com>
 <20120103175922.GC31746@google.com>
 <20120103200906.GG31746@google.com>
 <4F03631C.8080501@kernel.dk>
 <20120103221301.GH31746@google.com>
 <20120103223505.GI31746@google.com>
 <20120105012445.GP31746@google.com>
 <alpine.LSU.2.00.1201051026090.2009@eggly.anvils>
 <20120105183842.GF18486@google.com>
 <20120106021707.GA6276@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106021707.GA6276@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Thu, Jan 05, 2012 at 06:17:07PM -0800, Tejun Heo wrote:
> When two requests are merged, if the absorbed request is older than
> the absorbing one, cfq_merged_requests() tries to reposition it in the
> cfqq->fifo list by list_move()'ing the absorbing request to the
> absorbed one before removing it.
> 
> This works if both requests are on the same cfqq but nothing
> guarantees that and the code ends up moving the merged request to a
> different cfqq's fifo list without adjusting the rest.  This leads to
> the following failures.
> 
> * A request may be on the fifo list of a cfqq without holding
>   reference to it and the cfqq can be freed before requst is finished.
>   Among other things, this triggers list debug warning and slab debug
>   use-after-free warning.
> 
> * As a request can be on the wrong fifo queue, it may be issued and
>   completed before its cfqq is scheduled.  If the cfqq didn't have
>   other requests on it, it would be empty by the time it's dispatched
>   triggering BUG_ON() in cfq_dispatch_request().
> 
> Fix it by making cfq_merged_requests() scan the absorbing request's
> fifo list for the correct slot and move there instead.

Hmmm... while the patch would fix the problem.  It isn't entirely
correct.  The root cause is,

1. q->last_merge and rqhash used to be used only for merging bios into
   requests and that queries elevator whether the merge should be
   allowed.  cfq disallows merging if they belong to different cfqqs.

2. request-request merging didn't use to use q->last_merge or rqhash to
   find request candidates.  It used elv_former/latter_request() and
   cfq never returned request from a different cfqq.

3. Plug merging started using q->last_merge and rqhash and now
   elevator can't prevent cross cfqq merges.

So, yeah, the right fix would be using elv_former/latter_request()
instead.  Maybe we should strip out rqhash altogether and change
elevator handle everything?  I don't know.  I'll prepare a different
fix patch soon.

Thanks.

-- 
tejun
