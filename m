Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab2ASOr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:47:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36499 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab2ASOrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:47:25 -0500
Message-ID: <4F182CDE.2080603@zytor.com>
Date: Thu, 19 Jan 2012 06:46:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 2/2] jump labels/x86: Use etiher 5 byte or 2 byte jumps
References: <20120118195340.767928915@goodmis.org> <20120118195926.797694014@goodmis.org> <20120119144141.GA547@Krystal>
In-Reply-To: <20120119144141.GA547@Krystal>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 06:41 AM, Mathieu Desnoyers wrote:
>> diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
>> index a32b18c..872b3e1 100644
>> --- a/arch/x86/include/asm/jump_label.h
>> +++ b/arch/x86/include/asm/jump_label.h
>> @@ -14,7 +14,7 @@
>>  static __always_inline bool arch_static_branch(struct jump_label_key *key)
>>  {
>>  	asm goto("1:"
>> -		JUMP_LABEL_INITIAL_NOP
>> +		"jmp %l[l_yes]\n"
> 
> Is it possible that the compiler choose a jump that is not 2 or 5-byte ?
> e.g. a jmp rel16 (e9 opcode) on 32-bit x86, or any of the other
> instruction listed under the JMP-Jump instruction in the Intel insn
> manual ?
> 

No.

>>  				   void *(*poker)(void *, const void *, size_t))
>>  {
>>  	union jump_code_union code;
>> +	unsigned char nop;
>> +	unsigned char op;
>> +	unsigned size;
>> +	void *ip = (void *)entry->code;
>> +	void *ideal = (void *)ideal_nops[NOP_ATOMIC5];
> 
> "void *" should possibly be "unsigned char *" here to respect the nop
> place-holder typing.
> 

const unsigned char * please.

>> +
>> +	/* Use probe_kernel_read()? */
>> +	op = *(unsigned char *)ip;
>> +	nop = ideal_nops[NOP_ATOMIC5][0];
>>  
>>  	if (type == JUMP_LABEL_ENABLE) {
>> -		code.jump = 0xe9;
>> -		code.offset = entry->target -
>> -				(entry->code + JUMP_LABEL_NOP_SIZE);
>> -	} else
>> -		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
>> +		if (op == 0xe9 || op == 0xeb)
>> +			/* Already enabled. Warn? */
> 
> This could be caused by failure to run the link-time script, or running
> the transform twice. A warning would indeed be welcome, as this should
> never happen.
> 

Warning?  No.  ERROR.  Something very bad could be happening here.  We
have covered this before.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

