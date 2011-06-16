Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab1FPX2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 19:28:13 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:35925 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab1FPX2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 19:28:10 -0400
Subject: Re: [PATCH] genirq: don't use flush_scheduled_work() in IRQ
 affinity notifiers
From: Ben Hutchings <bhutchings@solarflare.com>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20110615142917.GY8141@htj.dyndns.org>
References: <20110615142917.GY8141@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Fri, 17 Jun 2011 00:28:06 +0100
Message-ID: <1308266886.2925.27.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jun 2011 23:28:09.0569 (UTC) FILETIME=[0D7C5D10:01CC2C7D]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18202.004
X-TM-AS-Result: No--12.369000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-15 at 16:29 +0200, Tejun Heo wrote:
> cd7eab44e9 (genirq: Add IRQ affinity notifiers) added use of
> flush_scheduled_work() which is being deprecated.  Add a dedicated
> workqueue and flush it instead of flushing system-wide workqueue.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ben Hutchings <bhutchings@solarflare.com>
> ---
> I'm planning on marking flush_scheduled_work() deprecated in
> linux-next soonish.  It would be great if this patch (or something
> else which removes flush_scheduled_work() call somehow) can be
> included in linux-next.
[...]
> --- work.orig/kernel/irq/manage.c
> +++ work/kernel/irq/manage.c
> @@ -74,6 +74,16 @@ EXPORT_SYMBOL(synchronize_irq);
>  
>  #ifdef CONFIG_SMP
>  cpumask_var_t irq_default_affinity;
> +static struct workqueue_struct *irq_affinity_notify_wq;
> +
> +static int __init irq_affinity_init(void)
> +{
> +	irq_affinity_notify_wq = alloc_workqueue("irq_affinity_notify", 0, 0);
> +	if (!irq_affinity_notify_wq)
> +		return -ENOMEM;
> +	return 0;
> +}
> +subsys_initcall(irq_affinity_init);
[...]

This facility is enabled on all configurations with NET && SMP &&
GENERIC_HARDIRQS, but at the moment is only useful for some net drivers
(currently only one).  So I don't think it should be creating a task at
boot time.  Does alloc_workqueue() still create any tasks immediately?

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

