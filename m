Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1E3ItN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 04:49:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39437 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab1E3ItL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 04:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N8rAovTqC1iWtq/hNQDdE4X/clgAS80MVs3ioeL/6ws2/a7RL+pyf6siRjc8JuUVPK
         n5M/sTjiZzHqEiKkbzN7+LV7xOYTa/nfRH0RDap/N4nBHXZnupxSY3AH0+rQC5jX2CdS
         g8oOaFkQRG3ASG/bsfuSPV53yKH9k7ocaPuBg=
Date: Mon, 30 May 2011 10:49:06 +0200
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: jan.kratochvil@redhat.com, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: execve-under-ptrace API bug (was Re: Ptrace documentation, draft
 #3)
Message-ID: <20110530084906.GA11773@htj.dyndns.org>
References: <BANLkTikH4k0MfTwNzNJN-P85ER4-hKdifw@mail.gmail.com>
 <20110525143250.GJ10146@htj.dyndns.org>
 <201105300528.17384.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105300528.17384.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Denys.

On Mon, May 30, 2011 at 05:28:17AM +0200, Denys Vlasenko wrote:
> On Wednesday 25 May 2011 16:32, Tejun Heo wrote:
> > > 	1.x execve under ptrace.
> > > 
> > ...
> > >   ** we get death notification: leader died: **
> > >  PID0 exit(0)                            = ?
> > >   ** we get syscall-entry-stop in thread 1: **
> > >  PID1 execve("/bin/foo", "foo" <unfinished ...>
> > >   ** we get syscall-entry-stop in thread 2: **
> > >  PID2 execve("/bin/bar", "bar" <unfinished ...>
> > >   ** we get PTRACE_EVENT_EXEC for PID0, we issue PTRACE_SYSCALL **
> > >   ** we get syscall-exit-stop for PID0: **
> > >  PID0 <... execve resumed> )             = 0
> > > 
> > > ??? Question: WHICH execve succeeded? Can tracer figure it out?
> > 
> > Hmmm... I don't know.  Maybe we can set ptrace message to the original
> > tid?
> 
> The problem with execve is bigger than merely reporting this pid.
>
> Consider how strace tracks its tracees. Currently, it remembers
> their pids - sometimes by remembering clone's return values!
> This is hopelessly broken wrt pid namespaces.

I'm not too familiar with pid namespaces but don't all threads of the
same process belong to the same namespace?  I don't think strace would
need to track pids all the time.  It just needs to store pids of
in-flight exec's and match it on exec completion.  I'm probably
missing something but why wouldn't that work?

> This works (I have a patch against a somewhat older strace),
> but now in light of this "interesting" execve-under-ptrace
> behavior it appears to have a flaw: all threads except the
> execve'ing one disappear without any notification to strace,
> therefore strace doesn't know which tracee data ("struct tcb"
> in strace-speak) need to be dropped!
> 
> I am not sure current strace handles this correctly either.
> I will be very surprised if it does.
> 
> I think the API needs fixing. Tracee must never disappear like that
> on execve (or in any other case). They must always deliver a
> WIFEXITED or WIFSIGNALED notification, allowing tracer to know
> that they are gone. We probably also need to document how are these
> "I died on execve" notifications are ordered wrt PTRACE_EVENT_EXEC
> stop in execve-ing thread.

A problem is that by the time de-threading is in progress, it's
already too deep and there's no way back and the exec'ing thread has
to wait for completion in uninterruptible sleeps - ie. it expects
de-threading to finish in finite amount of time and to achieve that it
basically sends SIGKILL to all other threads.  If we introduce a trap
in de-threading itself, we can easily end up with an unkillable
task.

> Ideas?

But, if necessary, I can think of two other ways,

1. Don't allow more than one thread in the same group enter exec(2)
   path at all.  It's not like parallel execution of exec(2) buys us
   anything anyway.  One thing to be careful about is that binfmt code
   may recurse.

2. Add another trap point right before de-threading commences.  It can
   still back out if de-threading hasn't started yet.  We'll still
   need to add explicit synchronization there but the window would be
   much smaller.

Thanks.

-- 
tejun
