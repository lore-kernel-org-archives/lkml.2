Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab2GNPu7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 11:50:59 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59883 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2GNPus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 11:50:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAObL_7GX0q_qywY4g1S2iRZWPS95ar01wtvv9wDW=zswwaZ6fQ@mail.gmail.com>
References: <1342279974-26917-1-git-send-email-wad@chromium.org>
	<1342279974-26917-2-git-send-email-wad@chromium.org>
	<CAObL_7GX0q_qywY4g1S2iRZWPS95ar01wtvv9wDW=zswwaZ6fQ@mail.gmail.com>
Date: Sat, 14 Jul 2012 10:50:46 -0500
Message-ID: <CABqD9hbmsi-VcXATWsGw37vo2RxoMvFvUs-RkVx9nTGbPtqidg@mail.gmail.com>
Subject: Re: [PATCH 2/3] vsyscall_64: allow SECCOMP_RET_TRACErs to skip
From: Will Drewry <wad@chromium.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Kees Cook <keescook@chromium.org>, james.l.morris@oracle.com,
        rob@landley.net, linux-doc@vger.kernel.org, cevans@chromium.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, eparis@redhat.com, fengxj325@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 10:44 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> I think I'd prefer if changing to something other than whatever value is
> used to cancel the syscall resulted in a crash rather than just being
> ignored.

I was trying to keep as much seccomp-ptrace behavior intact rather
than making it terminal in this special case.  Is there a reason why
it'd make more sense to crash?

> How hard is it for a page fault to return into the syscall entry path?  It
> should be possible to do this for rel, although it could be messy and not
> worth it.

Not sure, tbh. I think given vsyscall's status and the fact that
ptrace+seccomp+vsyscall=emulate isn't horrible, I think it's fine to
either ignore (what is in tree now) or to allow ptrace to skip,
without providing full functionality.  But obviously, my view my be
biased!

thanks!
will

>
> On Jul 14, 2012 10:35 AM, "Will Drewry" <wad@chromium.org> wrote:
>>
>> Current quirky ptrace behavior with vsyscall and seccomp
>> does not allow tracers to bypass the call.  This change
>> provides that ability by checking if orig_ax changed.
>>
>> Signed-off-by: Will Drewry <wad@chromium.org>
>> ---
>>  arch/x86/kernel/vsyscall_64.c |   10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
>> index 5db36ca..5f9640c 100644
>> --- a/arch/x86/kernel/vsyscall_64.c
>> +++ b/arch/x86/kernel/vsyscall_64.c
>> @@ -142,11 +142,15 @@ static int addr_to_vsyscall_nr(unsigned long addr)
>>  #ifdef CONFIG_SECCOMP
>>  static int vsyscall_seccomp(struct task_struct *tsk, int syscall_nr)
>>  {
>> +       int ret;
>>         if (!seccomp_mode(&tsk->seccomp))
>>                 return 0;
>>         task_pt_regs(tsk)->orig_ax = syscall_nr;
>>         task_pt_regs(tsk)->ax = syscall_nr;
>> -       return __secure_computing(syscall_nr);
>> +       ret = __secure_computing(syscall_nr);
>> +       if (task_pt_regs(tsk)->orig_ax != syscall_nr)
>> +               return 1; /* ptrace syscall skip */
>> +       return ret;
>>  }
>>  #else
>>  #define vsyscall_seccomp(_tsk, _nr) 0
>> @@ -278,9 +282,9 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned
>> long address)
>>         current_thread_info()->sig_on_uaccess_error =
>> prev_sig_on_uaccess_error;
>>
>>         if (skip) {
>> -               if ((long)regs->ax <= 0L) /* seccomp errno emulation */
>> +               if ((long)regs->ax <= 0L || skip == 1) /* seccomp
>> errno/trace */
>>                         goto do_ret;
>> -               goto done; /* seccomp trace/trap */
>> +               goto done; /* seccomp trap */
>>         }
>>
>>         if (ret == -EFAULT) {
>> --
>> 1.7.9.5
>>
>
