Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab2AREX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 23:23:26 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39496 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab2AREXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 23:23:25 -0500
MIME-Version: 1.0
In-Reply-To: <CANejiEUE0ZNNf=t5dUTD8pTB5G3gAGAxkSRkvFomrh3Bm+dY=Q@mail.gmail.com>
References: <20120117201823.GD19223@redhat.com>
	<20120117214834.GD26207@google.com>
	<20120117220715.GB23527@redhat.com>
	<CANejiEUfAxR-DFH+eRQUbmc1jKHSkcBP1RxuRQ-9JKLU=1Ds0w@mail.gmail.com>
	<20120118010323.GA32160@htj.dyndns.org>
	<CANejiEUopG3MgUsvGMbkdHKrgBT_c+bir1bApt8p86kQn42huQ@mail.gmail.com>
	<20120118011112.GB32160@htj.dyndns.org>
	<1326850253.22361.619.camel@sli10-conroe>
	<CANejiEUE0ZNNf=t5dUTD8pTB5G3gAGAxkSRkvFomrh3Bm+dY=Q@mail.gmail.com>
Date: Wed, 18 Jan 2012 12:23:24 +0800
X-Google-Sender-Auth: y7_tvT8R7yNvd_H5GwqtnYQFbYE
Message-ID: <CANejiEU2mDG6rz9YmMY=1o317T+=L7Jx0Dwh981k4yXdRfxuEA@mail.gmail.com>
Subject: Re: Kernel crash in icq_free_icq_rcu
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/18 Shaohua Li <shaohua.li@intel.com>:
> 2012/1/18 Shaohua Li <shaohua.li@intel.com>:
>> On Tue, 2012-01-17 at 17:11 -0800, Tejun Heo wrote:
>>> On Wed, Jan 18, 2012 at 09:05:26AM +0800, Shaohua Li wrote:
>>> > > Vivek is seeing the problem while switching elevators.  Are you too?
>>> > > Or is it during normal operation?
>>> > same here. I had some problems when I debug my ioscheduler, but
>>> > eventually found even switching cfq and noop can trigger oops.
>>>
>>> Hmmm... maybe quiescing isn't working as expected and kmem cache is
>>> being destroyed with live icq's.  I'll try to reproduce it.
>> this debug patch seems to fix for me.
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index e6c05a9..c6a8ef5 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -872,11 +872,11 @@ retry:
>>        spin_unlock_irq(q->queue_lock);
>>
>>        /* create icq if missing */
>> -       if (unlikely(et->icq_cache && !icq))
>> +       if (unlikely(et->icq_cache && !icq && (rw_flags & REQ_ELVPRIV)))
>>                icq = ioc_create_icq(q, gfp_mask);
>>
>>        /* rqs are guaranteed to have icq on elv_set_request() if requested */
>> -       if (likely(!et->icq_cache || icq))
>> +       if (likely(!et->icq_cache || icq || !(rw_flags & REQ_ELVPRIV)))
>>                rq = blk_alloc_request(q, icq, rw_flags, gfp_mask);
>>
>>        if (unlikely(!rq)) {
> this passed my test, but I didn't get reason why it can help ...
> blk_alloc_request doesn't use icq if REQ_ELVPRIV isn't set, so the code
> has problem for sure.
Ok, I got the reason here:
CPU 0                                                             CPU1
get_request
   ioc_create_icq
       allocate icq with cfq ioscheduler

 switch to noop
       insert icq to ioc

 switch to cfq

         ioc_clear_queue
in ioc_clear_queue, ioc has icq in its list, but current elevator is noop,
so ioc_exit_icq will get a NULL et->icq_cache

I hit a kmem_cache_alloc_node oops too. because the et in ioc_create_icq
might not be the et of get_request (we drop lock before calling ioc_create_icq)

The put_io_context has a workqueue to run ioc_exit_icq, I suspect
there is problem too.
