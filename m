Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab0HPObq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:31:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262Ab0HPObp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:31:45 -0400
Date: Mon, 16 Aug 2010 10:30:52 -0400
From: Don Zickus <dzickus@redhat.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH] fix BUG using smp_processor_id() in touch_nmi_watchdog
 and touch_softlockup_watchdog
Message-ID: <20100816143052.GV4879@redhat.com>
References: <20100813102158.GA5434@swordfish.minsk.epam.com>
 <1281946970.1926.998.camel@laptop>
 <20100816133452.GS4879@redhat.com>
 <1281966418.1926.1421.camel@laptop>
 <20100816140829.GA5225@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100816140829.GA5225@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ing Frederic

On Mon, Aug 16, 2010 at 05:08:29PM +0300, Sergey Senozhatsky wrote:
> Fix: acpi_os_stall calls touch_nmi_watchdog and touch_softlockup_watchdog
> with preemption enabled causing 'BUG: using smp_processor_id() in preemptible
> code'.
>      
> Patch also removes double smp_processor_id call (smp_processor_id itself and in
> __get_cpu_var) in __touch_watchdog.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Acked-by: Don Zickus <dzickus@redhat.com>

> 
> ---
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 613bc1f..8822f1e 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -116,13 +116,14 @@ static unsigned long get_sample_period(void)
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
> +	int this_cpu = get_cpu();
> +	per_cpu(watchdog_touch_ts, this_cpu) = 0;
> +	put_cpu();
>  }
>  EXPORT_SYMBOL(touch_softlockup_watchdog);
>  
> @@ -142,7 +143,9 @@ void touch_all_softlockup_watchdogs(void)
>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
>  void touch_nmi_watchdog(void)
>  {
> -	__get_cpu_var(watchdog_nmi_touch) = true;
> +	int this_cpu = get_cpu();
> +	per_cpu(watchdog_nmi_touch, this_cpu) = true;
> +	put_cpu();
>  	touch_softlockup_watchdog();
>  }
>  EXPORT_SYMBOL(touch_nmi_watchdog);
> 
