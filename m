Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066Ab2EXSYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:24:41 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36577 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933804Ab2EXSYj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:24:39 -0400
MIME-Version: 1.0
In-Reply-To: <acabbed13c4f02e653879844a9cbddef.squirrel@webmail.greenhost.nl>
References: <20120522173942.GJ11775@ZenIV.linux.org.uk>
	<1337875681-20717-1-git-send-email-wad@chromium.org>
	<1337875681-20717-2-git-send-email-wad@chromium.org>
	<acabbed13c4f02e653879844a9cbddef.squirrel@webmail.greenhost.nl>
Date: Thu, 24 May 2012 13:24:37 -0500
Message-ID: <CABqD9hZCx88UzAeayn0cz=nTcT=fMiUZohTayHWq+Dcnnx-hQQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] seccomp: Don't allow tracers to abuse RET_TRACE
From: Will Drewry <wad@chromium.org>
To: Indan Zupancic <indan@nul.nu>
Cc: linux-kernel@vger.kernel.org, mcgrathr@google.com, hpa@zytor.com,
        netdev@parisplace.org, linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de,
        luto@mit.edu, serge.hallyn@canonical.com, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 12:54 PM, Indan Zupancic <indan@nul.nu> wrote:
> On Thu, May 24, 2012 18:07, Will Drewry wrote:
>> Ensure that consumers of the PTRACE_EVENT_SECCOMP notification
>> cannot change the system call number for the traced task
>> without it resulting in the system call being skipped.
>>
>> Traditionally, tracers will set the system call number to
>> -1 to skip the system call. This behavior will work as expected
>> but the tracer will be unable to remap the system call to a valid
>> system call after the seccomp policy has been evaluated.
>>
>> Signed-off-by: Will Drewry <wad@chromium.org>
>> ---
>>  kernel/seccomp.c |    4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>> index ee376be..33f0ad6 100644
>> --- a/kernel/seccomp.c
>> +++ b/kernel/seccomp.c
>> @@ -425,6 +425,10 @@ int __secure_computing(int this_syscall)
>>                        */
>>                       if (fatal_signal_pending(current))
>>                               break;
>> +                     /* Skip the system call if the tracer changed it. */
>> +                     if (this_syscall !=
>> +                         syscall_get_nr(current, task_pt_regs(current)))
>> +                             goto skip;
>>                       return 0;
>>               case SECCOMP_RET_ALLOW:
>>                       return 0;
>> --
>
> This patch doesn't make any sense whatsoever. You can't know why a system
> call was blocked by a seccomp filter, assuming it's always because of the
> system call number is wrong.

All this does is assert that the tracer can't change the syscall
number without it skipping the call.  If seccomp returned
SECCOMP_RET_TRACE because the argument to open was O_RDWR, then
everything is fine.

> Also, you don't check if an allowed system call is changed into a denied
> one, so this doesn't protect against ptracers bypassing seccomp filters.

This enforces that the system call that is going to be executed is the
one that triggered SECCOMP_RET_TRACE.  That means seccomp is
delegating the go/no-go decision to the tracer.  I don't understand
your assertion here.  This code doesn't affect the PTRACE_SYSCALL
case.

> And one of the main points of PTRACE_EVENT_SECCOMP events was that it's
> useful for cases that can't be handled or decided by the seccomp filter.
> Then taking away the ability to change the syscall number makes it a lot
> less useful.

Do you have a valid case where you want to remap one system call to
another without the ability to also handle the syscall exit path and
do any fixups?  I've mostly just seen skip, allow, update arguments -
not swapping the entire syscall.  That said, it's possible.  you could
do all sorts of weird things with ptrace if you want :)

> Either do the seccomp test before or after ptrace, or both, but please
> don't introduce ad hoc checks like this.

I don't feel strongly about this RFC, but I don't believe that
expectations are being changed dramatically.

thanks!
will
