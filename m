Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125Ab2GLQyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:54:07 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:32666 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934084Ab2GLQyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:54:05 -0400
Message-ID: <1342111772.8472.18.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 2/3 RESEND] acpi : prevent cpu from becoming online
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Thu, 12 Jul 2012 10:49:32 -0600
In-Reply-To: <4FFEB7BA.6050505@jp.fujitsu.com>
References: <4FFEB35A.6030500@jp.fujitsu.com>
	 <4FFEB4BA.8010800@jp.fujitsu.com> <4FFEB7BA.6050505@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 20:40 +0900, Yasuaki Ishimatsu wrote:
> Even if acpi_processor_handle_eject() offlines cpu, there is a chance
> to online the cpu after that. So the patch closes the window by using
> get/put_online_cpus().
> 
> Why does the patch change _cpu_up() logic?
> 
> The patch cares the race of hot-remove cpu and _cpu_up(). If the patch
> does not change it, there is the following race.
> 
> hot-remove cpu                         |  _cpu_up()
> ------------------------------------- ------------------------------------
> call acpi_processor_handle_eject()     |
>      call cpu_down()                   |
>      call get_online_cpus()            |
>                                        | call cpu_hotplug_begin() and stop here
>      call arch_unregister_cpu()        |
>      call acpi_unmap_lsapic()          |
>      call put_online_cpus()            |
>                                        | start and continue _cpu_up()
>      return acpi_processor_remove()    |
> continue hot-remove the cpu            |
> 
> So _cpu_up() can continue to itself. And hot-remove cpu can also continue
> itself. If the patch changes _cpu_up() logic, the race disappears as below:
> 
> hot-remove cpu                         | _cpu_up()
> -----------------------------------------------------------------------
> call acpi_processor_handle_eject()     |
>      call cpu_down()                   |
>      call get_online_cpus()            |
>                                        | call cpu_hotplug_begin() and stop here
>      call arch_unregister_cpu()        |
>      call acpi_unmap_lsapic()          |
>           cpu's cpu_present is set     |
>           to false by set_cpu_present()|
>      call put_online_cpus()            |
>                                        | start _cpu_up()
>                                        | check cpu_present() and return -EINVAL
>      return acpi_processor_remove()    |
> continue hot-remove the cpu            |
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> ---
>  drivers/acpi/processor_driver.c |   14 ++++++++++++++
>  kernel/cpu.c                    |    8 +++++---
>  2 files changed, 19 insertions(+), 3 deletions(-)
> 
> Index: linux-3.5-rc6/drivers/acpi/processor_driver.c
> ===================================================================
> --- linux-3.5-rc6.orig/drivers/acpi/processor_driver.c	2012-07-12 20:34:29.438289841 +0900
> +++ linux-3.5-rc6/drivers/acpi/processor_driver.c	2012-07-12 20:39:29.190542257 +0900
> @@ -850,8 +850,22 @@ static int acpi_processor_handle_eject(s
>  			return ret;
>  	}
> 
> +	get_online_cpus();
> +	/*
> +	 * The cpu might become online again at this point. So we check whether
> +	 * the cpu has been onlined or not. If the cpu became online, it means
> +	 * that someone wants to use the cpu. So acpi_processor_handle_eject()
> +	 * returns -EAGAIN.
> +	 */
> +	if (unlikely(cpu_online(pr->id))) {
> +		put_online_cpus();
> +		printk(KERN_WARNING "Failed to remove CPU %d, "
> +		       "since someone onlines the cpu\n" , pr->id);

pr_warn() should be used per the recent checkpatch change.

Thanks,
-Toshi

> +		return -EAGAIN;
> +	}
>  	arch_unregister_cpu(pr->id);
>  	acpi_unmap_lsapic(pr->id);
> +	put_online_cpus();
>  	return ret;
>  }
>  #else
> Index: linux-3.5-rc6/kernel/cpu.c
> ===================================================================
> --- linux-3.5-rc6.orig/kernel/cpu.c	2012-07-12 20:34:29.438289841 +0900
> +++ linux-3.5-rc6/kernel/cpu.c	2012-07-12 20:34:35.040219535 +0900
> @@ -343,11 +343,13 @@ static int __cpuinit _cpu_up(unsigned in
>  	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
>  	struct task_struct *idle;
> 
> -	if (cpu_online(cpu) || !cpu_present(cpu))
> -		return -EINVAL;
> -
>  	cpu_hotplug_begin();
> 
> +	if (cpu_online(cpu) || !cpu_present(cpu)) {
> +		ret =  -EINVAL;
> +		goto out;
> +	}
> +
>  	idle = idle_thread_get(cpu);
>  	if (IS_ERR(idle)) {
>  		ret = PTR_ERR(idle);
> 


