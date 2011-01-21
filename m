Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab1AUNPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 08:15:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48915 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab1AUNPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 08:15:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LRpObZZ8HZbH1gAWMk0TcuKhIjyQ540dKdDV0K402sxVu7P4tg4SVxQVj0nbpKd6O3
         iM319qteXw9qQsR1B2c09rvmwlHEXsniqV3z5Vx0h/ULnmRXrCiHM6PmPDfsFHd55On5
         yjRNEAlT6G52nvgpHV/BMMcihtZTShZZtrW5k=
Date: Fri, 21 Jan 2011 21:15:01 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, samu.p.onkalo@nokia.com,
        mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Bug in scheduler when using rt_mutex
Message-ID: <20110121131501.GA6051@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1295442799.11678.43.camel@kolo>
 <1295443822.28776.23.camel@laptop>
 <AANLkTinQ4sczEwZYCk1_tLmeJyjyXj4TVoSZbjg+KiRq@mail.gmail.com>
 <1295499568.8027.30.camel@marge.simson.net>
 <AANLkTikEwgMzco2fHT668Mg3fC-T3EBMUgQQqW-Ojj-Y@mail.gmail.com>
 <1295503938.8027.59.camel@marge.simson.net>
 <AANLkTi=7YyA-e8HAq+C_prK2EaZKcaTfzDJvmO3e3W=B@mail.gmail.com>
 <1295512625.8027.88.camel@marge.simson.net>
 <AANLkTi=WhLy=4MNdm-HaOUOmbKXsNSJojnzqRTYp6qop@mail.gmail.com>
 <1295518047.8027.104.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1295518047.8027.104.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 11:07:27AM +0100, Mike Galbraith wrote:
> On Thu, 2011-01-20 at 17:07 +0800, Yong Zhang wrote:
> > On Thu, Jan 20, 2011 at 4:37 PM, Mike Galbraith <efault@gmx.de> wrote:
> > > On Thu, 2011-01-20 at 15:06 +0800, Yong Zhang wrote:
> > >> On Thu, Jan 20, 2011 at 2:12 PM, Mike Galbraith <efault@gmx.de> wrote:
> > >> > If the task returns as a sleeper, place entity() will be called when it
> > >> > is awakened, so it's sleep credit will be clipped as usual.  So vruntime
> > >> > can be much less than min_vruntime at class exit time, and it doesn't
> > >> > matter, clipping on wakeup after re-entry takes care of it.. if that's
> > >> > what you were thinking about.
> > >>
> > >> For a sleep task which stay in sched_fair before it's waked:
> > >> try_to_wake_up()
> > >>   ttwu_activate()
> > >>     activate_task()
> > >>       enqueue_task_fair()
> > >>         enqueue_entity()
> > >>           place_entity()        <== clip vruntime
> > >>
> > >> For a sleep task which promote to sched_rt when it's sleep:
> > >> rt_mutex_setprio()
> > >>   check_class_changed()
> > >>     switch_from_fair()       <== vruntime -= min_vruntime
> > >>       try_to_wake_up()
> > >>         ...run then stay on rq
> > >>         rt_mutex_setprio()
> > >>           enqueue_task_fair()     <==vruntime += min_vruntime
> > >>
> > >> The difference is that in the second case, place_entity() is not
> > >> called, but wrt sched_fair, the task is a WAKEUP task.
> > >> Then we place this task in sched_fair before where it should be.
> > >
> > > D'oh.  You're right, he needs to be clipped before he leaves.
> > 
> > Exactly we should clip it when it comes back, because it still could
> > sleep for some time after it leaves ;)
> 
> That's ok, we don't and aren't supposed to care what happens while he's
> gone.  But we do have to make sure that vruntime is sane either when he
> leaves, or when he comes back.  Seems to me the easiest is clip when he
> leaves to cover him having slept a long time before leaving, then coming
> back on us as a runner.  If he comes back as a sleeper, he'll be clipped
> again anyway, so all is well.

OK, fair enough.

> 
> sched_fork() should probably zero child's vruntime too, so non-fair
> children can't enter fair_class with some bogus lag they never had.

Yeah,
So I think Peter's new patch is taking care of all the issue now.

Thanks,
Yong
