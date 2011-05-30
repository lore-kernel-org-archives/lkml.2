Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1E3Kne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 06:43:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45255 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1E3Knd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 06:43:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=KMaBubktrJxPteUp2PebdTCGqRIiSQk+YoyU5nGOX9l5SMxbs5KDKUoZjtodK21jJU
         6Vj4nk+6CFHj6kEA08GOvPXvvR47UWTrckjKBDJip1cRIbKmmDVpDvS2dwD3tDA1v3Fn
         qgsY6DxWyIjhGEN/UVTTxjiB6fsogV0h/AAaY=
MIME-Version: 1.0
In-Reply-To: <20110530073503.GC6720@liondog.tnic>
References: <cover.1306724657.git.luto@mit.edu> <07445623494a3d9f02581eb06326420f5f443043.1306724657.git.luto@mit.edu>
 <20110530073503.GC6720@liondog.tnic>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 30 May 2011 06:43:13 -0400
X-Google-Sender-Auth: UFabEIj4xiAyYNkgxKsVgO_43ew
Message-ID: <BANLkTi=Y5LdjorVH8_t-4c1vFmog7w01cQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] x86-64: Emulate vsyscalls
To: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@mit.edu>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 3:35 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Sun, May 29, 2011 at 11:48:45PM -0400, Andy Lutomirski wrote:
>> There's a fair amount of code in the vsyscall page, and who knows
>> what will happen if an exploit jumps into the middle of it.  Reduce
>> the risk by replacing most of it with short magic incantations that
>> are useless if entered in the middle.  This change can be disabled
>> by CONFIG_UNSAFE_VSYSCALLS (default y).
>>
>> This causes vsyscalls to be a little more expensive than real
>> syscalls.  Fortunately sensible programs don't use them.
>>
>> Some care is taken to make sure that tools like valgrind and
>> ThreadSpotter still work.
>>
>> This patch is not perfect: the vread_tsc and vread_hpet functions
>> are still at a fixed address.  Fixing that might involve making
>> alternative patching work in the vDSO.
>>
>> Signed-off-by: Andy Lutomirski <luto@mit.edu>
>> ---
>>  arch/x86/Kconfig                  |   17 +++++
>>  arch/x86/kernel/Makefile          |    3 +
>>  arch/x86/kernel/vsyscall_64.c     |  121 +++++++++++++++++++++++++++++++++++--
>>  arch/x86/kernel/vsyscall_emu_64.S |   40 ++++++++++++
>>  4 files changed, 176 insertions(+), 5 deletions(-)
>>  create mode 100644 arch/x86/kernel/vsyscall_emu_64.S
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index cc6c53a..186018b 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -1650,6 +1650,23 @@ config COMPAT_VDSO
>>
>>         If unsure, say Y.
>>
>> +config UNSAFE_VSYSCALLS
>> +     def_bool y
>> +     prompt "Unsafe fast legacy vsyscalls"
>> +     depends on X86_64
>> +     ---help---
>> +       Legacy user code expects to be able to issue three syscalls
>> +       by calling fixed addresses in kernel space.  If you say N,
>> +       then the kernel traps and emulates these calls.  If you say
>> +       Y, then there is actual executable code at a fixed address
>> +       to implement these calls efficiently.
>> +
>> +       On a system with recent enough glibc (probably 2.14 or
>> +       newer) and no static binaries, you can say N without a
>> +       performance penalty to improve security
>> +
>> +       If unsure, say Y.
>> +
>>  config CMDLINE_BOOL
>>       bool "Built-in kernel command line"
>>       ---help---
>> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
>> index a24521b..b901781 100644
>> --- a/arch/x86/kernel/Makefile
>> +++ b/arch/x86/kernel/Makefile
>> @@ -42,6 +42,9 @@ obj-$(CONFIG_X86_32)        += probe_roms_32.o
>>  obj-$(CONFIG_X86_32) += sys_i386_32.o i386_ksyms_32.o
>>  obj-$(CONFIG_X86_64) += sys_x86_64.o x8664_ksyms_64.o
>>  obj-$(CONFIG_X86_64) += syscall_64.o vsyscall_64.o vread_tsc_64.o
>> +ifndef CONFIG_UNSAFE_VSYSCALLS
>> +     obj-$(CONFIG_X86_64)    += vsyscall_emu_64.o
>> +endif
>>  obj-y                        += bootflag.o e820.o
>>  obj-y                        += pci-dma.o quirks.o topology.o kdebugfs.o
>>  obj-y                        += alternative.o i8253.o pci-nommu.o hw_breakpoint.o
>> diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
>> index 71fa506..5b3d62a 100644
>> --- a/arch/x86/kernel/vsyscall_64.c
>> +++ b/arch/x86/kernel/vsyscall_64.c
>> @@ -48,9 +48,6 @@
>>  #include <asm/vgtod.h>
>>  #include <asm/traps.h>
>>
>> -#define __vsyscall(nr) \
>> -             __attribute__ ((unused, __section__(".vsyscall_" #nr))) notrace
>> -
>>  DEFINE_VVAR(int, vgetcpu_mode);
>>  DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
>>  {
>> @@ -96,6 +93,7 @@ static void warn_bad_vsyscall(struct pt_regs *regs, bool is_warning,
>>               return;
>>
>>       tsk = current;
>> +
>>       printk("%s%s[%d] %s ip:%lx sp:%lx ax:%lx si:%lx di:%lx",
>>              is_warning ? KERN_WARNING : KERN_INFO,
>>              tsk->comm, task_pid_nr(tsk),
>> @@ -106,6 +104,12 @@ static void warn_bad_vsyscall(struct pt_regs *regs, bool is_warning,
>>       printk("\n");
>>  }
>>
>> +#ifdef CONFIG_UNSAFE_VSYSCALLS
>> +
>> +#define __vsyscall(nr)                                                       \
>> +     __attribute__ ((unused, __section__(".vsyscall_" #nr))) notrace
>> +
>> +
>>  /* RED-PEN may want to readd seq locking, but then the variable should be
>>   * write-once.
>>   */
>> @@ -117,8 +121,11 @@ static __always_inline void do_get_tz(struct timezone * tz)
>>  static __always_inline int fallback_gettimeofday(struct timeval *tv)
>>  {
>>       int ret;
>> -     /* Invoke do_emulate_vsyscall. */
>> -     asm volatile("movb $0xce, %%al;\n\t"
>> +     /*
>> +      * Invoke do_emulate_vsyscall.  Intentionally incompatible with
>> +      * the CONFIG_UNSAFE_VSYSCALLS=n case.
>> +      */
>> +     asm volatile("mov $0xce, %%al;\n\t"
>>                    "int %[vec]"
>>                    : "=a" (ret)
>>                    : "D" (tv), [vec] "i" (VSYSCALL_EMU_VECTOR));
>> @@ -237,6 +244,8 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
>>       long ret;
>>
>>       /* Kernel code must never get here. */
>> +     if (!user_mode(regs))
>> +             early_printk("oh crap!\n");
>>       BUG_ON(!user_mode(regs));
>>
>>       local_irq_enable();
>> @@ -278,6 +287,106 @@ out:
>>       local_irq_disable();
>>  }
>>
>> +#else /* CONFIG_UNSAFE_VSYSCALLS=n below */
>> +
>> +static inline unsigned long vsyscall_intcc_addr(int vsyscall_nr)
>> +{
>> +     return VSYSCALL_START + 1024*vsyscall_nr + 2;
>> +}
>> +
>> +void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
>> +{
>> +     u8 vsyscall_nr, al;
>> +     long ret;
>> +
>> +     /* Kernel code must never get here. */
>> +     BUG_ON(!user_mode(regs));
>> +
>> +     local_irq_enable();
>> +
>> +     /*
>> +      * Decode the vsyscall number.
>> +      * 0xcc -> 0, 0xce -> 1, 0xf0 -> 2; see vsyscall_emu_64.S for why.
>> +      */
>> +     al = regs->ax & 0xff;
>> +     vsyscall_nr = (al - 0xcc) >> 1;
>
> Ok, but
>
>        (0xf0 - 0xcc) >> 1 == 0x12
>
> Don't you mean 0xd0 here? Although 0xd0 is opcode for all those
> rotate/shift insns. What am I missing?

Wow, -ESHOULDUSECALCULATOR  I knew I was bad at arithmetic, but 0xcc +
4 == 0xf0 is pretty amazing.  I was so excited that I found three
"safe" opcodes in an arithmetic sequence.

I'll fix that.  I suspect the only reason I didn't crash anything is
because I didn't give vgetcpu enough exercise here.

--Andy
