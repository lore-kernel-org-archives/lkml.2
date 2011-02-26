Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263Ab1BZCsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 21:48:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56586 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1BZCsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 21:48:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=vp+QF3B/mp60DxDcMHb+g2qTrk+N02v1jHqXVrFASO+YN1hypqJHyYdg2YiW2JAkYs
         Iyz0Dcg118FvKCOvwz2Zc5PqhmRNb7wpD9z8tyRUs/Vqb1ykxu9jOIbGUmQ+wxfi6gzr
         VLKle5lBBlq0L50+merd7mdh2ljZRcoGaCEwc=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after PTRACE_ATTACH
Date: Sat, 26 Feb 2011 03:48:03 +0100
User-Agent: KMail/1.8.2
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
References: <20110214190141.GA19221@redhat.com> <20110224202941.GA12258@redhat.com> <20110225155142.GQ24828@htj.dyndns.org>
In-Reply-To: <20110225155142.GQ24828@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <201102260348.03312.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 February 2011 16:51, Tejun Heo wrote:
> > > * ptrace, sans the odd SIGSTOP on attach which we should remove, is
> > >   per-task.  Sending out SIGCONT on PTRACE_CONT would break that.  I
> > >   really don't think that's a good idea.
> > 
> > Hmm. But why do you think we should always send SIGCONT after attach?
> 
> Hmmm... my sentences were confusing.  I was trying to say,
> 
> * ptrace, as it currently stands, is largely per-task.  One exception
>   is the implicit SIGSTOP which is sent on PTRACE_ATTACH but this
>   should be replaced with a more transparent attach request which
>   doesn't affect jctl states.
> 
> * Sending out SIGCONT on PTRACE_CONT on jctl stopped tracee adds
>   another exception to per-task behavior, which I don't think is a
>   good idea.

Guys, it looks like we finally identified some points on which
everyone on this thread agrees (at least I don't see any strong
objections).

To enumerate:

* PTRACE_ATTACH's insertion of SIGSTOP is a design bug, but it is
  so ingrained by now that we don't want to change PTRACE_ATTACH
  semantic. We fix this situation by introducing a new ptrace call,
  PTRACE_ATTACH_NOSTOP, which has saner API.

* group-stop state is currently not preserved across ptrace-stop.
  This makes, in particular, ^Z and SIGSTOP inoperative for straced
  programs. Everyone agrees this needs to be fixed.
  (There is a small bug of not notifying real parent about the group-stop,
  I don't want to go there since it is also non-contentious - everybody
  is in agreement this also should be fixed in "obvious" way).

* HOWEVER, this behavior _is_ indeed used by gdb to run small fragments
  of tracee even if it's stopped. Jan's example:
    # gdb -p applicationpid
    (gdb) print getpid()
    (gdb) print show_me_your_internal_debug_dump()
    (gdb) continue
  gdb people want to preserve this feature.
  How gdb implements this? I ssume it does this by modifying IP,
  setting a breakpoint on return address, and issues PTRACE_CONT(0).
  Currently it works because of "group-stop is ignored under ptrace" bug.


How we can accomodate this gdb need while fixing this bug?


Oleg's POV is that gdb should SIGCONT the tracee (at least if it is
currently in group-stop). This has the advantage of using standard Unix
tool. The disadvantage is that SIGCONT will wake up *all* threads,
and that it will cause user-visible effects (SIGCONT handler will be run,
parent can (or "should be able to", we may have a bug there too)
see child to be WCONTINUED.

Frankly, it seems that this is hardly acceptable for gdb. gdb people
do want here a "secret" backdoor-ish way to make a *thread*
(not the whole process) running even when the process is in group-stop.
Yes, this is a "violation" of the convention that normally
stopped process has all threads stopped, and it makes Oleg feel
it is "wrong", but it is also useful, and used in real life.
We can't ignore that.


Jan's idea is to make kernel remember group-stop state upon attach,
preserve current behavior of ignoring group-stop while attached,
and restore group-stop upon detach.
Sorry Jan, this won't work in many cases. It won't fix the
"stracing makes process ignore SIGSTOP" bug - the result will be
that buggy behavior will be still observed. Neither it will work for
    # gdb -p applicationpid
    (gdb) print getpid()
    (gdb) print show_me_your_internal_debug_dump()
    (gdb) continue
- the "continue" will make application run even if we attached to it while
it was stopped. It will ONLY work for
    # gdb -p applicationpid
    (gdb) print getpid()
    (gdb) print show_me_your_internal_debug_dump()
    (gdb) quit
sequence. Which is good, but not good enough.


Tejun, you are disagreeng with Oleg's proposal. Do you have a proposal
which looks better to you? Or do you propose to just leave it as-is,
that is, to continue to ignore group-stop under ptrace?


>From my side, i really want to see "group-stop is ignored under ptrace"
bug fixed, yet I feel gdb's needs are legitimate. Perhaps I can help
by presenting a few ideas how to open a backdoor in ptrace API for gdb:

(a) Special-case ptrace(PTRACE_CONT/SYSCALL, pid, 0, SIGCONT) to do
"special restart for gdb" thing. Problem with this idea is that we can
be in ptrace-stop caused by genuine signal delivery, and using
ptrace(PTRACE_CONT/SYSCALL, SIGCONT) from it means "inject SIGCONT".
IOW: this creates ambiquity.

    or

(b) Abuse "addr" parameter in ptrace(PTRACE_CONT/SYSCALL, pid, addr, sig).
Currently, it is unused. Can we define a value for it which means
"do gdb hacky restart under group-stop, if tracee is indeed under group-stop"?
(the value should be different from 0 and 0x1 - values currently used by strace)

    or

(c) Add ptrace(PTRACE_CONT2/SYSCALL2/SINGLESTEP2) with the semantic of
"do gdb hacky restart under group-stop, if tracee is indeed under group-stop".
I like it less because we have at least three restarting PTRACE_foo,
maybe even four if we want to have DETACH2 too.
Duplicating every one of them feels ugly.

    or

(d) Add a ptrace option PTRACE_O_IGNORE_JOB_STOP which can be set/cleared
by PTRACE_SETOPTIONS and which modifies ptrace-restart behavior.
gdb will set the option before it wants to do
"restart-which-ignores-group-stop", and clears it again when it
no longer wants it. In the example above:
    # gdb -p applicationpid
    (gdb) print getpid() # sets IGNORE_JOB_STOP before PTRACE_CONT(0)
    (gdb) print show_me_your_internal_debug_dump() # sets IGNORE_JOB_STOP
    (gdb) continue       # clears IGNORE_JOB_STOP before PTRACE_CONT(0)


Unfortunately, none of them look particularly elegant, and all of them
will require gdb to be changed.

Jan, which one of these proposed changes to API looks "least bad" to you
from gdb POV?

Of course, feel free to provide a better proposal.

-- 
vda
