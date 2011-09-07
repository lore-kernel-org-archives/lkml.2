Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab1IGVkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:40:40 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34813 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab1IGVkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:40:37 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] Make PTRACE_SEIZE set ptrace options specified in data parameter
Date: Wed, 7 Sep 2011 23:40:34 +0200
User-Agent: KMail/1.8.2
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
References: <201109070647.40850.vda.linux@googlemail.com> <20110907170212.GB5176@redhat.com>
In-Reply-To: <20110907170212.GB5176@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201109072340.34626.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 September 2011 19:02, Oleg Nesterov wrote:
> >  	retval = -EIO;
> > -	if (seize && !(flags & PTRACE_SEIZE_DEVEL))
> > -		goto out;
> > +	if (seize) {
> > +		if ((flags & ~(long)PTRACE_O_MASK) != PTRACE_SEIZE_DEVEL)
> > +			goto out;
> > +		flags &= ~PTRACE_SEIZE_DEVEL;
> > +	} else
> > +		flags = 0;
> 
> Personally I do not care, but this is against the coding-style rules. This
> should be
> 
> 	} else {
> 		flags = 0;
> 	}

Ok


> > @@ -263,7 +267,7 @@ static int ptrace_attach(struct task_struct *task, long request,
> >  	if (task->ptrace)
> >  		goto unlock_tasklist;
> >
> > -	task->ptrace = PT_PTRACED;
> > +	task->ptrace = PT_PTRACED | (flags << PT_OPT_FLAG_SHIFT);
> >  	if (seize)
> >  		task->ptrace |= PT_SEIZED;
> 
> Hmm. Tejun, Denys, this doesn't look exactly right.
> 
> I already thought about this before, but somehow I convinced myself
> this is fine.
> 
> I think we should set both PT_PTRACED | PT_SEIZED "atomically", at
> once. Otherwise, say, the tracee can do do_jobctl_trap() in between,
> no? Nothing really bad can happen, but we shouldn't lose EVENT_STOP
> code.
> 
> IOW, I think we need the small fix before this patch.

I think the best is to just do one and only assignment to task->ptrace.
Even before patch, we can touch it three times...

Sending patch v2...

-- 
vda
