Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab2D2JtM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 05:49:12 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:40456 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750945Ab2D2JtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 05:49:10 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18I0o4sgyYIZjQp+XvLyEfgGpMXttULq5zvEe1NiN
	8JTCtUdAf/qFUY
Message-ID: <1335692945.7442.7.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] namespaces: fix leak on fork() failure
From: Mike Galbraith <efault@gmx.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
Date: Sun, 29 Apr 2012 11:49:05 +0200
In-Reply-To: <m14ns355ru.fsf@fess.ebiederm.org>
References: <1335604790.5995.22.camel@marge.simpson.net>
	 <20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-29 at 00:57 -0700, Eric W. Biederman wrote:

> Mike's proposed change to switch_task_namespace is most definitely not
> correct.  This will potentially get called on unshare and so we don't
> limit ourselves to just an exit pid_namespace.  The result is that we
> could free the proc mount long before it is safe.

!new && !(p->flags & PF_EXITING) should prevent that..

> At the same time the leak that Mike detected is most definitely real.
> 
> > Perhaps it would be more clean to add the explicit
> >
> > 	 bad_fork_cleanup_namespaces:
> > 	+	if (unlikely(clone_flags & CLONE_NEWPID))
> > 	+		pid_ns_release_proc(...);
> > 		exit_task_namespaces(p);
> > 		
> > 		
> > code into this error path in copy_process?
> 
> For now Oleg your minimal patch looks good.

..but yeah, that looks much nicer.

> Part of me would like to call proc_flush_task instead of
> pid_ns_release_proc but we have no assurance task_pid and task_tgid are
> valid when we get here so proc_flush_task is out.

I only discovered pid_ns_release_proc() exists after didn't work :)

-Mike

