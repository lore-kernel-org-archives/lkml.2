Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab2KMVnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:43:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:53827 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab2KMVnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:43:17 -0500
Message-ID: <50A2BEC4.7080006@infradead.org>
Date: Tue, 13 Nov 2012 13:42:28 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrew Cooks <acooks@gmail.com>
CC: "Greg Kroah-Hartman (commit_signer:31/49=63%)" 
	<gregkh@linuxfoundation.org>,
        "Kay Sievers (commit_signer:27/49=55%)" <kay@vrfy.org>,
        "Peter Zijlstra (commit_signer:7/49=14%)" <a.p.zijlstra@chello.nl>,
        "Andrew Morton (commit_signer:5/49=10%)" <akpm@linux-foundation.org>,
        "Ingo Molnar (commit_signer:5/49=10%)" <mingo@elte.hu>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] boot_delay should only affect output
References: <1352789457-15244-1-git-send-email-acooks@gmail.com>
In-Reply-To: <1352789457-15244-1-git-send-email-acooks@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 10:50 PM, Andrew Cooks wrote:

> The boot_delay parameter affects all printk(), even if the log level
>  prevents visible output from the call. It results in delays greater
>  than the user intended without purpose.
> 
> This patch changes the behaviour of boot_delay to only delay output.
> 
> Signed-off-by: Andrew Cooks <acooks@gmail.com>


Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  kernel/printk.c |   40 +++++++++++++++++++++-------------------
>  1 files changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 66a2ea3..c098003 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -741,6 +741,21 @@ void __init setup_log_buf(int early)
>  		free, (free * 100) / __LOG_BUF_LEN);
>  }
>  
> +static bool __read_mostly ignore_loglevel;
> +
> +static int __init ignore_loglevel_setup(char *str)
> +{
> +	ignore_loglevel = 1;
> +	printk(KERN_INFO "debug: ignoring loglevel setting.\n");
> +
> +	return 0;
> +}
> +
> +early_param("ignore_loglevel", ignore_loglevel_setup);
> +module_param(ignore_loglevel, bool, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
> +	"print all kernel messages to the console.");
> +
>  #ifdef CONFIG_BOOT_PRINTK_DELAY
>  
>  static int boot_delay; /* msecs delay after each printk during bootup */
> @@ -764,13 +779,15 @@ static int __init boot_delay_setup(char *str)
>  }
>  __setup("boot_delay=", boot_delay_setup);
>  
> -static void boot_delay_msec(void)
> +static void boot_delay_msec(int level)
>  {
>  	unsigned long long k;
>  	unsigned long timeout;
>  
> -	if (boot_delay == 0 || system_state != SYSTEM_BOOTING)
> +	if ((boot_delay == 0 || system_state != SYSTEM_BOOTING)
> +		|| (level >= console_loglevel && !ignore_loglevel)) {
>  		return;
> +	}
>  
>  	k = (unsigned long long)loops_per_msec * boot_delay;
>  
> @@ -789,7 +806,7 @@ static void boot_delay_msec(void)
>  	}
>  }
>  #else
> -static inline void boot_delay_msec(void)
> +static inline void boot_delay_msec(int level)
>  {
>  }
>  #endif
> @@ -1232,21 +1249,6 @@ SYSCALL_DEFINE3(syslog, int, type, char __user *, buf, int, len)
>  	return do_syslog(type, buf, len, SYSLOG_FROM_CALL);
>  }
>  
> -static bool __read_mostly ignore_loglevel;
> -
> -static int __init ignore_loglevel_setup(char *str)
> -{
> -	ignore_loglevel = 1;
> -	printk(KERN_INFO "debug: ignoring loglevel setting.\n");
> -
> -	return 0;
> -}
> -
> -early_param("ignore_loglevel", ignore_loglevel_setup);
> -module_param(ignore_loglevel, bool, S_IRUGO | S_IWUSR);
> -MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
> -	"print all kernel messages to the console.");
> -
>  /*
>   * Call the console drivers, asking them to write out
>   * log_buf[start] to log_buf[end - 1].
> @@ -1492,7 +1494,7 @@ asmlinkage int vprintk_emit(int facility, int level,
>  	int this_cpu;
>  	int printed_len = 0;
>  
> -	boot_delay_msec();
> +	boot_delay_msec(level);
>  	printk_delay();
>  
>  	/* This stops the holder of console_sem just where we want him */



-- 
~Randy
