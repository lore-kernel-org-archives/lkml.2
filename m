Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab1IBODe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 10:03:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab1IBODd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 10:03:33 -0400
Date: Fri, 2 Sep 2011 16:00:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, bblum@andrew.cmu.edu, fweisbec@gmail.com,
        neilb@suse.de, paul@paulmenage.org, paulmck@linux.vnet.ibm.com
Subject: Re: +
	cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch
	added to -mm tree
Message-ID: <20110902140015.GA31530@redhat.com>
References: <201109012108.p81L8X0b029484@imap1.linux-foundation.org> <20110902123706.GB26764@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902123706.GB26764@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to mention, sorry...

That said, I believe the patch is correct and should fix the problem.

On 09/02, Oleg Nesterov wrote:
>
> > From: Ben Blum <bblum@andrew.cmu.edu>
> >
> > Fix unstable tasklist locking in cgroup_attach_proc.
> >
> > According to this thread - https://lkml.org/lkml/2011/7/27/243 - RCU is
> > not sufficient to guarantee the tasklist is stable w.r.t.  de_thread and
> > exit.  Taking tasklist_lock for reading, instead of rcu_read_lock, ensures
> > proper exclusion.
>
> I still think we should avoid the global lock.
>
> In any case, with tasklist or siglock,
>
> > -	rcu_read_lock();
> > +	read_lock(&tasklist_lock);
> >  	if (!thread_group_leader(leader)) {
> >  		/*
> >  		 * a race with de_thread from another thread's exec() may strip
> > @@ -2036,7 +2036,7 @@ int cgroup_attach_proc(struct cgroup *cg
> >  		 * throw this task away and try again (from cgroup_procs_write);
> >  		 * this is "double-double-toil-and-trouble-check locking".
> >  		 */
> > -		rcu_read_unlock();
> > +		read_unlock(&tasklist_lock);
> >  		retval = -EAGAIN;
>
> this check+comment becomes completely pointless and imho very confusing.
>
> Oleg.

