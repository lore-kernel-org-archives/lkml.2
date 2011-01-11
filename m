Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab1AKAsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 19:48:06 -0500
Received: from smtp-out.google.com ([216.239.44.51]:25360 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab1AKAsB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 19:48:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=o4W4AJajvh8n1USnuvSahlVuEtyh4o35p9bwA4K4AZH3MpY25X2zSwgjUKLIh5wHr2
         whRIm/0ctOYtQpdJDKtw==
MIME-Version: 1.0
In-Reply-To: <AANLkTikWFiUWHgddJeeStonVMuSgqPHFo=MAJM4qYzyo@mail.gmail.com>
References: <20101216031016.186364650@google.com> <20101216031038.067028969@google.com>
 <1292497423.6803.4572.camel@twins> <1292509608.5532.3.camel@maggy.simson.net> <AANLkTikWFiUWHgddJeeStonVMuSgqPHFo=MAJM4qYzyo@mail.gmail.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 10 Jan 2011 16:47:29 -0800
Message-ID: <AANLkTinZ+DAwKgAFU=G0DfreEE=FBye91x8VfnM0CgXO@mail.gmail.com>
Subject: Re: [patch 1/2] sched: move periodic share updates to entity_tick()
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Never mind, my git state was wonky -- I see these now, Thanks!

On Mon, Jan 10, 2011 at 3:49 PM, Paul Turner <pjt@google.com> wrote:
> Back from the Holidays and catching up on email -- Peter, looks like
> this fix still needs merging?
>
> On Thu, Dec 16, 2010 at 6:26 AM, Mike Galbraith <efault@gmx.de> wrote:
>> On Thu, 2010-12-16 at 12:03 +0100, Peter Zijlstra wrote:
>>> I made that:
>>
>> Box is ill, I'll test these as soon as it's all better.
>>
>>> ---
>>> Subject: sched: Move periodic share updates to entity_tick()
>>> From: Paul Turner <pjt@google.com>
>>> Date: Wed, 15 Dec 2010 19:10:17 -0800
>>>
>>> Long running entities that do not block (dequeue) require periodic updates to
>>> maintain accurate share values.  (Note: group entities with several threads are
>>> quite likely to be non-blocking in many circumstances).
>>>
>>> By virtue of being long-running however, we will see entity ticks (otherwise
>>> the required update occurs in dequeue/put and we are done).  Thus we can move
>>> the detection (and associated work) for these updates into the periodic path.
>>>
>>> This restores the 'atomicity' of update_curr() with respect to accounting.
>>>
>>> Signed-off-by: Paul Turner <pjt@google.com>
>>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>> LKML-Reference: <20101216031038.067028969@google.com>
>>> ---
>>>  kernel/sched_fair.c |   21 +++++++++++++++++----
>>>  1 file changed, 17 insertions(+), 4 deletions(-)
>>>
>>> Index: linux-2.6/kernel/sched_fair.c
>>> ===================================================================
>>> --- linux-2.6.orig/kernel/sched_fair.c
>>> +++ linux-2.6/kernel/sched_fair.c
>>> @@ -564,10 +564,6 @@ __update_curr(struct cfs_rq *cfs_rq, str
>>>
>>>  #if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
>>>       cfs_rq->load_unacc_exec_time += delta_exec;
>>> -     if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
>>> -             update_cfs_load(cfs_rq, 0);
>>> -             update_cfs_shares(cfs_rq, 0);
>>> -     }
>>>  #endif
>>>  }
>>>
>>> @@ -809,6 +805,14 @@ static void update_cfs_shares(struct cfs
>>>
>>>       reweight_entity(cfs_rq_of(se), se, shares);
>>>  }
>>> +
>>> +static void update_entity_shares_tick(struct cfs_rq *cfs_rq)
>>> +{
>>> +     if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
>>> +             update_cfs_load(cfs_rq, 0);
>>> +             update_cfs_shares(cfs_rq, 0);
>>> +     }
>>> +}
>>>  #else /* CONFIG_FAIR_GROUP_SCHED */
>>>  static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
>>>  {
>>> @@ -817,6 +821,10 @@ static void update_cfs_load(struct cfs_r
>>>  static inline void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
>>>  {
>>>  }
>>> +
>>> +static inline void update_entity_shares_tick(struct cfs_rq *cfs_rq)
>>> +{
>>> +}
>>>  #endif /* CONFIG_FAIR_GROUP_SCHED */
>>>
>>>  static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
>>> @@ -1133,6 +1141,11 @@ entity_tick(struct cfs_rq *cfs_rq, struc
>>>        */
>>>       update_curr(cfs_rq);
>>>
>>> +     /*
>>> +      * Update share accounting for long-running entities.
>>> +      */
>>> +     update_entity_shares_tick(cfs_rq);
>>> +
>>>  #ifdef CONFIG_SCHED_HRTICK
>>>       /*
>>>        * queued ticks are scheduled to match the slice, so don't bother
>>>
>>
>>
>>
>
