Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab0HQNOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:14:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab0HQNOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:14:10 -0400
Date: Tue, 17 Aug 2010 09:13:20 -0400
From: Don Zickus <dzickus@redhat.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix BUG using smp_processor_id() in touch_nmi_watchdog
 and touch_softlockup_watchdog
Message-ID: <20100817131320.GX4879@redhat.com>
References: <20100816133452.GS4879@redhat.com>
 <1281966418.1926.1421.camel@laptop>
 <20100816140829.GA5225@swordfish.minsk.epam.com>
 <20100817025954.GA12366@nowhere>
 <AANLkTikdng247Fct0ANXiitC3ja98_ee3-fUVDGraEwo@mail.gmail.com>
 <20100817083945.GA12022@swordfish.minsk.epam.com>
 <AANLkTik-4S_=L5FLhMfommf5Umd0xO+h4QP9uoxwrgFE@mail.gmail.com>
 <20100817092407.GB12022@swordfish.minsk.epam.com>
 <AANLkTikjR1nC3DYdvSw=FEmAVZ98=ju2RNq-MF1L7U3u@mail.gmail.com>
 <20100817103948.GA5352@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817103948.GA5352@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 01:39:48PM +0300, Sergey Senozhatsky wrote:
> Please kindly review.

I don't have a deep enough understanding of the subtleties between
per_cpu, __get_cpu_var, and __raw_get_cpu_var to really say which is
correct.  To me, all three versions of your patch look they do the same
thing.

Technically, it seems like preempt_disable/enable would be the correct
thing to do.  But as someone pointed out earlier, if the code is preempted
and switches cpu, then the touch_*_watchdog effectively becomes a no-op
(which I guess it can do even with the preempt_disable/enable surrounding
it).  So I have no idea.  I am going to wait for smarter people than me to
provide an opinion. :-)

Cheers,
Don

> 
> ---
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 613bc1f..22dd388 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -116,13 +116,12 @@ static unsigned long get_sample_period(void)
>  static void __touch_watchdog(void)
>  {
>  	int this_cpu = smp_processor_id();
> -
> -	__get_cpu_var(watchdog_touch_ts) = get_timestamp(this_cpu);
> +	per_cpu(watchdog_touch_ts, this_cpu) = get_timestamp(this_cpu);
>  }
>  
>  void touch_softlockup_watchdog(void)
>  {
> -	__get_cpu_var(watchdog_touch_ts) = 0;
> +	__raw_get_cpu_var(watchdog_touch_ts) = 0;
>  }
>  EXPORT_SYMBOL(touch_softlockup_watchdog);
>  
> @@ -142,7 +141,7 @@ void touch_all_softlockup_watchdogs(void)
>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
>  void touch_nmi_watchdog(void)
>  {
> -	__get_cpu_var(watchdog_nmi_touch) = true;
> +	__raw_get_cpu_var(watchdog_nmi_touch) = true;
>  	touch_softlockup_watchdog();
>  }
>  EXPORT_SYMBOL(touch_nmi_watchdog);
> 
