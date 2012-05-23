Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625Ab2EWOyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:54:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290Ab2EWOyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:54:11 -0400
Date: Wed, 23 May 2012 16:52:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] pidns: Guarantee that the pidns init will be the last
	pidns process reaped. v2
Message-ID: <20120523145239.GA20378@redhat.com>
References: <8762c87rrd.fsf_-_@xmission.com> <20120516183920.GA19975@redhat.com> <878vgrsv7q.fsf@xmission.com> <20120517170015.GA12436@redhat.com> <87d3628oqa.fsf@xmission.com> <20120518123911.GA417@redhat.com> <87zk95kper.fsf@xmission.com> <20120521124414.GA20391@redhat.com> <87d35x5ank.fsf_-_@xmission.com> <20120522122315.c3f2118c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120522122315.c3f2118c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22, Andrew Morton wrote:
>
> On Mon, 21 May 2012 18:20:31 -0600
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
> > +		/* If we are the last child process in a pid namespace
>
> like this:
> 		/*
> 		 * If ...
>
> > +		 * to be reaped notify the child_reaper.
>
> s/reaped/reaped,/
>
> More seriously, it isn't a very good comment.  It tells us "what" the
> code is doing (which is pretty obvious from reading it), but it didn't
> tell us "why" it is doing this.  Why do PID namespaces need special
> handling here?  What's the backstory??

Well, this is documented in the changelog but I agree, this needs some
documentation.

Perhaps zap_pid_ns_processes() should document that it waits for the
stealth EXIT_DEAD tasks, and __unhash_process() can simply say
"see zap_pid_ns_processes()".

> > @@ -189,6 +189,17 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
> >  		rc = sys_wait4(-1, NULL, __WALL, NULL);
> >  	} while (rc != -ECHILD);
> >
> > +	read_lock(&tasklist_lock);
> > +	for (;;) {
> > +		__set_current_state(TASK_UNINTERRUPTIBLE);
> > +		if (list_empty(&current->children))
> > +			break;
> > +		read_unlock(&tasklist_lock);
> > +		schedule();
> > +		read_lock(&tasklist_lock);
> > +	}
> > +	read_unlock(&tasklist_lock);
>
> Well.
>
> a) This loop can leave the thread in state TASK_UNINTERRUPTIBLE,
>    which looks wrong.

OOPS. You fixed this in *-fix.patch, thanks.

> b) Given that the waking side is also testing list_empty(), I think
>    you might need set_current_state() here, with the barrier.  So that
>    this thread gets the correct view of the list_head wrt the waker's
>    view.

We rely on tasklist_lock, note that the waking side takes it for writing.

> c) Did we really need to bang on tasklist_lock so many times?  There
>    doesn't seem a nicer way of structuring this :(

See above.

We do not really need tasklist_lock to wait for list_empty(children),
we could add a couple of barriers or use wait_event(wait_chldexit).
But the explicit usage of tasklist makes the code more understandable,
this this way we obviously can't race with the child doing release_task(),
say, we can't return before the last detach_pid(PIDTYPE_PID).

As for re-structuring, I'd suggest

	for (;;) {
		bool need_wait = false;

		read_lock(&tasklist_lock);
		if (!list_empty(&current->children)) {
			__set_current_state(TASK_UNINTERRUPTIBLE);
			need_wait = true;
		}
		read_unlock(&tasklist_lock);

		if (!need_wait)
			break;
		schedule();
	}

but this is subjective.

Oleg.

