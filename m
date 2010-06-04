Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0FDIOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 04:14:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64919 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab0FDIOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 04:14:14 -0400
Message-ID: <4C08B5D0.6090104@cn.fujitsu.com>
Date: Fri, 04 Jun 2010 16:14:08 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: rework remove-write-access for a slot
References: <4C061C16.9040208@cn.fujitsu.com> <4C063E01.7040206@redhat.com>
In-Reply-To: <4C063E01.7040206@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 06/02/2010 11:53 AM, Lai Jiangshan wrote:
>> Current code uses slot_bitmap to find ptes who map a page
>> from the memory slot, it is not precise: some ptes in the shadow page
>> are not map any page from the memory slot.
>>
>> This patch uses rmap to find the ptes precisely, and remove
>> the unused slot_bitmap.
>>
>>    
> 
> Patch looks good; a couple of comments:
> 
> - We might see a slowdown with !tdp, since we no longer have locality. 
> Each page will map to an spte in a different page.  However, it's still
> worth it in my opinion.

Yes, this patch hurts the cache since we no longer have locality.
And if most pages of the slot are not mapped(rmap_next(kvm, rmapp, NULL)==NULL),
this patch will worse than old method I think.

This patch do things straightly, precisely.

> - I thought of a different approach to write protection: write protect
> the L4 sptes, on write fault add write permission to the L4 spte and
> write protect the L3 sptes that it points to, etc.  This method can use
> the slot bitmap to reduce the number of write faults.  However we can
> reintroduce the slot bitmap if/when we use the method, this shouldn't
> block the patch.

It is very a good approach and it is blazing fast.

I have no time to implement it currently,
could you update it into the TODO list?

> 
>>
>> +static void rmapp_remove_write_access(struct kvm *kvm, unsigned long
>> *rmapp)
>> +{
>> +    u64 *spte = rmap_next(kvm, rmapp, NULL);
>> +
>> +    while (spte) {
>> +        /* avoid RMW */
>> +        if (is_writable_pte(*spte))
>> +            *spte &= ~PT_WRITABLE_MASK;
> 
> Must use an atomic operation here to avoid losing dirty or accessed bit.
> 

Atomic operation is too expensive, I retained the comment "/* avoid RMW */"
and wait someone take a good approach for it.


