Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab2LLUGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 15:06:05 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:60113 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab2LLUGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 15:06:02 -0500
Message-ID: <50C8E3A3.4050106@linux.vnet.ibm.com>
Date: Thu, 13 Dec 2012 04:05:55 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] KVM: x86: improve reexecute_instruction
References: <50C5A747.1020105@linux.vnet.ibm.com> <20121211233641.GA14520@amt.cnet>
In-Reply-To: <20121211233641.GA14520@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121220-1618-0000-0000-00000303DC81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 07:36 AM, Marcelo Tosatti wrote:
> On Mon, Dec 10, 2012 at 05:11:35PM +0800, Xiao Guangrong wrote:
>> Changelog:
>> There are some changes from Marcelo and Gleb's review, thank you all!
>> - access indirect_shadow_pages in the protection of mmu-lock
>> - fix the issue when unhandleable instruction access on large page
>> - add a new test case for large page
>>
>> The current reexecute_instruction can not well detect the failed instruction
>> emulation. It allows guest to retry all the instructions except it accesses
>> on error pfn.
>>
>> For example, these cases can not be detected:
>> - for tdp used
>>   currently, it refused to retry all instructions. If nested npt is used, the
>>   emulation may be caused by shadow page, it can be fixed by unshadow the
>>   shadow page.
>>
>> - for shadow mmu
>>   some cases are nested-write-protect, for example, if the page we want to
>>   write is used as PDE but it chains to itself. Under this case, we should
>>   stop the emulation and report the case to userspace.
>>
>> There are two test cases based on kvm-unit-test can trigger a infinite loop on
>> current code (ept = 0), after this patchset, it can report the error to Qemu.
>>
>> Subject: [PATCH] access test: test unhandleable instruction
>>
>> Test the instruction which can not be handled by kvm
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> 
> Please submit the test for inclusion. There should be some way to make
> it fail.. 

Yes.

But it is not easy. If the test cases run normally, kvm will report a error to Qemu
then Qemu will exit the vcpu thread after dumping the vcpu state.

We need to do something to let guest can be aware that the error report is triggered.
I guess we can add a option in Qemu, say '-notify-guest' and allow Qemu to inject #GP
to guest with a special ERROR_CODE if error is reported.

> program a timer interrupt and #GP? 

Could you please explain the detail?

