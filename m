Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab0D0XW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 19:22:56 -0400
Received: from relay1.sgi.com ([192.48.179.29]:35138 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab0D0XWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 19:22:55 -0400
Date: Tue, 27 Apr 2010 18:22:52 -0500
From: Robin Holt <holt@sgi.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Robin Holt <holt@sgi.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Weirdness in /proc/<pid>/maps and /proc/<pid>/stat.
Message-ID: <20100427232252.GS4920@sgi.com>
References: <20100427185343.GR4920@sgi.com>
 <1272403129.29233.20.camel@wall-e.seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272403129.29233.20.camel@wall-e.seibold.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 11:18:49PM +0200, Stefani Seibold wrote:
> Am Dienstag, den 27.04.2010, 13:53 -0500 schrieb Robin Holt:
> > With commit d899bf7b, the behavior of field 28 of /proc/<pid>/stat
> > was changed as was /proc/<pid>/maps.  I don't know if that change was
> > correct, but its resulting behavior is much more difficult to explain.
> > I was wondering if we could determine what the "correct" behavior is
> > before I spend much more time trying to give it the wrong behavior.
> > 
> > My test program is attached below.  Essentially:
> > fork() -> pthread_create() -> fork()
> > 
> > x86_64 2.6.32 stable kernel:
> > Step			stat-28		maps-threadstack
> > p (parent)                  0x7fff5607ddc0  N/A
> > c (child)                   0x7fff55c7dc50  N/A
> > ppthread                    0x7f2cf5c9bff0  0x7f2cf5c9d000:007feff0
> > ppthread+fork               0x7f2cf589be30  0x7f2cf5c9d000:003fee30
> > cpthread                    0x7f2cf589be30  0x7f2cf5c9d000:007feff0
> > cpthread+fork               0x7f2cf589be30  0x7f2cf5c9d000:003fee30
> 
> I must guess, because the output of your example code does not fit to
> your description. But the stat-28 make sense for me. A thread gets a new
> stack, a fork inherits the stack of the process. 

In the fork case, the child's stack is not limited to its location at
the time of the fork call, but rather the top which the parent used.
The first two lines illustrate this.  Additionally, as the child returns
from the my_fork() function, its sp is much closer to the stat-28 field
of the parent above and much (in my test code 2MB) higher than what
field 28 is reporting as the start of the stack.

My point was field 28 is currently a nearly random value due to the
setting task->stack_start at the time fork is called.  The current stack
pointer at that time has a very limited relationship to the start of
the stack.

This point further factors into the max stack size calculation.  In the
case of the pthread'd tasks which did the fork, their max stack size
is really the same as their parents.  Just because part of the stack is
consumed at the time of the fork call does not mean that portion of the
stack is not available to the task, merely that it was used at the time
of the system call.

> 
> > Note: For all of the above, the /proc/<pids>/task/*/maps files had the
> > stack line like:
> > 7fff55c7d000-7fff56081000 rw-p 00000000 00:00 0                         [stack]
> > 
> 
> This should be okay, because this is the stack of the main thread. The
> stack of the thread is marked as [thread stack: xxxxxxxx]. Where
> xxxxxxxx is the max size of the stack, because the thread stack could
> start at a arbitrary position inside the VMA.
> 
> > The problems I see are:
> > 1)  In the fork() case, we are using the current userland stack
> >     pointer for task->stack_start.  This appears wrong as the
> >     function which called fork() may be returned to and may
> >     further return to higher level callers, finding sp now
> >     beyond the value reported in /proc/self/stat.  Additionally,
> >     the value reported for the child of the fork has no relationship
> >     to the stack size rlimit any longer.
> > 
> > 2)  In the pthread + fork case, in addition to the problem
> >     above, the size information in /proc/self/maps
> >     is incorrect as it does not take into consideration
> >     the same return paths.
> > 
> > The problem I am running into is coming up with any way to
> > make the task->stack_start value usable.

Thanks,
Robin
