Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab0CYR3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:29:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:58417 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab0CYR3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:29:08 -0400
Subject: Re: [PATCH 0/6] sched/cpusets fixes, more changes are needed
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Blum <bblum@google.com>,
       Jiri Slaby <jirislaby@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20100325161008.GA11724@redhat.com>
References: <20100315090958.GA9116@redhat.com>
	 <1269452296.5109.508.camel@twins> <20100324180912.GA21774@redhat.com>
	 <1269512531.12097.67.camel@laptop> <20100325154616.GA9773@redhat.com>
	 <20100325160243.GA11517@redhat.com>  <20100325161008.GA11724@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Mar 2010 18:29:02 +0100
Message-ID: <1269538142.12097.87.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 17:10 +0100, Oleg Nesterov wrote:
> Argh, sorry for noise...
> 
> On 03/25, Oleg Nesterov wrote:
> >
> > On 03/25, Oleg Nesterov wrote:
> > >
> > > I like the current idea to call select_task_rq() without rq->lock, but
> > > of course this is up to you.
> > >
> > > However, once again, can't we make a simpler patch?
> > >
> > > 	- remove PF_STARTING from task_waking()
> > > 	
> > > 	- change sched_fork() to set RUNNING instead of WAKING
> 
> When I reread this thread, suddenly finally I noticed you mentioned
> _twice_ your patch does this too ;) Not to mention the patch itself
> which I misread. Sorry.
> 
> > IOW, something like the (unchecked, uncompiled) patch below.
> 
> Still, what do you think?

Yeah, such a smaller patch might work too, but I was trying to remove
some more of the complexity we grown.

Being able to fully remove that TASK_WAKING check from task_rq_lock()
and only have it in set_cpus_allowed_ptr() would reduce some fast-path
logic.

You patch add a memory barrier and an unlock_wait(), which, while
seemingly correct, are harder to parse than the modified locking.

(Ideally we'd protect ->cpus_allowed using a per-task lock, but adding
more atomics ops to ttwu() is to be avoided)

(Now if I could manage to remove that lock-drop for the cgroup muck we'd
be able to remove TASK_WAKING... but that looks like a long term goal)


