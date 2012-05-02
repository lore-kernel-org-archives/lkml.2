Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab2EBFkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 01:40:04 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:49061 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab2EBFkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 01:40:02 -0400
Message-ID: <4FA0C8A7.9000001@linux.vnet.ibm.com>
Date: Wed, 02 May 2012 13:39:51 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page fault
References: <4F9776D2.7020506@linux.vnet.ibm.com> <4F9777A4.208@linux.vnet.ibm.com>	<20120426234535.GA5057@amt.cnet> <4F9A3445.2060305@linux.vnet.ibm.com>	<20120427145213.GB28796@amt.cnet> <20120429175004.b54d8c095a60d98c8cdbc942@gmail.com>
In-Reply-To: <20120429175004.b54d8c095a60d98c8cdbc942@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12050205-9574-0000-0000-0000027186C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2012 04:50 PM, Takuya Yoshikawa wrote:

> On Fri, 27 Apr 2012 11:52:13 -0300
> Marcelo Tosatti <mtosatti@redhat.com> wrote:
> 
>> Yes but the objective you are aiming for is to read and write sptes
>> without mmu_lock. That is, i am not talking about this patch. 
>> Please read carefully the two examples i gave (separated by "example)").
> 
> The real objective is not still clear.
> 
> The ~10% improvement reported before was on macro benchmarks during live
> migration.  At least, that optimization was the initial objective.
> 
> But at some point, the objective suddenly changed to "lock-less" without
> understanding what introduced the original improvement.
> 
> Was the problem really mmu_lock contention?
> 


Takuya, i am so tired to argue the advantage of lockless write-protect
and lockless O(1) dirty-log again and again.

> If the path being introduced by this patch is really fast, isn't it
> possible to achieve the same improvement still using mmu_lock?
> 
> 
> Note: During live migration, the fact that the guest gets faulted is
> itself a limitation.  We could easily see noticeable slowdown of a
> program even if it runs only between two GET_DIRTY_LOGs.
> 


Obviously no.

It depends on what the guest is doing, from my autotest test, it very
easily to see that, the huge improvement is on bench-migration not
pure-migration.

> 
>> The rules for code under mmu_lock should be:
>>
>> 1) Spte updates under mmu lock must always be atomic and 
>> with locked instructions.
>> 2) Spte values must be read once, and appropriate action
>> must be taken when writing them back in case their value 
>> has changed (remote TLB flush might be required).
> 
> Although I am not certain about what will be really needed in the
> final form, if this kind of maybe-needed-overhead is going to be
> added little by little, I worry about possible regression.


Well, will you suggest Linus to reject all patches and stop
all discussion for the "possible regression" reason?

