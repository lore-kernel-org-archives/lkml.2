Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab0FPXko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 19:40:44 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54104 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815Ab0FPXkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 19:40:42 -0400
Date: Wed, 16 Jun 2010 16:39:37 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
Message-ID: <20100616233937.GQ24749@outflux.net>
References: <20100616221833.GM24749@outflux.net>
 <20100616231006.34A28403D2@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616231006.34A28403D2@magilla.sf.frob.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 16, 2010 at 04:10:06PM -0700, Roland McGrath wrote:
> This constraint seems fairly insane to me, but I don't really care about
> people using sysctl to enable insane things if that's what floats your
> boat.  GDB's "attach", "strace -p", etc. are pretty normal (and highly
> useful) things for ordinary users debugging their own programs.

Right, but I don't think "ordinary users" debug their own programs.
Ordinary developers and sysadmin do, absolutely, and for them, this
sysctl would probably stay set to 0.

> I tend to think that this constraint offers more a delusion of security
> than much real protection.  But I'm too lazy to try to come up with a more
> contorted exploit that this wouldn't prevent, so I won't belabor the point.

Well, I don't want to present it as something it's not.  It's only
designed to block access to what is immediately in memory.  It certainly
won't stop an attacker from tricking a user into divulging credentials
directly or launching a process and then ptracing it, but it would put
a stop to an automated worm that did not need to go phishing.

> I think those who are actually paranoid would use something more meaningful
> via the LSM ptrace check, like SELinux with a policy that only permits
> known debugger applications to use ptrace.  Aside from SELinux, it could
> also be done with a new capability like CAP_PTRACE_MINE and filesystem
> capabilities on installed debugger application binaries, for example.

This has been the area I've run into the most.  I like the idea of a
semi-privileged capability like you suggest.  It would solve a number
of iffy spots, like KDE and Chrome that fork/exec a debugger from the
crashing process and attach back to it.  Those programs could be given
fscap for CAP_PTRACE_MINE, or something.  Though, honestly, just trying to
get rid of PTRACE seems like the better place to spend time.

> You've described this as allowing ptrace on "children", but really it's
> "unorphaned descendants", i.e. also children of children, etc.

Right, I should say "descendants", which is the correct intent.

> I don't think "task->pid > 0" is a sort of check that is used elsewhere in
> the kernel for this.  Perhaps "task == &init_task" would be better.

Is this correct for pid_ns?  I thought pid 1 (regardless of NS) would have
a NULL parent?

> It's not immediately obvious to me how this interacts with pid_ns, or
> should.  Probably it shouldn't pay attention to pid_ns, as it doesn't.
> But I think it merits an explicit statement of intent about that.

Okay, I can do that.

> I suspect you really want to test same_thread_group(walker, current).
> You don't actually mean to rule out a debugger that forks children with
> one thread and calls ptrace with another, do you?

Won't they ultimately have the same parent, though?

> Oh, and surely you meant real_parent.  Off hand I think that might only
> really add up to a different constraint if you had some ptrace attaches
> already live when you did set the sysctl flag.  But I have the vague
> sensation I'm overlooking some other arcane case.  And it just doesn't
> logically match the stated intent of the thing to depend on parent
> rather than real_parent.

Oh, yes.  That seems right.  I can fix that.

-Kees

-- 
Kees Cook
Ubuntu Security Team
