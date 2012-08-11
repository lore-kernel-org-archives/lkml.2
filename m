Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab2HKDg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 23:36:56 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54488 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2HKDg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 23:36:26 -0400
Message-ID: <5025D334.9070503@linux.vnet.ibm.com>
Date: Sat, 11 Aug 2012 11:36:20 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 00/12] KVM: introduce readonly memslot
References: <5020E423.9080004@linux.vnet.ibm.com> <20120810181422.GA14892@amt.cnet>
In-Reply-To: <20120810181422.GA14892@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12081103-4790-0000-0000-000004163E2B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2012 02:14 AM, Marcelo Tosatti wrote:
> On Tue, Aug 07, 2012 at 05:47:15PM +0800, Xiao Guangrong wrote:
>> Changelog:
>> - introduce KVM_PFN_ERR_RO_FAULT instead of dummy page
>> - introduce KVM_HVA_ERR_BAD and optimize error hva indicators
>>
>> The test case can be found at:
>> http://lkml.indiana.edu/hypermail/linux/kernel/1207.2/00819/migrate-perf.tar.bz2
>>
>> In current code, if we map a readonly memory space from host to guest
>> and the page is not currently mapped in the host, we will get a fault-pfn
>> and async is not allowed, then the vm will crash.
>>
>> As Avi's suggestion, We introduce readonly memory region to map ROM/ROMD
>> to the guest, read access is happy for readonly memslot, write access on
>> readonly memslot will cause KVM_EXIT_MMIO exit.
> 
> Memory slots whose QEMU mapping is write protected is supported
> today, as long as there are no write faults.
> 
> What prevents the use of mmap(!MAP_WRITE) to handle read-only memslots
> again?
> 

It is happy to map !write host memory space to the readonly memslot,
and they can coexist as well.

readonly memslot checks the write-permission by seeing slot->flags and
!write memory checks the write-permission in hva_to_pfn() function
which checks vma->flags. It is no conflict.

> The initial objective was to fix a vm crash, can you explain that
> initial problem?
>

The issue was trigged by this code:

                } else {
                        if (async && (vma->vm_flags & VM_WRITE))
                                *async = true;
                        pfn = KVM_PFN_ERR_FAULT;
                }

If the host memory region is readonly (!vma->vm_flags & VM_WRITE) and
its physical page is swapped out (or the file data does not be read in),
get_user_page_nowait will fail, above code reject to set async,
then we will get a fault pfn and async=false.

I guess this issue also exists in "QEMU write protected mapping" as
you mentioned above.

