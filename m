Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab1ALCP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 21:15:59 -0500
Received: from claw.goop.org ([74.207.240.146]:43866 "EHLO claw.goop.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab1ALCP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 21:15:57 -0500
Message-ID: <4D2D0EBE.7040406@goop.org>
Date: Wed, 12 Jan 2011 13:15:26 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 2/9] mm: add apply_to_page_range_batch()
References: <cover.1292450600.git.jeremy.fitzhardinge@citrix.com> <8c28c76840fcc7b76c7c8ce4dc28a57241243df7.1292450600.git.jeremy.fitzhardinge@citrix.com> <20110110212628.GC15016@dumpdata.com>
In-Reply-To: <20110110212628.GC15016@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2011 08:26 AM, Konrad Rzeszutek Wilk wrote:
> . snip..
>>  static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>>  				     unsigned long addr, unsigned long end,
>> -				     pte_fn_t fn, void *data)
>> +				     pte_batch_fn_t fn, void *data)
>>  {
>>  	pte_t *pte;
>>  	int err;
>> -	pgtable_t token;
>>  	spinlock_t *uninitialized_var(ptl);
>>  
>>  	pte = (mm == &init_mm) ?
>> @@ -1940,25 +1939,17 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>>  	BUG_ON(pmd_huge(*pmd));
>>  
>>  	arch_enter_lazy_mmu_mode();
>> -
>> -	token = pmd_pgtable(*pmd);
>> -
>> -	do {
>> -		err = fn(pte++, addr, data);
>> -		if (err)
>> -			break;
>> -	} while (addr += PAGE_SIZE, addr != end);
>> -
>> +	err = fn(pte, (end - addr) / PAGE_SIZE, addr, data);
>>  	arch_leave_lazy_mmu_mode();
>>  
>>  	if (mm != &init_mm)
>> -		pte_unmap_unlock(pte-1, ptl);
>> +		pte_unmap_unlock(pte, ptl);
> That looks like a bug fix as well? Did this hit us before the change or was
> it masked by the fact that the code never go to here?

No, it isn't.  In the original code, "pte" would end up pointing into
the next page as the end state of the loop; the "-1" points it back to
the correct page.  With the new version, pte remains unchanged.

    J
