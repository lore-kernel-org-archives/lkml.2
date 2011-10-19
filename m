Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab1JSO4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:56:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956Ab1JSO4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:56:30 -0400
Date: Wed, 19 Oct 2011 10:56:22 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com
Subject: Re: [PATCH 07/10] block: reorganize throtl_get_tg() and
 blk_throtl_bio()
Message-ID: <20111019145622.GE1140@redhat.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318998384-22525-8-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 09:26:21PM -0700, Tejun Heo wrote:
> blk_throtl_bio() and throtl_get_tg() have rather unusual interface.
> 
> * throtl_get_tg() returns pointer to a valid tg or ERR_PTR(-ENODEV),
>   and drops queue_lock in the latter case.  Different locking context
>   depending on return value is error-prone and DEAD state is scheduled
>   to be protected by queue_lock anyway.  Move DEAD check inside
>   queue_lock and return valid tg or NULL.

Tejun,

A driver could call blk_cleanup_queue(), mark the queue DEAD and then
free the driver provided spin lock. So once queue is DEAD one could
not rely on queue lock still being there. That's the reason I did
not try to take queue lock again if queue is marked DEAD.

Now I see the change that blk_cleanup_queue will start poiting to
internal queue lock (Thought it is racy). This will atleast make
sure that some spinlock is around. So now this change should be
fine.

> 
> * blk_throtl_bio() indicates return status both with its return value
>   and in/out param **@bio.  The former is used to indicate whether
>   queue is found to be dead during throtl processing.  The latter
>   whether the bio is throttled.
> 
>   There's no point in returning DEAD check result from
>   blk_throtl_bio().  The queue can die after blk_throtl_bio() is
>   finished but before make_request_fn() grabs queue lock.

The reason I was returning error in case of queue DEAD is that I wanted
IO to now return with error instead of continuing to call q->make_request_fn(q, bio) which does not do queue dead check and assumes queue is still alive.

With this change, if queue is DEAD, bio will not be throttled and we
will continue to submit bio to queue and I am not sure who will catch
it in __make_request()?

Thanks
Vivek
