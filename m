Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945986Ab2KNXR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 18:17:27 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:60587 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab2KNXRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 18:17:25 -0500
Message-ID: <50A4267B.1030902@linux.vnet.ibm.com>
Date: Thu, 15 Nov 2012 07:17:15 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: MMU: lazily drop large spte
References: <50978DFE.1000005@linux.vnet.ibm.com> <20121112231032.GB5798@amt.cnet> <50A20428.1030004@linux.vnet.ibm.com> <20121114143747.GA7054@amt.cnet>
In-Reply-To: <20121114143747.GA7054@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12111423-4790-0000-0000-0000058F4325
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 10:37 PM, Marcelo Tosatti wrote:
> On Tue, Nov 13, 2012 at 04:26:16PM +0800, Xiao Guangrong wrote:
>> Hi Marcelo,
>>
>> On 11/13/2012 07:10 AM, Marcelo Tosatti wrote:
>>> On Mon, Nov 05, 2012 at 05:59:26PM +0800, Xiao Guangrong wrote:
>>>> Do not drop large spte until it can be insteaded by small pages so that
>>>> the guest can happliy read memory through it
>>>>
>>>> The idea is from Avi:
>>>> | As I mentioned before, write-protecting a large spte is a good idea,
>>>> | since it moves some work from protect-time to fault-time, so it reduces
>>>> | jitter.  This removes the need for the return value.
>>>>
>>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>>> ---
>>>>  arch/x86/kvm/mmu.c |   34 +++++++++-------------------------
>>>>  1 files changed, 9 insertions(+), 25 deletions(-)
>>>
>>> Its likely that other 4k pages are mapped read-write in the 2mb range 
>>> covered by a read-only 2mb map. Therefore its not entirely useful to
>>> map read-only. 
>>>
>>
>> It needs a page fault to install a pte even if it is the read access.
>> After the change, the page fault can be avoided.
>>
>>> Can you measure an improvement with this change?
>>
>> I have a test case to measure the read time which has been attached.
>> It maps 4k pages at first (dirt-loggged), then switch to large sptes
>> (stop dirt-logging), at the last, measure the read access time after write
>> protect sptes.
>>
>> Before: 23314111 ns	After: 11404197 ns
> 
> Ok, i'm concerned about cases similar to e49146dce8c3dc6f44 (with shadow),
> that is:
> 
> - large page must be destroyed when write protecting due to 
> shadowed page.
> - with shadow, it does not make sense to write protect 
> large sptes as mentioned earlier.
> 

This case is removed now, the code when e49146dce8c3dc6f44 was applied is:
|
|                pt = sp->spt;
|                for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
|                        /* avoid RMW */
|                        if (is_writable_pte(pt[i]))
|                                update_spte(&pt[i], pt[i] & ~PT_WRITABLE_MASK);
|        }

The real problem in this code is it would write-protect the spte even if
it is not a last spte that caused the middle-level shadow page table was
write-protected. So e49146dce8c3dc6f44 added this code:
|                if (sp->role.level != PT_PAGE_TABLE_LEVEL)
|                        continue;
|
was good to fix this problem.

Now, the current code is:
|		for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
|			if (!is_shadow_present_pte(pt[i]) ||
|			      !is_last_spte(pt[i], sp->role.level))
|				continue;
|
|			spte_write_protect(kvm, &pt[i], &flush, false);
|		}
It only write-protect the last spte. So, it allows large spte existent.
(the large spte can be broken by drop_large_spte() on the page-fault path.)

> So i wonder why is this part from your patch
> 
> -               if (level > PT_PAGE_TABLE_LEVEL &&
> -                   has_wrprotected_page(vcpu->kvm, gfn, level)) {
> -                       ret = 1;
> -                       drop_spte(vcpu->kvm, sptep);
> -                       goto done;
> -               }
> 
> necessary (assuming EPT is in use).

This is safe, we change these code to:

-		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
+		if ((level > PT_PAGE_TABLE_LEVEL &&
+		   has_wrprotected_page(vcpu->kvm, gfn, level)) ||
+		      mmu_need_write_protect(vcpu, gfn, can_unsync)) {
 			pgprintk("%s: found shadow page for %llx, marking ro\n",
 				 __func__, gfn);
 			ret = 1;

The spte become read-only which can ensure the shadow gfn can not be changed.

Btw, the origin code allows to create readonly spte under this case if !(pte_access & WRITEABBLE)

