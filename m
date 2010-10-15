Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab0JOHC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 03:02:58 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48160 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950Ab0JOHC5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 03:02:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=w63aq99I+eTUfbErtBLIYI4fjuAKd0eBrG6n3JPx/MI5M0me1g00sdhrUvxIx0AE92
         PIHKLADEqYmIMe6uNXg+qwgJIFmat1wDITf2gRPQwCDBITWlqfxs7XO6ZOoTM9yrtE/s
         zA1DD/2D1L76RU8NcPce4zPN2hw27yODeSvi8=
MIME-Version: 1.0
In-Reply-To: <AANLkTik5_TCXeGzTWBZzE8F0Cb2bQq-D228xDXk87rhP@mail.gmail.com>
References: <AANLkTinNxzktyttzEjWSUPBiOUwh+4DUL0tmP7p1UiT5@mail.gmail.com>
	<4CB75F05.9070505@linux.intel.com>
	<AANLkTik5_TCXeGzTWBZzE8F0Cb2bQq-D228xDXk87rhP@mail.gmail.com>
Date: Fri, 15 Oct 2010 10:02:56 +0300
X-Google-Sender-Auth: DR0CH48tjN2EbI8ZHz3jVlazaDs
Message-ID: <AANLkTi=vYFv+S=D6O06Nys4cjU7KHWv11d_VdLGmLyf6@mail.gmail.com>
Subject: Re: [REGRESSION] um: rcu_sched_state detected stall on CPU 0
From: Pekka Enberg <penberg@kernel.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, penberg@cs.helsinki.fi,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 2:44 AM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Thu, Oct 14, 2010 at 9:50 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
>>  On 10/14/2010 11:27 AM, richard -rw- weinberger wrote:
>>>
>>> Hi Arjan!
>>>
>>> This commit causes some problems on UML.
>>>
>> that is extremely weird.
>>>
>>> The kernel freezes after a few seconds until it gets some input.
>>> e.g: When I run top it stops refreshing the process list until i press a
>>> button.
>>
>> a slab timer change (to not be as critical) causing global timer issues....
>> that's very obviously not a problem with this patch.
>> has this been seem anywhere except UML ?
>
> A small update:
> It seems that CONFIG_NO_HZ is broken on UML. :-(
>
> CONFIG_NO_HZ + CONFIG_SLAB: works
> CONFIG_NO_HZ + CONFIG_SLAB + your patch: broken
> CONFIG_NO_HZ + CONFIG_SLUB: broken
>
> CONFIG_SLAB + your patch: works
> CONFIG_SLAB: works
> CONFIG_SLUB: works

Thanks for testing! Thomas, Ingo, Peter, I'm not sure who maintains
CONFIG_NO_HZ so I CC'd you. The problem here is that Arjan's
deferrable timers patch in SLAB triggered something that looks like a
latent bug with UML and NOHZ.

                        Pekka

>>> Messages like this appear:
>>> INFO: rcu_sched_state detected stall on CPU 0 (t=7348 jiffies)
>>>
>>> After reverting UML works fine again.
>>>
>>> commit 78b435368fcd615e695a06012cd963a556284e00
>>> Author: Arjan van de Ven<arjan@linux.intel.com>
>>> Date:   Mon Jul 19 10:59:42 2010 -0700
>>>
>>>     slab: use deferable timers for its periodic housekeeping
>>>
>>>     slab has a "once every 2 second" timer for its housekeeping.
>>>     As the number of logical processors is growing, its more and more
>>>     common that this 2 second timer becomes the primary wakeup source.
>>>
>>>     This patch turns this housekeeping timer into a deferable timer,
>>>     which means that the timer does not interrupt idle, but just runs
>>>     at the next event that wakes the cpu up.
>>>
>>>     The impact is that the timer likely runs a bit later, but during the
>>>     delay no code is running so there's not all that much reason for
>>>     a difference in housekeeping to occur because of this delay.
>>>
>>>     Signed-off-by: Arjan van de Ven<arjan@linux.intel.com>
>>>     Signed-off-by: Pekka Enberg<penberg@cs.helsinki.fi>
>>>
>>> diff --git a/mm/slab.c b/mm/slab.c
>>> index e49f8f4..29aad44 100644
>>> --- a/mm/slab.c
>>> +++ b/mm/slab.c
>>> @@ -861,7 +861,7 @@ static void __cpuinit start_cpu_timer(int cpu)
>>>          */
>>>         if (keventd_up()&&  reap_work->work.func == NULL) {
>>>                 init_reap_node(cpu);
>>> -               INIT_DELAYED_WORK(reap_work, cache_reap);
>>> +               INIT_DELAYED_WORK_DEFERRABLE(reap_work, cache_reap);
>>>                 schedule_delayed_work_on(cpu, reap_work,
>>>                                         __round_jiffies_relative(HZ,
>>> cpu));
>>>         }
>>>
>>>
>>
>>
>
>
>
> --
> Thanks,
> //richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
