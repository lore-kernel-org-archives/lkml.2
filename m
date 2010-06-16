Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890Ab0FPXLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 19:11:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab0FPXLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 19:11:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Kees Cook <kees.cook@canonical.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
In-Reply-To: Kees Cook's message of  Wednesday, 16 June 2010 15:18:33 -0700 <20100616221833.GM24749@outflux.net>
References: <20100616221833.GM24749@outflux.net>
X-Windows: garbage at your fingertips.
Message-Id: <20100616231006.34A28403D2@magilla.sf.frob.com>
Date: Wed, 16 Jun 2010 16:10:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This constraint seems fairly insane to me, but I don't really care about
people using sysctl to enable insane things if that's what floats your
boat.  GDB's "attach", "strace -p", etc. are pretty normal (and highly
useful) things for ordinary users debugging their own programs.

I tend to think that this constraint offers more a delusion of security
than much real protection.  But I'm too lazy to try to come up with a more
contorted exploit that this wouldn't prevent, so I won't belabor the point.

I think those who are actually paranoid would use something more meaningful
via the LSM ptrace check, like SELinux with a policy that only permits
known debugger applications to use ptrace.  Aside from SELinux, it could
also be done with a new capability like CAP_PTRACE_MINE and filesystem
capabilities on installed debugger application binaries, for example.

You've described this as allowing ptrace on "children", but really it's
"unorphaned descendants", i.e. also children of children, etc.

I don't think "task->pid > 0" is a sort of check that is used elsewhere in
the kernel for this.  Perhaps "task == &init_task" would be better.

It's not immediately obvious to me how this interacts with pid_ns, or
should.  Probably it shouldn't pay attention to pid_ns, as it doesn't.
But I think it merits an explicit statement of intent about that.

I suspect you really want to test same_thread_group(walker, current).
You don't actually mean to rule out a debugger that forks children with
one thread and calls ptrace with another, do you?

Oh, and surely you meant real_parent.  Off hand I think that might only
really add up to a different constraint if you had some ptrace attaches
already live when you did set the sysctl flag.  But I have the vague
sensation I'm overlooking some other arcane case.  And it just doesn't
logically match the stated intent of the thing to depend on parent
rather than real_parent.


Thanks,
Roland
