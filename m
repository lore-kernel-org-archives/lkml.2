Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab2JHEhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 00:37:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:4542 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab2JHEhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 00:37:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,549,1344236400"; 
   d="scan'208";a="231085063"
From: Andi Kleen <andi@firstfloor.org>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: <x86@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-sh@vger.kernel.org>,
        <linux-ia64@vger.kernel.org>, <cmetcalf@tilera.com>,
        <sparclinux@vger.kernel.org>, <rientjes@google.com>,
        <liuj97@gmail.com>, <len.brown@intel.com>, <cl@linux.com>,
        <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: Re: [PATCH 8/10] memory-hotplug : remove page table of x86_64 architecture
References: <506E43E0.70507@jp.fujitsu.com> <506E4799.30407@jp.fujitsu.com>
Date: Sun, 07 Oct 2012 21:37:00 -0700
In-Reply-To: <506E4799.30407@jp.fujitsu.com> (Yasuaki Ishimatsu's message of
	"Fri, 5 Oct 2012 11:36:09 +0900")
Message-ID: <m2d30tvatv.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com> writes:
> +			}
> +
> +			/*
> +			 * We use 2M page, but we need to remove part of them,
> +			 * so split 2M page to 4K page.
> +			 */
> +			pte = alloc_low_page(&pte_phys);

What happens when the allocation fails?

alloc_low_page seems to be buggy there too, it would __pa a NULL 
pointer.

> +		if (pud_large(*pud)) {
> +			if ((addr & ~PUD_MASK) == 0 && next <= end) {
> +				set_pud(pud, __pud(0));
> +				pages++;
> +				continue;
> +			}
> +
> +			/*
> +			 * We use 1G page, but we need to remove part of them,
> +			 * so split 1G page to 2M page.
> +			 */
> +			pmd = alloc_low_page(&pmd_phys);

Same here

> +			__split_large_page((pte_t *)pud, addr, (pte_t *)pmd);
> +
> +			spin_lock(&init_mm.page_table_lock);
> +			pud_populate(&init_mm, pud, __va(pmd_phys));
> +			spin_unlock(&init_mm.page_table_lock);
> +		}
> +
> +		pmd = map_low_page(pmd_offset(pud, 0));
> +		phys_pmd_remove(pmd, addr, end);
> +		unmap_low_page(pmd);
> +		__flush_tlb_all();
> +	}
> +	__flush_tlb_all();

This doesn't flush the other CPUs doesn't it?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
