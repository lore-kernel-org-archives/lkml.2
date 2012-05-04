Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569Ab2EDUOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:14:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:60451 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab2EDUOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:14:51 -0400
Message-ID: <1336162456.6509.63.camel@twins>
Subject: Re: [PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets
 handling upon CPU hotplug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: mingo@kernel.org, pjt@google.com, paul@paulmenage.org,
        akpm@linux-foundation.org, rjw@sisk.pl, nacc@us.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, rob@landley.net, tj@kernel.org,
        mschmidt@redhat.com, berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pm@vger.kernel.org
Date: Fri, 04 May 2012 22:14:16 +0200
In-Reply-To: <4FA434E9.6000305@linux.vnet.ibm.com>
References: <20120504191535.4603.83236.stgit@srivatsabhat>
	 <1336159496.6509.51.camel@twins> <4FA434E9.6000305@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-05 at 01:28 +0530, Srivatsa S. Bhat wrote:
> On 05/05/2012 12:54 AM, Peter Zijlstra wrote:
> 
> > 
> >>   Documentation/cgroups/cpusets.txt |   43 +++--
> >>  include/linux/cpuset.h            |    4 
> >>  kernel/cpuset.c                   |  317 ++++++++++++++++++++++++++++---------
> >>  kernel/sched/core.c               |    4 
> >>  4 files changed, 274 insertions(+), 94 deletions(-)
> > 
> > Bah, I really hate this complexity you've created for a problem that
> > really doesn't exist.
> > 
> 
> 
> Doesn't exist? Well, I believe we do have a problem and a serious one
> at that too!

Still not convinced,..

> The heart of the problem can be summarized in 2 sentences:
> 
> o	During a CPU hotplug, tasks can move between cpusets, and never
> 	come back to their original cpuset.

This is a feature! You cannot say a task is part of a cpuset and then
run it elsewhere just because things don't work out.

That's actively violating the meaning of cpusets.

> o	Tasks might get pinned to lesser number of cpus, unreasonably.

-ENOPARSE, are you trying to say that when the set contains 4 cpus and
you unplug one its left with 3? Sounds like pretty damn obvious, that's
what unplug does, it takes a cpu away.

> Both these are undesirable from a system-admin point of view.

Both of those are fundamental principles you cannot change.

> Moreover, having workarounds for this from userspace is way too messy and
> ugly, if not impossible.

There's nothing to work around -- with the exception of the suspend case
-- things work as they ought to.

> > So why not fix the active mask crap?
> 
> 
> Because I doubt if that is the right way to approach this problem.
> 
> An updated cpu_active_mask not being the necessary and sufficient condition
> for all scheduler related activities, is a different problem altogether, IMHO.

It was the sole cause the previous, simple, patch didn't work. So fixing
that seems like important.

> (Btw, Ingo had also suggested reworking this whole cpuset thing, while
> reviewing the previous version of this fix.
> http://thread.gmane.org/gmane.linux.kernel/1250097/focus=1252133)

I still maintain that what you're proposing is wrong. You simply cannot
run a task outside of the set for a little while and say that's ok.

A set becoming empty while still having tasks is a hard error and not
something that should be swept under the carpet. Currently we printk()
and move them to the parent set until we find a set with !0 cpus. I
think Paul Jackson was wrong there, he should have simply SIGKILL'ed the
tasks or failed the hotplug.

> Also, we need to fix this problem at the CPU Hotplug level itself, and
> not just for the suspend/resume case. Because, we have had numerous bug
> reports and people complaining about this issue, in various scenarios,
> including those that didn't involve suspend/resume.

NO, absolutely not and I will NAK any and all such nonsense. WTF is a
cpuset worth if you can run on random other cpus?

> I am sure some of the people in Cc will have more to add to this, but in
> general, when the CPU hotplug (maybe even cpu offline + online) and the
> cpuset administration are done asynchronously, it leads to nasty surprises.
> In fact, there have been reports where people spent inordinate amounts of
> time before they figured out that a long-forgotten cpu hotplug operation
> which was performed, was the root-cause of a low-performing workload!.

Yeah so? I'm sure you can find infinite examples of clueless people
wasting time because they don't know how things work.



