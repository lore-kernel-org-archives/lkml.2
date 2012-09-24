Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab2IXMc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:32:26 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:50555 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab2IXMcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:32:24 -0400
Message-ID: <506052D1.5000006@linux.vnet.ibm.com>
Date: Mon, 24 Sep 2012 20:32:17 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 1/7] KVM: MMU: fix release noslot pfn
References: <505C0FA8.5070007@linux.vnet.ibm.com> <505C0FCF.2070308@linux.vnet.ibm.com> <20120923091335.GA20907@redhat.com> <505FE8B4.8030309@linux.vnet.ibm.com> <20120924112416.GA23096@redhat.com> <506048D1.70403@linux.vnet.ibm.com> <20120924120424.GB23096@redhat.com>
In-Reply-To: <20120924120424.GB23096@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092412-5490-0000-0000-0000022FA380
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 08:04 PM, Gleb Natapov wrote:
> On Mon, Sep 24, 2012 at 07:49:37PM +0800, Xiao Guangrong wrote:
>> On 09/24/2012 07:24 PM, Gleb Natapov wrote:
>>> On Mon, Sep 24, 2012 at 12:59:32PM +0800, Xiao Guangrong wrote:
>>>> On 09/23/2012 05:13 PM, Gleb Natapov wrote:
>>>>> On Fri, Sep 21, 2012 at 02:57:19PM +0800, Xiao Guangrong wrote:
>>>>>> We can not directly call kvm_release_pfn_clean to release the pfn
>>>>>> since we can meet noslot pfn which is used to cache mmio info into
>>>>>> spte
>>>>>>
>>>>> Wouldn't it be better to move the check into kvm_release_pfn_clean()?
>>>>
>>>> I think there is no reason for us to prefer to adding this branch in
>>>> the common code. :)
>>>
>>> Is the function performance critical? Is function called without the check
>>> on a hot path?  The function already contains much heavier kvm_is_mmio_pfn()
>>> check. If most/all function invocation require check before call it's
>>> better to move it inside.
>>
>> It is not most/all functions need do this check - it is only needed on x86 mmu
>> page-fault/prefetch path.
> At least on x86 there 7 calls to kvm_release_pfn_clean(), 5 of them are
> guarded by is_noslot_pfn() (after this patch) 

3 places after the whole patchset (There are some cleanups after this patch).

> and one by even stronger is_error_pfn(). 

This one is:

|	if (!is_error_pfn(pfn)) {
|                kvm_release_pfn_clean(pfn);
|                return true;
|	}
|
|	return false;

We can change it to:

| if (is_error_pfn(pfn))
|	return false;
|
| kvm_release_pfn_clean(pfn);
| return true;

> I guess when/if other architectures will add MMIO MMU
> caching they will need to guard kvm_release_pfn_clean() by is_noslot_pfn()
> too in most cases. I am not insisting, but as this patch shows it is
> easy to miss the check before calling the function.

Sounds reasonable. I will consider it if Avi/Marcelo have no object on
it.



