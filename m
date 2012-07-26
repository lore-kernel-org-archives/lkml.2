Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab2GZKVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:21:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49067 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab2GZKVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:21:12 -0400
Date: Thu, 26 Jul 2012 12:21:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: tglx@linutronix.de, mingo@redhat.com, suresh.b.siddha@intel.com,
        hpa@zytor.com, yinghai@kernel.org, agordeev@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH] x86/ioapic: Fix NULL pointer dereference on CPU hotplug
 after disabling irqs
Message-ID: <20120726102106.GA22573@gmail.com>
References: <BC5CD145C5D9E74D86490E60F52766FF1EBCFCDD@ORSMSX105.amr.corp.intel.com>
 <50111146.7070707@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50111146.7070707@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com> wrote:

> In current Linux, percpu variable `vector_irq' is not always cleared when
> a CPU is offlined. If the CPU that has the disabled irqs in vector_irq is
> hotplugged again, __setup_vector_irq() hits invalid irq vector and may
> crash.
> 
> This bug can be reproduced as following;
>  # echo 0 > /sys/devices/system/cpu/cpu7/online
>  # modprobe -r some_driver_using_interrupts     # vector_irq@cpu7 uncleared
>  # echo 1 > /sys/devices/system/cpu/cpu7/online # kernel may crash
> 
> To fix this problem, this patch clears vector_irq in __fixup_irqs() when
> the CPU is offlined.
> 
> This also reverts commit f6175f5bfb4c, which partially fixes this bug by
> clearing vector in __clear_irq_vector(). But in environments with IOMMU IRQ
> remapper, it could fail because cfg->domain doesn't contain offlined CPUs.
> With this patch, the fix in __clear_irq_vector() can be reverted because
> every vector_irq is already cleared in __fixup_irqs() on offlined CPUs.
> 
> Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Alexander Gordeev <agordeev@redhat.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |    4 ++--
>  arch/x86/kernel/irq.c          |    1 +
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 5f0ff59..ac96561 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -1195,7 +1195,7 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
>  	BUG_ON(!cfg->vector);
>   	vector = cfg->vector;
> -	for_each_cpu(cpu, cfg->domain)
> +	for_each_cpu_and(cpu, cfg->domain, cpu_online_mask)
>  		per_cpu(vector_irq, cpu)[vector] = -1;
>   	cfg->vector = 0;
> @@ -1203,7 +1203,7 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
>   	if (likely(!cfg->move_in_progress))
>  		return;
> -	for_each_cpu(cpu, cfg->old_domain) {

that's not a valid diff - something in your mailer ate lines or 
such. See Documentation/email-clients.txt.

Thanks,

	Ingo
