Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030214Ab2ERMkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 08:40:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759667Ab2ERMkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 08:40:41 -0400
Date: Fri, 18 May 2012 14:39:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 2/3] pidns: Guarantee that the pidns init will be the
	last pidns process reaped.
Message-ID: <20120518123911.GA417@redhat.com>
References: <20120429165846.GA19054@redhat.com> <1335754867.17899.4.camel@marge.simpson.net> <m1zk9rmyh4.fsf@fess.ebiederm.org> <20120501134214.f6b44f4a.akpm@linux-foundation.org> <87havs7rvv.fsf_-_@xmission.com> <8762c87rrd.fsf_-_@xmission.com> <20120516183920.GA19975@redhat.com> <878vgrsv7q.fsf@xmission.com> <20120517170015.GA12436@redhat.com> <87d3628oqa.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d3628oqa.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > What do you think?
>
> I think there is something very compelling about your solution,
> we do need my bit about making the init process ignore SIGCHLD
> so all of init's children self reap.

Not sure I understand. This can work with or without 3/3 which
changes zap_pid_ns_processes() to ignore SIGCHLD. And just in
case, I think 3/3 is fine.

And once again, this wait_event() + __wake_up_parent() is very
simple and straightforward, we can cleanup this code later if
needed.


> > Do you mean the "if (tsk->ptrace)" code in exit_notify() ? Nobody
> > understand it ;) Last time this code was modified by me (iirc), but
> > I simply tried to preserve the previous behaviour.
>
> Yes.  It is some pretty strange code.

Yes. In particular, I think it should always use SIGCHLD.

> Especially where we are reading
> a return result which is always false.  I think there is a bug somewhere
> between that code and ptrace detach

Yes. This is the known oddity. We always notify the tracer if the
leader exits, even if !thread_group_empty(). But after that the
tracer can't detach, and it can't do do_wait(WEXITED).

The problem is not that we can't "fix" this. Just any discussed
fix adds the subtle/incompatible user-visible change.

Oleg.

