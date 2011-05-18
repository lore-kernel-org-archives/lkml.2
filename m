Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab1ERBip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 21:38:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46185 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677Ab1ERBio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 21:38:44 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=XYJHFtupD_QA:10 a=nZMiEFGSWTUA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=aDwY-2FZ_ZypQZgIKlIA:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Tue, 17 May 2011 21:38:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] sched: correct how RT task is picked
Message-ID: <20110518013842.GD23940@home.goodmis.org>
References: <BANLkTikkeR_yf1HGhgq7WEO-kEvDGkV_tw@mail.gmail.com>
 <BANLkTim4n-WA_6nJpg4Nd99yuc3f+VWkcw@mail.gmail.com>
 <BANLkTikOecxhb8pZfAd19FLrPAPY4zacDQ@mail.gmail.com>
 <20110512120606.GA3639@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512120606.GA3639@zhy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 08:06:06PM +0800, Yong Zhang wrote:
> On Wed, May 11, 2011 at 09:44:04PM +0800, Hillf Danton wrote:
> > On Wed, May 11, 2011 at 4:43 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> > > On Tue, May 10, 2011 at 9:04 PM, Hillf Danton <dhillf@gmail.com> wrote:
> > >> When picking RT task for given CPU,
> > >> [1] if the cpu is invalid for cpumask test, right result could not be
> > >
> > > 'cpu is invalid' means weather we care it or not, it's not real 'invalid'
> > >
> > If cpu is not cared, how to determine whether it is allowed for task to run?
> 
> pick_next_highest_task_rt() can be used to get the next highest pullable
> task on a certain rq(regradless on which cpu that task could run). but
> currently we have no such kind of caller.
> 
> > 
> > >> reached even by further checking nr_cpus_allowed,
> > >> on the other hand, the input cpu is valid in two cases that
> > >> pick_next_highest_task_rt() is called, thus the invalid input cpu
> > >> looks over-concern.
> > >> [2] if the cpu is valid for cpumask test, further checking
> > >> nr_cpus_allowed looks overwork, since it is computed based on
> > >> cpus_allowed,
> > >
> > > No, cpumask_test_cpu(cpu, &p->cpus_allowed) doesn't mean
> > > p->rt.nr_cpus_allowed > 1.
> > >
> > If cpu is allowed for task to run, then why more cpus are enforced?
> 
> I think you can take a look at next_prio(), it just calculate the
> next highest task on the current cpu; in this case,
> cpumask_test_cpu(cpu, &p->cpus_allowed) will be true for the most
> of time, but maybe that task is bound to this cpu.

I've been looking at the history here, and I think that '-1' is a relic.

If you look at sched_rt.c in f65eda4f789168ba5ff3fa75546c29efeed19f58:

$ git show f65eda4f:kernel/sched_rt.c 

You'll see that push_rt_task calls pick_next_highest_task_rt() with a
-1. That code has long been replaced.

I'm a bit nervous about taking Hillf's patch as is. But a little more
reviewing and testing may prove that it is legit.

-- Steve

