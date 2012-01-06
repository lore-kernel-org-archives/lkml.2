Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab2AFCgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 21:36:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:39646 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758492Ab2AFCgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 21:36:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="53783217"
Subject: Re: [PATCH block:for-3.3/core] cfq: merged request shouldn't jump
 to a different cfqq
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, x86@kernel.org
In-Reply-To: <20120106021707.GA6276@google.com>
References: <20111228211918.GA3516@google.com>
	 <20120103173500.GB31746@google.com> <20120103175922.GC31746@google.com>
	 <20120103200906.GG31746@google.com> <4F03631C.8080501@kernel.dk>
	 <20120103221301.GH31746@google.com> <20120103223505.GI31746@google.com>
	 <20120105012445.GP31746@google.com>
	 <alpine.LSU.2.00.1201051026090.2009@eggly.anvils>
	 <20120105183842.GF18486@google.com>  <20120106021707.GA6276@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Jan 2012 10:47:41 +0800
Message-ID: <1325818061.22361.507.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-05 at 18:17 -0800, Tejun Heo wrote:
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
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Hugh Dickins <hughd@google.com>
> Cc: stable@vger.kernel.org
> ---
> It survived my testing long enough and I'm relatively confident this
> should fix the crash but I might have gotten the scanning wrong, so
> please pay extra attention there.
> 
> I suspect we just didn't have enough backward request-request merges
> before the recent plug merge updates to trigger this bug.
The patch itself looks good to me, but I'm wondering if we really need
do reposition of the fifo list for merged request. it's rare case and
not worthy such complexity to me.

Thanks,
Shaohua

