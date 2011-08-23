Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab1HWWCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:02:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39355 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab1HWWCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:02:11 -0400
Date: Tue, 23 Aug 2011 15:01:58 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 0/3] make vfork killable
Message-ID: <20110823220158.GA28444@count0.beaverton.ibm.com>
References: <20110727163159.GA23785@redhat.com>
 <20110729192358.GB31717@mtj.dyndns.org>
 <20110812175550.GA7484@redhat.com>
 <20110813161814.GE4254@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110813161814.GE4254@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 13, 2011 at 06:18:14PM +0200, Tejun Heo wrote:
> Hello, Oleg.
> 
> On Fri, Aug 12, 2011 at 07:55:50PM +0200, Oleg Nesterov wrote:
> > > an alternative approach
> > > could be handling vfork waiting as a type of job control stop.
> > 
> > Well, I didn't see the code, but to be honest this doesn't look
> > like a good idea to me. Firstly, personally I do not think this
> > has something to do with the job control stop.
> > 
> > And, to me sys_restart_syscall() looks like the very natural
> > approach, and simple.
> 
> I've been playing with this and it does a bit further than
> implementation simplicity.  Currently, we have three different modes
> of stopping a task.
> 
> * Regular job control and ptrace.
> * vfork wait.
> * cgroup freeze.
> 
> Currently, all three behave differently and the latter two use
> UNINTERRUPTIBLE sleep causing rather nasty problems.  If we want to
> fix the UNINTERRUPTIBLE sleep problem, we end up introducing a new
> user visible state no matter which way we go - ie. a task will be in a
> state which isn't UNINTERRUPTIBLE sleep but still behave differently
> in terms of signal delivery and job control.
> 
> What's needed is this different state of being stopped which reponds
> to all kernel's desires (killing and ptracing) but stays stopped
> regardless of what the user requests.
> 
> There's multiple ways to implement this and forced syscall restart is
> one way to achieve it - ie. while the stop condition is pending,
> syscall is forced to be restarted after interruption and re-enter
> stop.  The downside is that that wouldn't work with cgroup freeze at
> all - there's no syscall to restart.
> 
> So, what I'm proposing is to basically add another job control state
> which is similar to process group stop but controlled by other
> parameters like vfork wait condition or control group frozen state.

Are you proposing one new jobctl state for vfork and another for
the cgroup freezer?

> This allows these stops to be handled in a way very similar to already
> esablished job control states including interaction with ptrace.

Interesting. So long as shells and ptracers in containers would not see
jobctl traps/events triggered by tasks outside the container it sounds
fine.

Cheers,
	-Matt Helsley
