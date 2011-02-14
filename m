Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab1BNSzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:55:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53524 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1BNSzr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:55:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ABwce1bdtGLOF5p4l0P9YsIf2YqXynFutEoTe9cc5d4bLL958Pw+OFCIeK9akaPJFm
         kmzBpDlhvBAOYglLBTQv3KAtM06B8kJWGwaxvEFlgSBckzyOFBmP3OxE5/7WttT+Rw+J
         xa12c4Hm+z6zTi2CKyyyLXxqX6c1QPtftoZJ4=
MIME-Version: 1.0
In-Reply-To: <20110214175144.GC15847@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com>
 <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com>
 <20110214151340.GP18742@htj.dyndns.org> <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
 <20110214175144.GC15847@redhat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 14 Feb 2011 19:55:25 +0100
Message-ID: <AANLkTi=VVWVkrqqQyOtsP72S5-nWny=Ukmf_r-m1qMwV@mail.gmail.com>
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after PTRACE_ATTACH
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 6:51 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/14, Denys Vlasenko wrote:
>>
>> >> $ strace -tt sleep 30
>> >> 23:02:15.619262 execve("/bin/sleep", ["sleep", "30"], [/* 30 vars */]) = 0
>> >> ...
>> >> 23:02:15.622112 nanosleep({30, 0}, NULL) = ? ERESTART_RESTARTBLOCK (To be restarted)
>> >> 23:02:23.781165 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
>> >> 23:02:23.781251 --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
>> >>     (I forgot again why we see it twice. Another quirk I guess...)
>> >> 23:02:23.781310 restart_syscall(<... resuming interrupted call ...>) = 0
>> >> 23:02:45.622433 close(1)                = 0
>> >> 23:02:45.622743 close(2)                = 0
>> >> 23:02:45.622885 exit_group(0)           = ?
>> >>
>> >> Why sleep didn't stop?
>> >>
>> >> Because PTRACE_SYSCALL brought the task out of group stop at once,
>> >> even though strace did try hard to not do so:
>> >>
>> >>     ptrace(PTRACE_SYSCALL, $PID, 0x1, SIGSTOP) <-- note SIGSTOP!
>> >>
>> >> PTRACE_CONT in this situation would do the same.
>> >
>> > This can be fixed by updating strace, right?  strace can look at the
>> > wait(2) exit code and if the tracee stopped for group stop, wait for
>> > the tracee to be continued instead of issuing PTRACE_SYSCALL.
>
> Ah, I seem to understand the confusion, let me repeat...
>
>> But tracee didn't stop _yet_.
>
> This depends on "_yet_". strace does ptrace(SYSCALL, SIGSTOP) twice.
> The first time it does this after the tracee reports the signal, and
> the tracee stopps.
>
>> Signal is not delivered _yet_, debugger
>> can decide at this point whether to deliver it:
>> ptrace(PTRACE_SYSCALL, $PID, 0x1, SIGSTOP)
>> or ignore:
>> ptrace(PTRACE_SYSCALL, $PID, 0x1, 0)
>>
>> strace has to deliver SIGSTOP if it wants to make program run exactly
>> as it would run without strace. So it tries to do so.
>> Currently, ptrace machinery doesn't react as strace, its user, expects it to.
>
> It does, see above. But then the tracee actually stopps, and report
> this to the tracer. However, strace handles this case as if this was
> another signal=SIGSTOP, so it does ptrace(SYSCALL, SIGSTOP) again.
>
> SIGSTOP has no effect, but PTRACE_SYSCALL wakeups the tracee.

I performed a small experiment. You are right, SIGSTOP here
is ignored, and PTRACE_SYSCALL wakes the tracee up:
replacing SIGSTOP with 0 doesn't change anything.

I tried to simply not do ptrace(PTRACE_SYSCALL, ..., 0) at all.
Behavior changes, but it is still wrong. Now tracee doesn't wake up
on SIGCONT. Here is the run of modified strace:

# strace -tt -s99 -oLOG ./strace sleep 55
execve("/bin/sleep", ["sleep", "55"], [/* 48 vars */]) = 0
brk(0)                                  = 0x22a9000
...
nanosleep({55, 0}, NULL)                = ? ERESTART_RESTARTBLOCK (To
be restarted)
          <-- kill -STOP 25339
--- SIGSTOP (Stopped (signal)) @ 0 (0) --- STOP: si_signo:19 si_code:0
si_status:0 si_value:(nil)
--- SIGSTOP (Stopped (signal)) @ 0 (0) --- STOP:
ptrace(PTRACE_GETSIGINFO) failed
...does not exit for minutes...
           <-- kill -CONT 25339
...still nothing, it is stopped, does not exit for minutes...
           <-- kill -KILL 25339
+++ killed by SIGKILL +++


Here is what patched strace saw and did:

19:41:09.601764 wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGSTOP}],
__WALL, NULL) = 25339
19:41:09.601914 rt_sigprocmask(SIG_BLOCK, [HUP INT QUIT PIPE TERM], NULL, 8) = 0
19:41:09.602081 ptrace(PTRACE_GETSIGINFO, 25339, 0, {si_signo=SIGSTOP,
si_code=SI_USER, si_pid=10105, si_uid=0, si_value={int=0, ptr=0}}) = 0
19:41:09.602273 write(2, "--- SIGSTOP (Stopped (signal)) @ 0 (0) ---
STOP: si_signo:19 si_code:0 si_status:0 si_value:(nil) \n", 99) = 99
19:41:09.602456 ptrace(PTRACE_SYSCALL, 25339, 0x1, SIGSTOP) = 0
19:41:09.602582 --- SIGCHLD (Child exited) @ 0 (0) ---
19:41:09.602652 rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0

19:41:09.602792 wait4(-1, [{WIFSTOPPED(s) && WSTOPSIG(s) == SIGSTOP}],
__WALL, NULL) = 25339
19:41:09.602927 rt_sigprocmask(SIG_BLOCK, [HUP INT QUIT PIPE TERM], NULL, 8) = 0
19:41:09.603081 ptrace(PTRACE_GETSIGINFO, 25339, 0, 0x7fff436fc730) =
-1 EINVAL (Invalid argument)
19:41:09.603231 write(2, "--- SIGSTOP (Stopped (signal)) @ 0 (0) ---
STOP: ptrace(PTRACE_GETSIGINFO) failed \n", 83) = 83
19:41:09.603369 rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
      <<<< the change is here. Unpatched strace would do
ptrace(PTRACE_SYSCALL, 25339, 0x1, SIGSTOP) >>>

19:41:09.603511 wait4(-1, [{WIFSIGNALED(s) && WTERMSIG(s) ==
SIGKILL}], __WALL, NULL) = 25339
      <<<< SIGCONT is not visible! >>>>>
19:47:00.836723 --- SIGCHLD (Child exited) @ 0 (0) ---
19:47:00.836804 rt_sigprocmask(SIG_BLOCK, [HUP INT QUIT PIPE TERM], NULL, 8) = 0
19:47:00.837010 write(2, "+++ killed by SIGKILL +++\n", 26) = 26
19:47:00.837212 rt_sigaction(SIGKILL, {SIG_DFL, [KILL],
SA_RESTORER|SA_RESTART, 0x7f5df12d5970}, {0x7fff436f0043, ~[HUP INT
BUS USR2 PIPE ALRM TTIN XCPU PROF WINCH IO PWR RTMIN RT_16 RT_17 RT_18
RT
19:47:00.837458 gettid()                = 25338
19:47:00.837596 tgkill(25338, 25338, SIGKILL <unfinished ...>
19:47:00.837831 +++ killed by SIGKILL +++

As you see, SIGCONT was completely invisible to debugger.

-- 
vda
