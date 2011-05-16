Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab1EPNYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:24:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44804 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab1EPNYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:24:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AuyFjtJb3EILhkaYu8gN3Tsw2Mj5vnJOQTZG/sMTd+HuwqONTjPU2QfScOktBjrVYh
         LGgyxfTF4aXdLfgd8bypEXLoVEalcIUVndG+bX+IJpWsdGnNgtey/I3TwyaNeSrDZNsk
         6ZPM3fJF0qyrwDH3P0pzkbDYLM3cNJlJGZli0=
Date: Mon, 16 May 2011 15:24:00 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 6/9] job control: make task_clear_jobctl_pending()
 clear TRAPPING automatically
Message-ID: <20110516132400.GY23665@htj.dyndns.org>
References: <1305301580-9924-1-git-send-email-tj@kernel.org>
 <1305301580-9924-7-git-send-email-tj@kernel.org>
 <20110516122535.GD4898@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516122535.GD4898@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 16, 2011 at 02:25:35PM +0200, Oleg Nesterov wrote:
> On 05/13, Tejun Heo wrote:
> >
> > @@ -264,6 +267,9 @@ void task_clear_jobctl_pending(struct task_struct *task, unsigned int mask)
> >  		mask |= JOBCTL_STOP_CONSUME | JOBCTL_STOP_DEQUEUED;
> >
> >  	task->jobctl &= ~mask;
> > +
> > +	if (!(task->jobctl & JOBCTL_PENDING_MASK))
> > +		task_clear_jobctl_trapping(task);
> >  }
> 
> So, SIGCONT clears JOBCTL_TRAPPING and wakes up the tracer.

If JOBCTL_TRAPPING is set && JOBCTL_STOP_PENDING was the only pending
condition.

> I can't really understand this without seeing the next changes, but
> it seems this makes some things worse, although I am not sure.

It's a safety mechanism.  We shouldn't have TRAPPING set when no
stop/trap is pending and the above establishes that invariant and will
also be used to simplify exception cases where all pending conditions
are cleared (tracee being killed).  It's conceptually much easier to
grasp that way - you clear all pending conditions when the task dies
and the mechanism to wait for trap transition is cleared together.

> For example. PTRACE_SEIZE should guarantee the tracee will trap and
> report. However, if the tracee is stopped during attach, we can race
> with SIGCONT. The previous version had the similar problem afaics, but
> it was easy (I think) to fix. Now that SIGCONT clears JOBCTL_TRAPPING
> we need more complications.

This problem doesn't exist anymore.  SEIZE directly schedules
JOBCTL_TRAP_STOP instead of using JOBCTL_STOP_PENDING, so it actually
works exactly as it should.

1. If tracee was stopped and tracer attaches, tracee should re-trap
   and tracer should wait for TRAPPING.

2. If tracee was not stopped and tracer attaches, tracee traps to
   STOP.

3. If tracee was stopped and tracer attaches but SIGCONT is received
   before TRAPPING is done, TRAPPING is cleared and tracer and tracee
   are in the same conditions as #2, which is exactly how they should
   be.

Thanks.

-- 
tejun
