Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab1FEIx7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 04:53:59 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:37533 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab1FEIx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 04:53:57 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/X5zri/u5Y1+fsZ6BmRA==
X-RZG-CLASS-ID: mo00
Message-ID: <4DEB4417.9070003@die-jansens.de>
Date: Sun, 05 Jun 2011 10:53:43 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
References: <4DE64596.5010006@die-jansens.de> <1306946120.2497.606.camel@laptop> <4DE674EB.1000200@die-jansens.de> <1306951751.2497.626.camel@laptop> <1306953870.2497.627.camel@laptop> <4DE6936F.7090700@die-jansens.de> <BANLkTimXXR1mJDtdCsbXF410sd3irFSitQ@mail.gmail.com> <1307092535.2353.2973.camel@twins> <4DE8B13D.9020302@die-jansens.de> <1307097052.2353.3061.camel@twins> <20110605081747.GA17920@elte.hu>
In-Reply-To: <20110605081747.GA17920@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.06.2011 10:17, Ingo Molnar wrote:
>
> * Peter Zijlstra<peterz@infradead.org>  wrote:
>
>> On Fri, 2011-06-03 at 12:02 +0200, Arne Jansen wrote:
>>> On 03.06.2011 11:15, Peter Zijlstra wrote:
>>
>>>> Anyway, Arne, how long did you wait before power cycling the box? The
>>>> NMI watchdog should trigger in about a minute or so if it will trigger
>>>> at all (its enabled in your config).
>>>
>>> No, it doesn't trigger,
>>
>> Bummer.
>
> Is there no output even when the console is configured to do an
> earlyprintk? That will allow the NMI watchdog to punch through even a
> printk or scheduler lockup.
>

Just to be clear, I have no boot problems whatsoever. And I have no
problems with the serial console. It's just the regular printk locking
up when e.g. I load the test module.

> Arne, you can turn this on via one of these:
>
>    earlyprintk=vga,keep

I don't have access to vga as it is a remote machine.

>    earlyprintk=serial,ttyS0,115200,keep

I'll try that.

>
> (the ',keep' portion is important to have it active even after the
> regular console has been switched on.)
>
> Could you also please check with the (untested) patch below applied?
> This will turn off *all* printk done by the NMI watchdog and switches
> it to do pure early_printk() - which does not use any locking so it
> should never lock up.
>
> [ If you keep seeing 'NMI watchdog tick' messages periodically
>    occuring after the lockup then i'll send a more complete patch that
>    shuts off the regular printk path and makes sure that all output is
>    early_printk() based only. ]
>
> earlyprintk=,keep with such a patch has let me down only on the
> rarest of occasions.
>
> ( Arne, please also double check on a working bootup that the NMI
>    watchdog is actually ticking, by checking the NMI counts in
>    /proc/interrupts go up slowly but surely on all CPUs. )
>
> Thanks,
>
> 	Ingo
>
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 3d0c56a..7c7e33f 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -234,15 +234,12 @@ static void watchdog_overflow_callback(struct perf_event *event, int nmi,
>   		if (__this_cpu_read(hard_watchdog_warn) == true)
>   			return;
>
> -		if (hardlockup_panic)
> -			panic("Watchdog detected hard LOCKUP on cpu %d", this_cpu);
> -		else
> -			WARN(1, "Watchdog detected hard LOCKUP on cpu %d", this_cpu);
> -
>   		__this_cpu_write(hard_watchdog_warn, true);
>   		return;
>   	}
>
> +	early_printk("NMI watchog tick %ld\n", jiffies);
> +
>   	__this_cpu_write(hard_watchdog_warn, false);
>   	return;
>   }

