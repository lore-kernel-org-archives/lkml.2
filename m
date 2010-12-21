Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab0LURBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 12:01:16 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:45123 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab0LURBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 12:01:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T3oz7GFqIq7W0hz5nlyKZ9V9od/Mgu5pkJrU5D4BJutNa7+qtjXcVwCuFDGjUgoJRm
         5GDBZRilTvTfEbi+aPHT67hbXlaYjb6y23v4EndtzILw/fDloNs70GtoG0Oc3SlZI4v5
         28ppMY1GFEbVitDrAbDNqZ8BhEy5aclZ4+KM8=
Date: Tue, 21 Dec 2010 18:01:10 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 00/15] Nohz task support
Message-ID: <20101221170108.GL1750@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292859886.22905.22.camel@gandalf.stny.rr.com>
 <20101220233341.GA1715@nowhere>
 <4D10B214.8010305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D10B214.8010305@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 03:56:36PM +0200, Avi Kivity wrote:
> On 12/21/2010 01:33 AM, Frederic Weisbecker wrote:
> >On Mon, Dec 20, 2010 at 10:44:46AM -0500, Steven Rostedt wrote:
> >>  On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> >>  >  The timer interrupt handles several things like preemption,
> >>  >  timekeeping, rcu, etc...
> >>  >
> >>  >  However it appears that sometimes it is simply useless like
> >>  >  when a task runs alone and even more when it is in userspace
> >>  >  as RCU doesn't need it at all in such case.
> >>  >
> >>  >  It appears that HPC workload would get some win of such timer
> >>  >  deactivation, and perhaps also the Real Time world as this
> >>  >  minimizes the critical sections due to way less interrupts to
> >>  >  handle.
> >>  >
> >>  >  It works through the procfs interface:
> >>  >
> >>  >  echo 1>  /proc/self/nohz
> >>
> >>  I wounder if we could just have this happen automatically.
> >
> >But this would add some global overhead, especially in the syscall
> >path as we need to take the slow path to hook userspace resume/exit.
> 
> This is zero as there is already a test on thread_info->flags on the
> syscall exit path.
> 
> (or I misunderstood you - what's the purpose of the slow path?)


Yes but on most cases threads don't have flags that route them to the
syscall slow path, which is to call syscall_trace_enter() and
syscall_trace_leave() as proxys. They call the syscall handler
directly.

But the nohz tasks must use a TIF_ flag that forces the syscall
slow path, which is where is the overhead. So if you wanted to
make that automatic for every task, you need to force the syscall
slow path on every tasks. And this is quite an overhead.
