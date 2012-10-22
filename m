Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab2JVVN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:13:26 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49396 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab2JVVNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:13:23 -0400
Date: Mon, 22 Oct 2012 17:13:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/7] freezer: add missing mb's to freezer_count() and
 freezer_should_skip()
Message-ID: <20121022211317.GD5951@atj.dyndns.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <1350426526-14254-3-git-send-email-tj@kernel.org>
 <20121022174404.GA21553@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022174404.GA21553@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Mon, Oct 22, 2012 at 07:44:04PM +0200, Oleg Nesterov wrote:
> >  static inline void freezer_count(void)
> >  {
> >  	current->flags &= ~PF_FREEZER_SKIP;
> > +	/*
> > +	 * If freezing is in progress, the following paired with smp_mb()
> > +	 * in freezer_should_skip() ensures that either we see %true
> > +	 * freezing() or freezer_should_skip() sees !PF_FREEZER_SKIP.
> > +	 */
> > +	smp_mb();
> >  	try_to_freeze();
> 
> I agree, this looks like a bug fix.

Yeah, and this isn't dangerous at all.  I'll ping -stable.

> > -static inline int freezer_should_skip(struct task_struct *p)
> > +static inline bool freezer_should_skip(struct task_struct *p)
> >  {
> > -	return !!(p->flags & PF_FREEZER_SKIP);
> > +	/*
> > +	 * The following smp_mb() paired with the one in freezer_count()
> > +	 * ensures that either freezer_count() sees %true freezing() or we
> > +	 * see cleared %PF_FREEZER_SKIP and return %false.  This makes it
> > +	 * impossible for a task to slip frozen state testing after
> > +	 * clearing %PF_FREEZER_SKIP.
> > +	 */
> > +	smp_mb();
> > +	return p->flags & PF_FREEZER_SKIP;
> >  }
> 
> I am not sure we really need smp_mb() here. Speaking of cgroup_freezer,
> it seems that a single mb() after "->state = CGROUP_FREEZING" should be
> enough.

Hmmm... I agree pairing there would work too.

> But even if I am right, I agree that it looks better in freezer_should_skip()
> and this is more robust.

But, yeah, performance implications at this level are almost
completely irrelavent here and I think pairing freezer_should_skip()
is easier to read.

> So I think the patch is fine and fixes the bug.

Awesome.

> We probably have another similar race. If ptrace_stop()->may_ptrace_stop()
> returns false, the task does
> 
> 	__set_current_state(TASK_RUNNING);
> 	// no mb in between
> 	try_to_freeze();
> 
> And this can race with task_is_stopped_or_traced() check in the same way.
> (of course this is only theoretical).
> 
> do_signal_stop() is probably fine, we can rely on ->siglock.

Hmm....  Guess we should drop __ from set_current_state.  I wonder
whether we should just add mb to freezing()?  What do you think?

Thanks.

--
tejun
