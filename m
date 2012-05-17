Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965787Ab2EQQaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:30:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59566 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932968Ab2EQQaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:30:46 -0400
Message-ID: <4FB527B2.2010800@gmail.com>
Date: Thu, 17 May 2012 09:30:42 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>, ralf@linux-mips.org
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
Subject: Re: [PATCH -rt] MIPS: Octeon: convert smp_reserve_lock to raw spinlock
References: <1337249709-7346-1-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1337249709-7346-1-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 03:15 AM, Yong Zhang wrote:
> From: Yong Zhang<yong.zhang@windriver.com>
>
> Because __cpu_disable is called in atomic context and spinlock
> is a mutex on -rt.
>
> Signed-off-by: Yong Zhang<yong.zhang0@gmail.com>
> ---
>   arch/mips/cavium-octeon/smp.c |    6 +++---
>   1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
> index ef9c34a..473c72b 100644
> --- a/arch/mips/cavium-octeon/smp.c
> +++ b/arch/mips/cavium-octeon/smp.c
> @@ -257,7 +257,7 @@ DEFINE_PER_CPU(int, cpu_state);
>
>   extern void fixup_irqs(void);
>
> -static DEFINE_SPINLOCK(smp_reserve_lock);
> +static DEFINE_RAW_SPINLOCK(smp_reserve_lock);
>

Ralf added this in 773cb77d (MIPS: Cavium: Add CPU hotplugging code.)

I'm not even sure what this lock is supposed to be protecting, so I 
would like Ralf to take a look.

You can add an Acked-by: from me for either this patch as is, or if Ralf 
thinks it is OK, removing the lock entirely.

In any event we can merge this via Ralf's tree.

Thanks,
David Daney


>   static int octeon_cpu_disable(void)
>   {
> @@ -266,7 +266,7 @@ static int octeon_cpu_disable(void)
>   	if (cpu == 0)
>   		return -EBUSY;
>
> -	spin_lock(&smp_reserve_lock);
> +	raw_spin_lock(&smp_reserve_lock);
>
>   	set_cpu_online(cpu, false);
>   	cpu_clear(cpu, cpu_callin_map);
> @@ -277,7 +277,7 @@ static int octeon_cpu_disable(void)
>   	flush_cache_all();
>   	local_flush_tlb_all();
>
> -	spin_unlock(&smp_reserve_lock);
> +	raw_spin_unlock(&smp_reserve_lock);
>
>   	return 0;
>   }

