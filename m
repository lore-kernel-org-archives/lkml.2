Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897Ab2GLMnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 08:43:11 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:34405 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab2GLMnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 08:43:08 -0400
Message-ID: <4FFEC60B.7040800@linux.vnet.ibm.com>
Date: Thu, 12 Jul 2012 18:11:47 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
        toshi.kani@hp.com
Subject: Re: [PATCH v3 2/3 RESEND] acpi : prevent cpu from becoming online
References: <4FFEB35A.6030500@jp.fujitsu.com> <4FFEB4BA.8010800@jp.fujitsu.com> <4FFEB7BA.6050505@jp.fujitsu.com>
In-Reply-To: <4FFEB7BA.6050505@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
x-cbid: 12071212-4790-0000-0000-000003A83F2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 05:10 PM, Yasuaki Ishimatsu wrote:
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

Please consider fixing the grammar issue below (since it is a user-visible
print statement). Other than that, everything looks fine.

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
 
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

How about:
"Failed to remove CPU %d, because some other task brought the CPU back online\n"

Regards,
Srivatsa S. Bhat

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

