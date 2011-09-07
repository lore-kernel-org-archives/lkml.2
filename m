Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab1IGEoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 00:44:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36734 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab1IGEoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 00:44:39 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2] Fix clearing of task->ptrace if PTRACE_SETOPTIONS fails
Date: Wed, 7 Sep 2011 06:44:35 +0200
User-Agent: KMail/1.8.2
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
References: <201109042311.18793.vda.linux@googlemail.com> <1315327963.29637.1.camel@dhcp-25-63.brq.redhat.com> <20110906184346.GA25904@redhat.com>
In-Reply-To: <20110906184346.GA25904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201109070644.35382.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 September 2011 20:43, Oleg Nesterov wrote:
> > +#define PT_OPT_FLAG_SHIFT	3
> > +/* must be directly before PT_TRACE_event bits */
> > +#define PT_TRACESYSGOOD	0x00000008
> 
> This probably means PT_TRACESYSGOOD should be also defined as PT_EVENT_FLAG(0)

Good idea.

> >  /* PT_TRACE_* event enable flags */
> > -#define PT_EVENT_FLAG_SHIFT	4
> > -#define PT_EVENT_FLAG(event)	(1 << (PT_EVENT_FLAG_SHIFT + (event) - 1))
> > -
> > +#define PT_EVENT_FLAG(event)	(1 << (PT_OPT_FLAG_SHIFT + (event)))
> 
> And ptrace_setoptions() does
> 
> 	child->ptrace |= (data << PT_OPT_FLAG_SHIFT);
> 
> Now we should verify that
> 
> 	PTRACE_O_XXX == 1 << PTRACE_EVENT_XXX;
> 
> for every XXX... Looks correct. But perhaps it makes sense to do this
> explicitely and redefine PTRACE_O_* via PTRACE_EVENT_*.

Also good idea.
 
> > -	if (seize && !(flags & PTRACE_SEIZE_DEVEL))
> > -		goto out;
> > +	if (seize) {
> > +		if ((flags & ~(long)PTRACE_O_MASK) != PTRACE_SEIZE_DEVEL)
> > +			goto out;
> > +		flags &= ~PTRACE_SEIZE_DEVEL;
> > +	} else
> > +		flags = 0;
> >  
> >  	audit_ptrace(task);
> 
> This chunk looks completely off-topic, why it is needed in this patch?

It isn't, it wasn't supposed to be there :(


> >  static int ptrace_setoptions(struct task_struct *child, unsigned long data)
> >  {
> > -	child->ptrace &= ~PT_TRACE_MASK;
> > -
> > -	if (data & PTRACE_O_TRACESYSGOOD)
> > -		child->ptrace |= PT_TRACESYSGOOD;
> > -
> > -	if (data & PTRACE_O_TRACEFORK)
> > -		child->ptrace |= PT_TRACE_FORK;
> > -
> > -	if (data & PTRACE_O_TRACEVFORK)
> > -		child->ptrace |= PT_TRACE_VFORK;
> > -
> > -	if (data & PTRACE_O_TRACECLONE)
> > -		child->ptrace |= PT_TRACE_CLONE;
> > -
> > -	if (data & PTRACE_O_TRACEEXEC)
> > -		child->ptrace |= PT_TRACE_EXEC;
> > -
> > -	if (data & PTRACE_O_TRACEVFORKDONE)
> > -		child->ptrace |= PT_TRACE_VFORK_DONE;
> > +	if (data & ~(long)PTRACE_O_MASK)
> > +		return -EINVAL;
> 
> Oh, yes, I always hated this logic. We change ->ptrace first, then
> return -EINVAL if data is wrong.
> 
> But. Denys, I think this needs a separate patch. And of course, of
> course this can break things. Say, a poor application passes the
> unsupported bit along with the valid bits, and doesn't check the result.
> This works before this patch.

This is really a gross bug, I think we should just bite the bullet
and fix it.

I have hard time imagining how application managed to *inadvertently*
invent a non-existing PTRACE_O_BOGUSFLAG and pass it
to PTRACE_SETOPTIONS call. In what header did they fing PTRACE_O_BOGUSFLAG?

I think this can only happen if they do this on purpose,
but *what* purpose? To get options cleared? Can't imagine anyone doing that,
option clearing can be done without resort to undocumented kernel bugs -
ptrace(PTRACE_SETOPTIONS, pid, 0, 0) does it, rigth?

Sending patch v3 in separate mail.

-- 
vda
