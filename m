Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1DRRbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 13:31:02 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:3021 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab1DRRa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 13:30:56 -0400
Message-ID: <4DAC754A.3080207@caviumnetworks.com>
Date: Mon, 18 Apr 2011 10:30:50 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>, Robert Millan <rmh@gnu.org>,
        wu zhangjin <wuzhangjin@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] MIPS: Introduce set_elf_platform() helper function
References: <f571cce5cf7793777f8303cea5e9628f@localhost>
In-Reply-To: <f571cce5cf7793777f8303cea5e9628f@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Apr 2011 17:30:55.0619 (UTC) FILETIME=[5F7BE530:01CBFDEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2011 11:29 AM, Kevin Cernekee wrote:
> From: Robert Millan<rmh@gnu.org>
>
> Replace these sequences:
>
> if (cpu == 0)
> 	__elf_platform = "foo";
>
> with a trivial inline function.
>
> Signed-off-by: Robert Millan<rmh@gnu.org>
> Acked-by: David Daney<ddaney@caviumnetworks.com>
> Signed-off-by: Kevin Cernekee<cernekee@gmail.com>
> ---
>   arch/mips/include/asm/elf.h  |    6 ++++++
>   arch/mips/kernel/cpu-probe.c |    6 ++----
>   2 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/arch/mips/include/asm/elf.h b/arch/mips/include/asm/elf.h
> index 455c0ac..455da05 100644
> --- a/arch/mips/include/asm/elf.h
> +++ b/arch/mips/include/asm/elf.h
> @@ -348,6 +348,12 @@ extern int dump_task_fpu(struct task_struct *, elf_fpregset_t *);
>   #define ELF_PLATFORM  __elf_platform
>   extern const char *__elf_platform;
>
> +static inline void set_elf_platform(int cpu, const char *plat)
> +{
> +	if (cpu == 0)
> +		__elf_platform = plat;
> +}
> +

Now I want to NAK it.

This function is only ever used in cpu-probe.c, can't we just put it in 
there (and then make it non-inline)?  The less stuff in elf.h the better.

David Daney


>   /*
>    * See comments in asm-alpha/elf.h, this is the same thing
>    * on the MIPS.
> diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
> index f65d4c8..5633ab1 100644
> --- a/arch/mips/kernel/cpu-probe.c
> +++ b/arch/mips/kernel/cpu-probe.c
> @@ -956,14 +956,12 @@ static inline void cpu_probe_cavium(struct cpuinfo_mips *c, unsigned int cpu)
>   		c->cputype = CPU_CAVIUM_OCTEON_PLUS;
>   		__cpu_name[cpu] = "Cavium Octeon+";
>   platform:
> -		if (cpu == 0)
> -			__elf_platform = "octeon";
> +		set_elf_platform(cpu, "octeon");
>   		break;
>   	case PRID_IMP_CAVIUM_CN63XX:
>   		c->cputype = CPU_CAVIUM_OCTEON2;
>   		__cpu_name[cpu] = "Cavium Octeon II";
> -		if (cpu == 0)
> -			__elf_platform = "octeon2";
> +		set_elf_platform(cpu, "octeon2");
>   		break;
>   	default:
>   		printk(KERN_INFO "Unknown Octeon chip!\n");

