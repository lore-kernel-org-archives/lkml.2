Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab1J0Ob0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 10:31:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab1J0ObZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 10:31:25 -0400
Date: Thu, 27 Oct 2011 10:31:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 10/13] block, cfq: unlink cfq_io_context's
 immediately
Message-ID: <20111027143119.GD7491@redhat.com>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
 <1319593719-19132-11-git-send-email-tj@kernel.org>
 <20111026213107.GI24261@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111026213107.GI24261@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 02:31:07PM -0700, Tejun Heo wrote:

[..]
> -void put_io_context(struct io_context *ioc)
> +void put_io_context(struct io_context *ioc, struct request_queue *locked_q)
>  {
> +	struct request_queue *last_q = locked_q;
> +	unsigned long flags;
> +
>  	if (ioc == NULL)
>  		return;
>  
>  	BUG_ON(atomic_long_read(&ioc->refcount) <= 0);
> +	if (locked_q)
> +		lockdep_assert_held(locked_q->queue_lock);
>  

Looks like lockdep_assert_held() can't be used if !CONFIG_LOCKDEP. So
Jens had put following patch to fix one compilation issue. You might
want to provide a null definition of lockdep_assert_held() in case
of !CONFIG_LOCKDEP.

commit 334c2b0b8b2ab186fa198413386cba41fffcb4f2
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Oct 25 15:51:48 2011 +0200

    blk-throttle: use queue_is_locked() instead of lockdep_is_held()
    
    We can't use the latter if !CONFIG_LOCKDEP.
    
    Reported-by: Sedat Dilek <sedat.dilek@googlemail.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

Thanks
Vivek
