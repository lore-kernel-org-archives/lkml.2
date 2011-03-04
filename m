Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605Ab1CDNBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 08:01:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47189 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759515Ab1CDNBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 08:01:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=aMQVmlKdRpSgO599Zfuq/ngkvLib7fUh059bvKlKIl0SQjp1slb8y6q0XlebT+bFkp
         Hz7RSe+xyMo1qm56W/2I3VRq6je+oiTcl4Ps0cGoyuAzMYe+iMOLLV6zEUmIhEg+Ldsv
         CKepD8z6W0Dd2nOsJ589swN7zjkUY97lqZT+4=
MIME-Version: 1.0
In-Reply-To: <20110303202246.GB32152@redhat.com>
References: <20110301152457.GE26074@htj.dyndns.org> <20110303173422.GA27960@redhat.com>
 <20110303202246.GB32152@redhat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 4 Mar 2011 14:01:04 +0100
Message-ID: <AANLkTikeCzr-OGkmaaortS7_rR+JCM9B6aJV0c52EMbE@mail.gmail.com>
Subject: Re: [RFC] Proposal for ptrace improvements
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 9:22 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 03/03, Oleg Nesterov wrote:
>>
>> I'll ask the questions later.
>
> Right now I do not see any holes (but I'll try more ;)
>
> One question, to ensure I really understand you. To simplify,
> consider this particular example.
>
> Tracee:
>
>        int main(void)
>        {
>                kill(SIGSTOP, getpid());
>
>                printf("I am running\n");
>
>                for (;;)
>                        ;
>        }
>
> To simplify again, suppose that the debugger attaches when it is
> already stopped, then it does PTRACE_CONT(0).

I think whatever new attach operation we invent needs to provide
a way to know whether attached task is stopped or not.

If debugger wants to say "please continue doing whatever
you were doing before attachment", then, using this information,
debugger can decide whether to do PTRACE_CONT(0) and
sleep on waitpid, or _don't_ do PTRACE_CONT(0) and
sleep on waitpid.

> In this case the tracee remains SIGNAL_STOP_STOPPED but prints
> "I am running" and enters the endless loop.
>
> (the new debugger can do PTRACE_SEIZE after that and "return"
>  it to the stopped state without affecting jctl state).

As far as I can understand the proposal, yes.
Basically, this behavior is intended for gdb to have a way
to implement it's backdoor-ish hack to have stopped tasks
to nevertheless run some code.
(I bet other people will eventually abuse this in horrible ways)


> Now, if SIGCONT comes (from anywhere) it clears SIGNAL_STOP_STOPPED,
> the tracee traps and reports this event to debugger.

And again, I would like to ask you kernel guys to give
userspace a way to distinguish this stop from other possible stops.

IOW: debugger PTRACE_SYSCALL(0)'ed a job control stopped task.
Debugger gets WIFSTOPPED, WSTOPSIG = SIGTRAP.
Debugger wants to know: is it a "syscall entry/exit" stop
or an "end of job control stop" stop?
Preferably without the need to query PTRACE_GETSIGINFO
on every SIGTRAP - that'd slow strace down a lot.

I imagine one way to do it is to #define a PTRACE_EVENT_foo
for "end of job control stop" stop and return it in high byte
of waitpid status, just like other PTRACE_EVENTs are returned today.

-- 
vda
