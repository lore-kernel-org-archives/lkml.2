Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1B1M43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 07:56:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1B1M42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 07:56:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bPchF0iqEwlLyYzB3V1dirHfx8h5AfVvYxO/SG0Hv9eLgu65Bx+OwejR5N/JCt3hHa
         yO9FJ5K3UoiA/tE8dyceVshxU7BrijuXm7fxUOEzZu5G9EHUTSb2SfDyVOzPCXFtLFvz
         5OhIJ5RQS9VYRgNJCNsVeKNTLcViu+l1QdPUs=
Date: Mon, 28 Feb 2011 13:56:22 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110228125622.GA9326@htj.dyndns.org>
References: <20110214190141.GA19221@redhat.com>
 <20110224202941.GA12258@redhat.com>
 <20110225155142.GQ24828@htj.dyndns.org>
 <201102260348.03312.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102260348.03312.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Denys.

On Sat, Feb 26, 2011 at 03:48:03AM +0100, Denys Vlasenko wrote:
> * PTRACE_ATTACH's insertion of SIGSTOP is a design bug, but it is
>   so ingrained by now that we don't want to change PTRACE_ATTACH
>   semantic. We fix this situation by introducing a new ptrace call,
>   PTRACE_ATTACH_NOSTOP, which has saner API.

I'm thinking about a slightly different one.  Instead of having
PTRACE_ATTACH_NOSTOP + INTERRUPT, I think one which attaches and
cleanly seizes the tracee would be better.  Let's say it's
PTRACE_SEIZE.  This should be able to serve both ATTACH and INTERRUPT,
but this is a detail.

> * group-stop state is currently not preserved across ptrace-stop.
>   This makes, in particular, ^Z and SIGSTOP inoperative for straced
>   programs. Everyone agrees this needs to be fixed.
>   (There is a small bug of not notifying real parent about the group-stop,
>   I don't want to go there since it is also non-contentious - everybody
>   is in agreement this also should be fixed in "obvious" way).

Yeap, we do agree on this one, unfortunately not on how yet.

> * HOWEVER, this behavior _is_ indeed used by gdb to run small fragments
>   of tracee even if it's stopped. Jan's example:
>     # gdb -p applicationpid
>     (gdb) print getpid()
>     (gdb) print show_me_your_internal_debug_dump()
>     (gdb) continue
>   gdb people want to preserve this feature.
>   How gdb implements this? I ssume it does this by modifying IP,
>   setting a breakpoint on return address, and issues PTRACE_CONT(0).
>   Currently it works because of "group-stop is ignored under ptrace" bug.

I don't think it works because of "group-stop is ignored under ptrace"
bug.  IMO, it's because ptrace is inherently per-task not
per-task-group, which I think is the right way to do it.

> How we can accomodate this gdb need while fixing this bug?
>
> Oleg's POV is that gdb should SIGCONT the tracee (at least if it is
> currently in group-stop). This has the advantage of using standard Unix
> tool. The disadvantage is that SIGCONT will wake up *all* threads,
> and that it will cause user-visible effects (SIGCONT handler will be run,
> parent can (or "should be able to", we may have a bug there too)
> see child to be WCONTINUED.
> 
> Frankly, it seems that this is hardly acceptable for gdb. gdb people
> do want here a "secret" backdoor-ish way to make a *thread*
> (not the whole process) running even when the process is in group-stop.
> Yes, this is a "violation" of the convention that normally
> stopped process has all threads stopped, and it makes Oleg feel
> it is "wrong", but it is also useful, and used in real life.
> We can't ignore that.

Yeah, agreed and as I said multiple times I think this is by design
and actually the better and more useful behavior, albeit slightly less
intuitive.

> Jan's idea is to make kernel remember group-stop state upon attach,
> preserve current behavior of ignoring group-stop while attached,
> and restore group-stop upon detach.
> Sorry Jan, this won't work in many cases. It won't fix the
> "stracing makes process ignore SIGSTOP" bug - the result will be
> that buggy behavior will be still observed. Neither it will work for
>     # gdb -p applicationpid
>     (gdb) print getpid()
>     (gdb) print show_me_your_internal_debug_dump()
>     (gdb) continue
> - the "continue" will make application run even if we attached to it while
> it was stopped. It will ONLY work for
>     # gdb -p applicationpid
>     (gdb) print getpid()
>     (gdb) print show_me_your_internal_debug_dump()
>     (gdb) quit
> sequence. Which is good, but not good enough.
> 
> Tejun, you are disagreeng with Oleg's proposal.

Yeap.

> Do you have a proposal which looks better to you? Or do you propose
> to just leave it as-is, that is, to continue to ignore group-stop
> under ptrace?

I'm writing my proposal now.  Will post soon.  Was too lazy to do
anything during the weekend.

> From my side, i really want to see "group-stop is ignored under ptrace"
> bug fixed, yet I feel gdb's needs are legitimate. Perhaps I can help
> by presenting a few ideas how to open a backdoor in ptrace API for gdb:
> 
> (a) Special-case ptrace(PTRACE_CONT/SYSCALL, pid, 0, SIGCONT) to do
> "special restart for gdb" thing. Problem with this idea is that we can
> be in ptrace-stop caused by genuine signal delivery, and using
> ptrace(PTRACE_CONT/SYSCALL, SIGCONT) from it means "inject SIGCONT".
> IOW: this creates ambiquity.
> 
>     or
> 
> (b) Abuse "addr" parameter in ptrace(PTRACE_CONT/SYSCALL, pid, addr, sig).
> Currently, it is unused. Can we define a value for it which means
> "do gdb hacky restart under group-stop, if tracee is indeed under group-stop"?
> (the value should be different from 0 and 0x1 - values currently used by strace)
> 
>     or
> 
> (c) Add ptrace(PTRACE_CONT2/SYSCALL2/SINGLESTEP2) with the semantic of
> "do gdb hacky restart under group-stop, if tracee is indeed under group-stop".
> I like it less because we have at least three restarting PTRACE_foo,
> maybe even four if we want to have DETACH2 too.
> Duplicating every one of them feels ugly.
> 
>     or
> 
> (d) Add a ptrace option PTRACE_O_IGNORE_JOB_STOP which can be set/cleared
> by PTRACE_SETOPTIONS and which modifies ptrace-restart behavior.
> gdb will set the option before it wants to do
> "restart-which-ignores-group-stop", and clears it again when it
> no longer wants it. In the example above:
>     # gdb -p applicationpid
>     (gdb) print getpid() # sets IGNORE_JOB_STOP before PTRACE_CONT(0)
>     (gdb) print show_me_your_internal_debug_dump() # sets IGNORE_JOB_STOP
>     (gdb) continue       # clears IGNORE_JOB_STOP before PTRACE_CONT(0)

I don't think any such hack is necessary.  We just need to let the
ptracer know what's going on.  There's no need to discern between trap
resume and group stop resume.  Anyways, will come back soon with a
proposal.

Thanks.

-- 
tejun
