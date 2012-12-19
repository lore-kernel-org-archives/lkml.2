Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab2LSO4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 09:56:38 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:55073 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab2LSO4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 09:56:30 -0500
Message-ID: <50D1D58D.6060408@linux.vnet.ibm.com>
Date: Wed, 19 Dec 2012 09:56:13 -0500
From: Corey Bryant <coreyb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        jmorris@namei.org, pmoore@redhat.com, otubo@linux.vnet.ibm.com,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 1/3] seccomp: Add SECCOMP_RET_INFO return value
References: <1355867449-3209-1-git-send-email-coreyb@linux.vnet.ibm.com> <CABqD9hbw2kT1PYiHRNSq+xVEDQdYPVqrJv78Sa4DiSnvWJ97cQ@mail.gmail.com>
In-Reply-To: <CABqD9hbw2kT1PYiHRNSq+xVEDQdYPVqrJv78Sa4DiSnvWJ97cQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121914-2398-0000-0000-00000F314E6D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/18/2012 05:22 PM, Will Drewry wrote:
> Thanks for the patch!

Thanks for the feedback!

>
> On Tue, Dec 18, 2012 at 3:50 PM, Corey Bryant <coreyb@linux.vnet.ibm.com> wrote:
>> Adds a new return value to seccomp filters that causes an
>> informational kernel message to be printed.  The message
>> includes the system call number.
>
> I don't have strong opinions about this either way, but here are the
> points that led me to drop a _LOG return value in the past:

I figured you had attempted a log mechanism before. :)  I've just found 
it too difficult to learn the syscalls a process uses and I think this 
would ease the pain.

> - ptrace can cover this awkwardly (user)
> - ftrace can cover this awkwardly (system/root)
> - audit can cover this without an allow
> - _TRAP can be used to implement this
> - There's no good way to give back the log data.
>
> I've been relying on SECCOMP_RET_TRAP:
> - trap on failure, log, then die
> - trap on failure, log, then jump to a whitelisted re-entry point to
> resume the syscall

We tried using SECCOMP_RET_TRAP with QEMU.  And while it was useful most 
of the time, we hit some scenarios where libraries used by QEMU were 
blocking SIGSYS.  So the signal would never get delivered to our signal 
handler.  If it was just QEMU blocking the syscalls then we could work 
around that, but I don't want to have to update other libraries.

> while others I've spoken with have been using the audit path to track
> denied values -- not so great for soft-failures :)

The audit path would work too but if I understand I think you can only 
learn one syscall per execution.  The nice thing about SECCOMP_RET_INFO 
is that you can easily learn all the syscalls in one execution.

>
> [snip]
>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>> index 5af44b5..854f628 100644
>> --- a/kernel/seccomp.c
>> +++ b/kernel/seccomp.c
>> @@ -433,6 +433,10 @@ int __secure_computing(int this_syscall)
>>                                  goto skip;  /* Explicit request to skip. */
>>
>>                          return 0;
>> +               case SECCOMP_RET_INFO:
>> +                       if (printk_ratelimit())
>> +                               pr_info("seccomp: syscall=%d\n", this_syscall);
>
> The arch value will also be needed to make this reliably meaningful
> (how was the syscall called).
>

Ah, yes.  Thanks.

> That aside, I worry that pr_info is the wrong place for a random user
> on the machine to log to for this, but I may be wrong, rather than a
> dedicated ringbufffer, etc.  So if this is for a user with privs, then
> a SECCOMP_RET_AUDIT might make sense.  Feedback to a local user seems
> tricky in general. I don't know :)  I just decided to deal with it in
> userland even if it is slightly painful.

That's a good point.  I don't know which option is better either so if 
anyone else could weigh in on the better approach I'd appreciate it.

-- 
Regards,
Corey Bryant

