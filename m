Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab0JVL5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:57:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35778 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab0JVL5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:57:05 -0400
Date: Fri, 22 Oct 2010 13:57:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 9/9] ACPI, APEI, Generic Hardware Error Source
 POLL/IRQ/NMI notification type support
Message-ID: <20101022115700.GC10456@basil.fritz.box>
References: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
 <1287538620-7442-10-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287538620-7442-10-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 09:37:00AM +0800, Huang Ying wrote:

Hi Ying,

Only some minor nits found in review. 

I don't think they're merge blockers, but could be all fixed
in followups later.

Overall it looks all good.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

> + * These 2 spinlock is used to prevent atomic ioremap virtual memory
> + * area from being mapped simultaneously.
> + */
> +static DEFINE_RAW_SPINLOCK(ghes_ioremap_lock_nmi);
> +static DEFINE_SPINLOCK(ghes_ioremap_lock_irq);
> +
> +static int ghes_ioremap_init(void)
> +{
> +	ghes_ioremap_area = __get_vm_area(PAGE_SIZE * 2, VM_IOREMAP,

Should make the magic PAGE_SIZE * 2 into a define with a comment?

> +			vaddr = ghes_ioremap_pfn_nmi(paddr >> PAGE_SHIFT);
> +		} else {
> +			spin_lock_irqsave(&ghes_ioremap_lock_irq, flags);
> +			vaddr = ghes_ioremap_pfn_irq(paddr >> PAGE_SHIFT);
> +		}
> +		trunk = PAGE_SIZE - offset;
> +		trunk = min(trunk, len);
> +		if (from_phys)
> +			memcpy(buffer, vaddr + offset, trunk);
> +		else
> +			memcpy(vaddr + offset, buffer, trunk);

In generic Linux this would be memcpy_fromio. On x86 of course it's the same. 
Still perhaps better use that to prevent sparse from freaking out with its 
address space checks.

> @@ -303,6 +390,43 @@ out:
>  	return 0;
>  }
>  
> +static void ghes_add_timer(struct ghes *ghes)
> +{
> +	struct acpi_hest_generic *g = ghes->generic;
> +	unsigned long expire;
> +
> +	if (!g->notify.poll_interval) {
> +		pr_warning(FW_WARN GHES_PFX "Poll interval is 0 for "
> +			   "generaic hardware error source: %d, disabled.",

generaic -> generic 

This is user visible so should be fixed.


> +			   g->header.source_id);
> +		return;
> +	}
> +	expire = jiffies + msecs_to_jiffies(g->notify.poll_interval);
> +	ghes->timer.expires = round_jiffies_relative(expire);
> +	add_timer(&ghes->timer);

Could actually make this a deferrable timer I guess to be even more
friendly to power.

> +		}
> +		ret = NOTIFY_STOP;
> +	}
> +
> +	if (ret == NOTIFY_DONE)
> +		goto out;
> +
> +	if (sev_global >= GHES_SEV_PANIC) {
> +		herr_persist_all_records();
> +		oops_begin();
> +		/* reboot to log the error! */
> +		if (panic_timeout == 0)
> +			panic_timeout = ghes_panic_timeout;
> +		panic(GHES_PFX "generic hardware fatal error!\n");

I suspect need some more explanation on this one.

> +	case ACPI_HEST_NOTIFY_NMI:
> +		mutex_lock(&ghes_list_mutex);
> +		list_del_rcu(&ghes->list);
> +		if (list_empty(&ghes_nmi))
> +			unregister_die_notifier(&ghes_notifier_nmi);
> +		mutex_unlock(&ghes_list_mutex);
> +		synchronize_rcu();

Should normally have a comment to describe what it synchronizes against.
The NMI in this case I guess.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
