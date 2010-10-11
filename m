Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab0JKRfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:35:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63252 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab0JKRfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:35:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DKBfSZfXRx4AQPYFn5F6O0HRlieczsGXfUTE0lT726RIsTe1c1qJetjvvG7Nq/6Nzn
         pLCFfe2UQyEkkS6OIszmeU4AjH3m3BwI03U8wuIYJN3CwpfW7J4P14V25dG4b9SCrjZL
         9yya6JpZN9O3Wcj3canjFVXW3zyR/eo/BAgPY=
Message-ID: <4CB34A1A.3030003@gmail.com>
Date: Mon, 11 Oct 2010 19:32:10 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>, linux-mm@kvack.org
Subject: Re: [PATCH 14(16] pramfs: memory protection
References: <4CB1EBA2.8090409@gmail.com> <87aamm3si1.fsf@basil.nowhere.org>
In-Reply-To: <87aamm3si1.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 10/10/2010 18:46, Andi Kleen ha scritto:
> This won't work at all on x86 because you don't handle large 
> pages.
> 
> And it doesn't work on x86-64 because the first 2GB are double
> mapped (direct and kernel text mapping)
> 
> Thirdly I expect it won't either on architectures that map
> the direct mapping with special registers (like IA64 or MIPS)

Andi, what do you think to use the already implemented follow_pte
instead? 

int writeable_kernel_pte_range(unsigned long address, unsigned long size,
							      unsigned int rw)
{

	unsigned long addr = address & PAGE_MASK;
	unsigned long end = address + size;
	unsigned long start = addr;
	int ret = -EINVAL;
	pte_t *ptep, pte;
	spinlock_t *lock = &init_mm.page_table_lock;

	do {
		ret = follow_pte(&init_mm, addr, &ptep, &lock);
		if (ret)
			goto out;
		pte = *ptep;
		if (pte_present(pte)) {
			  pte = rw ? pte_mkwrite(pte) : pte_wrprotect(pte);
			  *ptep = pte;
		}
		pte_unmap_unlock(ptep, lock);
		addr += PAGE_SIZE;
	} while (addr && (addr < end));

	ret = 0;

out:
	flush_tlb_kernel_range(start, end);
	return ret;
}


> 
> I'm not sure this is very useful anyways. It doesn't protect
> against stray DMA and it doesn't protect against writes through
> broken user PTEs.
> 
> -Andi
> 

It's a way to have more protection against kernel bug, for a 
in-memory fs can be important. However this option can be 
enabled/disabled at fs level.

Marco
