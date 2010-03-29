Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab0C2MGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:06:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:38349 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0C2MGG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:06:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EUkEp+VYT44+MGKuPlJ0csanYjKfK/7FJeNIIdwMC4TXB9H9gWyR3N1aqRKw8Zeb6A
         A51SsYdzqGKa8q4LwFtgw+zhPL6su8qT2dfVgFulpEYkM/KQ8oOlLJ2JJwF0yG+4L4C9
         Uuul6fG4xonwsOMcrJWExd7jW8IghqGFMc94I=
MIME-Version: 1.0
In-Reply-To: <20100329114046.GB16971@redhat.com>
References: <1269812331-8511-1-git-send-regression-fweisbec@gmail.com>
	 <20100329114046.GB16971@redhat.com>
Date: Mon, 29 Mar 2010 14:06:03 +0200
Message-ID: <520f0cf11003290506o629c9ab6n95c94c48ba24acf4@mail.gmail.com>
Subject: Re: [PATCH] ptrace: kill BKL in ptrace syscall
From: John Kacur <jkacur@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 1:40 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 03/28, Frederic Weisbecker wrote:
>>
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> The comment suggests that this usage is stale. There is no bkl in the
>> exec path so if there is a race lurking there, the bkl in ptrace is
>> not going to help in this regard.
>
> I never understood this comment too, and I do not see any potentional
> races bkl could prevent.
>
>> Overview of the possibility of "accidental" races this bkl might
>> protect:
>>
>> - ptrace_traceme() is protected against task removal and concurrent
>> read/write on current->ptrace as it locks write tasklist_lock.
>>
>> - arch_ptrace_attach() is serialized by ptrace_traceme() against
>> concurrent PTRACE_TRACEME or PTRACE_ATTACH
>>
>> - ptrace_attach() is protected the same way ptrace_traceme() and
>> in turn serializes arch_ptrace_attach()
>>
>> - ptrace_check_attach() does its own well described serializing too.
>>
>> There is no obvious race here.
>
> Yes, nothing inside sys_ptrace() pathes relies on bkl, and all recent
> changes were done assuming that lock_kernel() doesn't exist.
>
> I think the patch is correct.
>
> Acked-by: Oleg Nesterov <oleg@redhat.com>
>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>  kernel/ptrace.c |   10 ----------
>>  1 files changed, 0 insertions(+), 10 deletions(-)
>>
>> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
>> index 42ad8ae..5357502 100644
>> --- a/kernel/ptrace.c
>> +++ b/kernel/ptrace.c
>> @@ -666,10 +666,6 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, long, addr, long, data)
>>       struct task_struct *child;
>>       long ret;
>>
>> -     /*
>> -      * This lock_kernel fixes a subtle race with suid exec
>> -      */
>> -     lock_kernel();
>>       if (request == PTRACE_TRACEME) {
>>               ret = ptrace_traceme();
>>               if (!ret)
>> @@ -703,7 +699,6 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, long, addr, long, data)
>>   out_put_task_struct:
>>       put_task_struct(child);
>>   out:
>> -     unlock_kernel();
>>       return ret;
>>  }
>>
>> @@ -813,10 +808,6 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
>>       struct task_struct *child;
>>       long ret;
>>
>> -     /*
>> -      * This lock_kernel fixes a subtle race with suid exec
>> -      */
>> -     lock_kernel();
>>       if (request == PTRACE_TRACEME) {
>>               ret = ptrace_traceme();
>>               goto out;
>> @@ -846,7 +837,6 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
>>   out_put_task_struct:
>>       put_task_struct(child);
>>   out:
>> -     unlock_kernel();
>>       return ret;
>>  }
>>  #endif       /* CONFIG_COMPAT */
>> --
>> 1.6.2.3
>>

So, just to be clear about this particular patch, who is queuing it up
to send to Linus? Would that be you Oleg, as a ptrace maintainer?

Thanks
