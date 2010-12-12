Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab0LLRaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 12:30:11 -0500
Received: from www.tglx.de ([62.245.132.106]:56583 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab0LLRaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 12:30:07 -0500
Date: Sun, 12 Dec 2010 18:29:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@web.de>
cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v2 1/4] genirq: Introduce driver-readable IRQ status
 word
In-Reply-To: <0b28922dfb7f5791fcb1866a0f1c033bacb8f4d8.1292152963.git.jan.kiszka@web.de>
Message-ID: <alpine.LFD.2.00.1012121747000.2653@localhost6.localdomain6>
References: <cover.1292152963.git.jan.kiszka@web.de> <0b28922dfb7f5791fcb1866a0f1c033bacb8f4d8.1292152963.git.jan.kiszka@web.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Dec 2010, Jan Kiszka wrote:

> From: Jan Kiszka <jan.kiszka@siemens.com>
> 
> This associates a status word with every IRQ descriptor. Drivers can obtain
> its content via get_irq_status(irq). First use case will be propagating the
> interrupt sharing state.
> 
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  include/linux/interrupt.h |    2 ++
>  include/linux/irq.h       |    2 ++
>  kernel/irq/manage.c       |   15 +++++++++++++++
>  3 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 79d0c4f..16cdbbf 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -126,6 +126,8 @@ struct irqaction {
>  
>  extern irqreturn_t no_action(int cpl, void *dev_id);
>  
> +extern unsigned long get_irq_status(unsigned long irq);
> +
>  #ifdef CONFIG_GENERIC_HARDIRQS
>  extern int __must_check
>  request_threaded_irq(unsigned int irq, irq_handler_t handler,
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index abde252..5554203 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -96,6 +96,7 @@ struct msi_desc;
>   *			methods, to allow shared chip implementations
>   * @msi_desc:		MSI descriptor
>   * @affinity:		IRQ affinity on SMP
> + * @status:		driver-readable status flags (IRQS_*)
>   *
>   * The fields here need to overlay the ones in irq_desc until we
>   * cleaned up the direct references and switched everything over to
> @@ -108,6 +109,7 @@ struct irq_data {
>  	void			*handler_data;
>  	void			*chip_data;
>  	struct msi_desc		*msi_desc;
> +	unsigned long		status;

That breaks the current code which has irq_data embedded and shadowed
in irq_desc for migratory reasons until all users are fixed up and the
GENERIC_HARDIRQS_NO_DEPRECATED sections are cleaned up. I know it's
ugly, but that was the only way not to rewrite the world in one go. :)
Just move it below affinity.

Also we should name it different than status, drv_status perhaps, to
avoid confusion with the irq_desc status.

>  #ifdef CONFIG_SMP
>  	cpumask_var_t		affinity;
>  #endif

Thanks,

	tglx
