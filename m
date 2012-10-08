Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab2JHFSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 01:18:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43935 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab2JHFSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 01:18:01 -0400
X-IronPort-AV: E=Sophos;i="4.80,551,1344182400"; 
   d="scan'208";a="5957657"
Message-ID: <50726354.60803@cn.fujitsu.com>
Date: Mon, 08 Oct 2012 13:23:32 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH 8/10] memory-hotplug : remove page table of x86_64 architecture
References: <506E43E0.70507@jp.fujitsu.com> <506E4799.30407@jp.fujitsu.com> <m2d30tvatv.fsf@firstfloor.org>
In-Reply-To: <m2d30tvatv.fsf@firstfloor.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/08 13:17:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/08 13:17:52,
	Serialize complete at 2012/10/08 13:17:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/08/2012 12:37 PM, Andi Kleen Wrote:
> Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com> writes:
>> +			}
>> +
>> +			/*
>> +			 * We use 2M page, but we need to remove part of them,
>> +			 * so split 2M page to 4K page.
>> +			 */
>> +			pte = alloc_low_page(&pte_phys);
> 
> What happens when the allocation fails?
> 
> alloc_low_page seems to be buggy there too, it would __pa a NULL 
> pointer.

Yes, it will cause kernek panicked in __pa() if CONFI_DEBUG_VIRTUAL is set.
Otherwise, it will return a NULL pointer. I will update this patch to deal
with NULL pointer.

> 
>> +		if (pud_large(*pud)) {
>> +			if ((addr & ~PUD_MASK) == 0 && next <= end) {
>> +				set_pud(pud, __pud(0));
>> +				pages++;
>> +				continue;
>> +			}
>> +
>> +			/*
>> +			 * We use 1G page, but we need to remove part of them,
>> +			 * so split 1G page to 2M page.
>> +			 */
>> +			pmd = alloc_low_page(&pmd_phys);
> 
> Same here
> 
>> +			__split_large_page((pte_t *)pud, addr, (pte_t *)pmd);
>> +
>> +			spin_lock(&init_mm.page_table_lock);
>> +			pud_populate(&init_mm, pud, __va(pmd_phys));
>> +			spin_unlock(&init_mm.page_table_lock);
>> +		}
>> +
>> +		pmd = map_low_page(pmd_offset(pud, 0));
>> +		phys_pmd_remove(pmd, addr, end);
>> +		unmap_low_page(pmd);
>> +		__flush_tlb_all();
>> +	}
>> +	__flush_tlb_all();
> 
> This doesn't flush the other CPUs doesn't it?

How to flush the other CPU's tlb? use on_each_cpu() to run __flush_tlb_all()
on each online cpu?

Thanks
Wen Congyang

> 
> -Andi
> 

