Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab0H0M4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 08:56:18 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:49066 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab0H0M4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 08:56:16 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L7TA0W-01-IVC-02
X-M-MSG: 
Date: Fri, 27 Aug 2010 14:43:44 +0200
From: Robert Richter <robert.richter@amd.com>
To: Matt Fleming <matt@console-pimps.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
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
Message-ID: <20100827124344.GJ22783@erda.amd.com>
References: <cover.1282848651.git.matt@console-pimps.org>
 <442a16796990290ca3ebaaa3d0ab317e7b0a30a5.1282848651.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <442a16796990290ca3ebaaa3d0ab317e7b0a30a5.1282848651.git.matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.08.10 15:09:16, Matt Fleming wrote:
> From: Will Deacon <will.deacon@arm.com>
> 
> The current implementation is not entirely safe in the case that
> oprofile_arch_init() fails. We need to make sure that we always call
> exit_driverfs() if we've called init_driverfs(). Also, avoid a potential
> double free when freeing 'counter_config', e.g. don't free
> 'counter_config' in both oprofile_arch_init() and oprofile_arch_exit().
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm/oprofile/common.c |   15 ++++++++-------
>  1 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
> index 0691176..482779c 100644
> --- a/arch/arm/oprofile/common.c
> +++ b/arch/arm/oprofile/common.c
> @@ -275,10 +275,12 @@ out:
>  	return ret;
>  }
>  
> -static void  exit_driverfs(void)
> +static void exit_driverfs(void)
>  {
> -	platform_device_unregister(oprofile_pdev);
> -	platform_driver_unregister(&oprofile_driver);
> +	if (!IS_ERR_OR_NULL(oprofile_pdev)) {
> +		platform_device_unregister(oprofile_pdev);
> +		platform_driver_unregister(&oprofile_driver);
> +	}

The root cause that makes this check necessary is that
oprofile_arch_exit() is called though oprofile_arch_init() failed. We
should better fix this instead. I have to admit we will then have to
check all architectural implementations.

>  }
>  #else
>  static int __init init_driverfs(void) { return 0; }
> @@ -363,10 +365,8 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
>  	}
>  
>  	ret = init_driverfs();
> -	if (ret) {
> -		kfree(counter_config);

We should not return from oprofile_arch_init() with allocated
resources if the function fails. To fix duplicate kfrees, we should
free it here and then set counter_config to NULL. It should also be
freed if for_each_possible_cpu() or op_name_from_perf_id() fails.

Also, the pointer should be NULLed after freeing in
oprofile_arch_exit(). There, we also don't need the NULL pointer check
as it is save to call kfree(NULL).

-Robert

> +	if (ret)
>  		return ret;
> -	}
>  
>  	for_each_possible_cpu(cpu) {
>  		perf_events[cpu] = kcalloc(perf_num_counters,
> @@ -401,8 +401,9 @@ void oprofile_arch_exit(void)
>  	int cpu, id;
>  	struct perf_event *event;
>  
> +	exit_driverfs();
> +
>  	if (*perf_events) {
> -		exit_driverfs();
>  		for_each_possible_cpu(cpu) {
>  			for (id = 0; id < perf_num_counters; ++id) {
>  				event = perf_events[cpu][id];
> -- 
> 1.7.1
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

