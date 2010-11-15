Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab0KOP6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 10:58:49 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:61992 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231Ab0KOP6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 10:58:47 -0500
Message-ID: <4CE158B6.4070900@dcl.info.waseda.ac.jp>
Date: Tue, 16 Nov 2010 00:58:46 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100724 Lanikai/3.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Ma Ling <ling.ma@intel.com>, Zhao Yakui <yakui.zhao@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] perf bench: add --prefault option for causing page faults
 before benchmark
References: <1288976785-15857-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20101110092945.GD12238@elte.hu>
In-Reply-To: <20101110092945.GD12238@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010年11月10日 18:29, Ingo Molnar wrote:
>
> * Hitoshi Mitake<mitake@dcl.info.waseda.ac.jp>  wrote:
>
>> This patch adds --prefault option to perf bench mem memcpy.
>> If user specify this option to perf bench mem memcpy, overhead of
>> page faults will be removed from the score of memcpy().
>>
>> Example of usage:
>> | % ./perf bench mem memcpy -l 500MB
>> | # Running mem/memcpy benchmark...
>> | # Copying 500MB Bytes from 0x7fc036749010 to 0x7fc055b4a010 ...
>> |
>> |      628.526821 MB/Sec
>> | mitake@X201i:~/linux/.../tools/perf% ./perf bench mem memcpy -l 500MB --prefault
>> | # Running mem/memcpy benchmark...
>> | # Copying 500MB Bytes from 0x7ff1b45e2010 to 0x7ff1d39e3010 ...
>> |
>> |        4.849256 GB/Sec
>
> Ok, looks rather useful.
>
> We are rather close to being able to apply these bits. We need a resolution for the
> arch/x86/lib/memcpy_64.S details. The ugliest are these kinds of #ifdefs:
>
> +#ifndef PERF_BENCH
>   .Lmemcpy_e:
>          .previous
> +#endif
>
> What happens if we keep that label in place?

This is the part of objdump -D arch/x86/lib/memcpy_64.o,

Disassembly of section .altinstr_replacement:

0000000000000000 <.altinstr_replacement>:
    0:   48 89 f8                mov    %rdi,%rax
    3:   89 d1                   mov    %edx,%ecx
    5:   c1 e9 03                shr    $0x3,%ecx
    8:   83 e2 07                and    $0x7,%edx
    b:   f3 48 a5                rep movsq %ds:(%rsi),%es:(%rdi)
    e:   89 d1                   mov    %edx,%ecx
   10:   f3 a4                   rep movsb %ds:(%rsi),%es:(%rdi)
   12:   c3                      retq

I didn't know that we can use the symbol name which start with '.',
and it seems that such a symbol is eliminated from object file.

We can know the start address of .Lmemcpy_c, the rep version of memcpy()
because the start address is stored in another section,
.altinstructions like this.

These information can be exploited for our purose, I'll try it.

>
> This:
>
> +#ifndef PERF_BENCH
>   ENTRY(__memcpy)
>   ENTRY(memcpy)
>          CFI_STARTPROC
> +#else
> +	.globl  memcpy_x86_64_unrolled
> +memcpy_x86_64_unrolled:
> +#endif
>
> Could be removed if you defined an ENTRY() macro in perf, right?
>
> This:
>
> +#ifndef PERF_BENCH
> +
>          CFI_ENDPROC
>   ENDPROC(memcpy)
>   ENDPROC(__memcpy)
>
> Could be solved by defining ENDPROC()/etc. macros in perf, right?
>
> We could remove this #ifdef:
>
> +#ifndef PERF_BENCH
> +
>   #include<linux/linkage.h>
>
>   #include<asm/cpufeature.h>
>   #include<asm/dwarf2.h>
>
> +#endif /* PERF_BENCH */
>
> if you added empty linkage.h, cpufeature.h and dwarf2.h files as
> tools/perf/util/include/linux/linkage.h, tools/perf/util/include/asm/cpufeature.h.
>
> That linkage.h file could even contain a short perf version of the ENTRY() macro,
> etc.
>
> That way we can avoid having to touch arch/x86/lib/memcpy_64.S altogether.

Thanks for your advice. adding empty headers and macros
will be the smart way to include memcpy_64.S without modification.

Thanks,


