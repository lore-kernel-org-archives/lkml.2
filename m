Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935422Ab0KQTpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 14:45:34 -0500
Received: from smtp-out.google.com ([74.125.121.35]:40874 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab0KQTpd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 14:45:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lool9hXYVgt7TEOCA+n0wAalkr2LnOYKfLx5QG/+TYWDUy9wqviPAFihFx0JAVWPc5
         mj0iSifgPU0Uto86GlLA==
MIME-Version: 1.0
In-Reply-To: <1290022924-3548-1-git-send-email-ncrao@google.com>
References: <1289956639.27424.303.camel@debian> <1290022924-3548-1-git-send-email-ncrao@google.com>
From: Nikhil Rao <ncrao@google.com>
Date: Wed, 17 Nov 2010 11:45:07 -0800
Message-ID: <AANLkTimqnATGj2cFeU8qWgjVErb7y3j1ENg7vx_B7HU2@mail.gmail.com>
Subject: Re: [performance bug] volanomark regression on 37-rc1
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>
Cc: Alex Shi <alex.shi@intel.com>, Nikhil Rao <ncrao@google.com>,
        Rakib Mullick <rakib.mullick@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forgot to add cc-list in previous mail.

On Wed, Nov 17, 2010 at 11:42 AM, Nikhil Rao <ncrao@google.com> wrote:
> On Tue, Nov 16, 2010 at 5:17 PM, Alex,Shi <alex.shi@intel.com> wrote:
>>
>> In the original source (.36 kernel) the rq->idle_stamp is set as zero
>> after task was pulled to this cpu in load_balance(). Nikhil move this
>> setting to pull_task(), that has same effect.
>> I don't know what the details effect of removing idle_stamp setting
>> instead of recovered it on idle_balance(). :)
>>
>> My machines are doing rc2 performance testing. I may try this patch
>> after testing finish.
>>
>> The following is part of Nikhil's old patch.
>> ===
>> @@ -3162,10 +3186,8 @@ static void idle_balance(int this_cpu, struct rq
>> *this_rq)
>>                interval = msecs_to_jiffies(sd->balance_interval);
>>                if (time_after(next_balance, sd->last_balance +
>> interval))
>>                        next_balance = sd->last_balance + interval;
>> -               if (pulled_task) {
>> -                       this_rq->idle_stamp = 0;
>> +               if (pulled_task)
>>                        break;
>> -               }
>>        }
>>
>> Regards
>> Alex
>>
>
> Ah, should have caught this when reviewing Mike's patch. :-(
>
> Thanks for catching that. We need to reset idle_stamp to 0 or else the avg_idle
> calculations are incorrect. I've attached a patch below that resets idle_stamp
> in the newidle path when we pull.
>
> ---
> sched: volanomark regression fix (part 2)
>
> An earlier commit reverts idle balancing throttling reset to fix a 30%
> regression in volanomark throughput. We still need to reset idle_stamp when we
> pull a task in newidle balance.
>
> Reported-by: Alex Shi <alex.shi@intel.com>
> Signed-off-by: Nikhil Rao <ncrao@google.com>
> ---
>  kernel/sched_fair.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 83f65dd..e6e7d4b 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -3193,8 +3193,10 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
>                interval = msecs_to_jiffies(sd->balance_interval);
>                if (time_after(next_balance, sd->last_balance + interval))
>                        next_balance = sd->last_balance + interval;
> -               if (pulled_task)
> +               if (pulled_task) {
> +                       this_rq->idle_stamp = 0;
>                        break;
> +               }
>        }
>
>        raw_spin_lock(&this_rq->lock);
> --
> 1.7.3.1
>
>
