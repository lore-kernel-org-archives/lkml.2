Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab1EIJsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 05:48:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33417 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1EIJsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 05:48:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AQanbOl3MFG+JzjRb8bhIA5ZqSqH7V+fW1uV+gzbliyMMQ36BFwCsGQG8fPEow97bv
         Bv/Vl99m5bsTF6Hxvbq8WCu+1VbrpxxNoGbrWI2dKzlBozFY3QG7ViXMs+XKaqfkJQfR
         i8Lxo0p804nywoY0n9MYG9OXdVvfiAxhDXa5A=
Date: Mon, 9 May 2011 11:48:39 +0200
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and
 group stop notification
Message-ID: <20110509094839.GG1661@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <201105090027.41534.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105090027.41534.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 09, 2011 at 12:27:41AM +0200, Denys Vlasenko wrote:
> > After PTRACE_SEIZE, tracee will trap.
> 
> So which is it? Does PTRACE_SEIZE trap or not?

PTRACE_SEIZE attaches to a new tracee and traps it.  INTERRUPT traps
already attached tracee.

> > * Group stop notification is implemented as sticky INTERRUPT trap
> >   which gets cleared on PTRACE_GETSIGINFO and notifies both start and
> >   end of group stops.
> > ...
> > * The trap condition is sticky until GETSIGINFO.  This is necessary
> >   because generation of the event may race with CONT and ptracer may
> >   miss the trap.
> 
> As a userspace guy, I find this explanation unclear.
> 
> What is "sticky" exactly? siginfo.si_pt_flags contents?
> 
> What exactly "sticky" means? If PTRACE_GETSIGINFO is not queried
> by userspace after it observed ptrace stop, what will happen?

It means that INTERRUPT trap will happen repeatedly until the
condition is cleared by PTRACE_GETSIGINFO.

> Real world users of ptrace, such as strace, will likely avoid
> PTRACE_GETSIGINFO'ing on every stop - they will examine wait status,
> and query PTRACE_GETSIGINFO only if they know they have to -
> such as when they see a job stop signal (SIGSTOP/SIGTSTP/etc),
> not SIGTRAP.
>
> Is it still possible, or PTRACE_GETSIGINFO will be a mandatory call
> after each ptrace stop for any userspace usage which wants to track
> job stop status of the tracee?

You can tell INTERRUPT trap from the exit_code stored in si_status
(si_code CLD_TRAPPED and si_status SIGTRAP | (PTRACE_EVENT_INTERRUPT
<< 8)), so you can call GETSIGINFO only after INTERRUPT traps, which
should be enough for job control notifications, but you would also
have to do GETSIGINFO to discern signal delivery and actual group stop
traps (si_code zero and si_status is the signo for both).

> I don't know the status of ptrace test suite after I stopped working
> on strace (did the suite bit rot, or is it maintained and still
> relevant?). If it is still in use, I can adapt these tests and add
> them to it.

I have no idea but am planning write more complete example program.
The ones included in the commit messages are mostly just to show that
the basic functionality implemented by the commit works, so they
aren't necessarily good examples.

Thank you.

-- 
tejun
