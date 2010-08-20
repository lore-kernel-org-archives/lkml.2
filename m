Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab0HTNru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 09:47:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45272 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab0HTNrr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 09:47:47 -0400
Subject: Re: [patch 3/3] sched: move sched_avg_update() to update_cpu_load()
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chris@frostnet.net" <chris@frostnet.net>,
        "debian00@aliceadsl.fr" <debian00@aliceadsl.fr>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jonathan.protzenko@gmail.com" <jonathan.protzenko@gmail.com>,
        "mans@mansr.com" <mans@mansr.com>,
        "psastudio@mail.ru" <psastudio@mail.ru>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "stephan.eicher@web.de" <stephan.eicher@web.de>,
        "sxxe@gmx.de" <sxxe@gmx.de>,
        "thomas@archlinux.org" <thomas@archlinux.org>,
        "venki@google.com" <venki@google.com>,
        "wonghow@gmail.com" <wonghow@gmail.com>
In-Reply-To: <1282265478.10905.1.camel@sbsiddha-MOBL3.sc.intel.com>
References: <20100813190539.410550989@sbsiddha-MOBL3.sc.intel.com>
	 <20100813193911.999833492@sbsiddha-MOBL3.sc.intel.com>
	 <1281945634.1926.968.camel@laptop>
	 <1281980769.2676.33.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1281987086.1926.1890.camel@laptop>
	 <1282265478.10905.1.camel@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 20 Aug 2010 15:47:23 +0200
Message-ID: <1282312043.2605.1033.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 17:51 -0700, Suresh Siddha wrote:
> 
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: sched: move sched_avg_update() to update_cpu_load()
> 
> Currently sched_avg_update() (which updates rt_avg stats in the rq) is getting
> called from scale_rt_power() (in the load balance context) which doesn't take
> rq->lock.
> 
> Fix it by moving the sched_avg_update() to more appropriate update_cpu_load()
> where the CFS load gets updated aswell.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  kernel/sched.c      |    3 ++-
>  kernel/sched_fair.c |    2 --
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> Index: tree/kernel/sched_fair.c
> ===================================================================
> --- tree.orig/kernel/sched_fair.c
> +++ tree/kernel/sched_fair.c
> @@ -2268,8 +2268,6 @@ unsigned long scale_rt_power(int cpu)
>         struct rq *rq = cpu_rq(cpu);
>         u64 total, available;
>  
> -       sched_avg_update(rq);
> -
>         total = sched_avg_period() + (rq->clock - rq->age_stamp);
>         available = total - rq->rt_avg;
>  
> Index: tree/kernel/sched.c
> ===================================================================
> --- tree.orig/kernel/sched.c
> +++ tree/kernel/sched.c
> @@ -3182,6 +3182,8 @@ static void update_cpu_load(struct rq *t
>  
>                 this_rq->cpu_load[i] = (old_load * (scale - 1) + new_load) >> i;
>         }
> +
> +       sched_avg_update(this_rq);
>  }
>  
>  static void update_cpu_load_active(struct rq *this_rq) 

breaks CONFIG_SMP=n builds..

  CC      kernel/sched.o
/usr/src/linux-2.6/kernel/sched.c: In function ‘update_cpu_load’:
/usr/src/linux-2.6/kernel/sched.c:3186: error: implicit declaration of function ‘sched_avg_update’  CC      kernel/sched.o
/usr/src/linux-2.6/kernel/sched.c: In function ‘update_cpu_load’:
/usr/src/linux-2.6/kernel/sched.c:3186: error: implicit declaration of function ‘sched_avg_update’


