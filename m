Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab2EIMMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 08:12:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61179 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab2EIMMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 08:12:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Magnus Damm <magnus.damm@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] mach-shmobile: Emma Mobile EV2 SMP prototype code
Date: Wed, 9 May 2012 12:12:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, horms@verge.net.au,
        linux@arm.linux.org.uk, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, lethal@linux-sh.org,
        olof@lixom.net
References: <20120509075407.5991.60556.sendpatchset@w520>
In-Reply-To: <20120509075407.5991.60556.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205091212.08239.arnd@arndb.de>
X-Provags-ID: V02:K0:OakHwVzMQutjBfQiIjzWoTVL90IFarbbPg5NE8zzWse
 G8xTMcFWEhSrwR3kCdkRvQzbKC3hvFKPE+QxneNk/nEJ42t9Xw
 vlmug206N1DuUE+xAx6aFAo63+APM7meRfS+JJz1q1rSUCcgEZ
 kPuTWpUaqqprlcZKwB2+QTPyrciApOvapaok77sm/a4u1WJCEe
 QPmhk25GBJV+2vRJZJTZOAx0raF/vkG36ReXE0YNtDpsEsw8wH
 Jty2oQZF0RVSUu+Nued37a7d7CguK+uodA6g2fps+aO/3LnWXY
 n4OaJWHdpBSu/1mnxFxzF8Rk/VI79WddAR4OvEadFtb54wqefq
 N6QezkhzaeMOBYBlTvsc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 May 2012, Magnus Damm wrote:
>  static unsigned int __init shmobile_smp_get_core_count(void)
>  {
> @@ -31,6 +32,9 @@ static unsigned int __init shmobile_smp_
>  	if (is_r8a7779())
>  		return r8a7779_get_core_count();
>  
> +	if (is_emev2())
> +		return emev2_get_core_count();
> +
>  	return 1;
>  }
>  
> @@ -41,6 +45,9 @@ static void __init shmobile_smp_prepare_
>  
>  	if (is_r8a7779())
>  		r8a7779_smp_prepare_cpus();
> +
> +	if (is_emev2())
> +		emev2_smp_prepare_cpus();
>  }
>  
>  int shmobile_platform_cpu_kill(unsigned int cpu)
> ...

This shows that we really want an abstraction for soc-specific SMP ops
even within one platform, and we'll need the same thing for multiplatform.

Marc Zyngier already proposed a solution for this last year, but I
think we couldn't agree on the details back then before he lost interest.
I think we should pick that up again and get it into 3.6 so the code above
can be simplified and we can do the multiplatform solution. We'll probably
discuss the details in Hong Kong in a couple of weeks, so there is no
point in changing it now, but I'd hope that you can migrate this to
whatever we come up with in the following merge window.

> +#define SMU_GENERAL_REG0	IOMEM(0xe01107c0)

I would keep this together with the other SMU handling code and export a
function to set it, rather than hardcoding the address.

> +static DEFINE_SPINLOCK(scu_lock);
> +static unsigned long tmp;
> +
> +static void modify_scu_cpu_psr(unsigned long set, unsigned long clr)
> +{
> +	void __iomem *scu_base = scu_base_addr();
> +
> +	spin_lock(&scu_lock);
> +	tmp = readl(scu_base + 8);
> +	tmp &= ~clr;
> +	tmp |= set;
> +	spin_unlock(&scu_lock);
> +
> +	/* disable cache coherency after releasing the lock */
> +	writel(tmp, scu_base + 8);
> +}

This looks strange: why is tmp a file-level static variable rather than
local to the modify_scu_cpu_psr function? Why do you do the writel
without the spinlock held?

	Arnd
