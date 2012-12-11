Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab2LKGbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 01:31:35 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:54060 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab2LKGbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 01:31:34 -0500
Message-ID: <50C6D2EC.20701@linux.vnet.ibm.com>
Date: Tue, 11 Dec 2012 12:00:04 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Chuansheng Liu <chuansheng.liu@intel.com>
CC: tglx@linutronix.de, paul.mckenney@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smpboot: calling smpboot_register_percpu_thread is unsafe
 during one CPU being down
References: <1355235467.6184.10.camel@cliu38-desktop-build>
In-Reply-To: <1355235467.6184.10.camel@cliu38-desktop-build>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121106-0260-0000-0000-0000024738D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 07:47 PM, Chuansheng Liu wrote:
> 
> When one CPU is going down, and smpboot_register_percpu_thread is called,
> there is the race issue below:
> T1(CPUA):                                      T2(CPUB):
> _cpu_down()                                    smpboot_register_percpu_thread()
>   smpboot_park_threads()                       ...
>   __stop_machine()                               __smpboot_create_thread(CPU_Dying)
>                                                  [Currently, the being down CPU is online yet]
>     take_cpu_down()                              smpboot_unpark_thread(CPU_Dying)
>       __cpu_disable()                              ....
>         native_cpu_disable()
>    ....                                          Here the new kthread will get running
>                                                  based on the CPU_Dying
>         set_cpu_online(cpu, false)
>    ....
>    cpu_notify(CPU_DYING)
> 
> After notified the CPU_DYING, the new created kthead for dying CPU will
> be migrated to another CPU in migration_call().
> 
> Here we need use get_online_cpus()/put_online_cpus() when calling
> function smpboot_register_percpu_thread().
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
>  kernel/smpboot.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/smpboot.c b/kernel/smpboot.c
> index d6c5fc0..3fe708a 100644
> --- a/kernel/smpboot.c
> +++ b/kernel/smpboot.c
> @@ -266,6 +266,7 @@ int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
>  	unsigned int cpu;
>  	int ret = 0;
> 
> +	get_online_cpus();
>  	mutex_lock(&smpboot_threads_lock);
>  	for_each_online_cpu(cpu) {
>  		ret = __smpboot_create_thread(plug_thread, cpu);
> @@ -278,6 +279,7 @@ int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
>  	list_add(&plug_thread->list, &hotplug_threads);
>  out:
>  	mutex_unlock(&smpboot_threads_lock);
> +	put_online_cpus();
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(smpboot_register_percpu_thread);
> 

