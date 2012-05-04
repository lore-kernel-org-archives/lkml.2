Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab2EDUqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:46:51 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45447 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506Ab2EDUqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:46:43 -0400
Date: Fri, 4 May 2012 13:46:27 -0700
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mingo@kernel.org,
        pjt@google.com, paul@paulmenage.org, akpm@linux-foundation.org,
        rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, rob@landley.net,
        tj@kernel.org, mschmidt@redhat.com, berrange@redhat.com,
        nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets
 handling upon CPU hotplug
Message-ID: <20120504204627.GB18177@linux.vnet.ibm.com>
References: <20120504191535.4603.83236.stgit@srivatsabhat>
 <1336159496.6509.51.camel@twins>
 <4FA434E9.6000305@linux.vnet.ibm.com>
 <1336162456.6509.63.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336162456.6509.63.camel@twins>
X-Operating-System: Linux 3.2.0-24-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050420-3534-0000-0000-000008146188
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.05.2012 [22:14:16 +0200], Peter Zijlstra wrote:
> On Sat, 2012-05-05 at 01:28 +0530, Srivatsa S. Bhat wrote:
> > On 05/05/2012 12:54 AM, Peter Zijlstra wrote:
> > 
> > > 
> > >>   Documentation/cgroups/cpusets.txt |   43 +++--
> > >>  include/linux/cpuset.h            |    4 
> > >>  kernel/cpuset.c                   |  317 ++++++++++++++++++++++++++++---------
> > >>  kernel/sched/core.c               |    4 
> > >>  4 files changed, 274 insertions(+), 94 deletions(-)
> > > 
> > > Bah, I really hate this complexity you've created for a problem that
> > > really doesn't exist.
> > > 
> > 
> > 
> > Doesn't exist? Well, I believe we do have a problem and a serious one
> > at that too!
> 
> Still not convinced,..
> 
> > The heart of the problem can be summarized in 2 sentences:
> > 
> > o	During a CPU hotplug, tasks can move between cpusets, and never
> > 	come back to their original cpuset.
> 
> This is a feature! You cannot say a task is part of a cpuset and then
> run it elsewhere just because things don't work out.
> 
> That's actively violating the meaning of cpusets.

Tbh, I agree with you Peter, as I think that's how cpusets *should*
work. But I'll also reference `man cpuset`:

       Not all allocations of system memory are constrained by cpusets,
       for the following reasons.

       If  hot-plug  functionality is used to remove all the CPUs that
       are currently assigned to a cpuset, then the kernel will
       automatically update the cpus_allowed of all processes attached
       to CPUs in that cpuset to allow all CPUs.  When memory hot-plug
       function- ality  for  removing  memory  nodes  is available, a
       similar exception is expected to apply there as well.  In
       general, the kernel prefers to violate cpuset placement, rather
       than starving a process that has had all its allowed CPUs or
       memory nodes  taken  off- line.   User  code  should  reconfigure
       cpusets to only refer to online CPUs and memory nodes when using
       hot-plug to add or remove such resources.

So cpusets are, per their own documentation, not hard-limits in the face
of hotplug.

I, personally, think we should just kill of tasks in cpuset-constrained
environments that are nonsensical (no memory, no cpus, etc.). But, it
would seem we've already supported this (inherit the parent in the face
of hotplug) behavior in the past. Not sure we should break it ... at
least on the surface.

> > o	Tasks might get pinned to lesser number of cpus, unreasonably.
> 
> -ENOPARSE, are you trying to say that when the set contains 4 cpus and
> you unplug one its left with 3? Sounds like pretty damn obvious, that's
> what unplug does, it takes a cpu away.

I think he's saying that it's pinned to 3 forever, even if that 4th CPU
is re-plugged.

> > Both these are undesirable from a system-admin point of view.
> 
> Both of those are fundamental principles you cannot change.

I see what you did there :)

<snip>

> > (Btw, Ingo had also suggested reworking this whole cpuset thing, while
> > reviewing the previous version of this fix.
> > http://thread.gmane.org/gmane.linux.kernel/1250097/focus=1252133)
> 
> I still maintain that what you're proposing is wrong. You simply cannot
> run a task outside of the set for a little while and say that's ok.
> 
> A set becoming empty while still having tasks is a hard error and not
> something that should be swept under the carpet. Currently we printk()
> and move them to the parent set until we find a set with !0 cpus. I
> think Paul Jackson was wrong there, he should have simply SIGKILL'ed the
> tasks or failed the hotplug.

Ah, excuse my quoting of the man-page, it would seem you are aware of
the pre-existing behavior.

So, I think I'm ok with putting the onus of all this on the
configuration owner -- don't configure/hotplug, etc. things stupidly.

We should change the cpusets implementation, then, though; update the
man-pages, etc.

So I can see several solutions:

- Rework cpusets to not be so nice to the user and kill of tasks that
  run in stupid cpusets. (to be written)
- Keep current behavior to be nice to the user, but make it much noisier
  when the cpuset rules are being broken because they are stupid (do
  nothing choice)
- Track/restore the user's setup when it's possible to do so. (this
  patchset)

I'm not sure any of these is "better" than the rest, but they probably
all have distinct merits.

How easy will it be for something like libvirt to handle that first
case? Can libvirt be modified to recognize that a VM has been killed due
to having an empty cpuset? And is that reasonable? What about other
users of cpusets (what are they?)?

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center

