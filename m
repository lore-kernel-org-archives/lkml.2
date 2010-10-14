Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab0JNXoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 19:44:10 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54430 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab0JNXoI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 19:44:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GkVZl15x6Cd7F5Bvbbckwsi8006Z3BRnDf54Tc7U00jjgSmS7AoiCmYb2Xixkggu25
         fP8GCPZ9l8ssOZDlukqqAo7QwfiZT7doHl/TK5f2Qb0pWLhW5zWQ+gMk0y0WLn5n7JFW
         TTfIVyrJqEXy3xoyMivkbcWJr30GPu06VOB6k=
MIME-Version: 1.0
In-Reply-To: <4CB75F05.9070505@linux.intel.com>
References: <AANLkTinNxzktyttzEjWSUPBiOUwh+4DUL0tmP7p1UiT5@mail.gmail.com>
	<4CB75F05.9070505@linux.intel.com>
Date: Fri, 15 Oct 2010 01:44:08 +0200
Message-ID: <AANLkTik5_TCXeGzTWBZzE8F0Cb2bQq-D228xDXk87rhP@mail.gmail.com>
Subject: Re: [REGRESSION] um: rcu_sched_state detected stall on CPU 0
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: penberg@cs.helsinki.fi, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 9:50 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
>  On 10/14/2010 11:27 AM, richard -rw- weinberger wrote:
>>
>> Hi Arjan!
>>
>> This commit causes some problems on UML.
>>
> that is extremely weird.
>>
>> The kernel freezes after a few seconds until it gets some input.
>> e.g: When I run top it stops refreshing the process list until i press a
>> button.
>
> a slab timer change (to not be as critical) causing global timer issues....
> that's very obviously not a problem with this patch.
> has this been seem anywhere except UML ?

A small update:
It seems that CONFIG_NO_HZ is broken on UML. :-(

CONFIG_NO_HZ + CONFIG_SLAB: works
CONFIG_NO_HZ + CONFIG_SLAB + your patch: broken
CONFIG_NO_HZ + CONFIG_SLUB: broken

CONFIG_SLAB + your patch: works
CONFIG_SLAB: works
CONFIG_SLUB: works

>> Messages like this appear:
>> INFO: rcu_sched_state detected stall on CPU 0 (t=7348 jiffies)
>>
>> After reverting UML works fine again.
>>
>> commit 78b435368fcd615e695a06012cd963a556284e00
>> Author: Arjan van de Ven<arjan@linux.intel.com>
>> Date:   Mon Jul 19 10:59:42 2010 -0700
>>
>>     slab: use deferable timers for its periodic housekeeping
>>
>>     slab has a "once every 2 second" timer for its housekeeping.
>>     As the number of logical processors is growing, its more and more
>>     common that this 2 second timer becomes the primary wakeup source.
>>
>>     This patch turns this housekeeping timer into a deferable timer,
>>     which means that the timer does not interrupt idle, but just runs
>>     at the next event that wakes the cpu up.
>>
>>     The impact is that the timer likely runs a bit later, but during the
>>     delay no code is running so there's not all that much reason for
>>     a difference in housekeeping to occur because of this delay.
>>
>>     Signed-off-by: Arjan van de Ven<arjan@linux.intel.com>
>>     Signed-off-by: Pekka Enberg<penberg@cs.helsinki.fi>
>>
>> diff --git a/mm/slab.c b/mm/slab.c
>> index e49f8f4..29aad44 100644
>> --- a/mm/slab.c
>> +++ b/mm/slab.c
>> @@ -861,7 +861,7 @@ static void __cpuinit start_cpu_timer(int cpu)
>>          */
>>         if (keventd_up()&&  reap_work->work.func == NULL) {
>>                 init_reap_node(cpu);
>> -               INIT_DELAYED_WORK(reap_work, cache_reap);
>> +               INIT_DELAYED_WORK_DEFERRABLE(reap_work, cache_reap);
>>                 schedule_delayed_work_on(cpu, reap_work,
>>                                         __round_jiffies_relative(HZ,
>> cpu));
>>         }
>>
>>
>
>



-- 
Thanks,
//richard
