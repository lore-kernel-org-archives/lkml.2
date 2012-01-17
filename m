Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab2AQRrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:47:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab2AQRrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:47:09 -0500
Date: Tue, 17 Jan 2012 18:40:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC] fs, proc: Introduce /proc/<pid>/task/<tid>/children
	entry v6
Message-ID: <20120117174049.GA19268@redhat.com>
References: <20120116153231.GF2998@moon> <20120116161114.GA17727@redhat.com> <20120116162021.GH2998@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116162021.GH2998@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16, Cyrill Gorcunov wrote:
>
> On Mon, Jan 16, 2012 at 05:11:14PM +0100, Oleg Nesterov wrote:
> > On 01/16, Cyrill Gorcunov wrote:
> > >
> > > +get_children_pid(struct proc_pid_children_iter *iter, struct pid *pid_prev, loff_t pos)
> > > +{
> > > +	struct task_struct *start, *task;
> > > +	struct pid *pid = NULL;
> > > +
> > > +	read_lock(&tasklist_lock);
> > > +
> > > +	start = pid_task(iter->pid_start, PIDTYPE_PID);
> > > +	if (!start)
> > > +		goto out;
> > > +
> > > +	/*
> > > +	 * Lets try to continue searching first, this gives
> > > +	 * us significant speedup on children-rich processes.
> > > +	 */
> > > +	if (pid_prev) {
> > > +		task = pid_task(pid_prev, PIDTYPE_PID);
> > > +		if (task && task->real_parent == start &&
> > > +		    !(list_empty(&task->sibling))) {
> >
> > Damn. No, this is wrong.
> >
> > Damn! Yes, it was we who told you to check list_empty(sibling) ;)
> >
> > But this is not enough. exit_ptrace() can do list_move() without
> > changing ->real_parent.
> >
> > I'll try to think. At first glance we can rely on EXIT_DEAD, but
> > I'd like to avoid this, I think EXIT_DEAD should die.
>
> Ouch! Thanks for catching this Oleg. I'll try to come with something
> to show as well.

Do you see another approach? I don't, so I'd suggest to check
"task->exit_state != EXIT_DEAD" instead of !list_empty().

Just in case, we can also check "start->exit_state == 0" instead
of "task->real_parent == start" with the same effect, up to you.

It would be nice to add the comment explaining these checks...

And I forgot to mention, the comment below

	> +			/*
	> +			 * We might miss some freshly created children
	> +			 * here, but it was never promised to be
	> +			 * accurate.
	> +			 */
	> +			if (list_is_last(&task->sibling, &start->children))
	> +				goto out;

looks misleading. Contrary to the slow path, we can't miss the
freshly forked child here, copy_process() does list_add_tail().

But the slow path obviously can skip much more than needed and
miss children (freshly forked or not), probably it would be better
to move the comment down and remove the "freshly created" part.

What do you think?

Oleg.

