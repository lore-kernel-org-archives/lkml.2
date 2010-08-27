Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab0H0QlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 12:41:08 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:42122 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab0H0QlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 12:41:05 -0400
X-SpamScore: -23
X-BigFish: VPS-23(zzbb2cK1432N1a09M98dN4015Lzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-WSS-ID: 0L7TKWE-01-ASK-02
X-M-MSG: 
Date: Fri, 27 Aug 2010 18:38:39 +0200
From: Robert Richter <robert.richter@amd.com>
To: Will Deacon <will.deacon@arm.com>
CC: Matt Fleming <matt@console-pimps.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/4] oprofile: Handle initialisation failure more
 gracefully
Message-ID: <20100827163839.GR22783@erda.amd.com>
References: <cover.1282848651.git.matt@console-pimps.org>
 <442a16796990290ca3ebaaa3d0ab317e7b0a30a5.1282848651.git.matt@console-pimps.org>
 <20100827124344.GJ22783@erda.amd.com>
 <1282922125.22128.5.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1282922125.22128.5.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.08.10 11:15:25, Will Deacon wrote:

> > > The current implementation is not entirely safe in the case that
> > > oprofile_arch_init() fails. We need to make sure that we always call
> > > exit_driverfs() if we've called init_driverfs(). Also, avoid a potential
> > > double free when freeing 'counter_config', e.g. don't free
> > > 'counter_config' in both oprofile_arch_init() and oprofile_arch_exit().

I am not sure if it is worth the memory handling code, we could
alternativly implement fixed size arrays with MAX_COUNTERS. This would
eas it a lot. But, this code will become generic, so we can stick with
this implementation.

But, cpu varables should be used, maybe with a later patch.

> > The root cause that makes this check necessary is that
> > oprofile_arch_exit() is called though oprofile_arch_init() failed. We
> > should better fix this instead. I have to admit we will then have to
> > check all architectural implementations.
> > 
> 
> I took a look through all of the oprofile_arch_{init,exit} functions
> and it looks like only ARM needs fixing. Nobody else does any allocation
> here [well, until Matt's unified version comes into play].

Great, many thanks.

> How about something like this? This removes the exit call
> from the init code and sets pointers to NULL after they have been
> freed. We still have to do some checking so that we don't try to
> release a NULL perf event:
> 
> diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
> index 0691176..12253eb 100644
> --- a/arch/arm/oprofile/common.c
> +++ b/arch/arm/oprofile/common.c
> @@ -275,10 +275,12 @@ out:
>  	return ret;
>  }
>  
> -static void  exit_driverfs(void)
> +static void __exit exit_driverfs(void)
>  {
> -	platform_device_unregister(oprofile_pdev);
> -	platform_driver_unregister(&oprofile_driver);
> +	if (!IS_ERR_OR_NULL(oprofile_pdev)) {

This check is obsolete here as we do not call oprofile_arch_exit() on
failure.

> +		platform_device_unregister(oprofile_pdev);
> +		platform_driver_unregister(&oprofile_driver);
> +	}
>  }
>  #else
>  static int __init init_driverfs(void) { return 0; }
> @@ -365,6 +367,7 @@ int __init oprofile_arch_init(struct
> oprofile_operations *ops)
>  	ret = init_driverfs();
>  	if (ret) {
>  		kfree(counter_config);
> +		counter_config = NULL;

Dito, obsolete now.

>  		return ret;
>  	}
>  
> @@ -374,8 +377,10 @@ int __init oprofile_arch_init(struct
> oprofile_operations *ops)
>  		if (!perf_events[cpu]) {
>  			pr_info("oprofile: failed to allocate %d perf events "
>  					"for cpu %d\n", perf_num_counters, cpu);
> -			while (--cpu >= 0)
> +			while (--cpu >= 0) {
>  				kfree(perf_events[cpu]);
> +				perf_events[cpu] = NULL;
> +			}

counter_config must be freed here.

>  			return -ENOMEM;
>  		}
>  	}
> @@ -396,25 +401,27 @@ int __init oprofile_arch_init(struct
> oprofile_operations *ops)
>  	return ret;
>  }
>  
> -void oprofile_arch_exit(void)
> +void __exit oprofile_arch_exit(void)
>  {
>  	int cpu, id;
>  	struct perf_event *event;
>  
> -	if (*perf_events) {
> -		exit_driverfs();
> -		for_each_possible_cpu(cpu) {
> -			for (id = 0; id < perf_num_counters; ++id) {
> -				event = perf_events[cpu][id];
> -				if (event != NULL)
> -					perf_event_release_kernel(event);
> -			}
> -			kfree(perf_events[cpu]);
> +	exit_driverfs();

If we shutdown all this in reverse order, this should be after the
loop.

> +
> +	for_each_possible_cpu(cpu) {
> +		if (!perf_events[cpu])
> +			continue;

Should be never NULL, the check can be removed.

> +
> +		for (id = 0; id < perf_num_counters; ++id) {
> +			event = perf_events[cpu][id];
> +			if (event != NULL)

	if (event)
		...

> +				perf_event_release_kernel(event);
>  		}
> +
> +		kfree(perf_events[cpu]);
>  	}
>  
> -	if (counter_config)
> -		kfree(counter_config);
> +	kfree(counter_config);
>  }
>  #else
>  int __init oprofile_arch_init(struct oprofile_operations *ops)
> @@ -422,5 +429,5 @@ int __init oprofile_arch_init(struct
> oprofile_operations *ops)
>  	pr_info("oprofile: hardware counters not available\n");
>  	return -ENODEV;
>  }
> -void oprofile_arch_exit(void) {}
> +void __exit oprofile_arch_exit(void) {}
>  #endif /* CONFIG_HW_PERF_EVENTS */
> diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
> index b336cd9..3094af0 100644
> --- a/drivers/oprofile/oprof.c
> +++ b/drivers/oprofile/oprof.c
> @@ -257,15 +257,11 @@ static int __init oprofile_init(void)
>  		printk(KERN_INFO "oprofile: using timer interrupt.\n");
>  		err = oprofile_timer_init(&oprofile_ops);
>  		if (err)
> -			goto out_arch;
> +			goto out;

A 'return err;' here would remove the goto. I would preffer this.

Thanks,

-Robert

>  	}
>  	err = oprofilefs_register();
> -	if (err)
> -		goto out_arch;
> -	return 0;
>  
> -out_arch:
> -	oprofile_arch_exit();
> +out:
>  	return err;
>  }
>  
> 
> Thanks,
> 
> Will
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

