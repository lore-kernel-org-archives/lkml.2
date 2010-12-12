Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab0LLQx5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 11:53:57 -0500
Received: from www.tglx.de ([62.245.132.106]:35056 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab0LLQxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 11:53:53 -0500
Date: Sun, 12 Dec 2010 17:53:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@web.de>
cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v2 2/4] genirq: Inform handler about line sharing state
In-Reply-To: <664535c6596c0c6bf7024f2608134c90e2093c19.1292152963.git.jan.kiszka@web.de>
Message-ID: <alpine.LFD.2.00.1012121750520.2653@localhost6.localdomain6>
References: <cover.1292152963.git.jan.kiszka@web.de> <664535c6596c0c6bf7024f2608134c90e2093c19.1292152963.git.jan.kiszka@web.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Dec 2010, Jan Kiszka wrote:

> From: Jan Kiszka <jan.kiszka@siemens.com>
> 
> This enabled interrupt handlers to retrieve the current line sharing state via
> the new interrupt status word so that they can adapt to it.
> 
> The switch from shared to exclusive is generally uncritical and can thus be
> performed on demand. However, preparing a line for shared mode may require
> preparational steps of the currently registered handler. It can therefore
> request an ahead-of-time notification via IRQF_ADAPTIVE. The notification
> consists of an exceptional handler invocation with IRQS_MAKE_SHAREABLE set in
> the status word.
> 
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  include/linux/interrupt.h |   10 ++++++++++
>  include/linux/irqdesc.h   |    2 ++
>  kernel/irq/irqdesc.c      |    2 ++
>  kernel/irq/manage.c       |   44 +++++++++++++++++++++++++++++++++++++++++---
>  4 files changed, 55 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 16cdbbf..c6323a2 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -55,6 +55,7 @@
>   *                Used by threaded interrupts which need to keep the
>   *                irq line disabled until the threaded handler has been run.
>   * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
> + * IRQF_ADAPTIVE - Request notification about upcoming interrupt line sharing
>   *
>   */
>  #define IRQF_DISABLED		0x00000020
> @@ -67,6 +68,7 @@
>  #define IRQF_IRQPOLL		0x00001000
>  #define IRQF_ONESHOT		0x00002000
>  #define IRQF_NO_SUSPEND		0x00004000
> +#define IRQF_ADAPTIVE		0x00008000
>  
>  #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND)
>  
> @@ -126,6 +128,14 @@ struct irqaction {
>  
>  extern irqreturn_t no_action(int cpl, void *dev_id);
>  
> +/*
> + * Driver-readable IRQ line status flags:
> + * IRQS_SHARED - line is shared between multiple handlers
> + * IRQS_MAKE_SHAREABLE - in the process of making an exclusive line shareable
> + */
> +#define IRQS_SHARED		0x00000001
> +#define IRQS_MAKE_SHAREABLE	0x00000002
> +
>  extern unsigned long get_irq_status(unsigned long irq);
>  
>  #ifdef CONFIG_GENERIC_HARDIRQS
> diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
> index 979c68c..c490e83 100644
> --- a/include/linux/irqdesc.h
> +++ b/include/linux/irqdesc.h
> @@ -29,6 +29,7 @@ struct timer_rand_state;
>   * @wait_for_threads:	wait queue for sync_irq to wait for threaded handlers
>   * @dir:		/proc/irq/ procfs entry
>   * @name:		flow handler name for /proc/interrupts output
> + * @register_lock:	protects registration & release, for unshared->shared

I think we can make that a global mutex. request/free_irq are not
hotpath operations which require a mutex per irq descriptor.

Thanks,

	tglx
