Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934950Ab1JETWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:22:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:34385 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934402Ab1JETWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:22:19 -0400
Date: Wed, 5 Oct 2011 21:22:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fenghua Yu <fenghua.yu@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <lenb@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] kernel/power/main.c: Not suspend/resume if CPU0 is
 offlined
In-Reply-To: <1317832759-10223-8-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.LFD.2.02.1110052120580.18778@ionos>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com> <1317832759-10223-8-git-send-email-fenghua.yu@intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011, Fenghua Yu wrote:

> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> System resumes from CPU0 on today's x86 BIOS. Don't suspend/resume if CPU0 is
> offlined and bsp_hotpluggable is 1.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  kernel/power/main.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/power/main.c b/kernel/power/main.c
> index 6c601f8..33ffb6a 100644
> --- a/kernel/power/main.c
> +++ b/kernel/power/main.c
> @@ -12,6 +12,7 @@
>  #include <linux/string.h>
>  #include <linux/resume-trace.h>
>  #include <linux/workqueue.h>
> +#include <linux/cpu.h>
>  
>  #include "power.h"
>  
> @@ -178,6 +179,14 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
>  	int len;
>  	int error = -EINVAL;
>  
> +#ifdef CONFIG_HOTPLUG_CPU
> +	if (bsp_hotpluggable && cpumask_first(cpu_online_mask) != 0) {
> +		printk(KERN_WARNING "Because CPU0 is offlined, system can't suspend/resume.\n");
> +
> +		return -ENODEV;
> +	}
> +#endif

Oh yes, we enforce that for all architectures no matter what.

This is a x86 restriction and the cpu hotplug architecture code can
veto unplugging.

Thanks,

	tglx
