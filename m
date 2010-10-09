Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128Ab0JIB1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 21:27:23 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:48504
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167Ab0JIB1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 21:27:21 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bh8275dhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-WSS-ID: 0LA01CP-02-O4M-02
X-M-MSG: 
Date: Sat, 9 Oct 2010 03:26:47 +0200
From: Robert Richter <robert.richter@amd.com>
To: Matt Fleming <matt@console-pimps.org>
CC: Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 5/7] ARM: oprofile: Move non-ARM code into separate
 init/exit
Message-ID: <20101009012647.GM13563@erda.amd.com>
References: <cover.1286584677.git.matt@console-pimps.org>
 <0de9eda11dbfe9c21348da07b57f04f35cd9effc.1286584677.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0de9eda11dbfe9c21348da07b57f04f35cd9effc.1286584677.git.matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.10.10 20:46:20, Matt Fleming wrote:
> In preparation for moving the majority of this oprofile code into an
> architecture-neutral place separate the architecture-independent code
> into oprofile_perf_init() and oprofile_perf_exit().
> 
> Signed-off-by: Matt Fleming <matt@console-pimps.org>
> Tested-by: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm/oprofile/common.c |   27 +++++++++++++++++++--------
>  1 files changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
> index fd6e323..8718311 100644
> --- a/arch/arm/oprofile/common.c
> +++ b/arch/arm/oprofile/common.c
> @@ -349,7 +349,7 @@ static void arm_backtrace(struct pt_regs * const regs, unsigned int depth)
>  		tail = user_backtrace(tail);
>  }
>  
> -int __init oprofile_arch_init(struct oprofile_operations *ops)
> +int __init oprofile_perf_init(struct oprofile_operations *ops)
>  {
>  	int cpu, ret = 0;
>  
> @@ -387,12 +387,11 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
>  		}
>  	}
>  
> -	ops->backtrace		= arm_backtrace;
> -	ops->create_files	= op_arm_create_files;
> -	ops->setup		= op_arm_setup;
> -	ops->start		= op_arm_start;
> -	ops->stop		= op_arm_stop;
> -	ops->shutdown		= op_arm_stop;
> +	ops->create_files	= oprofile_perf_create_files;
> +	ops->setup		= oprofile_perf_setup;
> +	ops->start		= oprofile_perf_start;
> +	ops->stop		= oprofile_perf_stop;
> +	ops->shutdown		= oprofile_perf_stop;

There is a compile breakage caused by patch #4. Will move the renames
to patch #4 when applying the patch.

-Robert

>  	ops->cpu_type		= op_name_from_perf_id();
>  
>  	if (!ops->cpu_type)
> @@ -410,7 +409,14 @@ out:
>  	return ret;
>  }
>  
> -void __exit oprofile_arch_exit(void)
> +int __init oprofile_arch_init(struct oprofile_operations *ops)
> +{
> +	ops->backtrace		= arm_backtrace;
> +
> +	return oprofile_perf_init(ops);
> +}
> +
> +void __exit oprofile_perf_exit(void)
>  {
>  	int cpu, id;
>  	struct perf_event *event;
> @@ -428,6 +434,11 @@ void __exit oprofile_arch_exit(void)
>  	kfree(counter_config);
>  	exit_driverfs();
>  }
> +
> +void __exit oprofile_arch_exit(void)
> +{
> +	oprofile_perf_exit();
> +}
>  #else
>  int __init oprofile_arch_init(struct oprofile_operations *ops)
>  {
> -- 
> 1.7.1
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

