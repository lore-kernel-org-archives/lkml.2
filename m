Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab2DPQPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:15:43 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64132 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752442Ab2DPQPi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:15:38 -0400
MIME-Version: 1.0
In-Reply-To: <CABqD9hauxzd4vVbxyC5M1p9e6mLt1cjYP7wbhzTKPi3iMpc0kg@mail.gmail.com>
References: <20120416154607.302f7ae245472e1e917dacef@canb.auug.org.au>
	<CABqD9hauxzd4vVbxyC5M1p9e6mLt1cjYP7wbhzTKPi3iMpc0kg@mail.gmail.com>
Date: Mon, 16 Apr 2012 11:15:36 -0500
Message-ID: <CABqD9hYhC3dNX3CVSbsuJaG=zBUC4VMyMVYYmyOTN+Xfb=uC8w@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (security
 tree related)
From: Will Drewry <wad@chromium.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 10:32 AM, Will Drewry <wad@chromium.org> wrote:
> On Mon, Apr 16, 2012 at 12:46 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> After merging the final tree, today's linux-next build (powerpc
>> allnoconfig) failed like this:
>>
>> arch/powerpc/kernel/ptrace.c: In function 'do_syscall_trace_enter':
>> arch/powerpc/kernel/ptrace.c:1713:2: error: statement with no effect [-Werror=unused-value]
>> cc1: all warnings being treated as errors
>>
>> Introduced by commit acf3b2c71ed2 ("seccomp: add SECCOMP_RET_ERRNO").  I
>> have applied the following hack fix that fixes the build, but the other
>> seven call sites of secure_computing() should be fixed up properly.
>
> Thanks for this, and the other two fixes!  I'll pull together a patch
> fixing up the other call sites.

Hrm - with liberal application of grep and lxr, I'm not seeing any
other call sites that need to be fixed.  I ended up with the exact
same patch as yours.

At present, the return value from secure_computing() can be ignored
for every arch that supports CONFIG_SECCOMP and does not support
CONFIG_HAVE_ARCH_SECCOMP_FILTER, so I don't necessarily see your patch
as a hack.  Then as the pieces needed to support
CONFIG_HAVE_ARCH_SECCOMP_FILTER end up in place, the (void) cast will
be removed.  (Respecting the return value is noted in the arch/Kconfig
description for adding support.)

I certainly don't mind bouncing the casts patch (broken out per-arch)
over to James's tree so that you don't have to carry the fix, but I
wonder if I'm missing some implicit context.

Thanks!
will

>
>> From: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date: Mon, 16 Apr 2012 15:39:49 +1000
>> Subject: [PATCH] seccomp: hack fix for build failures with secure_computing
>>  return value change
>>
>> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> ---
>>  arch/microblaze/kernel/ptrace.c |    2 +-
>>  arch/mips/kernel/ptrace.c       |    2 +-
>>  arch/powerpc/kernel/ptrace.c    |    2 +-
>>  arch/s390/kernel/ptrace.c       |    2 +-
>>  arch/sh/kernel/ptrace_32.c      |    2 +-
>>  arch/sh/kernel/ptrace_64.c      |    2 +-
>>  arch/sparc/kernel/ptrace_64.c   |    2 +-
>>  7 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/microblaze/kernel/ptrace.c b/arch/microblaze/kernel/ptrace.c
>> index 6eb2aa9..9e3ffc9 100644
>> --- a/arch/microblaze/kernel/ptrace.c
>> +++ b/arch/microblaze/kernel/ptrace.c
>> @@ -136,7 +136,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
>>  {
>>        long ret = 0;
>>
>> -       secure_computing(regs->r12);
>> +       (void)secure_computing(regs->r12);
>>
>>        if (test_thread_flag(TIF_SYSCALL_TRACE) &&
>>            tracehook_report_syscall_entry(regs))
>> diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
>> index 7c24c29..4f83d73 100644
>> --- a/arch/mips/kernel/ptrace.c
>> +++ b/arch/mips/kernel/ptrace.c
>> @@ -535,7 +535,7 @@ static inline int audit_arch(void)
>>  asmlinkage void syscall_trace_enter(struct pt_regs *regs)
>>  {
>>        /* do the secure computing check first */
>> -       secure_computing(regs->regs[2]);
>> +       (void)secure_computing(regs->regs[2]);
>>
>>        if (!(current->ptrace & PT_PTRACED))
>>                goto out;
>> diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
>> index 8d8e028..53cebc4 100644
>> --- a/arch/powerpc/kernel/ptrace.c
>> +++ b/arch/powerpc/kernel/ptrace.c
>> @@ -1710,7 +1710,7 @@ long do_syscall_trace_enter(struct pt_regs *regs)
>>  {
>>        long ret = 0;
>>
>> -       secure_computing(regs->gpr[0]);
>> +       (void)secure_computing(regs->gpr[0]);
>>
>>        if (test_thread_flag(TIF_SYSCALL_TRACE) &&
>>            tracehook_report_syscall_entry(regs))
>> diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
>> index 02f300f..96e0dea 100644
>> --- a/arch/s390/kernel/ptrace.c
>> +++ b/arch/s390/kernel/ptrace.c
>> @@ -719,7 +719,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
>>        long ret = 0;
>>
>>        /* Do the secure computing check first. */
>> -       secure_computing(regs->gprs[2]);
>> +       (void)secure_computing(regs->gprs[2]);
>>
>>        /*
>>         * The sysc_tracesys code in entry.S stored the system
>> diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
>> index 9698671..cf55945 100644
>> --- a/arch/sh/kernel/ptrace_32.c
>> +++ b/arch/sh/kernel/ptrace_32.c
>> @@ -503,7 +503,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
>>  {
>>        long ret = 0;
>>
>> -       secure_computing(regs->regs[0]);
>> +       (void)secure_computing(regs->regs[0]);
>>
>>        if (test_thread_flag(TIF_SYSCALL_TRACE) &&
>>            tracehook_report_syscall_entry(regs))
>> diff --git a/arch/sh/kernel/ptrace_64.c b/arch/sh/kernel/ptrace_64.c
>> index bc81e07..3d3600f 100644
>> --- a/arch/sh/kernel/ptrace_64.c
>> +++ b/arch/sh/kernel/ptrace_64.c
>> @@ -522,7 +522,7 @@ asmlinkage long long do_syscall_trace_enter(struct pt_regs *regs)
>>  {
>>        long long ret = 0;
>>
>> -       secure_computing(regs->regs[9]);
>> +       (void)secure_computing(regs->regs[9]);
>>
>>        if (test_thread_flag(TIF_SYSCALL_TRACE) &&
>>            tracehook_report_syscall_entry(regs))
>> diff --git a/arch/sparc/kernel/ptrace_64.c b/arch/sparc/kernel/ptrace_64.c
>> index 6f97c07..6ddec1f 100644
>> --- a/arch/sparc/kernel/ptrace_64.c
>> +++ b/arch/sparc/kernel/ptrace_64.c
>> @@ -1062,7 +1062,7 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
>>        int ret = 0;
>>
>>        /* do the secure computing check first */
>> -       secure_computing(regs->u_regs[UREG_G1]);
>> +       (void)secure_computing(regs->u_regs[UREG_G1]);
>>
>>        if (test_thread_flag(TIF_SYSCALL_TRACE))
>>                ret = tracehook_report_syscall_entry(regs);
>> --
>> 1.7.10.rc3
>>
>> --
>> Cheers,
>> Stephen Rothwell                    sfr@canb.auug.org.au
>> http://www.canb.auug.org.au/~sfr/
