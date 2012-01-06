Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030402Ab2AFPfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 10:35:01 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51249 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030340Ab2AFPe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 10:34:59 -0500
Date: Fri, 6 Jan 2012 07:34:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH block:for-3.3/core] block: disable
 ELEVATOR_INSERT_SORT_MERGE
Message-ID: <20120106153452.GG6276@google.com>
References: <20120105183842.GF18486@google.com>
 <20120106021707.GA6276@google.com>
 <20120106023638.GC6276@google.com>
 <1325819655.22361.513.camel@sli10-conroe>
 <20120106030406.GD6276@google.com>
 <20120106033012.GE6276@google.com>
 <20120106035247.GF6276@google.com>
 <1325823545.22361.526.camel@sli10-conroe>
 <CAOS58YPUgK4J6j1Gme9O9HeL7GrwnJU8QTVKbVLA9cEXPQ1kag@mail.gmail.com>
 <1325837757.22361.538.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325837757.22361.538.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Shaohua.

On Fri, Jan 06, 2012 at 04:15:57PM +0800, Shaohua Li wrote:
> it's not related to the recursive merge. I forgot the detail of the
> workload why we add INSERT_SORT_MERGE, it's added several months ago
> anyway.
> Obviously we shouldn't do complex things inside the merge window. I just
> didn't agree to disable INSERT_SORT_MERGE, which will bring performance
> regression for sure. Can we just change CFQ like your first path?

But that is exactly what was broken and papering it over is exactly
the thing we shouldn't do, for now or for ever.  Think about it.  Your
commit f1f8cc94651 "block, cfq: fix empty queue crash caused by
request merge" fixed one symptom caused by cross cfqq merging
happening behind cfq's back without properly root-causing it.  I'm not
saying it was your fault but in the end all it did was obscuring the
root cause of the problem further, making the next more subtle failure
much more difficult to diagnose.

So, if you think cross-cfqq merging is a good idea, please go ahead
and do it properly.  It shouldn't happen as a side effect of two bugs
folded together.

As for quicker fix than revamping merge infrastructure, adding another
callback to explicitly ask elevator whether two requests chosen by
block core can be merged.  I didn't go that route because I wasn't
sure about the benefit of doing so - I still can't see how that would
make a lot of difference without cross cfqq merging, and wanted to
stay on the safer side given the intricacy of the problem.

So, if you wanna do that and have workload which is benefited enough
to justify the extra step, let's do it after the merge window, merge
as fixes and send it back via -stable.  But we shouldn't be doing that
inside merge window when all other trees are getting pushed upstream
and we don't have much time for testing ourselves or in linux-next.

Thanks.

-- 
tejun
