Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab2EUKqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 06:46:07 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:39690 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab2EUKqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 06:46:06 -0400
Message-ID: <4FBA1B54.3@linux.vnet.ibm.com>
Date: Mon, 21 May 2012 16:09:16 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, sshtylyov@mvista.com, david.daney@cavium.com,
        sshtylyov@mvista.com,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/8] MIPS: call set_cpu_online() on the uping cpu with
 irq disabled
References: <1337580008-7280-1-git-send-email-yong.zhang0@gmail.com> <1337580008-7280-7-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1337580008-7280-7-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12052110-9574-0000-0000-000002C90167
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 11:30 AM, Yong Zhang wrote:

> From: Yong Zhang <yong.zhang@windriver.com>
> 
> To prevent a problem as commit 5fbd036b [sched: Cleanup cpu_active madness]
> and commit 2baab4e9 [sched: Fix select_fallback_rq() vs cpu_active/cpu_online]
> try to resolve, move set_cpu_online() to the brought up CPU and with irq
> disabled.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Acked-by: David Daney <david.daney@cavium.com>
> ---
>  arch/mips/kernel/smp.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
> index 73a268a..042145f 100644
> --- a/arch/mips/kernel/smp.c
> +++ b/arch/mips/kernel/smp.c
> @@ -122,6 +122,8 @@ asmlinkage __cpuinit void start_secondary(void)
> 
>  	notify_cpu_starting(cpu);
> 
> +	set_cpu_online(cpu, true);
> +


You will also need to use ipi_call_lock/unlock() around this.
See how x86 does it. (MIPS also selects USE_GENERIC_SMP_HELPERS).

Regards,
Srivatsa S. Bhat

>  	set_cpu_sibling_map(cpu);
> 
>  	cpu_set(cpu, cpu_callin_map);
> @@ -249,8 +251,6 @@ int __cpuinit __cpu_up(unsigned int cpu)
>  	while (!cpu_isset(cpu, cpu_callin_map))
>  		udelay(100);
> 
> -	set_cpu_online(cpu, true);
> -
>  	return 0;
>  }
> 

