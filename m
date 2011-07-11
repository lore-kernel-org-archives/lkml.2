Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964851Ab1GKW2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 18:28:37 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65267 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483Ab1GKW2g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 18:28:36 -0400
MIME-Version: 1.0
In-Reply-To: <20110711221432.GA10164@liondog.tnic>
References: <cover.1310267866.git.luto@mit.edu> <2215c119e580b40f243c37d284e7bced309d975f.1310267866.git.luto@mit.edu>
 <20110711221432.GA10164@liondog.tnic>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 11 Jul 2011 18:20:50 -0400
X-Google-Sender-Auth: 0of8oiOFhGUD5lZVrWU-wC2EyQA
Message-ID: <CAObL_7ERJ4D_R5k1C7OHLz1etZzxcaTA7rzFmtRu0-gpq_YpMQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] x86-64: Improve vsyscall emulation CS and RIP handling
To: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@mit.edu>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
        Borislav Petkov <bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 6:14 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Sat, Jul 09, 2011 at 11:22:08PM -0400, Andy Lutomirski wrote:
>> Two fixes here:
>>  - Send SIGSEGV if called from compat code or with a funny CS.
>>  - Don't BUG on impossible addresses.
>>
>> This patch also removes an unused variable.
>>
>> Signed-off-by: Andy Lutomirski <luto@mit.edu>
>> ---
>>  arch/x86/include/asm/vsyscall.h |   12 --------
>>  arch/x86/kernel/vsyscall_64.c   |   59 +++++++++++++++++++++++++--------------
>>  2 files changed, 38 insertions(+), 33 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
>> index bb710cb..d555973 100644
>> --- a/arch/x86/include/asm/vsyscall.h
>> +++ b/arch/x86/include/asm/vsyscall.h
>> @@ -31,18 +31,6 @@ extern struct timezone sys_tz;
>>
>>  extern void map_vsyscall(void);
>>
>> -/* Emulation */
>> -
>> -static inline bool is_vsyscall_entry(unsigned long addr)
>> -{
>> -     return (addr & ~0xC00UL) == VSYSCALL_START;
>> -}
>> -
>> -static inline int vsyscall_entry_nr(unsigned long addr)
>> -{
>> -     return (addr & 0xC00UL) >> 10;
>> -}
>> -
>>  #endif /* __KERNEL__ */
>>
>>  #endif /* _ASM_X86_VSYSCALL_H */
>> diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
>> index 10cd8ac..6d14848 100644
>> --- a/arch/x86/kernel/vsyscall_64.c
>> +++ b/arch/x86/kernel/vsyscall_64.c
>> @@ -38,6 +38,7 @@
>>
>>  #include <asm/vsyscall.h>
>>  #include <asm/pgtable.h>
>> +#include <asm/compat.h>
>>  #include <asm/page.h>
>>  #include <asm/unistd.h>
>>  #include <asm/fixmap.h>
>> @@ -97,33 +98,60 @@ static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
>>
>>       tsk = current;
>>
>> -     printk("%s%s[%d] %s ip:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
>> +     printk("%s%s[%d] %s ip:%lx cs:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
>>              level, tsk->comm, task_pid_nr(tsk),
>> -            message, regs->ip - 2, regs->sp, regs->ax, regs->si, regs->di);
>> +            message, regs->ip - 2, regs->cs,
>> +            regs->sp, regs->ax, regs->si, regs->di);
>> +}
>> +
>> +static int addr_to_vsyscall_nr(unsigned *vsyscall_nr, unsigned long addr)
>> +{
>> +     if ((addr & ~0xC00UL) != VSYSCALL_START)
>> +             return -EINVAL;
>> +
>> +     *vsyscall_nr = (addr & 0xC00UL) >> 10;
>> +     if (*vsyscall_nr >= 3)
>> +             return -EINVAL;
>> +
>> +     return 0;
>>  }
>
> I'm wondering: why don't you make this function return negative value on
> error, i.e. -EINVAL and the vsyscall number on success so that you can
> get rid of returning it through the arg pointer?
>
> Then at the callsite you can do:
>
>        vsyscall_nr = addr_to_vsyscall_nr(addr);
>        if (vsyscall_nr < 0)
>                warn_bad_vsyscall(...)

Because I don't want a warning about ret being used without being initialized.

With the code in this patch, the compiler is smart enough to figure
out that either vsyscall_nr is 0, 1, or 2 or that the EINVAL branch is
taken.  I'll see if it works the other way.

--Andy
