Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab2FMPA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:00:27 -0400
Received: from smtp.citrix.com ([66.165.176.89]:50255 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab2FMPA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:00:26 -0400
X-IronPort-AV: E=Sophos;i="4.75,763,1330923600"; 
   d="scan'208";a="27928637"
Message-ID: <4FD8AB07.7080004@citrix.com>
Date: Wed, 13 Jun 2012 16:00:23 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] x86/mm: remove arch-specific PTE/PMD get-and-clear
 functions
References: <1339582845-25659-1-git-send-email-david.vrabel@citrix.com> <20120613140404.GH5979@phenom.dumpdata.com>
In-Reply-To: <20120613140404.GH5979@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/12 15:04, Konrad Rzeszutek Wilk wrote:
> On Wed, Jun 13, 2012 at 11:20:43AM +0100, David Vrabel wrote:
>> This series removes the x86-specific implementation of
>> ptep_get_and_clear() and pmdp_get_and_clear().
>>
>> The principal reason for this is it allows Xen paravitualized guests
>> to batch the PTE clears which is a significant performance
>> optimization of munmap() and mremap() -- the number of entries into
>> the hypervisor is reduced by about a factor of about 30 (60 in 32-bit
>> guests) for munmap().
>>
>> There may be minimal gains on native and KVM guests due to the removal
>> of the locked xchg.
> 
> What about lguest?

As I note in the description of patch 1:

"There may be a performance regression with lguest guests as
an optimization for avoiding calling pte_update() when doing a full
teardown of an mm is removed."

I don't know how much this performance regression would be or if the
performance of lguest guests is something people care about.

We could have an x86-specific ptep_get_and_clear_full() which looks like:

pte_t ptep_get_and_clear_full(
	struct mm_struct *mm, unsigned long addr, pte_t *ptep,
	int full)
{
	pte_t pte = *ptep;

	pte_clear(mm, address, ptep);
	if (!full)
		pte_update(mm, addr, ptep);

	return pte;
}

Which would have all the performance benefits of the proposed patch
without the performance regression with lguest.

David

>>
>> Removal of arch-specific functions where generic ones are suitable
>> seems to be a generally useful thing to me.
>>
>> The full reasoning for why this is safe is included in the commit
>> message of patch 1 but to summarize.  The atomic get-and-clear does
>> not guarantee that the latest dirty/accessed bits are returned as TLB
>> as there is a still a window after the get-and-clear and before the
>> TLB flush that the bits may be updated on other processors.  So, user
>> space applications accessing pages that are being unmapped or remapped
>> already have unpredictable behaviour.
>>
>> David

