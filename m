Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1HDKUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 06:20:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54192 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab1HDKUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 06:20:44 -0400
Date: Thu, 4 Aug 2011 12:20:39 +0200
From: Tejun Heo <tj@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>, msnitzer@redhat.com
Subject: Re: [patch] blk-flush: fix flush policy calculation
Message-ID: <20110804102039.GD2731@htj.dyndns.org>
References: <x49d3go98ku.fsf@segfault.boston.devel.redhat.com>
 <CANejiEXK7NSJo-0vshyX6RSqmRbHmyxAw8_wFQEwvTXrEQF3fg@mail.gmail.com>
 <x4939hju2zh.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x4939hju2zh.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 02, 2011 at 01:39:46PM -0400, Jeff Moyer wrote:
> OK, sorry for top-posting here, but I chased the problem down further.
> 
> Commit ae1b1539622fb46e51b4d13b3f9e5f4c713f86ae, block: reimplement
> FLUSH/FUA to support merge, introduced a regression when running any
> sort of fsyncing workload using dm-multipath and certain storage (in our
> case, an HP EVA).  It turns out that dm-multipath always advertised
> flush+fua support, and passed commands on down the stack, where they
> used to get stripped off.  The above commit, unfortunately, changed that
> behavior:
...
> So, the flush machinery was bypassed in such cases (q->flush_flags == 0
> && rq->cmd_flags & (REQ_FLUSH|REQ_FUA)).
> 
> Now, however, we don't get into the flush machinery at all (which is why
> my initial patch didn't help this situation).  Instead,
> __elv_next_request just hands a request with flush and fua bits set to
> the scsi_request_fn, even though the underlying request_queue does not
> support flush or fua.
> 
> So, where do we fix this?  We could just accept Mike's patch to not send
> such requests down from dm-mpath, but that seems short-sighted.  We
> could reinstate some checks in __elv_next_request.  Or, we could put the
> checks into blk_insert_cloned_request.

Ah, okay, what changed there was where a request is passed into flush
machinery.  Before, it was while the request was being dispatched from
elevator to device.  After, it's de-composed when the request enters
elevator.  The bug is that there are paths which insert new requests
to elevator but didn't check for REQ_FLUSH|FUA.

I think it would be cleaner to add a wrapper around
__elv_add_request() which checks for REQ_FLUSH|FUA and enforce
REQ_INSERT_FLUSH if the request needs it.  Note that this should only
happen when a request enters the queue for the first time but not on
requeues - that was the reason why the decision wasn't made inside
__elv_add_request().

Thank you.

-- 
tejun
