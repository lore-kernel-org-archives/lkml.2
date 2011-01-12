Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab1ALGfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 01:35:50 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:36626 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1ALGfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 01:35:47 -0500
Date: Wed, 12 Jan 2011 12:05:43 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
Message-ID: <20110112063543.GD2723@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110110091622.GF2772@in.ibm.com>
 <1294655388.8197.22.camel@marge.simson.net>
 <1294657154.2016.459.camel@laptop>
 <1294677746.8345.4.camel@marge.simson.net>
 <20110111171046.GL4772@in.ibm.com>
 <1294771686.8006.15.camel@marge.simson.net>
 <20110112033709.GA2723@in.ibm.com>
 <AANLkTikFGqznUg7bzFckJy_x2mfBqE7PjaK2n83wLk6c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikFGqznUg7bzFckJy_x2mfBqE7PjaK2n83wLk6c@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 01:40:32PM +0800, Yong Zhang wrote:
> On Wed, Jan 12, 2011 at 11:37 AM, Bharata B Rao
> <bharata@linux.vnet.ibm.com> wrote:
> >> Unless I fscked up, set_task_rq() is the group change.  As soon as the
> >> task's class changes, it'll be moved to the root_task_group.
> >
> > Ok, this is what I understand, may be Peter Z can confirm...
> >
> > set_task_rq() just changes the task's cfs_rq and rt_rq as per its
> > task_group(). The normal way to change a task's group is to first
> > change its cgroup pointer (task->cgroups, see cgroup_attach_task())
> > After this you change the runqueues by calling set_task_rq() which
> > now refers to new group's runqueues.
> >
> > In your code, I don't see where you really change task's group. AFAICS,
> > it continues to remain in the same autogroup.
> 
> IMHO, task->cgroups will not change when autogroup take effect.

Yes and I believe this is cause for some of the weird semantics I see
with autogroup and cgroups. I am not sure if this has already been
discussed ealier, may be I need to go back and check the archives, but
consider this:

I have cpu cgroup mounted at /cgroup and see that all the tasks in the
system are listed in /cgroup/tasks file.

Now I start a task like this:

# ./while1 &
[1] 2761

and see that this task belongs to root cgroup.

# grep 2761 /cgroup/tasks
2671

But we know that this task really belongs to an autogroup and is not
sitting directly on root_task_group.

# cat /proc/2761/autogroup 
/autogroup-49 nice 0

So we have a task in an autogroup (which is a sub group of root_task_group)
but is being shown as part of root_task_group. Is this by design ?

Now say I create a sub cgroup and move this task to it.

# mkdir /cgroup/1
# echo 2671 > /cgroup/1/tasks

So now the task moved to a real cgroup.

# cat /cgroup/1/tasks 
2761

But the /proc/2761/autogroup isn't updated. It still shows
/autogroup-49 nice 0

May be this was all discussed earlier as I noted in the beginning, but I find
this semantics a bit unusual.

Regards,
Bharata.
