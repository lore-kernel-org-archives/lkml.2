Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab2ECMJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:09:37 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:46993 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2ECMJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:09:36 -0400
Message-ID: <4FA27578.1010509@linux.vnet.ibm.com>
Date: Thu, 03 May 2012 20:09:28 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page fault
References: <4F9776D2.7020506@linux.vnet.ibm.com> <4F9777A4.208@linux.vnet.ibm.com> <20120426234535.GA5057@amt.cnet> <4F9A3445.2060305@linux.vnet.ibm.com> <20120427145213.GB28796@amt.cnet> <20120429175004.b54d8c095a60d98c8cdbc942@gmail.com> <4FA0C8A7.9000001@linux.vnet.ibm.com> <20120502211031.GB12604@amt.cnet>
In-Reply-To: <20120502211031.GB12604@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12050302-1618-0000-0000-000001769B5B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 05:10 AM, Marcelo Tosatti wrote:

> On Wed, May 02, 2012 at 01:39:51PM +0800, Xiao Guangrong wrote:
>> On 04/29/2012 04:50 PM, Takuya Yoshikawa wrote:
>>
>>> On Fri, 27 Apr 2012 11:52:13 -0300
>>> Marcelo Tosatti <mtosatti@redhat.com> wrote:
>>>
>>>> Yes but the objective you are aiming for is to read and write sptes
>>>> without mmu_lock. That is, i am not talking about this patch. 
>>>> Please read carefully the two examples i gave (separated by "example)").
>>>
>>> The real objective is not still clear.
>>>
>>> The ~10% improvement reported before was on macro benchmarks during live
>>> migration.  At least, that optimization was the initial objective.
>>>
>>> But at some point, the objective suddenly changed to "lock-less" without
>>> understanding what introduced the original improvement.
>>>
>>> Was the problem really mmu_lock contention?
>>>
>>
>>
>> Takuya, i am so tired to argue the advantage of lockless write-protect
>> and lockless O(1) dirty-log again and again.
> 
> His point is valid: there is a lack of understanding on the details of
> the improvement.
> 


Actually, the improvement of lockless is that it can let vcpu to be parallel
as possible.

>From the test result, lockless gains little improvement for unix-migration,
in this case, the vcpus are almost idle (at least not busy).

The large improvement is from dbench-migration, in this case, all vcpus are
busy accessing memory which is write-protected by dirty-log. If you enable
page-fault/fast-page-fault tracepoints, you can see huge number of page fault
from different vcpu during the migration.

> Did you see the pahole output on struct kvm? Apparently mmu_lock is
> sharing a cacheline with read-intensive memslots pointer. It would be 
> interesting to see what are the effects of cacheline aligning mmu_lock.
> 


Yes, i see that. In my test .config, i have enabled
CONFIG_DEBUG_SPINLOCK/CONFIG_DEBUG_LOCK_ALLOC, mmu-lock is not sharing cacheline
with memslots. That means it is not a problem during my test.
(BTW, pahole can not work on my box, it shows:
......
DW_AT_<0x3c>=0x19
DW_AT_<0x3c>=0x19
DW_AT_<0x3c>=0x19
die__process_function: DW_TAG_INVALID (0x4109) @ <0x12886> not handled!
)

If we reorganize 'struct kvm', i guess it is good for kvm but it can not improve
too much for migration. :)


