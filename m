Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab2INF5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:57:21 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:34138 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab2INF5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:57:15 -0400
Message-ID: <5052C732.7060508@linux.vnet.ibm.com>
Date: Fri, 14 Sep 2012 13:57:06 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Fengguang Wu <fengguang.wu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [3.5.0 BUG] vmx_handle_exit: unexpected, valid vectoring info
 (0x80000b0e)
References: <20120912044037.GA23094@localhost> <505044AC.80205@redhat.com>
In-Reply-To: <505044AC.80205@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091405-9264-0000-0000-000002548A0A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 04:15 PM, Avi Kivity wrote:
> On 09/12/2012 07:40 AM, Fengguang Wu wrote:
>> Hi,
>>
>> 3 of my test boxes running v3.5 kernel become unaccessible and I find
>> two of them kept emitting this dmesg:
>>
>> vmx_handle_exit: unexpected, valid vectoring info (0x80000b0e) and exit reason is 0x31
>>
>> The other one has froze and the above lines are the last dmesg.
>> Any ideas?
> 
> First, that printk should be rate-limited.
> 
> Second, we should add EXIT_REASON_EPT_MISCONFIG (0x31) to 
> 
> 	if ((vectoring_info & VECTORING_INFO_VALID_MASK) &&
> 			(exit_reason != EXIT_REASON_EXCEPTION_NMI &&
> 			exit_reason != EXIT_REASON_EPT_VIOLATION &&
> 			exit_reason != EXIT_REASON_TASK_SWITCH))
> 		printk(KERN_WARNING "%s: unexpected, valid vectoring info "
> 		       "(0x%x) and exit reason is 0x%x\n",
> 		       __func__, vectoring_info, exit_reason);
> 
> since it's easily caused by the guest.

Yes, i will do these.

> 
> Third, it's really unexpected.  It seems the guest was attempting to deliver a page fault exception (0x0e) but encountered an mmio page during delivery (in the IDT, TSS, stack, or page tables).  Is this reproducible?  If so it's easy to patch kvm to halt in that case and allow examining the guest via qemu.
> 

Have no idea yet why the box was frozen under this case, will try to write a test case,
hope it can help me to find the reason out.

> Maybe we should do so regardless (return a KVM_EXIT_INTERNAL_ERROR).

I think this is reasonable.

Thanks!


