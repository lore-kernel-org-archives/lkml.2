Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab2HXBgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 21:36:17 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:39626 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab2HXBgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 21:36:12 -0400
Message-ID: <5036DA80.5010405@linux.vnet.ibm.com>
Date: Fri, 24 Aug 2012 09:36:00 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: f@amt.cnet, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: trace the events of mmu_notifier
References: <50335A27.2070306@linux.vnet.ibm.com> <20120823092405.GB32710@amt.cnet> <50362257.6060006@linux.vnet.ibm.com> <20120823130814.GA11915@amt.cnet>
In-Reply-To: <20120823130814.GA11915@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12082401-3568-0000-0000-0000025B5EA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 09:08 PM, Marcelo Tosatti wrote:
> On Thu, Aug 23, 2012 at 08:30:15PM +0800, Xiao Guangrong wrote:
>> On 08/23/2012 05:24 PM, Marcelo Tosatti wrote:
>>> On Tue, Aug 21, 2012 at 05:51:35PM +0800, Xiao Guangrong wrote:
>>>> mmu_notifier is the interface to broadcast the mm events to KVM, the
>>>> tracepoints introduced in this patch can trace all these events, it is
>>>> very helpful for us to notice and fix the bug caused by mm
>>>>
>>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>>> ---
>>>>  include/trace/events/kvm.h |  121 ++++++++++++++++++++++++++++++++++++++++++++
>>>>  virt/kvm/kvm_main.c        |   19 +++++++
>>>>  2 files changed, 140 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
>>>> index 7ef9e75..a855ff9 100644
>>>> --- a/include/trace/events/kvm.h
>>>> +++ b/include/trace/events/kvm.h
>>>> @@ -309,6 +309,127 @@ TRACE_EVENT(
>>>>
>>>>  #endif
>>>>
>>>> +#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
>>>> +DECLARE_EVENT_CLASS(mmu_notifier_address_class,
>>>> +
>>>> +	TP_PROTO(struct kvm *kvm, unsigned long address),
>>>> +
>>>> +	TP_ARGS(kvm, address),
>>>> +
>>>> +	TP_STRUCT__entry(
>>>> +		__field(struct kvm *, kvm)
>>>> +		__field(unsigned long, address)
>>>> +	),
>>>> +
>>>> +	TP_fast_assign(
>>>> +		__entry->kvm = kvm;
>>>> +		__entry->address = address;
>>>> +	),
>>>> +
>>>> +	TP_printk("kvm %p address %lx", __entry->kvm, __entry->address)
>>>
>>>
>>> Perhaps the pointer was useful for debugging, but otherwise, i don't
>>> think it should be printed.
>>
>> But this is the only information to identify the guest if may guest
>> are running.
> 
> Can't you get to task_struct, then pid?

Qemu-kvm have many threads, that means, we hardly know which pids belong
to the same kvm.

> 
> A kernel pointer to identify a task is really weird (and not consistent 
> with the other tracepoints).

Okay, if you really dislike it, i can use perf record to filter the process
then perf script to show the result, but it is not so readable because some
tracepoints can not fully decoded by perf script.

