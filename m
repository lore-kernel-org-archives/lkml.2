Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1HIQNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:13:40 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42024 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab1HIQNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:13:39 -0400
Date: Tue, 9 Aug 2011 18:13:34 +0200
From: Tejun Heo <tj@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        Mike Snitzer <msnitzer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [patch] block: properly handle flush/fua requests in
 blk_insert_cloned_request
Message-ID: <20110809161334.GC23842@htj.dyndns.org>
References: <x49y5z2eibl.fsf@segfault.boston.devel.redhat.com>
 <20110809153826.GB23842@htj.dyndns.org>
 <x49liv2eg34.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49liv2eg34.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 09, 2011 at 11:53:51AM -0400, Jeff Moyer wrote:
> Tejun Heo <tj@kernel.org> writes:
> > I'm a bit confused.  We still need ELEVATOR_INSERT_FLUSH fix for
> > insertion paths, right?  Or is blk_insert_cloned_request() supposed to
> > used only by request based dm which lives under the elevator?  If so,
> > it would be great to make that explicit in the comment.  Maybe just
> > renaming it to blk_insert_dm_cloned_request() would be better as it
> > wouldn't be safe for other cases anyway.
> 
> request-based dm is the only caller at present.  I'm not a fan of
> renaming the function, but I'm more than willing to comment it.

I'm still confused and don't think the patch is correct (you can't
turn off REQ_FUA without decomposing it to data + post flush).

Going through flush machinery twice is okay and I think is the right
thing to do.  At the upper queue, the request is decomposed to member
requests.  After decomposition, it's either REQ_FLUSH w/o data or data
request w/ or w/o REQ_FUA.  When the decomposed request reaches lower
queue, the lower queue will then either short-circuit it, execute
as-is or decompose data w/ REQ_FUA into data + REQ_FLUSH sequence.

AFAICS, the breakages are...

* ELEVATOR_INSERT_FLUSH not used properly from insert paths.

* Short circuit not kicking in for the dm requests. (the above and the
  policy patch should solve this, right?)

* BUG(!rq->bio || ...) in blk_insert_flush().  I think we can lift
  this restriction for empty REQ_FLUSH but also dm can just send down
  requests with empty bio.

Thanks.

-- 
tejun
