Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab1HMQSV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 12:18:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41682 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1HMQST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 12:18:19 -0400
Date: Sat, 13 Aug 2011 18:18:14 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 0/3] make vfork killable
Message-ID: <20110813161814.GE4254@htj.dyndns.org>
References: <20110727163159.GA23785@redhat.com>
 <20110729192358.GB31717@mtj.dyndns.org>
 <20110812175550.GA7484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812175550.GA7484@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Fri, Aug 12, 2011 at 07:55:50PM +0200, Oleg Nesterov wrote:
> > an alternative approach
> > could be handling vfork waiting as a type of job control stop.
> 
> Well, I didn't see the code, but to be honest this doesn't look
> like a good idea to me. Firstly, personally I do not think this
> has something to do with the job control stop.
> 
> And, to me sys_restart_syscall() looks like the very natural
> approach, and simple.

I've been playing with this and it does a bit further than
implementation simplicity.  Currently, we have three different modes
of stopping a task.

* Regular job control and ptrace.
* vfork wait.
* cgroup freeze.

Currently, all three behave differently and the latter two use
UNINTERRUPTIBLE sleep causing rather nasty problems.  If we want to
fix the UNINTERRUPTIBLE sleep problem, we end up introducing a new
user visible state no matter which way we go - ie. a task will be in a
state which isn't UNINTERRUPTIBLE sleep but still behave differently
in terms of signal delivery and job control.

What's needed is this different state of being stopped which reponds
to all kernel's desires (killing and ptracing) but stays stopped
regardless of what the user requests.

There's multiple ways to implement this and forced syscall restart is
one way to achieve it - ie. while the stop condition is pending,
syscall is forced to be restarted after interruption and re-enter
stop.  The downside is that that wouldn't work with cgroup freeze at
all - there's no syscall to restart.

So, what I'm proposing is to basically add another job control state
which is similar to process group stop but controlled by other
parameters like vfork wait condition or control group frozen state.
This allows these stops to be handled in a way very similar to already
esablished job control states including interaction with ptrace.

> > * When entering get_signal_to_deliver(), if vfork child exists, save
> >   sigmask and block all blockable signals.
> 
> Oh, I'd like to avoid this. Why should we change get_signal_to_deliver()
> paths to help vfork?

get_signal_to_deliver() may be a misnomer but that's already the place
user tasks go to sleep when they aren't allowed to proceed at the
moment, so it's a logical extension of the existing behavior.

> > * When leaving get_signal_to_deliver(), restore sigmask if saved on
> >   entry.
> 
> And I _think_ we need much more complications. We still need to
> communicate with the child, for example. Unless we are going to
> add the "struct completion vfork_done" or something into task_struct,
> personally I dislike this idea.
> 
> > Haven't really thought a lot about the details so this might end up
> > uglier than the current attempt.  :)
> 
> I _hope_ it is much uglier, but I can be wrong of course ;)

Oh, it turns out I didn't need this.  The implementation isn't simple
tho, but it gives a very uniform behavior across all different modes
of stops.  ie. both vfork and freeze under ptrace would report
TRAP_STOP w/ flags indicating stop conditions in effect and would
re-trap if LISTEN is in effect on each state transition, so it can be
handled exactly as the group stop condition.

Thanks.

-- 
tejun
