Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab2AIPn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:43:56 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56846 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932152Ab2AIPnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:43:55 -0500
X-Sasl-enc: /TZCjW858Zek93U7s0a84yeEmZzmaMgirtBRbkNA9Lir 1326123833
Date: Mon, 9 Jan 2012 07:37:58 -0800
From: Greg KH <greg@kroah.com>
To: Youquan Song <youquan.song@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, suresh.b.siddha@intel.com,
        arjan@linux.intel.com, len.brown@intel.com, anhua.xu@intel.com,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
Message-ID: <20120109153758.GC9329@kroah.com>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 04:56:07PM +0800, Youquan Song wrote:
> sched_smt_power_savings is totally broken at lastest linux and -tip tree.
> 
> sched_smt_power_savings is set to 1, the scheduler tries to schedule processes
>  on the least number of hyper-threads on a core as possible. In other words, 
> the process load is distributed such that all the hyper-threads in a core and 
> all the cores within the same processor are busy before the load is distributed
>  to other hyper-threads and cores in another processor. 
> 
> Test On Intel Xeon machine with 2 physical CPUs and each CPU has 8 cores / 16 
> threads. physical CPU 0 includes cpu[0~7] and cpu[16~23]; while physical CPU 1
> includes cpu[8~15] and cpu[24~31].
> 
> At latest -tip tree:
> echo 1 > /sys/devices/system/cpu/sched_smt_power_savings
> ./ebizzy -t 16 -S 100 &  sleep 10 ; cat /proc/sched_debug | grep -A 1 cpu# > tmp.log
> 
> cpu#0, 2693.564 MHz
>   .nr_running                    : 0
> --
> cpu#1, 2693.564 MHz
>   .nr_running                    : 1
> --
> cpu#2, 2693.564 MHz
>   .nr_running                    : 0
> --
> cpu#3, 2693.564 MHz
>   .nr_running                    : 1
> --
> cpu#4, 2693.564 MHz
>   .nr_running                    : 1
> --
> cpu#5, 2693.564 MHz
>   .nr_running                    : 1
> --
> cpu#6, 2693.564 MHz
>   .nr_running                    : 1
> --
> cpu#7, 2693.564 MHz
>   .nr_running                    : 1
> --
> cpu#8, 2693.564 MHz
>   .nr_running                    : 1
> --
> cpu#9, 2693.564 MHz
>   .nr_running                    : 1
> --
> cpu#10, 2693.564 MHz
>   .nr_running                    : 1
> --
> cpu#11, 2693.564 MHz
>   .nr_running                    : 0
> --
> cpu#12, 2693.564 MHz
>   .nr_running                    : 1
> --
> cpu#13, 2693.564 MHz
>   .nr_running                    : 1
> --
> cpu#14, 2693.564 MHz
>   .nr_running                    : 0
> --
> cpu#15, 2693.564 MHz
>   .nr_running                    : 0
> --
> cpu#16, 2693.564 MHz
>   .nr_running                    : 0
> --
> cpu#17, 2693.564 MHz
>   .nr_running                    : 0
> --
> cpu#18, 2693.564 MHz
>   .nr_running                    : 1
> --
> cpu#19, 2693.564 MHz
>   .nr_running                    : 0
> --
> cpu#20, 2693.564 MHz
>   .nr_running                    : 0
> --
> cpu#21, 2693.564 MHz
>   .nr_running                    : 0
> --
> cpu#22, 2693.564 MHz
>   .nr_running                    : 0
> --
> cpu#23, 2693.564 MHz
>   .nr_running                    : 0
> --
> cpu#24, 2693.564 MHz
>   .nr_running                    : 0
> --
> cpu#25, 2693.564 MHz
>   .nr_running                    : 1
> --
> cpu#26, 2693.564 MHz
>   .nr_running                    : 1
> --
> cpu#27, 2693.564 MHz
>   .nr_running                    : 1
> --
> cpu#28, 2693.564 MHz
>   .nr_running                    : 0
> --
> cpu#29, 2693.564 MHz
>   .nr_running                    : 0
> --
> cpu#30, 2693.564 MHz
>   .nr_running                    : 1
> --
> cpu#31, 2693.564 MHz
>   .nr_running                    : 1
> 
> >From above, we notice 16 threads are distributed among 2 physical CPUs.
> After apply the patch, 16 threads are only distributed at one physical CPU.
> In this case, we can notice 30% power saving.
> Following are the result after apply the patch:
> 
> cpu#0, 2693.384 MHz
>   .nr_running                    : 1
> --
> cpu#1, 2693.384 MHz
>   .nr_running                    : 1
> --
> cpu#2, 2693.384 MHz
>   .nr_running                    : 1
> --
> cpu#3, 2693.384 MHz
>   .nr_running                    : 1
> --
> cpu#4, 2693.384 MHz
>   .nr_running                    : 1
> --
> cpu#5, 2693.384 MHz
>   .nr_running                    : 1
> --
> cpu#6, 2693.384 MHz
>   .nr_running                    : 1
> --
> cpu#7, 2693.384 MHz
>   .nr_running                    : 1
> --
> cpu#8, 2693.384 MHz
>   .nr_running                    : 0
> --
> cpu#9, 2693.384 MHz
>   .nr_running                    : 0
> --
> cpu#10, 2693.384 MHz
>   .nr_running                    : 0
> --
> cpu#11, 2693.384 MHz
>   .nr_running                    : 0
> --
> cpu#12, 2693.384 MHz
>   .nr_running                    : 0
> --
> cpu#13, 2693.384 MHz
>   .nr_running                    : 0
> --
> cpu#14, 2693.384 MHz
>   .nr_running                    : 0
> --
> cpu#15, 2693.384 MHz
>   .nr_running                    : 0
> --
> cpu#16, 2693.384 MHz
>   .nr_running                    : 1
> --
> cpu#17, 2693.384 MHz
>   .nr_running                    : 1
> --
> cpu#18, 2693.384 MHz
>   .nr_running                    : 1
> --
> cpu#19, 2693.384 MHz
>   .nr_running                    : 1
> --
> cpu#20, 2693.384 MHz
>   .nr_running                    : 1
> --
> cpu#21, 2693.384 MHz
>   .nr_running                    : 1
> --
> cpu#22, 2693.384 MHz
>   .nr_running                    : 1
> --
> cpu#23, 2693.384 MHz
>   .nr_running                    : 1
> --
> cpu#24, 2693.384 MHz
>   .nr_running                    : 0
> --
> cpu#25, 2693.384 MHz
>   .nr_running                    : 0
> --
> cpu#26, 2693.384 MHz
>   .nr_running                    : 0
> --
> cpu#27, 2693.384 MHz
>   .nr_running                    : 0
> --
> cpu#28, 2693.384 MHz
>   .nr_running                    : 0
> --
> cpu#29, 2693.384 MHz
>   .nr_running                    : 0
> --
> cpu#30, 2693.384 MHz
>   .nr_running                    : 0
> --
> cpu#31, 2693.384 MHz
>   .nr_running                    : 1
> 
> 
> This patch will set SMT sibling power capability to SCHED_POWER_SCALE
> (1024) when sched_smt_power_savings set. So when there is possible do power
> saving during scheduling, scheduler will truly schedule processes as
> sched_smt_power_savings should do.
>  
> 
> Signed-off-by: Youquan Song <youquan.song@intel.com>
> Tested-by: Anhua Xu <anhua.xu@intel.com>
> ---
>  kernel/sched/fair.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
