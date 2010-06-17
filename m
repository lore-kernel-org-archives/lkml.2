Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911Ab0FQAr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 20:47:28 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60859 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571Ab0FQAr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 20:47:26 -0400
Date: Wed, 16 Jun 2010 17:46:24 -0700
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
Message-ID: <20100617004624.GR24749@outflux.net>
References: <20100616221833.GM24749@outflux.net>
 <20100616231006.34A28403D2@magilla.sf.frob.com>
 <20100616233937.GQ24749@outflux.net>
 <20100617001114.A90F5403D2@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617001114.A90F5403D2@magilla.sf.frob.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 05:11:14PM -0700, Roland McGrath wrote:
> > Though, honestly, just trying to get rid of PTRACE seems like the better
> > place to spend time.
> 
> Crushing irony of telling *me* this duly noted.  ;-)
> I am not really sure what deeply different set of security constraints
> you envision on any other kind of new debugger interface that would be
> any different for the concerns you've expressed, though.

I haven't though too much about replacements, but it seems like having
a way for processes to declare who/what can debug them is the way to go.
I realize this is very close to MAC policy, but having this be more
general-purpose seems valuable.

Like, a different version of PTRACE_TRACEME, something like PTRACE_BY_YOU.
Imagined example with total lack of error checking and invalid syntax...

void segfault_handler(void) {
	pid = horrible_dbus_insanity("spawn a debugger");
	prctl(PR_SET_DEBUGGER, pid);
}

PTRACE_TRACEME would be effectively the same as:

void segfault_handler(void) {
	if (pid = fork()) {
		execl(debugger,getppid());
		exit(1);
	} else {
		prctl(PR_SET_DEBUGGER, pid);
	}
}

> > > I suspect you really want to test same_thread_group(walker, current).
> > > You don't actually mean to rule out a debugger that forks children with
> > > one thread and calls ptrace with another, do you?
> > 
> > Won't they ultimately have the same parent, though?
> 
> Sure, those debugger threads will have the same parent, such as the shell
> that spawned the debugger.  But your "security" check is that the caller of
> ptrace is a direct ancestor of the tracee.  The ancestry of that ptrace
> caller is immaterial.

Ah right, sorry, I was being too literal (thought in your example the
parent didn't fork a debugger and called ptrace on its children).

Right, this would probably solve the Chrome case, but not KDE, which seems
to fork the crash handler from very far away.  I haven't looked too closely
there yet.

-Kees

-- 
Kees Cook
Ubuntu Security Team
