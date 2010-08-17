Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab0HQM5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 08:57:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46463 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab0HQM5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 08:57:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BMXRzjuqr8DV7GS1MLyVHXV5WzV5CQPaKcgigolCdbmalVhNgk1MNtLNz7GO1SB9kS
         7INa7Nlz9TnKut+FNuwJ+sPdMAXCQorHK8PCTNb/4DA9n9Zf+Q7XPYLx+TLt9SZaRm9V
         RA0tXbRDIvt5PbTo4Xw0kGGdAMOAONcPMeiyg=
Date: Tue, 17 Aug 2010 20:56:56 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix BUG using smp_processor_id() in touch_nmi_watchdog
 and touch_softlockup_watchdog
Message-ID: <20100817125656.GB2838@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100817103948.GA5352@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 01:39:48PM +0300, Sergey Senozhatsky wrote:
> Please kindly review.
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

The two caller of __touch_watchdog() is:
1)watchdog_timer_fn(): it's preempt disabled when called.
2)watchdog(): it's bound to one cpu. Then means using smp_processor_id()
              safely.

So I think this change is needless, but anyway it's harmless.

Below looks fine to me.
But you still need comments from others.

Thanks,
Yong

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
