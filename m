Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab0HRTeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:34:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185Ab0HRTeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:34:16 -0400
Date: Wed, 18 Aug 2010 12:33:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: fix BUG: using smp_processor_id() in touch_nmi_watchdog and
 touch_softlockup_watchdog
Message-Id: <20100818123346.02028e96.akpm@linux-foundation.org>
In-Reply-To: <20100813102158.GA5434@swordfish.minsk.epam.com>
References: <20100813102158.GA5434@swordfish.minsk.epam.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Aug 2010 13:21:58 +0300
Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> Hello,
> 
> Got this traces today:
> 
> ...
> 
> Avoid using smp_processor_id in touch_softlockup_watchdog and touch_nmi_watchdog.
> Patch also "removes" second call to smp_processor_id in __touch_watchdog
> (smp_processor_id itself and smp_processor_id in __get_cpu_var). 
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

Fair enough, although strictly speaking this should be done in a
separate and later patch.

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

Why did this start happening?  Surely we've called
touch_softlockup_watchdog() from within preemptible code before now. 
Methinks that

: commit 26e09c6eee14f4827b55137ba0eedc4e77cd50ab
: Author:     Don Zickus <dzickus@redhat.com>
: AuthorDate: Mon May 17 18:06:04 2010 -0400
: Commit:     Frederic Weisbecker <fweisbec@gmail.com>
: CommitDate: Wed May 19 11:32:14 2010 +0200
: 
:     lockup_detector: Convert per_cpu to __get_cpu_var for readability

was simply broken?  That would be strange, given that it's been sitting
around since May 17.

If we don't want to revert 26e09c6eee14f4827b55137ba0eedc4e77cd50ab
then I'd suggest that we simply switch to raw_smp_processor_id(): those
newly-added get_cpu/put_cpu calls don't do anything useful.
