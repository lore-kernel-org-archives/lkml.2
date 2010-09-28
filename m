Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab0I1VbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 17:31:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39489 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab0I1VbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 17:31:04 -0400
Message-ID: <4CA25E5C.2020203@kernel.org>
Date: Tue, 28 Sep 2010 14:30:04 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH] x86: Plug memory leak in sparse irq
References: <alpine.LFD.2.00.1009282052570.2416@localhost6.localdomain6> <AANLkTi=940qOigieOHd_cBcocBAb4AtYnm2v60i9CSmp@mail.gmail.com>
In-Reply-To: <AANLkTi=940qOigieOHd_cBcocBAb4AtYnm2v60i9CSmp@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Tue, Sep 28, 2010 at 11:57 AM
> Subject: [PATCH] x86: Plug memory leak in sparse irq
> To: LKML <linux-kernel@vger.kernel.org>
> Cc: x86@kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
> 
> 
> free_irq_cfg() is not freeing the cpumask_vars in irq_cfg.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@kernel.org
> ---
>  arch/x86/kernel/apic/io_apic.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
> @@ -311,9 +311,11 @@ void arch_init_copy_chip_data(struct irq
>        init_copy_irq_2_pin(old_cfg, cfg, node);
>  }
> 
> -static void free_irq_cfg(struct irq_cfg *old_cfg)
> +static void free_irq_cfg(struct irq_cfg *cfg)
>  {
> -       kfree(old_cfg);
> +       free_cpumask_var(cfg->domain);
> +       free_cpumask_var(cfg->old_domain);
> +       kfree(cfg);
>  }
> 
>  void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)

yes. still need

[PATCH] x86: copy cpumask while copying chip_data for offstack cpumask

While looking Thomas's
|	x86: Plug memory leak in sparse irq

found copy_chip_data() could copy the cpumask pointers instead of real data.
Need to use cpumask_copy there.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@kernel.org

---
 arch/x86/kernel/apic/io_apic.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -306,7 +306,10 @@ void arch_init_copy_chip_data(struct irq
 
 	old_cfg = old_desc->chip_data;
 
-	memcpy(cfg, old_cfg, sizeof(struct irq_cfg));
+	cfg->vector = old_cfg->vector;
+	cfg->move_in_progress = old_cfg->move_in_progress;
+	cpumask_copy(cfg->domain, old_cfg->domain);
+	cpumask_copy(cfg->old_domain, old_cfg->old_domain);
 
 	init_copy_irq_2_pin(old_cfg, cfg, node);
 }
