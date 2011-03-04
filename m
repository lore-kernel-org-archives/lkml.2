Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294Ab1CDNlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 08:41:32 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48204 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1CDNlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 08:41:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Tv8K9Mg7OBscg3Y6WX3KpeVTahADigNPv8JJbY+L2s/5P+3MEKkvaoZAJWLEhC/Y09
         8piui3Vtwu55ewMzxos6wU8De6P28MxSpyJE5uv2jv8K/8QxBvJa2q/MD03Tg0Wp5Fff
         Io57Dw4PnTO2Iw6j14uy208mzjNp9zKWZI7oU=
Date: Fri, 4 Mar 2011 14:41:26 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110304134126.GL20499@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110303173422.GA27960@redhat.com>
 <20110303202246.GB32152@redhat.com>
 <AANLkTikeCzr-OGkmaaortS7_rR+JCM9B6aJV0c52EMbE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikeCzr-OGkmaaortS7_rR+JCM9B6aJV0c52EMbE@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Mar 04, 2011 at 02:01:04PM +0100, Denys Vlasenko wrote:
> I think whatever new attach operation we invent needs to provide
> a way to know whether attached task is stopped or not.
> 
> If debugger wants to say "please continue doing whatever
> you were doing before attachment", then, using this information,
> debugger can decide whether to do PTRACE_CONT(0) and
> sleep on waitpid, or _don't_ do PTRACE_CONT(0) and
> sleep on waitpid.

Definitely.

> > Now, if SIGCONT comes (from anywhere) it clears SIGNAL_STOP_STOPPED,
> > the tracee traps and reports this event to debugger.
> 
> And again, I would like to ask you kernel guys to give
> userspace a way to distinguish this stop from other possible stops.
> 
> IOW: debugger PTRACE_SYSCALL(0)'ed a job control stopped task.
> Debugger gets WIFSTOPPED, WSTOPSIG = SIGTRAP.
> Debugger wants to know: is it a "syscall entry/exit" stop
> or an "end of job control stop" stop?
> Preferably without the need to query PTRACE_GETSIGINFO
> on every SIGTRAP - that'd slow strace down a lot.

There's no question that it should be distinguishible.  I was still
mostly thinking about siginfo tho.  Is PTRACE_GETSIGINFO such big
deal?  It's a very simple syscall.  It enters kernel, copyout the
structure and returns.  Are you interested in adding GET_SIGINFO call
to the current ptrace and see how much things actually slow down?

> I imagine one way to do it is to #define a PTRACE_EVENT_foo
> for "end of job control stop" stop and return it in high byte
> of waitpid status, just like other PTRACE_EVENTs are returned today.

Maybe but I'm not fully sure yet because I think for debuggers the
group stop status needs to be available for other ptrace traps too, so
it might really not fit there.  I'd like to avoid twisting debugging
API for performance.  As I wrote before, if this actually is a problem
and can't be done cleanly without siginfo, I think a better way would
be using vdso but that's a bit of complexity and would require some
numbers to justify the complexity.

Thanks.

-- 
tejun
