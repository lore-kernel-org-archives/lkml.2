Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0CVKYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 06:24:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab0CVKYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 06:24:42 -0400
Date: Mon, 22 Mar 2010 11:22:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: Paul Menage <menage@google.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       lizf@cn.fujitsu.com, matthltc@us.ibm.com,
       containers@lists.linux-foundation.org
Subject: Re: [RFC] [PATCH 1/2] cgroups: read-write lock CLONE_THREAD
	forking per threadgroup
Message-ID: <20100322102247.GA8363@redhat.com>
References: <200908202114.n7KLEN5H026646@imap1.linux-foundation.org> <20090821102611.GA2611@redhat.com> <20090821104528.GA3487@redhat.com> <6599ad830908211637w6c9fd3a7tbe41bc106ada03d7@mail.gmail.com> <20090822130952.GA4240@redhat.com> <20100105185330.GA17545@redhat.com> <20100117204833.GA29596@unix38.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100117204833.GA29596@unix38.andrew.cmu.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17, Ben Blum wrote:
>
> On Tue, Jan 05, 2010 at 07:53:30PM +0100, Oleg Nesterov wrote:
> >
> > I don't understand how this can close the race with de_thread().
> > ...
>
> the race with the sighand is handled in the next patch, in attach_proc,
> not in this function.

OK. I didn't verify this, the patches don't apply to 2.6.32-rc, but this
doesn't matter. Please see below.

> > > +	/* now try to find a sighand */
> > > +	if (likely(tsk->sighand)) {
> > > +		sighand = tsk->sighand;
> > > +	} else {
> > > +		sighand = ERR_PTR(-ESRCH);
> > > +		/*
> > > +		 * tsk is exiting; try to find another thread in the group
> > > +		 * whose sighand pointer is still alive.
> > > +		 */
> > > +		list_for_each_entry_rcu(p, &tsk->thread_group, thread_group) {
> > > +			if (p->sighand) {
> > > +				sighand = tsk->sighand;
> >
> > can't understand this "else {}" code... We hold tasklist, if the group
> > leader is dead (->sighand == NULL), then the whole thread group is
> > dead.
> >
> > Even if we had another thread with ->sighand != NULL, what is the point
> > of "if (unlikely(!thread_group_leader(tsk)))" check then?
>
> doesn't the group leader stay on the threadgroup list even when it dies?
> sighand can be null if the group leader has exited, but other threads
> are still running.

No, leader->sighand != NULL until all threads have exited.


Ben, I'd suggest you to redo these patches even if they are correct.
->sighand is not the right place for the mutex/locking

	- it is per CLONE_SIGHAND, not per process

	- we have to avoid the nasty and hard-to-test races with exec

	- we have to play with sighand->count and I really dislike this.
	  this ->count is not just a reference counter, look at
	  unshare_sighand(). Yes, this is fake, but still.

Please use ->signal instead. By the lucky coincidence the lifetime rules
for (greatly misnamed) signal_struct were changed recently in -mm.

With the recent changes, it is always safe to use task->signal. It can't
be changed, can't go away, no need to bump the counter, no races, etc.

What do you think?

Oleg.

