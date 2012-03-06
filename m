Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965092Ab2CFEVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 23:21:35 -0500
Received: from smtp1.Stanford.EDU ([171.67.219.81]:52879 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965036Ab2CFEVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 23:21:34 -0500
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Mar 2012 23:21:34 EST
Message-ID: <4F558F74.5050704@localhost>
Date: Mon, 05 Mar 2012 20:15:48 -0800
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <clark@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Subject: Re: [ANNOUNCE] 3.2.9-rt15
References: <alpine.LFD.2.02.1203021743040.2742@ionos> <1330985640.25686.342.camel@gandalf.stny.rr.com>
In-Reply-To: <1330985640.25686.342.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2012 02:14 PM, Steven Rostedt wrote:
> Thomas,
>
> Please fold this change into
>
>     cpu-rt-make-hotplug-lock-a-sleeping-spinlock-on-rt.patch

Thanks, this fixed the panic on shutdown I was experiencing!
-- Fernando


> As the patch was never tested (nor even compiled) it introduced a nasty
> bug into taking a CPU down instead of fixing one.
>
> Thanks,
>
> -- Steve
>
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index c25b5ff..66dfb74 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -59,16 +59,20 @@ static struct {
>   	int refcount;
>   } cpu_hotplug = {
>   	.active_writer = NULL,
> +#ifdef CONFIG_PREEMPT_RT_FULL
> +	.lock = __SPIN_LOCK_UNLOCKED(cpu_hotplug.lock),
> +#else
>   	.lock = __MUTEX_INITIALIZER(cpu_hotplug.lock),
> +#endif
>   	.refcount = 0,
>   };
>
>   #ifdef CONFIG_PREEMPT_RT_FULL
> -# define hotplug_lock() spin_lock(&cpu_hotplug.lock)
> -# define hotplug_unlock() spin_unlock(&cpu_hotplug.lock)
> +# define hotplug_lock() rt_spin_lock(&cpu_hotplug.lock)
> +# define hotplug_unlock() rt_spin_unlock(&cpu_hotplug.lock)
>   #else
>   # define hotplug_lock() mutex_lock(&cpu_hotplug.lock)
> -# define hotplug_lock() mutex_unlock(&cpu_hotplug.lock)
> +# define hotplug_unlock() mutex_unlock(&cpu_hotplug.lock)
>   #endif
>
>   struct hotplug_pcp {
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
