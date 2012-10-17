Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab2JQHFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 03:05:10 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:35350 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab2JQHFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 03:05:09 -0400
Message-ID: <507E5891.9060009@linux.vnet.ibm.com>
Date: Wed, 17 Oct 2012 15:04:49 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Avi Kivity <avi@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [3.5.0 BUG] vmx_handle_exit: unexpected, valid vectoring info
 (0x80000b0e)
References: <20120912044037.GA23094@localhost> <505044AC.80205@redhat.com> <5052C732.7060508@linux.vnet.ibm.com> <507E4F8E.7000103@linux.vnet.ibm.com> <20121017064319.GA17754@localhost>
In-Reply-To: <20121017064319.GA17754@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12101707-9574-0000-0000-000004E5CF08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 02:43 PM, Fengguang Wu wrote:
> On Wed, Oct 17, 2012 at 02:26:22PM +0800, Xiao Guangrong wrote:
>> On 09/14/2012 01:57 PM, Xiao Guangrong wrote:
>>> On 09/12/2012 04:15 PM, Avi Kivity wrote:
>>>> On 09/12/2012 07:40 AM, Fengguang Wu wrote:
>>>>> Hi,
>>>>>
>>>>> 3 of my test boxes running v3.5 kernel become unaccessible and I find
>>>>> two of them kept emitting this dmesg:
>>>>>
>>>>> vmx_handle_exit: unexpected, valid vectoring info (0x80000b0e) and exit reason is 0x31
>>>>>
>>>>> The other one has froze and the above lines are the last dmesg.
>>>>> Any ideas?
>>>>
>>>> First, that printk should be rate-limited.
>>>>
>>>> Second, we should add EXIT_REASON_EPT_MISCONFIG (0x31) to 
>>>>
>>>> 	if ((vectoring_info & VECTORING_INFO_VALID_MASK) &&
>>>> 			(exit_reason != EXIT_REASON_EXCEPTION_NMI &&
>>>> 			exit_reason != EXIT_REASON_EPT_VIOLATION &&
>>>> 			exit_reason != EXIT_REASON_TASK_SWITCH))
>>>> 		printk(KERN_WARNING "%s: unexpected, valid vectoring info "
>>>> 		       "(0x%x) and exit reason is 0x%x\n",
>>>> 		       __func__, vectoring_info, exit_reason);
>>>>
>>>> since it's easily caused by the guest.
>>>
>>> Yes, i will do these.
>>>
>>>>
>>>> Third, it's really unexpected.  It seems the guest was attempting to deliver a page fault exception (0x0e) but encountered an mmio page during delivery (in the IDT, TSS, stack, or page tables).  Is this reproducible?  If so it's easy to patch kvm to halt in that case and allow examining the guest via qemu.
>>>>
>>>
>>> Have no idea yet why the box was frozen under this case, will try to write a test case,
>>> hope it can help me to find the reason out.
>>>
>>
>> Still did not know why linux kernel triggered it. I have posted
>> a patchset to report an internal error for this case, hoping
>> Fengguang can reproduce it after the patchset and Qemu's dump
>> can help us to find the reason out.
>>
>> I will keep working on it.
> 
> Thanks! Shall I run some patched kernel, or just 3.6.0?

The patchset is under review. Can be found at:
https://lkml.org/lkml/2012/10/17/31

> 
> Another problem I sometimes run into is, dmesg no longer works in the
> test boxes that run lots of KVMs. It aborts with an error message:
> 
> dmesg: klogctl failed: Bad address

Interesting, will fight for it. :)


