Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab2DZTtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 15:49:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56714 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab2DZTtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 15:49:20 -0400
Message-ID: <4F99A69B.4040004@zytor.com>
Date: Thu, 26 Apr 2012 12:48:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Kevin Winchester <kjwinchester@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/5] x86: Cleanup and simplify cpu-specific data
References: <20120227115905.GB9943@elte.hu> <1332974587-15452-1-git-send-email-kjwinchester@gmail.com>
In-Reply-To: <1332974587-15452-1-git-send-email-kjwinchester@gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2012 03:43 PM, Kevin Winchester wrote:
> Various per-cpu fields are define in arch/x86/kernel/smpboot.c that are
> basically equivalent to the cpu-specific data in struct cpuinfo_x86.
> By moving these fields into the structure, a number of codepaths can be
> simplified since they no longer need to care about those fields not
> existing on !SMP builds.
> 
> The size effects on allno (UP) and allyes (MAX_SMP) kernels are as
> follows:
> 
> text      data      bss	      dec        hex      filename
>  1369227    181536   1399180    2949943   2d0337  vmlinux.i386.allno
>  1370216    181600   1399012    2950828	  2d06ac  vmlinux.i386.allno.after
>  1608231    310968    505088    2424287   24fddf  vmlinux.x86_64.allno
>  1609232    311032    504896    2425160   250148  vmlinux.x86_64.allno.after
> 97643748   6891747  34668544  139204039  84c15c7  vmlinux.i386.allyes
> 97643582   6892011  34668544  139204137  84c1629  vmlinux.i386.allyes.after
> 85869519  13567071  44511232  143947822  894782e  vmlinux.x86_64.allyes
> 85869134  13568607  44511232  143948973  8947cad  vmlinux.x86_64.allyes.after
> 
> As can be seen, the kernels get slighly larger, but the code reduction/
> simplification should be enough to compensate for it.
> 
> Changes in v5:
> - Reduced the number of files affected in the patchset by keeping helper
> functions in arch/x86/include/asm/smp.h
> - Rebased to latest tip/master
> 
> Kevin Winchester (5):
>   x86: Move per cpu cpu_llc_shared_map to a field in struct cpuinfo_x86
>   x86: Move per cpu cpu_llc_id to a field in struct cpuinfo_x86
>   x86: Move per cpu cpu_sibling_map to a field in struct cpuinfo_x86
>   x86: Move per cpu cpu_core_map to a field in struct cpuinfo_x86
>   x86: Remove #ifdef CONFIG_SMP sections by moving smp_num_siblings
>     into common.c
> 

I applied this patchset on top of v3.4-rc4 (to get a clean topic branch)
and ran into the following build problems:

i386 "allnoconfig":

/home/hpa/kernel/tip.x86-cpu/arch/x86/kernel/process.c: In function
‘select_idle_routine’:
/home/hpa/kernel/tip.x86-cpu/arch/x86/kernel/process.c:679:30: error:
‘smp_num_siblings’ undeclared (first use in this function)
/home/hpa/kernel/tip.x86-cpu/arch/x86/kernel/process.c:679:30: note:
each undeclared identifier is reported only once for each function it
appears in

i386 "allyesconfig" and "allmodconfig":

/home/hpa/kernel/tip.x86-cpu/drivers/cpufreq/speedstep-ich.c: In
function ‘speedstep_cpu_init’:
/home/hpa/kernel/tip.x86-cpu/drivers/cpufreq/speedstep-ich.c:337:2:
error: incompatible type for argument 2 of ‘cpumask_copy’
/home/hpa/kernel/tip.x86-cpu/include/linux/cpumask.h:483:20: note:
expected ‘const struct cpumask *’ but argument is of type ‘cpumask_t’

I will try it again against tip:master, but it looks to have the same
problems.

	-hpa
