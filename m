Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab2FFHd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:33:28 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55981 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2FFHd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:33:27 -0400
Date: Wed, 6 Jun 2012 09:33:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] printk: Shrink printk_sched buffer size, eliminate it
 when !CONFIG_PRINTK
Message-ID: <20120606073321.GH17808@gmail.com>
References: <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
 <1337096141.27694.82.camel@twins>
 <1337193010.27694.146.camel@twins>
 <CA+55aFzuygx6L-2hVCMbk5cvEdDp6AUtOGq-wYFn=4yEyebPLw@mail.gmail.com>
 <1337468148.573.139.camel@twins>
 <CANQmPXhN92i9E8HqxE7pqz=kOwtn5Mz0crW37H6qs+XD420Yuw@mail.gmail.com>
 <20120523150359.GB26974@gmail.com>
 <1337787838.1734.15.camel@joe2Laptop>
 <20120523155003.GA8202@gmail.com>
 <1338315431.18974.10.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338315431.18974.10.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> The size of the per-cpu printk_sched buf is much larger
> than necessary.  The maximum sched message emitted is
> ~80 bytes. Shrink the allocation for this printk_sched
> buffer from 512 bytes to 128.
> 
> printk_sched creates an unnecessary per-cpu buffer when
> CONFIG_PRINTK is not enabled.  Remove it when appropriate
> so embedded uses save a bit of space too.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  kernel/printk.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 32462d2..61cff0b 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -1726,24 +1726,30 @@ int is_console_locked(void)
>  }
>  
>  /*
> - * Delayed printk version, for scheduler-internal messages:
> + * Delayed printk version, for scheduler-internal messages.
> + * Not the normal 512 as it's a bit wasteful, sched messages are short,
> + * and 128 is more than sufficient for all current messages.
>   */
> -#define PRINTK_BUF_SIZE		512
> +#define PRINTK_SCHED_BUF_SIZE	128
>  
>  #define PRINTK_PENDING_WAKEUP	0x01
>  #define PRINTK_PENDING_SCHED	0x02
>  
>  static DEFINE_PER_CPU(int, printk_pending);
> -static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
> +#ifdef CONFIG_PRINTK
> +static DEFINE_PER_CPU(char [PRINTK_SCHED_BUF_SIZE], printk_sched_buf);
> +#endif
>  
>  void printk_tick(void)
>  {
>  	if (__this_cpu_read(printk_pending)) {
>  		int pending = __this_cpu_xchg(printk_pending, 0);
> +#ifdef CONFIG_PRINTK
>  		if (pending & PRINTK_PENDING_SCHED) {
>  			char *buf = __get_cpu_var(printk_sched_buf);
>  			printk(KERN_WARNING "[sched_delayed] %s", buf);
>  		}
> +#endif
>  		if (pending & PRINTK_PENDING_WAKEUP)
>  			wake_up_interruptible(&log_wait);
>  	}
> @@ -2189,7 +2195,7 @@ int printk_sched(const char *fmt, ...)
>  	buf = __get_cpu_var(printk_sched_buf);
>  
>  	va_start(args, fmt);
> -	r = vsnprintf(buf, PRINTK_BUF_SIZE, fmt, args);
> +	r = vsnprintf(buf, PRINTK_SCHED_BUF_SIZE, fmt, args);
>  	va_end(args);
>  
>  	__this_cpu_or(printk_pending, PRINTK_PENDING_SCHED);

The change makes sense but the further proliferation of #ifdefs 
is rather ugly and shows confusion: fundamentally, if we are 
going to cut out more printk functionality in the !CONFIG_PRINTK 
we might as well disable the whole thing, not just the 
printk_sched bits.

Thanks,

	Ingo
