Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab0JNUGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 16:06:42 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63328 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab0JNUGl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 16:06:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W8uj5ibtzkSPp3FQ8uMCt2cMu8ZYtdTiIZNnyK2JJDLyYaP9ESxcfGzyBev5CSk3Go
         R4MSV0wp6Rt6+OnInHtm6+jNmECTqaDM2SBVGyXX2BMxyjzNi7hdLuzjiiXXJzNqxUx3
         48enht2dJjgru2Y32LXD/fpdSpCrm2Y5FfZKQ=
MIME-Version: 1.0
In-Reply-To: <4CB75F05.9070505@linux.intel.com>
References: <AANLkTinNxzktyttzEjWSUPBiOUwh+4DUL0tmP7p1UiT5@mail.gmail.com>
	<4CB75F05.9070505@linux.intel.com>
Date: Thu, 14 Oct 2010 22:06:39 +0200
Message-ID: <AANLkTin2xPm2PCy-nd1MYxjy+Dis4T1Zh4Vzy07+k=Yx@mail.gmail.com>
Subject: Re: [REGRESSION] um: rcu_sched_state detected stall on CPU 0
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: penberg@cs.helsinki.fi, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net, cdfrey@foursquare.net
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
>

So far I've seen this problem only on UML.
Chris saw it too:
http://marc.info/?l=linux-kernel&m=128622041625323&w=2

Maybe your patch triggers a general timer problem within UML?

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
