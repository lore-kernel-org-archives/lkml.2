Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab1EXOCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:02:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41396 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1EXOCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:02:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K4ZPyCGr4MXjYPRLiO6VWnzFi0K9UGSn8PwkzV67SWeBFWkNnNLgNXwa7FKMXjmUEe
         QXXh2FFDqIVTnm3Th4u4emBBQeTm2N+NBMlHRE6vUzAyt2iJWeoEEUGlCYQXluMJ0LRp
         HuBv2+j2gHkRpAOK4K06vswIB56ubFyYjChKI=
Date: Tue, 24 May 2011 16:02:15 +0200
From: Tejun Heo <tj@kernel.org>
To: Pedro Alves <pedro@codesourcery.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, oleg@redhat.com,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110524140215.GF10334@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <201105241049.58921.pedro@codesourcery.com>
 <20110524120013.GD10334@htj.dyndns.org>
 <201105241336.04298.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105241336.04298.pedro@codesourcery.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 24, 2011 at 01:36:03PM +0100, Pedro Alves wrote:
> On Tuesday 24 May 2011 13:00:13, Tejun Heo wrote:
> > Hello,
> > 
> > On Tue, May 24, 2011 at 10:49:58AM +0100, Pedro Alves wrote:
> > > A couple interface questions that just crossed my mind:
> > > 
> > >  - on a fork/vfork/clone, if PTRACE_EVENT_FORK|VFORK|CLONE have been
> > >    enabled, will the tracer still see the new child stop with a
> > >    SIGSTOP, or will it see a PTRACE_EVENT_INTERRUPT?
> > 
> > This won't change, so SIGSTOP although we probably want to improve it
> > such that this can be distinguished from SIGTRAP from userland.
> 
> (I assume you meant SIGSTOP from userland.)  So that if a SIGSTOPs
> from userland is sent before the tracer waits for the child, the
> tracer sees a siginfo corresponding to the userland SIGSTOP?  Sounds
> like it might work.

Now that thinking more about it, TRAP_STOP (INTERRUPT trap) would
probably be better.  I'll think more about it.  For fork, it doesn't
really matter but deliverying SIGSTOP on CLONE isn't too good.  From
user's POV, TRAP_STOP should work too, right?

> > I'm currently leaning toward deprecating PTRACE_TRACEME.  If a task
> > can PTRACE_TRACEME, it may as well just do pause(2) and let the parent
> > SEIZE it.
> 
> Debuggers will want to nurse the child through a couple of
> execs (shell, then real debuggee), so that scheme requires a bit
> more synchronization, because SEIZE hides the magic exec SIGTRAP,
> and so the tracer needs to set the O_TRACEXEC option before the first
> exec, and make sure external signals don't break the synchronization.
> Reading/writing to/from blocking pipes for that initial synchronization
> is what GDB uses instead for e.g., hpux/ttrace support, which looks
> similar to using PTRACE_SEIZE for PTRACE_TRACEME.  A bit more
> cumbersome, though doable, I suppose.

Yes, it would require some sort of synchronization.  I was thinking
more along the line of ptracer modifying tracee so that it exits
pause(2) loop after ptracer issues PTRACE_CONT, but I agree using
pipes would be more straight-forward.

Thank you.

-- 
tejun
