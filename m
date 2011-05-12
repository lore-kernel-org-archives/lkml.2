Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab1ELUV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 16:21:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077Ab1ELUVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 16:21:25 -0400
Date: Thu, 12 May 2011 16:21:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: Question about life time of block device request queue
Message-ID: <20110512202121.GA24843@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am reading following code and wondering what makes sure that request
queue lock is still valid by the time we call __make_request().

__generic_make_request() {
...
...
                if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
                        goto end_io;

...
...
		ret = q->make_request_fn(q, bio); ---> __make_request();
}

__make_request(q)
{
	spin_lock_irq(q->queue_lock);
}

blk_cleanup_queue()
{
...
...
	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
...
...
}

So when a driver tears down the request queue it should call
blk_cleanup_queue() which will mark queue as DEAD.

In __generic_make_request() once we have checked for dead queue and then
we run bunch of more instructions and then call q->make_request_fn() which
calls __make_request() and in __make_request we take ->queue_lock. What
makes sure that driver did not call blk_cleanup_queue() between DEAD flag
test and taking of spin lock?

Is this a race condition or I am missing something.

Thanks
Vivek
