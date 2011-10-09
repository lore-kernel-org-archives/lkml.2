Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab1JIHQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 03:16:41 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51152 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1JIHQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 03:16:40 -0400
MIME-Version: 1.0
In-Reply-To: <CANejiEXzPp4TvLsZ0VXN9EicMgkHXfkhpLcuXzVvoEH5MJfQuQ@mail.gmail.com>
References: <1317397918.27140.15.camel@localhost>
	<x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
	<1317729761.25998.4.camel@localhost>
	<x49bottoq57.fsf@segfault.boston.devel.redhat.com>
	<CANejiEXnXJ7LkyqHyH1S2c4A95Si7v0-gDmRD824r3ROntaDCA@mail.gmail.com>
	<20111008161421.GA5743@redhat.com>
	<CANejiEXzPp4TvLsZ0VXN9EicMgkHXfkhpLcuXzVvoEH5MJfQuQ@mail.gmail.com>
Date: Sun, 9 Oct 2011 15:16:39 +0800
X-Google-Sender-Auth: 11xasitlzVUj1BdCfpD9c6N2oY8
Message-ID: <CANejiEV+Joc7qvWr1DF4cOR61GKy8MLX4TT4oWh7pxMkhb74Qg@mail.gmail.com>
Subject: Re: Block regression since 3.1-rc3
From: Shaohua Li <shli@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/9 Shaohua Li <shli@kernel.org>:
> 2011/10/9 Mike Snitzer <snitzer@redhat.com>:
>> On Sat, Oct 08 2011 at  7:02am -0400,
>> Shaohua Li <shli@kernel.org> wrote:
>>
>>> Looks the dm request based flush logic is broken.
>>>
>>> saved_make_request_fn
>>>   __make_request
>>>     blk_insert_flush
>>> but blk_insert_flush doesn't put the original request to list, instead, the
>>> q->flush_rq is in list.
>>> then
>>> dm_request_fn
>>>   blk_peek_request
>>>     dm_prep_fn
>>>       clone_rq
>>>   map_request
>>>     blk_insert_cloned_request
>>> so q->flush_rq is cloned, and get dispatched. but we can't clone q->flush_rq
>>> and use it to do flush. map_request even could assign a different blockdev to
>>> the cloned request.
>>
>> You haven't explained why cloning q->flush_rq is broken.  What is the
>> problem with map_request changing the blockdev?  For the purposes of
>> request-based DM the flush machinery has already managed the processing
>> of the flush at the higher level request_queue.
> hmm, looks I overlook the issue. cloned flush_rq has some problems but can
> be fixed.
> 1. it doesn't set requet->bio, request->bio_tail
> 2. REQ_CLONE_MASK should set REQ_FLUSH_SEQ
oh, don't need set REQ_FLUSH_SEQ, the low level queue will set it
anyway. sorry for
the noise. Jeff's patch looks ok then.
