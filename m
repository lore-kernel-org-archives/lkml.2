Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab2LNEuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 23:50:20 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:34591 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab2LNEuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 23:50:18 -0500
Message-ID: <50CAB001.2040106@linux.vnet.ibm.com>
Date: Fri, 14 Dec 2012 12:50:09 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] KVM: x86: improve reexecute_instruction
References: <50C5A747.1020105@linux.vnet.ibm.com> <20121211233641.GA14520@amt.cnet> <50C8E3A3.4050106@linux.vnet.ibm.com> <20121213225408.GB11385@amt.cnet>
In-Reply-To: <20121213225408.GB11385@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121404-9264-0000-0000-000002D8BB68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 06:54 AM, Marcelo Tosatti wrote:
> On Thu, Dec 13, 2012 at 04:05:55AM +0800, Xiao Guangrong wrote:
>> On 12/12/2012 07:36 AM, Marcelo Tosatti wrote:
>>> On Mon, Dec 10, 2012 at 05:11:35PM +0800, Xiao Guangrong wrote:
>>>> Changelog:
>>>> There are some changes from Marcelo and Gleb's review, thank you all!
>>>> - access indirect_shadow_pages in the protection of mmu-lock
>>>> - fix the issue when unhandleable instruction access on large page
>>>> - add a new test case for large page
>>>>
>>>> The current reexecute_instruction can not well detect the failed instruction
>>>> emulation. It allows guest to retry all the instructions except it accesses
>>>> on error pfn.
>>>>
>>>> For example, these cases can not be detected:
>>>> - for tdp used
>>>>   currently, it refused to retry all instructions. If nested npt is used, the
>>>>   emulation may be caused by shadow page, it can be fixed by unshadow the
>>>>   shadow page.
>>>>
>>>> - for shadow mmu
>>>>   some cases are nested-write-protect, for example, if the page we want to
>>>>   write is used as PDE but it chains to itself. Under this case, we should
>>>>   stop the emulation and report the case to userspace.
>>>>
>>>> There are two test cases based on kvm-unit-test can trigger a infinite loop on
>>>> current code (ept = 0), after this patchset, it can report the error to Qemu.
>>>>
>>>> Subject: [PATCH] access test: test unhandleable instruction
>>>>
>>>> Test the instruction which can not be handled by kvm
>>>>
>>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>>
>>> Please submit the test for inclusion. There should be some way to make
>>> it fail.. 
>>
>> Yes.
>>
>> But it is not easy. If the test cases run normally, kvm will report a error to Qemu
>> then Qemu will exit the vcpu thread after dumping the vcpu state.
>>
>> We need to do something to let guest can be aware that the error report is triggered.
>> I guess we can add a option in Qemu, say '-notify-guest' and allow Qemu to inject #GP
>> to guest with a special ERROR_CODE if error is reported.
>>
>>> program a timer interrupt and #GP? 
>>
>> Could you please explain the detail?
> 
> Before the instruction which writes continuously to the pagetable, arm
> say lapic timer. #GP on the interrupt handler and test with failure.

Sorry, I am confused about this. After Qemu exits due to KVM_EXIT_INTERNAL_ERROR,
the vm is stopped then interrupt can not be injected to guest. Or i missed something?



