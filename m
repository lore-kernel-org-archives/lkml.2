Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966491Ab0CPPEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 11:04:40 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:47206 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966326Ab0CPPEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:04:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:openpgp:content-type
         :content-transfer-encoding;
        b=uP74wyh4m3hpnGo3vGdi7Mo3MPm799Cgc4kTPJwajP5iBj+qpU9zRdxslzemMYzv+1
         jrV62s+jxPmqmJf3cHITep34MQR1lR7neF6JJ8f30rToiEHjOsmZ3pau688ENY9z+L5l
         jRg8PGZiYcrwE/HW9rCkPkr3KWUOyposSDAjg=
Message-ID: <4B9F9E02.6030007@gmail.com>
Date: Tue, 16 Mar 2010 17:04:34 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: x86: fix callgraphs of 32-bit processes on 64-bit
 kernels.
References: <1268667260-5505-1-git-send-email-edwintorok@gmail.com> <1268667260-5505-2-git-send-email-edwintorok@gmail.com> <20100316144906.GA5621@nowhere>
In-Reply-To: <20100316144906.GA5621@nowhere>
X-Enigmail-Version: 0.95.0
OpenPGP: id=5379965D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 04:49 PM, Frederic Weisbecker wrote:
> On Mon, Mar 15, 2010 at 05:34:20PM +0200, Török Edwin wrote:
>> When profiling a 32-bit process on a 64-bit kernel, callgraph tracing
>> stopped after the first function, because it has seen a garbage memory address
>> (tried to interpret the frame pointer, and return address as a 64-bit pointer).
>>
>> Fix this by using a struct stack_frame with 32-bit pointers when the TIF_IA32 flag is set.
>>
>> Note that TIF_IA32 flag must be used, and not is_compat_task(), because the
>> latter is only set when the 32-bit process is executing a syscall,
>> which may not always be the case (when tracing page fault events for example).
>>
>> Signed-off-by: Török Edwin <edwintorok@gmail.com>
>> ---
>>  arch/x86/kernel/cpu/perf_event.c |   33 +++++++++++++++++++++++++++++++++
>>  1 files changed, 33 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
>> index 8c1c070..13ee83a 100644
>> --- a/arch/x86/kernel/cpu/perf_event.c
>> +++ b/arch/x86/kernel/cpu/perf_event.c
>> @@ -2401,6 +2401,20 @@ static int copy_stack_frame(const void __user *fp, struct stack_frame *frame)
>>  	return bytes == sizeof(*frame);
>>  }
>>  
>> +struct stack_frame_ia32 {
>> +    u32 next_frame;
>> +    u32 return_address;
>> +};
>> +
>> +static int copy_stack_frame_ia32(u32 fp, struct stack_frame_ia32 *frame)
>> +{
>> +	unsigned long bytes;
>> +
>> +	bytes = copy_from_user_nmi(frame, (const void __user*)(unsigned long)fp, sizeof(*frame));
>> +
>> +	return bytes == sizeof(*frame);
>> +}
>> +
>>  static void
>>  perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
>>  {
>> @@ -2414,6 +2428,25 @@ perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
>>  
>>  	callchain_store(entry, PERF_CONTEXT_USER);
>>  	callchain_store(entry, regs->ip);
>> +	if (test_thread_flag(TIF_IA32)) {
>> +	    /* 32-bit process in 64-bit kernel. */
>> +	    u32 fp = regs->bp;
>> +	    struct stack_frame_ia32 frame;
>> +	    while (entry->nr < PERF_MAX_STACK_DEPTH) {
>> +		frame.next_frame     = 0;
>> +		frame.return_address = 0;
>> +
>> +		if (!copy_stack_frame_ia32(fp, &frame))
>> +			break;
>> +
>> +		if ((unsigned long)fp < regs->sp)
>> +			break;
> 
> 
> 
> Shouldn't it be this?
> 
> 	if (fp < (u32)regs->sp)
> 
> As the high part of fp is zeroed in the cast but
> the high part of regs->sp remains. I don't know what could be
> there, but since the user doesn't use it, perhaps just garbage?
> And that could messup the comparison.

Agreed. I sent a new patch with that change.

> 
> Otherwise the rest looks pretty good to me, nice catch.
> 

Thanks.

Best regards,
--Edwin
