Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab0CQItE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:49:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:31589 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab0CQIs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:48:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:openpgp:content-type
         :content-transfer-encoding;
        b=YjYcwsxEvXpxZFXJCWWTEkSyC8WyXHFytPGISQmjC+owSqT8LyZdp/+R9xayQ2EaQ3
         t5VyokwMyQzYuyWD16cykA7BG+gIkic0UscEaJETpSZ4072zhkS4AgPkIjeZqFTdoxvN
         HPTVbXmsaqb4MhNHO05/q1yvEmf3MXXPbL/oE=
Message-ID: <4BA09776.4020205@gmail.com>
Date: Wed, 17 Mar 2010 10:48:54 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: x86: fix callgraphs of 32-bit processes on 64-bit
 kernels V2.
References: <20100316144906.GA5621@nowhere> <1268751734-9167-1-git-send-email-edwintorok@gmail.com> <20100316170549.GC17537@elte.hu>
In-Reply-To: <20100316170549.GC17537@elte.hu>
X-Enigmail-Version: 0.95.0
OpenPGP: id=5379965D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 07:05 PM, Ingo Molnar wrote:
> * T??r??k Edwin <edwintorok@gmail.com> wrote:
> 
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
>> Signed-off-by: T??r??k Edwin <edwintorok@gmail.com>
>> ---
>>  arch/x86/kernel/cpu/perf_event.c |   33 +++++++++++++++++++++++++++++++++
>>  1 files changed, 33 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
>> index 8c1c070..b85ea9f 100644
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
> 
> Please put such new data type definitions not into the middle of a .c file but 
> next to where struct stack_frame is defined.

Ok.

> 
>> +
>> +static int copy_stack_frame_ia32(u32 fp, struct stack_frame_ia32 *frame)
>> +{
>> +	unsigned long bytes;
>> +
>> +	bytes = copy_from_user_nmi(frame, (const void __user*)(unsigned long)fp, sizeof(*frame));
>> +
>> +	return bytes == sizeof(*frame);
>> +}
>>
> 
> Single-use - should be inline i guess.
> 

So should be copy_stack_frame() then.

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
> 
> Please put newlines after local variable definition so that they are clearly 
> delimited.
> 
> Also, the tabulation is weird - please run it through scripts/checkpatch.pl.

I forgot to change shiftwidth to 8 (I usually use 4).
I cleaned the checkpatch warnings now.

> 
>> +		frame.next_frame     = 0;
>> +		frame.return_address = 0;
>> +
>> +		if (!copy_stack_frame_ia32(fp, &frame))
>> +			break;
>> +
>> +		if (fp < (u32)regs->sp)
>> +			break;
>> +
>> +		callchain_store(entry, frame.return_address);
>> +		fp = frame.next_frame;
>> +	    }
>> +	    return;
> 
> This whole new block should probably be in a helper inline?

To reduce indenting, or why?

> 
> Also, it should probably be #ifdef CONFIG_COMPAT or so.

Ok, see V3 of my patch.

Best regards,
--Edwin
