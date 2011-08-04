Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab1HDKQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 06:16:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59031 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab1HDKQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 06:16:29 -0400
Date: Thu, 4 Aug 2011 12:16:24 +0200
From: Tejun Heo <tj@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernle.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [patch] blk-flush: fix flush policy calculation
Message-ID: <20110804101624.GC2731@htj.dyndns.org>
References: <x49d3go98ku.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49d3go98ku.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Aug 01, 2011 at 04:32:17PM -0400, Jeff Moyer wrote:
>         /*
>          * If there's data but flush is not necessary, the request can be
>          * processed directly without going through flush machinery.  Queue
>          * for normal execution.
>          */
>         if ((policy & REQ_FSEQ_DATA) &&
>             !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
>                 list_add_tail(&rq->queuelist, &q->queue_head);
>                 return;
>         }
> 
> Given the code as it stands, I don't think the body of this if statement
> will ever be executed.

It does if the device has a WB cache and filesystem sends down a FUA
(but no FLUSH) request.

> I've attached a fix for this below.  It seems
> like this could be both a performance and a correctness issue, though
> I've not run into any problems I can directly attribute to this (perhaps
> due to file systems not issuing flushes when support is not advertised?).
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

Hmmm... yes, this can become a correctness issue if (and only if)
blk_queue_flush() is called to change q->flush_flags while requests
are in-flight; otherwise, requests wouldn't reach the function at all.
Also, I think it would be a generally good idea to always set
FSEQ_DATA if the request has data.

 Acked-by: Tejun Heo <tj@kernel.org>

but can you please update the description?

Thank you.

-- 
tejun
