Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab1IHXCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:02:09 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:53190 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab1IHXCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:02:03 -0400
Date: Thu, 8 Sep 2011 14:58:05 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, neilb@suse.de,
        paul@paulmenage.org, paulmck@linux.vnet.ibm.com
Subject: Re: +
 cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch added to
 -mm tree
Message-ID: <20110908185805.GB15434@ghc03.ghc.andrew.cmu.edu>
References: <201109012108.p81L8X0b029484@imap1.linux-foundation.org>
 <20110902123706.GB26764@redhat.com>
 <20110902140015.GA31530@redhat.com>
 <20110902141550.GA24012@unix33.andrew.cmu.edu>
 <20110902155534.GA4595@redhat.com>
 <20110907235931.GA22545@unix33.andrew.cmu.edu>
 <20110908173559.GA26492@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908173559.GA26492@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_3000_3999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 07:35:59PM +0200, Oleg Nesterov wrote:
> On 09/07, Ben Blum wrote:
> >
> > On Fri, Sep 02, 2011 at 05:55:34PM +0200, Oleg Nesterov wrote:
> > > On 09/02, Ben Blum wrote:
> > > >
> > > > But I don't think the check becomes pointless? If a sub-thread execs
> > > > right before read_lock(&tasklist_lock) (but after the find_task_by_vpid
> > > > in attach_task_by_pid), that causes the case that the comment refers to.
> > >
> > > How so? The comment says:
> > >
> > > 	* a race with de_thread from another thread's exec() may strip
> > > 	* us of our leadership, making while_each_thread unsafe
> > >
> > > This is not true.
> >
> > Sorry, the comment is unclear.
> 
> No, the comment is clear. In fact it was me who pointed out we can't
> do while_each_thread() blindly. And now I am tried to confuse you ;)
> 
> So, sorry for noise, and thanks for correcting me. Somehow I forgot
> this is not safe even under tasklist.
> 
> Partly I was confused because I was thinking about the patch I suggested,
> if we use ->siglock we are safe. If lock_task_sighand(task) succeeds,
> this task should be on list.
> 
> Anyway, I was wrong, sorry.
> 
> Oleg.

All right, no problem.

As for the patch below (which is the same as it was last time?): did you
mean for Andrew to replace the old tasklist_lock patch with this one, or
should one of us rewrite this against it? either way, it should have
something like the comment I proposed in the first thread.

Thanks,
Ben

> 
> --- x/kernel/cgroup.c
> +++ x/kernel/cgroup.c
> @@ -2000,6 +2000,7 @@ int cgroup_attach_proc(struct cgroup *cg
>  	/* threadgroup list cursor and array */
>  	struct task_struct *tsk;
>  	struct flex_array *group;
> +	unsigned long flags;
>  	/*
>  	 * we need to make sure we have css_sets for all the tasks we're
>  	 * going to move -before- we actually start moving them, so that in
> @@ -2027,19 +2028,10 @@ int cgroup_attach_proc(struct cgroup *cg
>  		goto out_free_group_list;
>  
>  	/* prevent changes to the threadgroup list while we take a snapshot. */
> -	rcu_read_lock();
> -	if (!thread_group_leader(leader)) {
> -		/*
> -		 * a race with de_thread from another thread's exec() may strip
> -		 * us of our leadership, making while_each_thread unsafe to use
> -		 * on this task. if this happens, there is no choice but to
> -		 * throw this task away and try again (from cgroup_procs_write);
> -		 * this is "double-double-toil-and-trouble-check locking".
> -		 */
> -		rcu_read_unlock();
> -		retval = -EAGAIN;
> +	retval = -EAGAIN;
> +	if (!lock_task_sighand(leader, &flags))
>  		goto out_free_group_list;
> -	}
> +
>  	/* take a reference on each task in the group to go in the array. */
>  	tsk = leader;
>  	i = 0;
> @@ -2055,9 +2047,9 @@ int cgroup_attach_proc(struct cgroup *cg
>  		BUG_ON(retval != 0);
>  		i++;
>  	} while_each_thread(leader, tsk);
> +	unlock_task_sighand(leader, &flags);
>  	/* remember the number of threads in the array for later. */
>  	group_size = i;
> -	rcu_read_unlock();
>  
>  	/*
>  	 * step 1: check that we can legitimately attach to the cgroup.
> 
> 
