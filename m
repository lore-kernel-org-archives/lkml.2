Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1B1NRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 08:17:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33257 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab1B1NRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 08:17:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ap4vsxNwgQ/9wkpkv0O/isf/Tdu75lcUJBw+dLO30pbGMxkMNS0gIu+zFTDSXIZzkS
         L3VPmHR8GxkHeI3kL61bYET3xTkz+6cgJ3n7PDo5BhCGvJFZAEL2/+WDedycLTgCaIMt
         V2b6RqYHKlCoNUofuOi9bQ9xRFiEQ3r5zPbQg=
MIME-Version: 1.0
In-Reply-To: <20110228125622.GA9326@htj.dyndns.org>
References: <20110214190141.GA19221@redhat.com> <20110224202941.GA12258@redhat.com>
 <20110225155142.GQ24828@htj.dyndns.org> <201102260348.03312.vda.linux@googlemail.com>
 <20110228125622.GA9326@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 28 Feb 2011 14:16:48 +0100
Message-ID: <AANLkTik1+XVrkwTouERoxF2AWYyv-UCqie_Wq3OLjoXg@mail.gmail.com>
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

On Mon, Feb 28, 2011 at 1:56 PM, Tejun Heo <tj@kernel.org> wrote:
>> * group-stop state is currently not preserved across ptrace-stop.
>>   This makes, in particular, ^Z and SIGSTOP inoperative for straced
>>   programs. Everyone agrees this needs to be fixed.
>>   (There is a small bug of not notifying real parent about the group-stop,
>>   I don't want to go there since it is also non-contentious - everybody
>>   is in agreement this also should be fixed in "obvious" way).
>
> Yeap, we do agree on this one, unfortunately not on how yet.
>
>> * HOWEVER, this behavior _is_ indeed used by gdb to run small fragments
>>   of tracee even if it's stopped. Jan's example:
>>     # gdb -p applicationpid
>>     (gdb) print getpid()
>>     (gdb) print show_me_your_internal_debug_dump()
>>     (gdb) continue
>>   gdb people want to preserve this feature.
>>   How gdb implements this? I ssume it does this by modifying IP,
>>   setting a breakpoint on return address, and issues PTRACE_CONT(0).
>>   Currently it works because of "group-stop is ignored under ptrace" bug.
>
> I don't think it works because of "group-stop is ignored under ptrace"
> bug.

How so?
Imagine the following: tracee was stopped (two cases: it was stopped
before we attached to it, or it was stopped by SIGSTOP during debug session),
and we do run on a hypothetical kernel which preserves group-stop.
At this point, in gdb user does this:

(gdb) print getpid()

gdb modifies IP, sets breakpoint on return address, and issues PTRACE_CONT(0).
Kernel has to put the tracee into group-stop, right?
Becuase if it doesn't, if it makes tracee run, then the kernel is
still broken. For example,
stracing a program and sending SIGSTOP on it won't work: the sequence
of events will be
got SIGSTOP because SIGSTOP was delivered
PTRACE_SYSCALL(SIGSTOP) - "inject it"
got SIGSTOP because tracee is in group-stop now
PTRACE_SYSCALL(SIGSTOP) - equivalent to PTRACE_SYSCALL(0)
  because we aren't in signal delivery ptrace-stop
and tracee continues.

That's why I think gdb's "print getpid()" today depends on the bug.
If we simply fix the bug (by making PTRACE_CONT/SYSCALL(0)
re-enter group-stop), then "print getpid()" will stop working
for stopped tracees.

> IMO, it's because ptrace is inherently per-task not
> per-task-group, which I think is the right way to do it.

Yes, it is, and I don't propose to change that.
However, I don't see how that is relevant to examples
I just described.

> Yeah, agreed and as I said multiple times I think this is by design
> and actually the better and more useful behavior, albeit slightly less
> intuitive.

As I described, current behavior breaks stracing of programs
which get SIGSTOPed or SIGTSTP'ed (^Z).
Which is pretty lame - ^Z is not exactly rare use case.

-- 
vda
