Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902Ab0JFNeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 09:34:10 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:34048
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756315Ab0JFNeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 09:34:06 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bh8275dhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-WSS-ID: 0L9VEZ8-02-E8C-02
X-M-MSG: 
Date: Wed, 6 Oct 2010 15:33:09 +0200
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
Subject: Re: [PATCH 4/7] ARM: oprofile: Move non-ARM code into separate
 init/exit
Message-ID: <20101006133309.GP13563@erda.amd.com>
References: <cover.1286222593.git.matt@console-pimps.org>
 <74092b0d162aafc21e408033cec6146e227363b5.1286222593.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74092b0d162aafc21e408033cec6146e227363b5.1286222593.git.matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.10.10 16:44:22, Matt Fleming wrote:
> In preparation for moving the majority of this oprofile code into an
> architecture-neutral place separate the architecture-independent code
> into oprofile_perf_init() and oprofile_perf_exit().
> 
> Signed-off-by: Matt Fleming <matt@console-pimps.org>
> Tested-by: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm/oprofile/common.c |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
> index 86df75f..e4cd332 100644
> --- a/arch/arm/oprofile/common.c
> +++ b/arch/arm/oprofile/common.c
> @@ -327,7 +327,7 @@ static void arm_backtrace(struct pt_regs * const regs, unsigned int depth)
>  		tail = user_backtrace(tail);
>  }
>  
> -int __init oprofile_arch_init(struct oprofile_operations *ops)
> +int __init oprofile_perf_init(struct oprofile_operations *ops)
>  {
>  	int cpu, ret = 0;
>  
> @@ -365,7 +365,6 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
>  		}
>  	}
>  
> -	ops->backtrace		= arm_backtrace;
>  	ops->create_files	= oprofile_perf_create_files;
>  	ops->setup		= oprofile_perf_setup;
>  	ops->start		= oprofile_perf_start;
> @@ -388,7 +387,14 @@ out:
>  	return ret;
>  }
>  
> -void __exit oprofile_arch_exit(void)
> +int __init oprofile_arch_init(struct oprofile_operations *ops)
> +{

We should do here a:

	memset(ops, 0, sizeof(*ops));

Otherwise it looks good.

-Robert

> +	ops->backtrace		= arm_backtrace;
> +
> +	return oprofile_perf_init(ops);
> +}
> +
> +void __exit oprofile_perf_exit(void)
>  {
>  	int cpu, id;
>  	struct perf_event *event;
> @@ -406,6 +412,11 @@ void __exit oprofile_arch_exit(void)
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

