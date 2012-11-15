Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767926Ab2KOOFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:05:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46558 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767757Ab2KOOFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:05:34 -0500
Message-ID: <50A4F6A7.2070708@kernel.dk>
Date: Thu, 15 Nov 2012 07:05:27 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jmoyer@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH v3] loop: Limit the number of requests in the bio list
References: <1352824065-6734-1-git-send-email-lczerner@redhat.com> <50A27892.1030800@kernel.dk> <alpine.LFD.2.00.1211140951380.3577@localhost> <50A3B705.7050008@kernel.dk> <alpine.LFD.2.00.1211150913030.27894@dhcp-1-104.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.1211150913030.27894@dhcp-1-104.brq.redhat.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-15 01:20, Lukáš Czerner wrote:
> On Wed, 14 Nov 2012, Jens Axboe wrote:
> 
>> Date: Wed, 14 Nov 2012 08:21:41 -0700
>> From: Jens Axboe <axboe@kernel.dk>
>> To: Lukáš Czerner <lczerner@redhat.com>
>> Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
>>     jmoyer@redhat.com, akpm@linux-foundation.org
>> Subject: Re: [PATCH v3] loop: Limit the number of requests in the bio list
>>
>> On 2012-11-14 02:02, Lukáš Czerner wrote:
>>> On Tue, 13 Nov 2012, Jens Axboe wrote:
>>>
>>>> Date: Tue, 13 Nov 2012 09:42:58 -0700
>>>> From: Jens Axboe <axboe@kernel.dk>
>>>> To: Lukas Czerner <lczerner@redhat.com>
>>>> Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
>>>>     jmoyer@redhat.com, akpm@linux-foundation.org
>>>> Subject: Re: [PATCH v3] loop: Limit the number of requests in the bio list
>>>>
>>>>> @@ -489,6 +491,12 @@ static void loop_make_request(struct request_queue *q, struct bio *old_bio)
>>>>>  		goto out;
>>>>>  	if (unlikely(rw == WRITE && (lo->lo_flags & LO_FLAGS_READ_ONLY)))
>>>>>  		goto out;
>>>>> +	if (lo->lo_bio_count >= q->nr_congestion_on) {
>>>>> +		spin_unlock_irq(&lo->lo_lock);
>>>>> +		wait_event(lo->lo_req_wait, lo->lo_bio_count <
>>>>> +			   q->nr_congestion_off);
>>>>> +		spin_lock_irq(&lo->lo_lock);
>>>>> +	}
>>>>
>>>> This makes me nervous. You are reading lo_bio_count outside the lock. If
>>>> you race with the prepare_to_wait() and condition check in
>>>> __wait_event(), then you will sleep forever.
>>>
>>> Hi Jens,
>>>
>>> I am sorry for being dense, but I do not see how this would be
>>> possible. The only place we increase the lo_bio_count is after that
>>> piece of code (possibly after the wait). Moreover every time we're
>>> decreasing the lo_bio_count and it is smaller than nr_congestion_off
>>> we will wake_up().
>>>
>>> That's how wait_event/wake_up is supposed to be used, right ?
>>
>> It is, yes. But you are checking the condition without the lock, so you
>> could be operating on a stale value. The point is, you have to safely
>> check the condition _after prepare_to_wait() to be completely safe. And
>> you do not. Either lo_bio_count needs to be atomic, or you need to use a
>> variant of wait_event() that holds the appropriate lock before
>> prepare_to_wait() and condition check, then dropping it for the sleep.
>>
>> See wait_even_lock_irq() in drivers/md/md.h.
> 
> Ok I knew that much. So the only possibility to deadlock is when we
> would process all the bios in the loop_thread() before the waiting
> event would get to checking the condition after which we would read
> the stale data where lo_bio_count is still < nr_congestion_off so we
> get back to sleep, never to be woken up again. That sounds highly
> unlikely. But fair enough, it make sense to make it absolutely bullet
> proof.

It depends on the settings. At the current depth/batch count, yes,
unlikely. But sometimes "highly unlikely" scenarios turn out to be
hitting all the time for person X's setup and settings.

> I'll take a look at the wait_event_lock_irq.

Thanks.

-- 
Jens Axboe

