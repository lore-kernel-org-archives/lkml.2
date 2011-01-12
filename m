Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab1ALHYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 02:24:47 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:42653 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754102Ab1ALHYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 02:24:45 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/xE014lijxmy/7feMRiGIEnht/WoOMrPJYd9rY4U
	R57ieOqJQHKYde
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
From: Mike Galbraith <efault@gmx.de>
To: bharata@linux.vnet.ibm.com
Cc: Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110112063543.GD2723@in.ibm.com>
References: <20110110091622.GF2772@in.ibm.com>
	 <1294655388.8197.22.camel@marge.simson.net>
	 <1294657154.2016.459.camel@laptop>
	 <1294677746.8345.4.camel@marge.simson.net>
	 <20110111171046.GL4772@in.ibm.com>
	 <1294771686.8006.15.camel@marge.simson.net>
	 <20110112033709.GA2723@in.ibm.com>
	 <AANLkTikFGqznUg7bzFckJy_x2mfBqE7PjaK2n83wLk6c@mail.gmail.com>
	 <20110112063543.GD2723@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 08:24:41 +0100
Message-ID: <1294817081.8370.60.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 12:05 +0530, Bharata B Rao wrote:
> On Wed, Jan 12, 2011 at 01:40:32PM +0800, Yong Zhang wrote:

> > IMHO, task->cgroups will not change when autogroup take effect.
> 
> Yes and I believe this is cause for some of the weird semantics I see
> with autogroup and cgroups. I am not sure if this has already been
> discussed ealier, may be I need to go back and check the archives, but
> consider this:
> 
> I have cpu cgroup mounted at /cgroup and see that all the tasks in the
> system are listed in /cgroup/tasks file.
> 
> Now I start a task like this:
> 
> # ./while1 &
> [1] 2761
> 
> and see that this task belongs to root cgroup.

Yes, cgroups sees cgroup associations, not autogroup associations.

> # grep 2761 /cgroup/tasks
> 2671
> 
> But we know that this task really belongs to an autogroup and is not
> sitting directly on root_task_group.

Yup, cgroups doesn't want it, so autogroup (if enabled) claims it.

> # cat /proc/2761/autogroup 
> /autogroup-49 nice 0
> 
> So we have a task in an autogroup (which is a sub group of root_task_group)
> but is being shown as part of root_task_group. Is this by design ?

Yes, it's supposed to be transparent to cgroups.

> Now say I create a sub cgroup and move this task to it.
> 
> # mkdir /cgroup/1
> # echo 2671 > /cgroup/1/tasks
> 
> So now the task moved to a real cgroup.
> 
> # cat /cgroup/1/tasks 
> 2761
> 
> But the /proc/2761/autogroup isn't updated. It still shows
> /autogroup-49 nice 0

The proc interface shows task->autogroup associations, which always
exist.  This is autogroups' view of the world, just as cgroup/tasks is
cgroups' view of it's world.

> May be this was all discussed earlier as I noted in the beginning, but I find
> this semantics a bit unusual.

Makes perfect sense to me.

	-Mike

