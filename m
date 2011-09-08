Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab1IHXaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:30:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233Ab1IHX3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:29:44 -0400
Date: Thu, 8 Sep 2011 20:17:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
        dvlasenk@redhat.com
Subject: Re: [PATCH v2] Make PTRACE_SEIZE set ptrace options specified in
	'data' parameter
Message-ID: <20110908181747.GA28120@redhat.com>
References: <201109072340.31460.vda.linux@googlemail.com> <20110908004438.GC3987@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908004438.GC3987@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08, Tejun Heo wrote:
>
> On Wed, Sep 07, 2011 at 11:40:31PM +0200, Denys Vlasenko wrote:
> > +	if (seize) {
> > +		if (addr != 0)
> > +			goto out;
> > +		if ((flags & ~(long)PTRACE_O_MASK) != PTRACE_SEIZE_DEVEL)
>
> Please use (unsigned long).  Also, wouldn't it be better to do the
> following instead?
>
> 	if (!(flags & PTRACE_SEIZE_DEVEL))
> 		goto out;
> 	flags &= ~PTRACE_SEIZE_DEVEL;
>
> 	if ((flags & ~(unsigned long(PTRACE_O_MASK))))
> 		goto out;
>
> Then, we can later just delete the first three lines when removing
> SEIZE_DEVEL.
>
> > @@ -263,11 +272,9 @@ static int ptrace_attach(struct task_struct *task, long request,
> >  	if (task->ptrace)
> >  		goto unlock_tasklist;
> >
> > -	task->ptrace = PT_PTRACED;
> > -	if (seize)
> > -		task->ptrace |= PT_SEIZED;
> >  	if (task_ns_capable(task, CAP_SYS_PTRACE))
> > -		task->ptrace |= PT_PTRACE_CAP;
> > +		flags |= PT_PTRACE_CAP;
> > +	task->ptrace = flags;
>
> Can you please put this in a separate patch?

Yes.

> Hmm... also I think we
> probably want to set ->ptrace while holding siglock too.

I thought about this too, and I agree this makes sense

> There are
> places which assume ->ptrace is protected by siglock.

Really? Once again, I agree. But _afaics_ currently this is not strictly
needed. PT_PTRACED/PT_SEIZED should not go away under ->siglock, yes, but
it seems that it is fine to set them.

> and linking are
> protected by siglock

Hmm. Could you explain this? Why do want __ptrace_link under ->siglock ?

Oleg.

