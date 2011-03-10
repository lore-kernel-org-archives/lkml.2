Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1CJKqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:46:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601Ab1CJKqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:46:39 -0500
Date: Thu, 10 Mar 2011 02:44:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pidns: Make pid_max per namespace
Message-Id: <20110310024459.e54fd99e.akpm@linux-foundation.org>
In-Reply-To: <4D78A2B8.1030605@parallels.com>
References: <4D6F53B5.5090105@parallels.com>
	<20110307155823.22e47d73.akpm@linux-foundation.org>
	<4D789B64.9000603@parallels.com>
	<20110310015045.63482b62.akpm@linux-foundation.org>
	<4D78A2B8.1030605@parallels.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011 13:06:48 +0300 Pavel Emelyanov <xemul@parallels.com> wrote:

> On 03/10/2011 12:50 PM, Andrew Morton wrote:
> > On Thu, 10 Mar 2011 12:35:32 +0300 Pavel Emelyanov <xemul@parallels.com> wrote:
> > 
> >> On 03/08/2011 02:58 AM, Andrew Morton wrote:
> >>> On Thu, 03 Mar 2011 11:39:17 +0300
> >>> Pavel Emelyanov <xemul@parallels.com> wrote:
> >>>
> >>>> Rationale:
> >>>>
> >>>> On x86_64 with big ram people running containers set pid_max on host to 
> >>>> large values to be able to launch more containers. At the same time 
> >>>> containers running 32-bit software experience problems with large pids - ps
> >>>> calls readdir/stat on proc entries and inode's i_ino happen to be too big 
> >>>> for the 32-bit API.
> >>>>
> >>>> Thus, the ability to limit the pid value inside container is required.
> >>>>
> >>>
> >>> This is a behavioural change, isn't it?  In current kernels a write to
> >>> /proc/sys/kernel/pid_max will change the max pid on all processes. 
> >>> After this change, that write will only affect processes in the current
> >>> namespace.  Anyone who was depending on the old behaviour might run
> >>> into problems?
> >>
> >> Hardly. If the behavior of some two apps depends on its synchronous change,
> >> these two might want to run in the same pid namespace.
> > 
> > I don't understand your answer.  What is this "synchronous change" of which
> > you speak?  Does your "might want to run" suggestion mean that userspace 
> > changes would be required for this operation to again work correctly?
> 
> Your concern was about "anyone who was depending on the old behaviour", where
> the old behavior meant "a write to sys.pid_max will change the max pid on all
> processes".
> 
> I wanted to say, that if someone changes pid_max and expects someone else to
> act differently after this, then these two should live in the same pid namespace.

So it's a non-back-compatible change to the userspace interface.  uh-oh.

> IOW, if X raises the pid_max, then all the processes X sees in its pid namespace
> *may* have pids up to this value. All the other process, that are not visible
> in X's pid space will have other values, but X doesn't see them, so why should
> we care?

Current userspace has no *need* to be running in the same pidns to
alter the pid_max of some processes.  So the chances are good that
any current userspace takes advantage of this.

Silly example:

	if (fork() == 0) {
		/* child */
		create_new_pidns();
		start_doing_stuff();
	} else {
		/* parent */
		increase_pid_max();
	}

Another example would be logging into a system as root in the init_ns
and modifying /proc/sys/kernel/pid_max by hand.

I don't have a clue how much code is out there using pid namespaces,
not how much of that code alters the default pid_max.  Hard.


The proposed interface is a bit weird and hacky anyway, isn't it?  We
have a single pseudo-file in a well-known location -
/proc/sys/kernel/pid_max.  One would expect alteration of that
system-wide file to have system-wide effects, only that isn't the case.
Instead a modification to the system-wide file has local-pidns-only
effects.  It would be much more logical to have a per-pidns pid_max
pseudo file.

And if we do that, we then need to work out what to do with writes to
/proc/sys/kernel/pid_max.  Remember the user expects those writes to
alter all processes on the machine!  I guess it would be acceptable to
permit that to continue to happen - a write to /proc/sys/kernel/pid_max
will overwrite all the per-pidns pid_max settings.

