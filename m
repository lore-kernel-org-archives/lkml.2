Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab1FENyk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 09:54:40 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:55206 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab1FENyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 09:54:39 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/X5zri/u5Y1+fsZ6BmRA==
X-RZG-CLASS-ID: mo00
Message-ID: <4DEB8A93.30601@die-jansens.de>
Date: Sun, 05 Jun 2011 15:54:27 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
References: <4DE8B13D.9020302@die-jansens.de> <1307097052.2353.3061.camel@twins> <20110605081747.GA17920@elte.hu> <4DEB4FA7.3050400@die-jansens.de> <20110605095555.GA22058@elte.hu> <4DEB58D8.4000805@die-jansens.de> <20110605110132.GB23463@elte.hu> <20110605111933.GA24592@elte.hu> <20110605113627.GA25724@elte.hu> <4DEB6F3A.3000109@die-jansens.de> <20110605133958.GA27812@elte.hu>
In-Reply-To: <20110605133958.GA27812@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.06.2011 15:39, Ingo Molnar wrote:
>
> * Arne Jansen<lists@die-jansens.de>  wrote:
>
>>>> Warning: it's entirely untested.
>>
>> How is the output supposed to come through? shouldn't printk revert
>> to early_printk instead of just returning?
>
> oh, right you are.
>
> Does the patch below work? It does early-printk within printk().

Too late, I already built my on early_vprintk ;)

Here we go:

http://eischnee.de/lockup.txt

Now it's your turn :)

-Arne

>
> Thanks,
>
> 	Ingo
>
> diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
> index cd28a35..211d8c2 100644
> --- a/arch/x86/kernel/early_printk.c
> +++ b/arch/x86/kernel/early_printk.c
> @@ -170,8 +170,8 @@ static struct console early_serial_console = {
>   };
>
>   /* Direct interface for emergencies */
> -static struct console *early_console =&early_vga_console;
> -static int __initdata early_console_initialized;
> +struct console *early_console =&early_vga_console;
> +int early_console_initialized;
>
>   asmlinkage void early_printk(const char *fmt, ...)
>   {
> diff --git a/include/linux/printk.h b/include/linux/printk.h
> index 0101d55..414dc34 100644
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -88,6 +88,9 @@ int no_printk(const char *fmt, ...)
>   	return 0;
>   }
>
> +extern struct console *early_console;
> +extern int early_console_initialized;
> +
>   extern asmlinkage __attribute__ ((format (printf, 1, 2)))
>   void early_printk(const char *fmt, ...);
>
> @@ -114,6 +117,8 @@ extern int printk_delay_msec;
>   extern int dmesg_restrict;
>   extern int kptr_restrict;
>
> +extern void printk_kill(void);
> +
>   void log_buf_kexec_setup(void);
>   void __init setup_log_buf(int early);
>   #else
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 3518539..50684e3 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -519,6 +519,19 @@ static void __call_console_drivers(unsigned start, unsigned end)
>   	}
>   }
>
> +/*
> + * This is independent of any log levels - a global
> + * kill switch that turns off all of printk.
> + *
> + * Used by the NMI watchdog if early-printk is enabled.
> + */
> +static int __read_mostly printk_killswitch;
> +
> +void printk_kill(void)
> +{
> +	printk_killswitch = 1;
> +}
> +
>   static int __read_mostly ignore_loglevel;
>
>   static int __init ignore_loglevel_setup(char *str)
> @@ -833,6 +846,16 @@ asmlinkage int vprintk(const char *fmt, va_list args)
>   	size_t plen;
>   	char special;
>
> +	/* Return early if a debugging subsystem has killed printk output: */
> +	if (unlikely(printk_killswitch)) {
> +		char buf[512];
> +
> +		printed_len = vscnprintf(buf, sizeof(buf), fmt, args);
> +		early_console->write(early_console, buf, printed_len);
> +
> +		return printed_len;
> +	}
> +
>   	boot_delay_msec();
>   	printk_delay();
>
> @@ -1533,6 +1556,7 @@ void register_console(struct console *newcon)
>   		for_each_console(bcon)
>   			if (bcon->flags&  CON_BOOT)
>   				unregister_console(bcon);
> +		early_console_initialized = 0;
>   	} else {
>   		printk(KERN_INFO "%sconsole [%s%d] enabled\n",
>   			(newcon->flags&  CON_BOOT) ? "boot" : "" ,
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 3d0c56a..6e9b109 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -234,6 +234,13 @@ static void watchdog_overflow_callback(struct perf_event *event, int nmi,
>   		if (__this_cpu_read(hard_watchdog_warn) == true)
>   			return;
>
> +		/*
> +		 * If early-printk is enabled then make sure we do not
> +		 * lock up in printk() and kill console logging:
> +		 */
> +		if (early_console_initialized)
> +			printk_kill();
> +
>   		if (hardlockup_panic)
>   			panic("Watchdog detected hard LOCKUP on cpu %d", this_cpu);
>   		else
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

