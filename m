Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab2C1FjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 01:39:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:11329 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab2C1FjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 01:39:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124135599"
Subject: Re: [PATCH] x86_fixup_irqs: Fix possible missing interrupt handle
 when disabling CPU
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>, tglx@linutronix.de,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, hpa@zytor.com
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A05DFB3@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A05DFB3@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: UMG
Date: Wed, 28 Mar 2012 13:38:53 +0800
Message-ID: <1332913133.1916.271.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 07:11 +0000, Liu, Chuansheng wrote:
> From: liu chuansheng <chuansheng.liu@intel.com>
> Subject: [PATCH] x86_fixup_irqs: Fix possible missing interrupt handle when disabling CPU
> 
> When preparing to unmask the irq in fixup_irqs(), using irqd_irq_masked()
> as the condition to determine if do real unmasking action or not.
> 
> Because in some chips, the .irq_disable is NULL, so calling disable_irq()
> does not mean the irq is masked immediately, and before enable_irq() if
> the irq is coming, it can be pending state. Using irqd_irq_disabled() will
> lose this chance.
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  arch/x86/kernel/irq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 6c0802e..b9dd37f 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -277,7 +277,7 @@ void fixup_irqs(void)
>                         set_affinity = 0;
>  
>                 if (!irqd_can_move_in_process_context(data) &&
> -                   !irqd_irq_disabled(data) && chip->irq_unmask)
> +                   !irqd_irq_masked(data) && chip->irq_unmask)
>                         chip->irq_unmask(data);
>  
>                 raw_spin_unlock(&desc->lock);
Thomas,

Originally, we found an issue when enabling Android (Gingerbread) with kernel
2.6.35 on Medfield.

When system goes to suspend-2-ram, some device drivers call disable_irq to
disable some device irq at device driver suspend callbacks. In addition,
some specific irq_chips just provide mask/unmask callbacks and have no
enable/disable callbacks. When drivers call
disable_irq=>...=>irq_disable=>desc->irq_data.chip->irq_disable, they don't
really mask the irq at the irq_chip. With such specific irq_chip, we could
keep the irq as wake up sources. When the irq arrives after driver disables them,
IRQ handling framework would mark it PENDING and calls the irq handler when
drivers call enable_irq.

After device driver's suspend/suspend_noirq callbacks are called, suspend-2-ram
would disable nonboot cpus, which calls fixup_irqs. fixup_irqs really masks the irq
at irq_chip as the drivers calls disable_irq before. So one of the side effects of
calling fixup_irq is to really mask the irq and we lose the wakeup capability of
the corresponding irq.

You might ask why drivers call disable_irq at suspend callback. That's because
another specific reason. suspend callback calls disable_irq and resume callback calls
enable_irq. Between suspend and resume callbacks, we don't want kernel to deliver
the irq to the driver irq handler as the device is not FULLY resumed yet.

Chuangsheng's patch tries to fix above issue, to keep the difference between
enable/disable and mask/unmask callbacks of irq_chip.

Hope my explanation could be a little clearer.

Sorry for taking you too much time.

Yanmin


