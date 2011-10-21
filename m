Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab1JUJU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 05:20:28 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48356
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753936Ab1JUJU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 05:20:27 -0400
Date: Fri, 21 Oct 2011 05:20:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, vgoyal@redhat.com, jgarzik@pobox.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 2/6] block: allow blk_execute_rq_nowait() to be called
 form IRQ context
Message-ID: <20111021092016.GA14388@infradead.org>
References: <1319169400-15706-1-git-send-email-tj@kernel.org>
 <1319169400-15706-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319169400-15706-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 08:56:36PM -0700, Tejun Heo wrote:
> Currently blk_execute_rq_nowait() directly calls __blk_run_queue() and
> thus can't be called from IRQ context.  This patch updates it to use
> blk_run_queue_async() instead.  This will be used to unexport
> elv_add_request().
> 
> This changes how queue is kicked after blk_execute_rq_nowait() but
> it's hardly a hot path and the effect shouldn't be noticeable.

It actually very much is a fasthpath for many of it's users, e.g. the
SCSI tape drivers, the OSD layer and the target scsi passthrough
backend.

I don't think blindly adding a context switch here without benchmarking
is doable.  Just add variants that do the workqueue dance or not.

