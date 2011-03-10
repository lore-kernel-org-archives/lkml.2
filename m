Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab1CJTbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:31:13 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:24338 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab1CJTbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:31:09 -0500
Message-ID: <4D7926C9.9070206@parallels.com>
Date: Thu, 10 Mar 2011 22:30:17 +0300
From: Andrew Vagin <avagin@parallels.com>
Reply-To: avagin@parallels.com
Organization: parallels
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrey Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: + x86-mm-handle-mm_fault_error-in-kernel-space.patch added to
 -mm tree
References: <20110310142812.GA25224@redhat.com>
In-Reply-To: <20110310142812.GA25224@redhat.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2011 05:28 PM, Oleg Nesterov wrote:
> (add cc's)
>
>> Subject: x86/mm: handle mm_fault_error() in kernel space
>> From: Andrey Vagin<avagin@openvz.org>
>>
>> mm_fault_error() should not execute oom-killer, if page fault occurs in
>> kernel space.  E.g.  in copy_from_user/copy_to_user.
> Why? I don't understand this part.
I thought for a bit more...

I think we should not execute out_of_memory() in this case at all, 
because when we return from page fault, we execute the same command and 
provoke the "same" page fault again. Now pls think what is the 
difference between these page faults? It has been generated from one 
place and the program do nothing between those. I think we try to handle 
one error two times and it isn't good. If handle_mm_fault() returns 
VM_FAULT_OOM and pagefault occurred from userspace, the current task 
should be killed by SIGKILL, then we should return from page fault back 
to userspace for the task to handle the signal. If handle_mm_fault() 
returns VM_FAULT_OOM and pagefault occurred in kernel space, we should 
execute no_context() to return from syscall.

Also note that out_of_memory is usually called from handle_mm_fault() -> 
... -> alloc_page()->...->out_of_memory().

>> This would happen if we find ourselves in OOM on a copy_to_user(), or a
>> copy_from_user() which faults.
>>
>> Without this patch, the kernels hangs up in copy_from_user, because OOM
>> killer sends SIG_KILL to current process,
> This depends. OOM can choose another victim, and if it does we shouldn't
> return -EFAULT.
>
>> but it can't handle a signal
>> while in syscall, then the kernel returns to copy_from_user, reexcute
>> current command and provokes page_fault again.
> Yes. This is buggy.
>
>> --- a/arch/x86/mm/fault.c~x86-mm-handle-mm_fault_error-in-kernel-space
>> +++ a/arch/x86/mm/fault.c
>> @@ -827,6 +827,13 @@ mm_fault_error(struct pt_regs *regs, uns
>>   	       unsigned long address, unsigned int fault)
>>   {
>>   	if (fault&  VM_FAULT_OOM) {
>> +		/* Kernel mode? Handle exceptions or die: */
>> +		if (!(error_code&  PF_USER)) {
>> +			up_read(&current->mm->mmap_sem);
>> +			no_context(regs, error_code, address);
>> +			return;
>> +		}
>> +
> At first glance, this is not optimal...
>
> Perhaps I missed something, but afaics it is better to call
> out_of_memory() first, then check if current was killed. In this case
> no_context() is fine, we are not going to return to the user-mode.
It's not first oom, so I perfere don't ca
> IOW, what do you think about the (untested/uncompiled) patch below?
>
> Oleg.
>
> --- x/arch/x86/mm/fault.c
> +++ x/arch/x86/mm/fault.c
> @@ -829,6 +829,11 @@ mm_fault_error(struct pt_regs *regs, uns
>   {
>   	if (fault&  VM_FAULT_OOM) {
>   		out_of_memory(regs, error_code, address);
> +
> +		if (!(error_code&  PF_USER)&&  fatal_signal_pending(current)) {
> +			no_context(regs, error_code, address);
> +			return;
> +		}
>   	} else {
>   		if (fault&  (VM_FAULT_SIGBUS|VM_FAULT_HWPOISON|
>   			     VM_FAULT_HWPOISON_LARGE))
>
>

