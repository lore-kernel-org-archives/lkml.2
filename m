Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab1BNRVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:21:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57350 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab1BNRVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:21:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hEPkgebGbQdaTWXE78r2ittd6ATLfJ5p2PKCfU6EanAzvKHd4A+SOa9K3kCTW8WecL
         TQ6Aa1lt704DkCtNXuwk8G5Yy3SFQhTX27MVhsHJcvs2dQj5ZdOrgfAf+P0olZU7Rxfq
         q79gaOp11wgqAh+hHeguHl2jI/d6xdRgsq7Cw=
MIME-Version: 1.0
In-Reply-To: <20110214151340.GP18742@htj.dyndns.org>
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com>
 <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com>
 <20110214151340.GP18742@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 14 Feb 2011 18:20:52 +0100
Message-ID: <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
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

On Mon, Feb 14, 2011 at 4:13 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Denys.
>
> On Sun, Feb 13, 2011 at 11:25:55PM +0100, Denys Vlasenko wrote:
>> But this "diddling behind group stop's back" is exactly the current
>> problem with stop signals.
>
> Maybe.  I don't necessarily agree but can see your point too but I
> think more important part is that that's a behavior which is quite
> noticeable from userland.
>
>> Here I try to stop a ptraced process:
>>
>> $ strace -tt sleep 30
>> 23:02:15.619262 execve("/bin/sleep", ["sleep", "30"], [/* 30 vars */]) = 0
>> ...
>> 23:02:15.622112 nanosleep({30, 0}, NULL) = ? ERESTART_RESTARTBLOCK (To be restarted)
>> 23:02:23.781165 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
>> 23:02:23.781251 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
>>     (I forgot again why we see it twice. Another quirk I guess...)
>> 23:02:23.781310 restart_syscall(<... resuming interrupted call ...>) = 0
>> 23:02:45.622433 close(1)                = 0
>> 23:02:45.622743 close(2)                = 0
>> 23:02:45.622885 exit_group(0)           = ?
>>
>> Why sleep didn't stop?
>>
>> Because PTRACE_SYSCALL brought the task out of group stop at once,
>> even though strace did try hard to not do so:
>>
>>     ptrace(PTRACE_SYSCALL, $PID, 0x1, SIGSTOP) <-- note SIGSTOP!
>>
>> PTRACE_CONT in this situation would do the same.
>
> This can be fixed by updating strace, right?  strace can look at the
> wait(2) exit code and if the tracee stopped for group stop, wait for
> the tracee to be continued instead of issuing PTRACE_SYSCALL.

But tracee didn't stop _yet_. Signal is not delivered _yet_, debugger
can decide at this point whether to deliver it:
ptrace(PTRACE_SYSCALL, $PID, 0x1, SIGSTOP)
or ignore:
ptrace(PTRACE_SYSCALL, $PID, 0x1, 0)

strace has to deliver SIGSTOP if it wants to make program run exactly
as it would run without strace. So it tries to do so.
Currently, ptrace machinery doesn't react as strace, its user, expects it to.

You are proposing to special-case SIGSTOP delivery in strace:
"if (sig != SIGSTOP) ptrace(PTRACE_SYSCALL, $PID, 0x1, sig)"

This is problematic. For example, will have an effect of not stopping
other threads of a multi-threaded process.


>> You are saying that it is useful that gdb restarts group-stopped task
>> with mere PTRACE_CONT. Above is a counter-example where it is anti-useful:
>> I would muchly prefer strace to see task sit stopped until it gets SIGCONT
>> (or some fatal signal).
>
> This is more of an issue which can be improved in strace.  Sure,
> changing the kernel to enforce group stop over ptrace would make this
> case behave better but at the cost of breaking gdb.
>
>> Why gdb can't use SIGCONT instead of PTRACE_CONT, just like every
>> other tool which needs to resume stopped tasks?
>
> Because that's how PTRACE_CONT behaved the whole time.  It can but
> just hasn't needed to.

Jan, please put on your gdb maintainer's hat, we need your opinion here.
Is it a problem from gdb's POV?

-- 
vda.
