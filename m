Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab1AaL0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:26:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43208 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab1AaL0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:26:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dNTPHjDgzbrYDSq+mValOinyfMAc4Gw79eBcZKGEEQ5+VHhzaD7PaSf336u1ul9Htf
         Cr+Pk46aAbHlqbtm15E0qGbzSg4qPJ0FCjCOv5Iibks2RnH4ZgGg81PG8Gpq7ggZN13D
         FOzEEyL1cb+h/tFtY4UKtKOyLngLsDOyCHfnI=
Date: Mon, 31 Jan 2011 12:26:34 +0100
From: Tejun Heo <tj@kernel.org>
To: Roland McGrath <roland@redhat.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 08/10] ptrace: participate in group stop from
 ptrace_stop() iff the task is trapping for group stop
Message-ID: <20110131112634.GG7459@htj.dyndns.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
 <1296227324-25295-9-git-send-email-tj@kernel.org>
 <20110128213009.340C7183C1E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128213009.340C7183C1E@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Roland.

On Fri, Jan 28, 2011 at 01:30:09PM -0800, Roland McGrath wrote:
> > A visible behavior change is increased likelihood of delayed group
> > stop completion if the thread group contains one or more ptraced
> > tasks.
> 
> I object to that difference in behavior.  As I've said before, I don't
> think there should be any option to circumvent a group stop via ptrace.
> If you think otherwise, you have a hard road to convince me of it.  

Yes, I do have some other ideas.  When a ptraced task gets a stop
signal, its delivery is controlled by the tracer, right?  So, right
from the beginning, group stop having consistent precedence over
ptrace breaks.

As long as the interaction is consistent and well defined, I don't
really think it matters one way or the other but given the above
precedence and the current ptracers' expectations, I can't see how we
would be able to prioritize group stop over ptrace at this point.

> It was always the intent that traced tasks should participate in the
> group stop bookkeeping.  I suspect the better line of fixes will be just
> to tie up the loose ends of the ptrace interactions so that all ptrace
> stops do the correct group_stop_count bookkeeping and notifications.

The problem is that those loose ends can't be tied up without breaking
the current users.  PTRACE_CONT has priority over group stop and it's
a very visible from userland.  I'm afraid the window of opportunity to
make that behavior the default had already passed quite some time ago.

What we can do is making the overriding behavior well defined and
logical.  This change makes the interaction at least logical - the
tracer would reliably know that the tracee has participated and
stopped for group stop whereas before the patch the tracer can't tell
whether a task has or hasn't participated in a pending group stop.

Please note that this change in practice only affects when the
completion of group stop is notified.  As our group stop notification
is almost completely broken while ptraced, this can't really break
anything further.

> If there is a group stop in progress but not yet complete, then
> PTRACE_CONT on a thread in the group should probably just move it
> from TASK_TRACED to TASK_STOPPED without resuming it at all.

I really don't think that's an option at this point and can't see how
such behavior could be made consistent given ptracer has inherent
superiority over signal delivery.  That would make initiation of group
stop controllerd by ptracer but participation not.  The behavior
becomes essentially indeterministic depending on which task in the
group gets the signal.  :-(

> Once a group stop is complete, then probably the ideal is that
> PTRACE_CONT would not resume a thread until a real SIGCONT cleared
> the job control stop condition.  But it's likely that existing
> ptrace users have expectations contrary to that, so we'll have to
> see.

So, no, I don't think that would be possible or even desirable.

Thank you.

-- 
tejun
