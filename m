Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407Ab0EMQqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:46:37 -0400
Received: from smtp-out.google.com ([74.125.121.35]:10021 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759394Ab0EMQqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:46:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=i3aRFW4sJyMWoM4wGs4CzK5e6F1cP5pUByMP19WjjOkq2J6WvcALcoEUa2UBfpT8j
	bSYedJKn885eMgaL7XY3w==
MIME-Version: 1.0
In-Reply-To: <1273661695.1626.15.camel@laptop>
References: <1273283329-25258-1-git-send-email-venki@google.com>
	 <1273661695.1626.15.camel@laptop>
Date: Thu, 13 May 2010 09:46:13 -0700
Message-ID: <i2l3055132f1005130946w46fea3c5s1f6400c6325a77b4@mail.gmail.com>
Subject: Re: [PATCH] sched: Avoid side-effect of tickless idle on 
	update_cpu_load
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Ken Chen <kenchen@google.com>, Paul Turner <pjt@google.com>,
       Nikhil Rao <ncrao@google.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 3:54 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-05-07 at 18:48 -0700, Venkatesh Pallipadi wrote:
>>
>>  /*
>> + * Load degrade calculations below are approximated on a 128 point scale.
>> + * degrade_zero_ticks is the number of ticks after which old_load at any
>> + * particular idx is approximated to be zero.
>> + * degrade_factor is a precomputed table, a row for each load idx.
>> + * Each column corresponds to degradation factor for a power of two ticks,
>> + * based on 128 point scale.
>> + * Example:
>> + * row 2, col 3 (=12) says that the degradation at load idx 2 after
>> + * 8 ticks is 12/128 (which is an approximation of 3^8/4^8).
>> + */
>
> This comment utterly forgets to explain why. Does the degradation factor
> correspond with the decay otherwise used? Maybe explicitly mention that
> function and clarify the whole cpu_load math.

OK. Will try to explain this better with a patch refresh.

>> +#define DEGRADE_SHIFT                7
>> +static const unsigned char
>> +             degrade_zero_ticks[CPU_LOAD_IDX_MAX] = {0, 8, 32, 64, 128};
>> +static const unsigned char
>> +             degrade_factor[CPU_LOAD_IDX_MAX][DEGRADE_SHIFT + 1] = {
>> +                                     {0, 0, 0, 0, 0, 0, 0, 0},
>> +                                     {64, 32, 8, 0, 0, 0, 0, 0},
>> +                                     {96, 72, 40, 12, 1, 0, 0},
>> +                                     {112, 98, 75, 43, 15, 1, 0},
>> +                                     {120, 112, 98, 76, 45, 16, 2} };
>> +
>> +/*
>> + * Update cpu_load for any backlog'd ticks. The backlog would be when
>> + * CPU is idle and so we just decay the old load without adding any new load.
>> + */
>> +static unsigned long update_backlog(unsigned long load,
>> +                        unsigned long missed_updates, int idx)
>> +{
>> +     int j = 0;
>> +
>> +     if (missed_updates >= degrade_zero_ticks[idx])
>> +             return 0;
>> +
>> +     if (idx == 1)
>> +             return load >> missed_updates;
>> +
>> +     while (missed_updates) {
>> +             if (missed_updates % 2)
>> +                     load =(load * degrade_factor[idx][j]) >> DEGRADE_SHIFT;
>> +
>> +             missed_updates >>= 1;
>> +             j++;
>> +     }
>> +     return load;
>> +}
>> +
>> +/*
>>   * Update rq->cpu_load[] statistics. This function is usually called every
>> - * scheduler tick (TICK_NSEC).
>> + * scheduler tick (TICK_NSEC). With tickless idle this will not be called
>> + * every tick. We fix it up based on jiffies.
>>   */
>>  static void update_cpu_load(struct rq *this_rq)
>>  {
>>       unsigned long this_load = this_rq->load.weight;
>> +     unsigned long curr_jiffies = jiffies;
>> +     unsigned long pending_updates, missed_updates;
>>       int i, scale;
>>
>>       this_rq->nr_load_updates++;
>>
>> +     if (curr_jiffies == this_rq->last_load_update_tick)
>> +             return;
>
> Under which conditions can this happen? Going idle right after having
> had the tick?

Yes. If we go idle after a tick and idle load balancer CPU gets its tick.

>
>> +     pending_updates = curr_jiffies - this_rq->last_load_update_tick;
>> +     this_rq->last_load_update_tick = curr_jiffies;
>> +     missed_updates = pending_updates - 1;
>> +
>>       /* Update our load: */
>> -     for (i = 0, scale = 1; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
>> +     this_rq->cpu_load[0] = this_load; /* Fasttrack for idx 0 */
>
> Why is this special case worth it?

I don't think it is really visible from performance point of view.
But, I did not like seeing
(old_load*(scale-1) + new_load) >> i
for scale = 1 and i = 0.
We have a subtraction, multiplication, shift, jump (loop) which can be
prevented with an
additional line of code, without making code any harder.

>
>> +     for (i = 1, scale = 2; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
>>               unsigned long old_load, new_load;
>>
>>               /* scale is effectively 1 << i now, and >> i divides by scale */
>>
>>               old_load = this_rq->cpu_load[i];
>> +             if (missed_updates)
>> +                     old_load = update_backlog(old_load, missed_updates, i);
>
> Would it make sense to stuff that conditional in update_backlog() and
> have a clearer flow? Maybe rename update_backlog() to decay_load() or
> such?

Yes. Makes sense. Will do and resend the patch.

Thanks,
Venki
