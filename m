Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2JMTin (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 15:38:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40950 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab2JMTim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 15:38:42 -0400
Date: Sat, 13 Oct 2012 20:38:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: [RFC] desired behaviour of syscall tracing wrt fork()
Message-ID: <20121013193839.GU2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	There's a lovely incosistency regarding whether we call
trace_sys_exit() for child process on return from fork()/clone()/etc.
The current situation:
	* called on amd64 for 32bit newborns
	* *NOT* called on i386 or amd64 for 64bit ones
	* not called on arm
	* called on ppc, s390, sh and sparc64
	* not wired on anything else
Note that existing in-kernel users of that tracepoint (ftrace and perf)
both at least attempt to bail out in that situation.  However, the
way it's done is not guaranteed to work if we wire more architectures -
it relies on syscall_get_nr() returning negative in child, which might
or might not work everywhere.  If nothing else, it's a landmine to
avoid...

	FWIW, I'd vote for not calling syscall_trace_...() on the way
from ret_from_fork() - nothing in there really wants to be called
for newborns; e.g. TIF_SYSCALL_TRACE is explicitly turned off for
newborns, audit_syscall_exit() will not see ->in_syscall set and will
log nothing and existing users of trace_sys_exit() at least attempt
to skip doing anything on those.

	Comments?  AFAICS, it's not that much surgery to do...
