Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab2EUULO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:11:14 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13794 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757813Ab2EUULN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:11:13 -0400
Message-ID: <4FBAA150.6050308@caviumnetworks.com>
Date: Mon, 21 May 2012 13:10:56 -0700
From: Venkat Subbiah <vsubbiah@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: "frank.rowand@am.sony.com" <frank.rowand@am.sony.com>
CC: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH RT 2/2] fix printk flush of messages
References: <4FB44EF1.9050809@am.sony.com> <4FB44FD0.4090800@am.sony.com>
In-Reply-To: <4FB44FD0.4090800@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2012 20:10:56.0985 (UTC) FILETIME=[D52A5490:01CD378D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 06:09 PM, Frank Rowand wrote:
> Updates console-make-rt-friendly.patch
>
> #ifdef CONFIG_PREEMPT_RT_FULL, printk() output is never flushed by
> printk() because:
So this is an issue for printk() itself and is not just for early_printk()?


    # some liberties taken in this pseudo-code to make it easier to follow
    printk()
       vprintk()
          raw_spin_lock(&logbuf_lock)
             # increment preempt_count():
             preempt_disable()
       result = console_trylock_for_printk()

As I read it console_trylock_for_printk() is called from printk() but in 
code it is called from vprintk()
>           retval = 0
>           # lock will always be false, because preempt_count() will be>= 1
>           lock = ...&&  !preempt_count()
>           if (lock)
>              retval = 1
>           return retval
>        # result will always be false since lock will always be false
>        if (result)
>           console_unlock()
>              # this is where the printk() output would be flushed
>
>
> On system boot some printk() output is flushed because register_console()
> and tty_open() call console_unlock().
>
>
> This change also fixes the problem that was previously fixed by
> preempt-rt-allow-immediate-magic-sysrq-output-for-preempt_rt_full.patch
>
> Signed-off-by: Frank Rowand<frank.rowand@am.sony.com>
>
> ---
>   kernel/printk.c |    2 	1 +	1 -	0 !
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: b/kernel/printk.c
> ===================================================================
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -847,7 +847,7 @@ static int console_trylock_for_printk(un
>   	int retval = 0, wake = 0;
>   #ifdef CONFIG_PREEMPT_RT_FULL
>   	int lock = !early_boot_irqs_disabled&&  !irqs_disabled_flags(flags)&&
> -		!preempt_count();
> +		(preempt_count()<= 1);
>   #else
>   	int lock = 1;
>   #endif
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

