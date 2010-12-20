Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297Ab0LTXdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:33:54 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:47339 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab0LTXdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:33:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uxkJamEVPx2i38/QSiU5Gu7pQQ6TNOwqdl6wJuVMI9Ii4lgK06GWtPlkDq44xXvlC0
         tzMXp75DXRuad8CUPpFetY66NF85ER/vxMEYrCmrTcBM3SxtStsNVEQkGDpJelYjo1nY
         zjT9ziZr033hYQqDxhoZPICWPcX//XnEpj1KY=
Date: Tue, 21 Dec 2010 00:33:48 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 00/15] Nohz task support
Message-ID: <20101220233341.GA1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292859886.22905.22.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292859886.22905.22.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 10:44:46AM -0500, Steven Rostedt wrote:
> On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > The timer interrupt handles several things like preemption,
> > timekeeping, rcu, etc...
> > 
> > However it appears that sometimes it is simply useless like
> > when a task runs alone and even more when it is in userspace
> > as RCU doesn't need it at all in such case.
> > 
> > It appears that HPC workload would get some win of such timer
> > deactivation, and perhaps also the Real Time world as this
> > minimizes the critical sections due to way less interrupts to
> > handle.
> > 
> > It works through the procfs interface:
> > 
> > echo 1 > /proc/self/nohz
> 
> I wounder if we could just have this happen automatically.

But this would add some global overhead, especially in the syscall
path as we need to take the slow path to hook userspace resume/exit.
 
> > - This must be written in /proc/self only, however further
> > plans to allow than to be set from another task should be
> > possible.
> > 
> > You need to migrate irqs manually from userspace, same
> > for tasks. If a non nohz task is running on the same cpu
> > than a nohz task, the tick can't be stopped.
> 
> So interrupts must not be set to this CPU?

No it's just that the point is to minimize interrupts. If you want
that on a cpu you can use a nohz task, but you still have do
migrate irqs in another CPU if you want to truly minimize
the interrupts on a nohz task.
 
> > 
> > I can provide you the tools I'm using to test it if you
> > want.
> > 
> > Note this depends on the rcu spurious softirq fixes in Paul's
> > queue for .38
> > 
> > I'm also using a hack to make init affine to the first CPU
> > on boot so that all userspace tasks end up to the first CPU
> > except kernel threads and tasks that change their affinity
> > explicitly (this is not sched isolation). This avoids any
> > task to set up timers to random CPUs on which we'll later
> > want to run a nohz task. But probably this can be fixed
> > with another way, like unbinding these timers or so. This
> > probably require a detailed audit.
> 
> Have you looked at "tuna"?

No, I'm discovering this, I'll have a look. I'm not sure this
can fix the randomly bound timer issue though.


> > Any comments are welcome.
> 
> Now as I was saying. If only a single running task is on a given CPU,
> and it is affined there. If no timers are set for wakeups on that CPU.
> Could we possible set this to be NOHZ automatically?
> 
> Just a thought.

So, we still need the syscalls slow path hooks.
