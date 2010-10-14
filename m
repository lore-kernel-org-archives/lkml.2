Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab0JNTuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:50:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:58995 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab0JNTua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:50:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,332,1283756400"; 
   d="scan'208";a="847207898"
Message-ID: <4CB75F05.9070505@linux.intel.com>
Date: Thu, 14 Oct 2010 12:50:29 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: penberg@cs.helsinki.fi, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [REGRESSION] um: rcu_sched_state detected stall on CPU 0
References: <AANLkTinNxzktyttzEjWSUPBiOUwh+4DUL0tmP7p1UiT5@mail.gmail.com>
In-Reply-To: <AANLkTinNxzktyttzEjWSUPBiOUwh+4DUL0tmP7p1UiT5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/14/2010 11:27 AM, richard -rw- weinberger wrote:
> Hi Arjan!
>
> This commit causes some problems on UML.
>
that is extremely weird.
> The kernel freezes after a few seconds until it gets some input.
> e.g: When I run top it stops refreshing the process list until i press a button.

a slab timer change (to not be as critical) causing global timer 
issues.... that's very obviously not a problem with this patch.
has this been seem anywhere except UML ?

> Messages like this appear:
> INFO: rcu_sched_state detected stall on CPU 0 (t=7348 jiffies)
>
> After reverting UML works fine again.
>
> commit 78b435368fcd615e695a06012cd963a556284e00
> Author: Arjan van de Ven<arjan@linux.intel.com>
> Date:   Mon Jul 19 10:59:42 2010 -0700
>
>      slab: use deferable timers for its periodic housekeeping
>
>      slab has a "once every 2 second" timer for its housekeeping.
>      As the number of logical processors is growing, its more and more
>      common that this 2 second timer becomes the primary wakeup source.
>
>      This patch turns this housekeeping timer into a deferable timer,
>      which means that the timer does not interrupt idle, but just runs
>      at the next event that wakes the cpu up.
>
>      The impact is that the timer likely runs a bit later, but during the
>      delay no code is running so there's not all that much reason for
>      a difference in housekeeping to occur because of this delay.
>
>      Signed-off-by: Arjan van de Ven<arjan@linux.intel.com>
>      Signed-off-by: Pekka Enberg<penberg@cs.helsinki.fi>
>
> diff --git a/mm/slab.c b/mm/slab.c
> index e49f8f4..29aad44 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -861,7 +861,7 @@ static void __cpuinit start_cpu_timer(int cpu)
>           */
>          if (keventd_up()&&  reap_work->work.func == NULL) {
>                  init_reap_node(cpu);
> -               INIT_DELAYED_WORK(reap_work, cache_reap);
> +               INIT_DELAYED_WORK_DEFERRABLE(reap_work, cache_reap);
>                  schedule_delayed_work_on(cpu, reap_work,
>                                          __round_jiffies_relative(HZ, cpu));
>          }
>
>

