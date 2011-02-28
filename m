Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1B1Nlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 08:41:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33057 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab1B1Nlu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 08:41:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=K/LmkoS4V1336iRuCOz0MUUzX+q9gdExOdxLtAN1uihPSXXWuI5yUAc788TaGagLfq
         HI0RzGFytWqRpjGJ3de7YDIMOWWEWcaVyvfHaCYICFlT8+aNFUSm3d96+YEYFmNXpKmj
         3mCzT+wmaDJ3Tk76/zJJOYDQAdyoz0igmgV+U=
MIME-Version: 1.0
In-Reply-To: <20110228132941.GB9326@htj.dyndns.org>
References: <20110214190141.GA19221@redhat.com> <20110224202941.GA12258@redhat.com>
 <20110225155142.GQ24828@htj.dyndns.org> <201102260348.03312.vda.linux@googlemail.com>
 <20110228125622.GA9326@htj.dyndns.org> <AANLkTik1+XVrkwTouERoxF2AWYyv-UCqie_Wq3OLjoXg@mail.gmail.com>
 <20110228132941.GB9326@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 28 Feb 2011 14:41:29 +0100
Message-ID: <AANLkTin9HW5R5Wihw+yceKkW=Pj+eB8-id0E1Gud2y-G@mail.gmail.com>
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after PTRACE_ATTACH
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 2:29 PM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Feb 28, 2011 at 02:16:48PM +0100, Denys Vlasenko wrote:
>> (gdb) print getpid()
>>
>> gdb modifies IP, sets breakpoint on return address, and issues PTRACE_CONT(0).
>> Kernel has to put the tracee into group-stop, right?
>> Becuase if it doesn't, if it makes tracee run, then the kernel is
>> still broken. For example,
>> stracing a program and sending SIGSTOP on it won't work: the sequence
>> of events will be
>> got SIGSTOP because SIGSTOP was delivered
>> PTRACE_SYSCALL(SIGSTOP) - "inject it"
>> got SIGSTOP because tracee is in group-stop now
>> PTRACE_SYSCALL(SIGSTOP) - equivalent to PTRACE_SYSCALL(0)
>>   because we aren't in signal delivery ptrace-stop
>> and tracee continues.
>>
>> That's why I think gdb's "print getpid()" today depends on the bug.
>> If we simply fix the bug (by making PTRACE_CONT/SYSCALL(0)
>> re-enter group-stop), then "print getpid()" will stop working
>> for stopped tracees.
>
> There's no reason to make the tracee re-enter group stop after pulling
> it out to execute 'print getpid()'.

If we want to execute 'print getpid()', you are right, we don't want
to enter group stop. That's use case #1. But there is use case #2:
"strace sleep" + ^Z. if we want to continue stracing sleep
without continuing, our PTRACE_SYSCALL(0) *must* make sleep
enter group stop. Otherwise, sleep won't be stopped. It will
continue sleeping and will exit, which is not what we want. Right?

>  The only thing necessary is a way
> for the debugger to find out that group stop has been lifted.

What do you mean by "has been *lifted*"?

> The debugger then can resume the tracee if it wishes so.  ie. group stop
> becomes a trap point + a state which the debugger can monitor.  If the
> debugger wants the tracee to follow the jctl behavior, it can do so by
> resuming the tracee as it sees fit.

Can you describe this in more details? Do you propose that
debugger can detect that we are in group stop (it is already sort-of
possible with PTRACE_GETSIGINFO) and if it doesn't want to
restart tracee, it simply doesn't do any PTRACE_SYSCALL/CONT?
I tried that. This makes tracee sit in *ptrace* stop, not group stop.
Meaning: debugger is never be able to see waking SIGCONT:
waitpid doesn't report it to the debugger.

-- 
vda
