Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1AXSku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:40:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52561 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab1AXSkt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:40:49 -0500
Subject: Re: [PATCH] a patch to fix the cpu-offline-online problem caused
 by pm_idle
From: Peter Zijlstra <peterz@infradead.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
In-Reply-To: <AANLkTinaOQpuJis5HgK316ANxpDS8eZ8Q0S4a44POrp0@mail.gmail.com>
References: <AANLkTinaOQpuJis5HgK316ANxpDS8eZ8Q0S4a44POrp0@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 24 Jan 2011 19:41:32 +0100
Message-ID: <1295894492.28776.470.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 02:34 -0500, Luming Yu wrote:
> Hi there,
> 
> I've seen many problems caused by deep-c-state-capable pm_idle on a
> NHM-EX system with this test script
> # for i in `seq 1 1000`; do echo $i; echo 0 >
> /sys/devices/system/cpu/cpu59/online ; sleep 1; echo 1 >
> /sys/devices/system/cpu/cpu59/online; done
> 
> As the bug " CPU online/offline causes system slowdown"
> https://bugzilla.redhat.com/show_bug.cgi?id=586551 described.
> 
> The simplest and easiest and cleanest way I can think of now is as the
> patch attached.
> 
> Signed-off-by: Yu Luming <luming.yu@intel.com>
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index c75fcdd..d419eb3 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -135,6 +135,7 @@ int __ref register_cpu_notifier(struct notifier_block *nb)
> 
>  #ifdef CONFIG_HOTPLUG_CPU
> 
> +static void (*pm_idle_saved) (void) __read_mostly;
>  EXPORT_SYMBOL(register_cpu_notifier);
> 
>  void __ref unregister_cpu_notifier(struct notifier_block *nb)
> @@ -145,6 +146,19 @@ void __ref unregister_cpu_notifier(struct
> notifier_block *nb)
>  }
>  EXPORT_SYMBOL(unregister_cpu_notifier);
> 
> +static inline void save_pm_idle(void)
> +{
> +	pm_idle_saved = pm_idle;
> +	pm_idle = default_idle;
> +	cpu_idle_wait();
> +}
> +
> +static inline void restore_pm_idle(void)
> +{
> +	pm_idle = pm_idle_saved;
> +	cpu_idle_wait();
> +}
> +
>  static inline void check_for_tasks(int cpu)
>  {
>  	struct task_struct *p;
> @@ -278,7 +292,9 @@ int __ref cpu_down(unsigned int cpu)
>  		goto out;
>  	}
> 
> +	save_pm_idle();
>  	err = _cpu_down(cpu, 0);
> +	restore_pm_idle();
> 
>  out:
>  	cpu_maps_update_done();
> @@ -376,7 +392,9 @@ int __cpuinit cpu_up(unsigned int cpu)
>  		goto out;
>  	}
> 
> +	save_pm_idle();
>  	err = _cpu_up(cpu, 0);
> +	restore_pm_idle();
> 
>  out:
>  	cpu_maps_update_done();

Ow god this is ugly.. pm_idle should die asap, not find it way into generic code, so NAK!

