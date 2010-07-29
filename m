Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0G2CLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 22:11:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54287 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab0G2CLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 22:11:49 -0400
Message-ID: <4C50E43A.4020106@cn.fujitsu.com>
Date: Thu, 29 Jul 2010 10:15:22 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 5/6] kvm, x86: use ro page and don't copy shared page
References: <4C3FC033.3000605@cn.fujitsu.com> <20100716071936.GE17894@redhat.com>
In-Reply-To: <20100716071936.GE17894@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 03:19 PM, Gleb Natapov wrote:

>> +/* get a current mapped page fast, and test whether the page is writable. */
>> +static struct page *get_user_page_and_protection(unsigned long addr,
>> +	int *writable)
>> +{
>> +	struct page *page[1];
>> +
>> +	if (__get_user_pages_fast(addr, 1, 1, page) == 1) {
>> +		*writable = 1;
>> +		return page[0];
>> +	}
>> +	if (__get_user_pages_fast(addr, 1, 0, page) == 1) {
>> +		*writable = 0;
>> +		return page[0];
>> +	}
>> +	return NULL;
>> +}
>> +
>> +static pfn_t kvm_get_pfn_for_page_fault(struct kvm *kvm, gfn_t gfn,
>> +		int write_fault, int *host_writable)
>> +{
>> +	unsigned long addr;
>> +	struct page *page;
>> +
>> +	if (!write_fault) {
>> +		addr = gfn_to_hva(kvm, gfn);
>> +		if (kvm_is_error_hva(addr)) {
>> +			get_page(bad_page);
>> +			return page_to_pfn(bad_page);
>> +		}
>> +
>> +		page = get_user_page_and_protection(addr, host_writable);
>> +		if (page)
>> +			return page_to_pfn(page);
>> +	}
>> +
>> +	*host_writable = 1;
>> +	return kvm_get_pfn_for_gfn(kvm, gfn);
>> +}
>> +
> kvm_get_pfn_for_gfn() returns fault_page if page is mapped RO, so caller
> of kvm_get_pfn_for_page_fault() and kvm_get_pfn_for_gfn() will get
> different results when called on the same page. Not good.
> kvm_get_pfn_for_page_fault() logic should be folded into
> kvm_get_pfn_for_gfn().
> 


The different results are the things we just need.
We don't want to copy and write a page which is mapped RO when
only read fault.
