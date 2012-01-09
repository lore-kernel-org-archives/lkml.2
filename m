Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab2AIPNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:13:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704Ab2AIPM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:12:59 -0500
Date: Mon, 9 Jan 2012 16:07:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Kay Sievers <kay.sievers@vrfy.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH] prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow
	simple process supervision
Message-ID: <20120109150701.GB1777@redhat.com>
References: <1325951797.860.10.camel@mop> <124669.1325952830@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <124669.1325952830@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07, Valdis.Kletnieks@vt.edu wrote:
>
> On Sat, 07 Jan 2012 16:56:37 +0100, Kay Sievers said:
> > Resending this, it got lost last year's September.
> >
> > We still need it to properly implement init-like service managers.
>
> > From: Lennart Poettering <lennart@poettering.net>
> > Subject: prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow simple process supervision
>
> > Users of this will be the systemd per-user instance, which provides
> > init-like functionality for the user's login session and D-Bus, which
> > activates bus services on-demand. Both need init-like capabilities
> > to be able to properly keep track of the services they start.
>
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -552,6 +552,18 @@ struct signal_struct {
> >  	int			group_stop_count;
> >  	unsigned int		flags; /* see SIGNAL_* flags below */
> >
> > +	/*
> > +	 * PR_SET_CHILD_SUBREAPER marks a process, like a service
> > +	 * manager, to re-parent orphan (double-forking) child processes
> > +	 * to this process instead of 'init'. The service manager is
> > +	 * able to receive SIGCHLD signals and is able to investigate
> > +	 * the process until it calls wait(). All children of this
> > +	 * process will inherit a flag if they should look for a
> > +	 * child_subreaper process at exit.
> > +	 */
> > +	unsigned int		is_child_subreaper:1;
> > +	unsigned int		has_child_subreaper:1;
>
> Is there someplace we can stick these two fields where they won't expand the
> signal_struct?  Can we stick them in signal_struct->flags instead?

Yes, it would be better to use signal_struct->flags. But we can't do this
until we cleanup the usage of ->flags. For example, task_participate_group_stop
simply does sig->flags = SIGNAL_STOP_STOPPED.


> > +		/* find the first ancestor marked as child_subreaper */
> > +		for (reaper = father->real_parent;
> > +		     reaper != &init_task;
> > +		     reaper = reaper->real_parent) {
>
> I admit being insufficiently caffienated - does this DTRT in a PID namespace? That
> &init_task looks fishy to me...

Probably this needs a comment. Initially I was confused too.

Note that the code below checks same_thread_group(reaper, pid_ns->child_reaper),
this is what we need to DTRT in a PID namespace. However we still need the
check above, see http://marc.info/?l=linux-kernel&m=131385460420380

Oleg.

