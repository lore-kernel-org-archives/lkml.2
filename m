Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1BDRE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 12:04:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51819 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab1BDRE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 12:04:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sY3e01RawIek0foCqcCvbn50MlmK9nRvENEmWORNkua5VoUw6VuZSYZZIZqEaAymo/
         iYrVO4tE8irPafOVX9FbdFJr3DqLpLzKWBL0ia6nNTOcG/Q92arLr5jjpKanobX4yxvT
         LkZehl8foYo/tvTtGPuHeLNCAqlBf6geTOyZo=
Date: Fri, 4 Feb 2011 18:04:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Stefan Fritsch <sf@sfritsch.de>,
        Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, agl@google.com, tzanussi@gmail.com,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, James Morris <jmorris@namei.org>
Subject: Re: Using ftrace/perf as a basis for generic seccomp
Message-ID: <20110204170448.GA1808@nowhere>
References: <1294867725.3237.230.camel@localhost.localdomain>
 <1296665124.3145.17.camel@localhost.localdomain>
 <20110203190643.GC1769@nowhere>
 <201102032306.34251.sf@sfritsch.de>
 <20110203231051.GA1840@nowhere>
 <1296784230.3145.44.camel@localhost.localdomain>
 <1296829915.26581.658.camel@laptop>
 <1296836962.3145.75.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296836962.3145.75.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 11:29:19AM -0500, Eric Paris wrote:
> On Fri, 2011-02-04 at 15:31 +0100, Peter Zijlstra wrote:
> > On Thu, 2011-02-03 at 20:50 -0500, Eric Paris wrote:
> > > I'm going to try to work on it over
> > > the next week or two.  
> > 
> > What is your use-case? Going by: http://lwn.net/Articles/332990/ syscall
> > based stuff (seccomp) is broken by design.
> 
> My personal goal is very different than an LSM.  My goal is to reduce
> attack surface.  I'm not trying to implement an LSM.  LSM hooks are
> (intentionally) placed in the kernel after object resolution is
> complete.  In an LSM we don't check 'open' type operation until after
> the pathname has been converted to an inode.  We don't check some
> 'sendto' operations until after the data has been placed into an skb and
> is about to be queued to a socket.  There is a LOT of code between
> syscall_entry() and any given LSM hook.
> 
> An obvious vulnerability that I'm sure all the people involved here know
> would be the original perf syscall bounds checking vulnerability.  If
> I'm dealing with an application that I know will never use perf I'd like
> a way to be able to completely disable the perf syscall and greatly
> reduce the kernel attack surface.  It would be almost impossible for an
> LSM to hook between the syscall_enter() and the location of that
> vulnerability in the perf syscall.  In my particular case I'm thinking
> about qemu, which never needs to call perf.  I want a way to disable all
> of the code after syscall_enter() for huge swaths of the kernel.
> 
> What we have today, called "seccomp", is a one way toggle,
> prctl(PR_SET_SECCOMP, 1), which reduces the available syscalls to
> read,write,exit, and sigreturn.  Any other syscall results in a process
> being immediately killed.  It's a great idea to reduce the attack
> surface of the kernel but it is too inflexible to be useful.  I wonder
> if anyone is using it.
> 
> Qemu on my box in just a couple of seconds of strace was found to use
> futex, ioctl, read, rt_sigaction, select, timer_gettime, timer_settime,
> and write.  I'm sure that other well defined processes have other such
> sort lists of required syscalls.  I think a more flexible seccomp which
> lets one remove syscalls from the allowed set (but never add them back)
> can GREATLY reduce the kernel attack surface from malicious processes.
> 
> This is not a sandbox.  This is not an LSM replacement.  This is a per
> syscall cutoff.  It can be used to help build a stronger sandbox.  I'll
> likely see if this can't be used by the SELinux sandbox which already
> uses the LSM hooks to control information flow and mediate access.  But
> SELinux does not control the sheer amount of the kernel code that can be
> executed.  I believe we can build a stronger sandbox using a flexible
> seccomp as one of the tools.  All we have to do is find one
> vulnerability in the code between the syscall entry and a LSM hook which
> would deny to operation to see the value in a per syscall control
> mechanism.
> 
> As to doing it in seccomp code where it's all of a syscall or none vs
> making use of the filter infrastructure to allow even more fine grained
> control over the syscall is a question.  I'm leaning more towards just
> doing it in seccomp.  We can't ever build a full and complete strong
> sandbox using the filter code.  James' assertions about copy_from_user()
> are obviously correct.  A chat with PeterZ privately on IRC indicated
> that he also was not interested in seeing this creep into the tracing
> code.

Note it's not about tracing here. It's about abstracting some tracing
features to make them standalone and usable outside tracing.

But yeah, now that I consider the fact that checks on pointers are
racy until objects are resolved (got my first security lesson), such
deep filtering up to dereferencing pointers is then pointless.

Now there are still immediate values for which there is still a point
(filtering fd, filtering opening mode, etc...).

>  Do we have a user that can articulate a need for greater
> flexibility in their use of such a hardening tool?

So yeah, indeed we probably need to get more usecases to consider it.
