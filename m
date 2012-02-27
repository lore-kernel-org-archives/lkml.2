Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab2B0TrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 14:47:24 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64965 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753965Ab2B0TrW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 14:47:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of wad@chromium.org designates 10.112.25.8 as permitted sender) smtp.mail=wad@chromium.org; dkim=pass header.i=wad@chromium.org
MIME-Version: 1.0
In-Reply-To: <20120227175407.GD10608@redhat.com>
References: <1330140111-17201-1-git-send-email-wad@chromium.org>
	<1330140111-17201-10-git-send-email-wad@chromium.org>
	<20120227175407.GD10608@redhat.com>
Date: Mon, 27 Feb 2012 13:47:17 -0600
Message-ID: <CABqD9hY1P7LfmBwQwSG7jDZmw6d_pZH4q2cZq_4ssjQUKRA32w@mail.gmail.com>
Subject: Re: [PATCH v11 10/12] ptrace,seccomp: Add PTRACE_SECCOMP support
From: Will Drewry <wad@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org,
        Denys Vlasenko <dvlasenk@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 11:54 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/24, Will Drewry wrote:
>>
>>  arch/Kconfig              |    1 +
>>  include/linux/ptrace.h    |    7 +++++--
>>  include/linux/seccomp.h   |    4 +++-
>>  include/linux/tracehook.h |    6 ++++++
>>  kernel/ptrace.c           |    4 ++++
>>  kernel/seccomp.c          |   18 ++++++++++++++++++
>
> FYI, this conflicts with the changes -mm tree.
>
> The changes in ptrace.* confict with Denys's
> "ptrace: simplify PTRACE_foo constants and PTRACE_SETOPTIONS code"
>
> The change in tracehook.h conflicts with
> "ptrace: the killed tracee should not enter the syscall"

What's the best way to reconcile this in this day and age? I don't see
these in kernel-next yet and I can't tell if there is a public -mm
anywhere anymore.  I can use the patches from the mailing list with
Denys's changes if that'd be good enough.  His cleanup will make this
code even smaller!

>> --- a/kernel/seccomp.c
>> +++ b/kernel/seccomp.c
>> @@ -354,6 +354,24 @@ int __secure_computing_int(int this_syscall)
>>                       seccomp_send_sigsys(this_syscall, reason_code);
>>                       return -1;
>>               }
>> +             case SECCOMP_RET_TRACE: {
>> +                     int ret;
>> +                     struct pt_regs *regs = task_pt_regs(current);
>> +                     if (!(test_tsk_thread_flag(current, TIF_SYSCALL_TRACE)) ||
>> +                         !(current->ptrace & PT_TRACE_SECCOMP))
>> +                             return -1;
>> +                     /*
>> +                      * PT_TRACE_SECCOMP and seccomp.trace indicate whether
>> +                      * tracehook_report_syscall_entry needs to signal the
>> +                      * tracer.  This avoids race conditions in hand off and
>> +                      * the requirement for TIF_SYSCALL_TRACE ensures that
>> +                      * we are in the syscall slow path.
>> +                      */
>> +                     current->seccomp.trace = 1;
>> +                     ret = tracehook_report_syscall_entry(regs);
>> +                     current->seccomp.trace = 0;
>> +                     return ret;
>
> To be honest, this interface looks a bit strange to me...
>
> Once again, sorry if this was already discussed. But perhaps it would
> be better to introduce PTRACE_EVENT_SECCOMP/PTRACE_O_SECCOMP instead?
>
> SECCOMP_RET_TRACE: could simply do ptrace_event(PTRACE_EVENT_SECCOMP)
> unconditionaly. The tracer can set the option and do PTRACE_CONT if it
> doesn't want the system call notifications.

Works for me - this also gets rid of the extra int for brief state
tracking. I'll switch over to that in the next rev.  (More follow-ups
to your reviews incoming too :).

Thanks!
will
