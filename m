Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab2IZIQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:16:13 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47574 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab2IZIPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:15:22 -0400
MIME-Version: 1.0
In-Reply-To: <5062C748020000780009DE21@nat28.tlf.novell.com>
References: <1348640118-26717-1-git-send-email-glorioustao@gmail.com>
	<5062C748020000780009DE21@nat28.tlf.novell.com>
Date: Wed, 26 Sep 2012 16:15:20 +0800
Message-ID: <CAAV8rnLsnHAF3Dj8nWDtHEvmoz8arBQGw9FjQTAnAKXCjHCwhQ@mail.gmail.com>
Subject: Re: [PATCH] x86_64: Work around old gas bug
From: Tao Guo <glorioustao@gmail.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ingo Molnar <mingo@elte.hu>, stable@kernel.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/12, Jan Beulich <JBeulich@suse.com> wrote:
>>>> On 26.09.12 at 08:15, Tao Guo <glorioustao@gmail.com> wrote:
>> gas in binutils(2.16.91) could not parse parentheses within macro
>> parameters,
>
> This description of yours contradicts the last hunk of the patch -
> iirc the requirement for macro parameters in those old gas
> versions is to be fully parenthesized if there's any blank inside
> (which could possibly not even be present in source code, but
> get inserted by the C preprocessor).
Yes, the description is a little misleading and I have corrected in
the new patch.
>
>> and this is a workaround to make old gas work without
>> generating below errors:
>> arch/x86/kernel/entry_64.S: Assembler messages:
>> arch/x86/kernel/entry_64.S:387: Error: too many positional arguments
>> arch/x86/kernel/entry_64.S:389: Error: too many positional arguments
>> arch/x86/kernel/entry_64.S:390: Error: too many positional arguments
>> arch/x86/kernel/entry_64.S:391: Error: too many positional arguments
>> arch/x86/kernel/entry_64.S:392: Error: too many positional arguments
>> arch/x86/kernel/entry_64.S:393: Error: too many positional arguments
>> arch/x86/kernel/entry_64.S:394: Error: too many positional arguments
>>
>> Signed-off-by: Tao Guo <glorioustao@gmail.com>
>> ---
>>  arch/x86/include/asm/calling.h |   52
>> +++++++++++++++++++--------------------
>>  arch/x86/kernel/entry_64.S     |   18 +++++++-------
>>  2 files changed, 34 insertions(+), 36 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/calling.h
>> b/arch/x86/include/asm/calling.h
>> index a9e3a74..7627e26 100644
>> --- a/arch/x86/include/asm/calling.h
>> +++ b/arch/x86/include/asm/calling.h
>> @@ -49,38 +49,36 @@ For 32-bit we have the following conventions - kernel
>> is
>> built with
>>  #include "dwarf2.h"
>>
>>  /*
>> - * 64-bit system call stack frame layout defines and helpers, for
>> - * assembly code (note that the seemingly unnecessary parentheses
>> - * are to prevent cpp from inserting spaces in expressions that get
>> - * passed to macros):
>> + * 64-bit system call stack frame layout defines and helpers,
>> + * for assembly code:
>>   */
>>
>> -#define R15		  (0)
>> -#define R14		  (8)
>> -#define R13		 (16)
>> -#define R12		 (24)
>> -#define RBP		 (32)
>> -#define RBX		 (40)
>> +#define R15		  0
>> +#define R14		  8
>> +#define R13		 16
>> +#define R12		 24
>> +#define RBP		 32
>> +#define RBX		 40
>>
>>  /* arguments: interrupts/non tracing syscalls only save up to here: */
>> -#define R11		 (48)
>> -#define R10		 (56)
>> -#define R9		 (64)
>> -#define R8		 (72)
>> -#define RAX		 (80)
>> -#define RCX		 (88)
>> -#define RDX		 (96)
>> -#define RSI		(104)
>> -#define RDI		(112)
>> -#define ORIG_RAX	(120)       /* + error_code */
>> +#define R11		 48
>> +#define R10		 56
>> +#define R9		 64
>> +#define R8		 72
>> +#define RAX		 80
>> +#define RCX		 88
>> +#define RDX		 96
>> +#define RSI		104
>> +#define RDI		112
>> +#define ORIG_RAX	120       /* + error_code */
>>  /* end of arguments */
>>
>>  /* cpu exception frame or undefined in case of fast syscall: */
>> -#define RIP		(128)
>> -#define CS		(136)
>> -#define EFLAGS		(144)
>> -#define RSP		(152)
>> -#define SS		(160)
>> +#define RIP		128
>> +#define CS		136
>> +#define EFLAGS		144
>> +#define RSP		152
>> +#define SS		160
>>
>>  #define ARGOFFSET	R11
>>  #define SWFRAME		ORIG_RAX
>
> While up the here the changes are certainly acceptable, ...
>
>> @@ -107,7 +105,7 @@ For 32-bit we have the following conventions - kernel
>> is
>> built with
>>
>>  	.endm
>>
>> -#define ARG_SKIP	(9*8)
>> +#define ARG_SKIP	9*8
>>
>>  	.macro RESTORE_ARGS rstor_rax=1, addskip=0, rstor_rcx=1, rstor_r11=1, \
>>  			    rstor_r8910=1, rstor_rdx=1
>> @@ -157,7 +155,7 @@ For 32-bit we have the following conventions - kernel
>> is
>> built with
>>  	.endif
>>  	.endm
>>
>> -#define REST_SKIP	(6*8)
>> +#define REST_SKIP	6*8
>>
>>  	.macro SAVE_REST
>>  	subq $REST_SKIP, %rsp
>
> ... these two ones aren't - you can't simply remove parentheses
> from expressions without causing (potentially future) problems,
> up to and including someone re-introducing the parentheses to
> address such problems. You ought to parenthesize the macro
> parameters where needed instead, as you did below.
Thanks for the suggestion and I will correct it in the new patch.
>
> But that's all leaving aside that in the past it was already
> suggested (by hpa iirc) to simply declare these 2.16-based
> assemblers non-suitable for building the kernel.
Yes, that's another way to solve such compiling problems; People can
at least get some instructions to solve their problems.

Thanks,
-Tao
>
> Jan
>
>> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
>> index 69babd8..784a5b6 100644
>> --- a/arch/x86/kernel/entry_64.S
>> +++ b/arch/x86/kernel/entry_64.S
>> @@ -342,15 +342,15 @@ ENDPROC(native_usergs_sysret64)
>>  	.macro SAVE_ARGS_IRQ
>>  	cld
>>  	/* start from rbp in pt_regs and jump over */
>> -	movq_cfi rdi, RDI-RBP
>> -	movq_cfi rsi, RSI-RBP
>> -	movq_cfi rdx, RDX-RBP
>> -	movq_cfi rcx, RCX-RBP
>> -	movq_cfi rax, RAX-RBP
>> -	movq_cfi  r8,  R8-RBP
>> -	movq_cfi  r9,  R9-RBP
>> -	movq_cfi r10, R10-RBP
>> -	movq_cfi r11, R11-RBP
>> +	movq_cfi rdi, (RDI-RBP)
>> +	movq_cfi rsi, (RSI-RBP)
>> +	movq_cfi rdx, (RDX-RBP)
>> +	movq_cfi rcx, (RCX-RBP)
>> +	movq_cfi rax, (RAX-RBP)
>> +	movq_cfi  r8,  (R8-RBP)
>> +	movq_cfi  r9,  (R9-RBP)
>> +	movq_cfi r10, (R10-RBP)
>> +	movq_cfi r11, (R11-RBP)
>>
>>  	/* Save rbp so that we can unwind from get_irq_regs() */
>>  	movq_cfi rbp, 0
>> --
>> 1.7.7
>
>
>
