Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab1EXMgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 08:36:14 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:36951 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab1EXMgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 08:36:13 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Date: Tue, 24 May 2011 13:36:03 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-28-generic; KDE/4.6.2; x86_64; ; )
Cc: Denys Vlasenko <vda.linux@googlemail.com>, oleg@redhat.com,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <201105241049.58921.pedro@codesourcery.com> <20110524120013.GD10334@htj.dyndns.org>
In-Reply-To: <20110524120013.GD10334@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105241336.04298.pedro@codesourcery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 May 2011 13:00:13, Tejun Heo wrote:
> Hello,
> 
> On Tue, May 24, 2011 at 10:49:58AM +0100, Pedro Alves wrote:
> > A couple interface questions that just crossed my mind:
> > 
> >  - on a fork/vfork/clone, if PTRACE_EVENT_FORK|VFORK|CLONE have been
> >    enabled, will the tracer still see the new child stop with a
> >    SIGSTOP, or will it see a PTRACE_EVENT_INTERRUPT?
> 
> This won't change, so SIGSTOP although we probably want to improve it
> such that this can be distinguished from SIGTRAP from userland.

(I assume you meant SIGSTOP from userland.)  So that if a SIGSTOPs
from userland is sent before the tracer waits for the child, the
tracer sees a siginfo corresponding to the userland SIGSTOP?  Sounds
like it might work.

> >  - is PTRACE_INTERRUPT on PTRACE_TRACEME-traced-child planed to
> >    be allowed (for convenience)?
> >    A PTRACE_O_TRACEINTERRUPT, or some such PTRACE_SETOPTIONS
> >    option might be necessary to get PTRACE_EVENT_INTERRUPT instead
> >    of SIGSTOP in the point above.
> 
> I'm currently leaning toward deprecating PTRACE_TRACEME.  If a task
> can PTRACE_TRACEME, it may as well just do pause(2) and let the parent
> SEIZE it.

Debuggers will want to nurse the child through a couple of
execs (shell, then real debuggee), so that scheme requires a bit
more synchronization, because SEIZE hides the magic exec SIGTRAP,
and so the tracer needs to set the O_TRACEXEC option before the first
exec, and make sure external signals don't break the synchronization.
Reading/writing to/from blocking pipes for that initial synchronization
is what GDB uses instead for e.g., hpux/ttrace support, which looks
similar to using PTRACE_SEIZE for PTRACE_TRACEME.  A bit more
cumbersome, though doable, I suppose.

Thanks.

-- 
Pedro Alves
