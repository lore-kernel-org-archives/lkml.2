Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab0JYCDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 22:03:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:17461 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab0JYCDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 22:03:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,233,1286175600"; 
   d="scan'208";a="619885112"
Subject: Re: [PATCH 9/9] ACPI, APEI, Generic Hardware Error Source
 POLL/IRQ/NMI notification type support
From: Huang Ying <ying.huang@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <20101022115700.GC10456@basil.fritz.box>
References: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
	 <1287538620-7442-10-git-send-email-ying.huang@intel.com>
	 <20101022115700.GC10456@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 10:03:27 +0800
Message-ID: <1287972207.2862.297.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andi,

Thank you very much for your review!

On Fri, 2010-10-22 at 19:57 +0800, Andi Kleen wrote:
> On Wed, Oct 20, 2010 at 09:37:00AM +0800, Huang Ying wrote:
> 
> Hi Ying,
> 
> Only some minor nits found in review. 
> 
> I don't think they're merge blockers, but could be all fixed
> in followups later.
> 
> Overall it looks all good.
> 
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> 
> > + * These 2 spinlock is used to prevent atomic ioremap virtual memory
> > + * area from being mapped simultaneously.
> > + */
> > +static DEFINE_RAW_SPINLOCK(ghes_ioremap_lock_nmi);
> > +static DEFINE_SPINLOCK(ghes_ioremap_lock_irq);
> > +
> > +static int ghes_ioremap_init(void)
> > +{
> > +	ghes_ioremap_area = __get_vm_area(PAGE_SIZE * 2, VM_IOREMAP,
> 
> Should make the magic PAGE_SIZE * 2 into a define with a comment?

Yes. Will do it.

> > +			vaddr = ghes_ioremap_pfn_nmi(paddr >> PAGE_SHIFT);
> > +		} else {
> > +			spin_lock_irqsave(&ghes_ioremap_lock_irq, flags);
> > +			vaddr = ghes_ioremap_pfn_irq(paddr >> PAGE_SHIFT);
> > +		}
> > +		trunk = PAGE_SIZE - offset;
> > +		trunk = min(trunk, len);
> > +		if (from_phys)
> > +			memcpy(buffer, vaddr + offset, trunk);
> > +		else
> > +			memcpy(vaddr + offset, buffer, trunk);
> 
> In generic Linux this would be memcpy_fromio. On x86 of course it's the same. 
> Still perhaps better use that to prevent sparse from freaking out with its 
> address space checks.

Will do it.

> > @@ -303,6 +390,43 @@ out:
> >  	return 0;
> >  }
> >  
> > +static void ghes_add_timer(struct ghes *ghes)
> > +{
> > +	struct acpi_hest_generic *g = ghes->generic;
> > +	unsigned long expire;
> > +
> > +	if (!g->notify.poll_interval) {
> > +		pr_warning(FW_WARN GHES_PFX "Poll interval is 0 for "
> > +			   "generaic hardware error source: %d, disabled.",
> 
> generaic -> generic 
> 
> This is user visible so should be fixed.

Yes. Will do it.

> > +			   g->header.source_id);
> > +		return;
> > +	}
> > +	expire = jiffies + msecs_to_jiffies(g->notify.poll_interval);
> > +	ghes->timer.expires = round_jiffies_relative(expire);
> > +	add_timer(&ghes->timer);
> 
> Could actually make this a deferrable timer I guess to be even more
> friendly to power.

Yes. Will do it.

> > +		}
> > +		ret = NOTIFY_STOP;
> > +	}
> > +
> > +	if (ret == NOTIFY_DONE)
> > +		goto out;
> > +
> > +	if (sev_global >= GHES_SEV_PANIC) {
> > +		herr_persist_all_records();
> > +		oops_begin();
> > +		/* reboot to log the error! */
> > +		if (panic_timeout == 0)
> > +			panic_timeout = ghes_panic_timeout;
> > +		panic(GHES_PFX "generic hardware fatal error!\n");
> 
> I suspect need some more explanation on this one.

Yes. Will do it.

> > +	case ACPI_HEST_NOTIFY_NMI:
> > +		mutex_lock(&ghes_list_mutex);
> > +		list_del_rcu(&ghes->list);
> > +		if (list_empty(&ghes_nmi))
> > +			unregister_die_notifier(&ghes_notifier_nmi);
> > +		mutex_unlock(&ghes_list_mutex);
> > +		synchronize_rcu();

Best Regards,
Huang Ying


