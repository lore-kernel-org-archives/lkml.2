Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab0KXDZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 22:25:29 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:42737 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab0KXDZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 22:25:28 -0500
Message-ID: <4CEC853B.6080508@kernel.org>
Date: Tue, 23 Nov 2010 19:23:39 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com, gorcunov@openvz.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] x86, nmi_watchdog:  remove the old nmi_watchdog
References: <1290540725-2911-1-git-send-email-dzickus@redhat.com> <1290540725-2911-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1290540725-2911-3-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2010 11:32 AM, Don Zickus wrote:
> Now that we have a new nmi_watchdog that is more generic and sits on
> top of the perf subsystem, we really do not need the old nmi_watchdog
> any more.
> 
> In addition, the old nmi_watchdog doesn't really work if you are using
> the default clocksource, hpet.  The old nmi_watchdog code relied on
> local apic interrupts to determine if the cpu is still alive.  With
> hpet as the clocksource, these interrupts don't increment any more
> and the old nmi_watchdog triggers false postives.
> 
> This piece removes the old nmi_watchdog code and stubs out any variables
> and functions calls.  The stubs are the same ones used by the new
> nmi_watchdog code, so it should be well tested.
> 
> v2: fix sparc breakage by undoing linux/nmi.h changes
>     clean up documentation and sysctl stuff
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  Documentation/kernel-parameters.txt |   10 +-
>  arch/x86/include/asm/nmi.h          |    4 -
>  arch/x86/kernel/apic/Makefile       |    5 +-
>  arch/x86/kernel/apic/hw_nmi.c       |   14 +-
>  arch/x86/kernel/apic/nmi.c          |  540 -----------------------------------
>  arch/x86/kernel/traps.c             |    8 -
>  kernel/sysctl.c                     |    9 +-
>  kernel/sysctl_binary.c              |    1 -
>  kernel/watchdog.c                   |    2 +
>  9 files changed, 16 insertions(+), 577 deletions(-)
>  delete mode 100644 arch/x86/kernel/apic/nmi.c
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index ed45e98..e48b93f 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1579,20 +1579,12 @@ and is between 256 and 4096 characters. It is defined in the file
>  
>  	nmi_watchdog=	[KNL,BUGS=X86] Debugging features for SMP kernels
>  			Format: [panic,][num]
> -			Valid num: 0,1,2
> +			Valid num: 0
>  			0 - turn nmi_watchdog off

thanks for keeping nmi_watchdog=0

> -			1 - use the IO-APIC timer for the NMI watchdog
> -			2 - use the local APIC for the NMI watchdog using
> -			a performance counter. Note: This will use one
> -			performance counter and the local APIC's performance
> -			vector.
>  			When panic is specified, panic when an NMI watchdog
>  			timeout occurs.
>  			This is useful when you use a panic=... timeout and
>  			need the box quickly up again.
> -			Instead of 1 and 2 it is possible to use the following
> -			symbolic names: lapic and ioapic
> -			Example: nmi_watchdog=2 or nmi_watchdog=panic,lapic
>  
>  	netpoll.carrier_timeout=
>  			[NET] Specifies amount of time (in seconds) that
...
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index c33a1ed..0daad4e 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -737,7 +737,7 @@ static struct ctl_table kern_table[] = {
>  		.extra2		= &one,
>  	},
>  #endif
> -#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86) && !defined(CONFIG_LOCKUP_DETECTOR)
> +#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
>  	{
>  		.procname       = "unknown_nmi_panic",
>  		.data           = &unknown_nmi_panic,
> @@ -745,13 +745,6 @@ static struct ctl_table kern_table[] = {
>  		.mode           = 0644,
>  		.proc_handler   = proc_dointvec,
>  	},
> -	{
> -		.procname       = "nmi_watchdog",
> -		.data           = &nmi_watchdog_enabled,
> -		.maxlen         = sizeof (int),
> -		.mode           = 0644,
> -		.proc_handler   = proc_nmi_enabled,
> -	},

wonder if you can keep nmi_watchdog in sysctl? So in run-time it could be disabled after it booted up.

>  #endif
>  #if defined(CONFIG_X86)
>  	{
> diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
> index 1357c57..4b2545a 100644
> --- a/kernel/sysctl_binary.c
> +++ b/kernel/sysctl_binary.c
> @@ -136,7 +136,6 @@ static const struct bin_table bin_kern_table[] = {
>  	{ CTL_INT,	KERN_IA64_UNALIGNED,		"ignore-unaligned-usertrap" },
>  	{ CTL_INT,	KERN_COMPAT_LOG,		"compat-log" },
>  	{ CTL_INT,	KERN_MAX_LOCK_DEPTH,		"max_lock_depth" },
> -	{ CTL_INT,	KERN_NMI_WATCHDOG,		"nmi_watchdog" },
>  	{ CTL_INT,	KERN_PANIC_ON_NMI,		"panic_on_unrecovered_nmi" },
>  	{}
>  };
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index bafba68..3c5441f 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -57,6 +57,8 @@ static int __init hardlockup_panic_setup(char *str)
>  {
>  	if (!strncmp(str, "panic", 5))
>  		hardlockup_panic = 1;
> +	else if (!strncmp(str, "0", 1))
> +		no_watchdog = 1;
>  	return 1;
>  }
>  __setup("nmi_watchdog=", hardlockup_panic_setup);

Thanks

	Yinghai
