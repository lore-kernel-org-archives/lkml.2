Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030208Ab1LPT7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:59:11 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:58092 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884Ab1LPT6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:58:53 -0500
Date: Fri, 16 Dec 2011 11:58:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH 10/15] module_param: make bool parameters really bool
 (core code)
Message-ID: <20111216195830.GH2419@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <87k45ysf1n.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k45ysf1n.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11121619-1780-0000-0000-000001B19459
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000241; HX=3.00000180; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00096675; UDB=6.00025173; UTC=2011-12-16
 19:58:50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 01:43:24PM +1030, Rusty Russell wrote:
> module_param(bool) used to counter-intuitively take an int.  In
> fddd5201 (mid-2009) we allowed bool or int/unsigned int using a messy
> trick.
> 
> It's time to remove the int/unsigned int option.  For this version
> it'll simply give a warning, but it'll break next kernel version.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

For the rcutorture component:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Given that this portion of the patch is self-sufficient, I have queued
the rcutorture portion of this patch with your signed-off-by, which I
can push for either 3.3 or 3.4 (default is most likely 3.4).  Of course,
if you would prefer some other approach, please let me know.

							Thanx, Paul

> ---
>  include/linux/init.h   |    3 ++-
>  init/main.c            |    2 +-
>  kernel/irq/internals.h |    2 +-
>  kernel/irq/spurious.c  |    2 +-
>  kernel/printk.c        |    8 ++++----
>  kernel/rcutorture.c    |    4 ++--
>  6 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/init.h b/include/linux/init.h
> --- a/include/linux/init.h
> +++ b/include/linux/init.h
> @@ -2,6 +2,7 @@
>  #define _LINUX_INIT_H
> 
>  #include <linux/compiler.h>
> +#include <linux/types.h>
> 
>  /* These macros are used to mark some functions or 
>   * initialized data (doesn't apply to uninitialized data)
> @@ -156,7 +157,7 @@ void prepare_namespace(void);
> 
>  extern void (*late_time_init)(void);
> 
> -extern int initcall_debug;
> +extern bool initcall_debug;
> 
>  #endif
>    
> diff --git a/init/main.c b/init/main.c
> --- a/init/main.c
> +++ b/init/main.c
> @@ -654,7 +654,7 @@ static void __init do_ctors(void)
>  #endif
>  }
> 
> -int initcall_debug;
> +bool initcall_debug;
>  core_param(initcall_debug, initcall_debug, bool, 0644);
> 
>  static char msgbuf[64];
> diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
> --- a/kernel/irq/internals.h
> +++ b/kernel/irq/internals.h
> @@ -15,7 +15,7 @@
> 
>  #define istate core_internal_state__do_not_mess_with_it
> 
> -extern int noirqdebug;
> +extern bool noirqdebug;
> 
>  /*
>   * Bits used by threaded handlers:
> diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
> --- a/kernel/irq/spurious.c
> +++ b/kernel/irq/spurious.c
> @@ -325,7 +325,7 @@ void note_interrupt(unsigned int irq, st
>  	desc->irqs_unhandled = 0;
>  }
> 
> -int noirqdebug __read_mostly;
> +bool noirqdebug __read_mostly;
> 
>  int noirqdebug_setup(char *str)
>  {
> diff --git a/kernel/printk.c b/kernel/printk.c
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -521,7 +521,7 @@ static void __call_console_drivers(unsig
>  	}
>  }
> 
> -static int __read_mostly ignore_loglevel;
> +static bool __read_mostly ignore_loglevel;
> 
>  static int __init ignore_loglevel_setup(char *str)
>  {
> @@ -695,9 +695,9 @@ static void zap_locks(void)
>  }
> 
>  #if defined(CONFIG_PRINTK_TIME)
> -static int printk_time = 1;
> +static bool printk_time = 1;
>  #else
> -static int printk_time = 0;
> +static bool printk_time = 0;
>  #endif
>  module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
> 
> @@ -1099,7 +1099,7 @@ int update_console_cmdline(char *name, i
>  	return -1;
>  }
> 
> -int console_suspend_enabled = 1;
> +bool console_suspend_enabled = 1;
>  EXPORT_SYMBOL(console_suspend_enabled);
> 
>  static int __init console_suspend_disable(char *str)
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -56,8 +56,8 @@ static int nreaders = -1;	/* # reader th
>  static int nfakewriters = 4;	/* # fake writer threads */
>  static int stat_interval;	/* Interval between stats, in seconds. */
>  				/*  Defaults to "only at end of test". */
> -static int verbose;		/* Print more debug info. */
> -static int test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
> +static bool verbose;		/* Print more debug info. */
> +static bool test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
>  static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
>  static int stutter = 5;		/* Start/stop testing interval (in sec) */
>  static int irqreader = 1;	/* RCU readers from irq (timers). */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

