Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab1ATIhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 03:37:12 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:49091 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753118Ab1ATIhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 03:37:10 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19OeDYXowBOlEFZHgsJOR2t1XIeWYXWRNHmyNeXI5
	b0kTxDJxFrR9KT
Subject: Re: Bug in scheduler when using rt_mutex
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, samu.p.onkalo@nokia.com,
        mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <AANLkTi=7YyA-e8HAq+C_prK2EaZKcaTfzDJvmO3e3W=B@mail.gmail.com>
References: <1295275365.12840.13.camel@kolo>
	 <1295280032.30950.128.camel@laptop> <1295339012.11678.35.camel@kolo>
	 <AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
	 <1295357746.30950.681.camel@laptop>
	 <AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
	 <1295430276.30950.1414.camel@laptop> <1295433498.30950.1482.camel@laptop>
	 <1295436632.30950.1542.camel@laptop> <1295441881.11678.41.camel@kolo>
	 <1295442799.11678.43.camel@kolo> <1295443822.28776.23.camel@laptop>
	 <AANLkTinQ4sczEwZYCk1_tLmeJyjyXj4TVoSZbjg+KiRq@mail.gmail.com>
	 <1295499568.8027.30.camel@marge.simson.net>
	 <AANLkTikEwgMzco2fHT668Mg3fC-T3EBMUgQQqW-Ojj-Y@mail.gmail.com>
	 <1295503938.8027.59.camel@marge.simson.net>
	 <AANLkTi=7YyA-e8HAq+C_prK2EaZKcaTfzDJvmO3e3W=B@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 09:37:05 +0100
Message-ID: <1295512625.8027.88.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 15:06 +0800, Yong Zhang wrote:
> On Thu, Jan 20, 2011 at 2:12 PM, Mike Galbraith <efault@gmx.de> wrote:
> > If the task returns as a sleeper, place entity() will be called when it
> > is awakened, so it's sleep credit will be clipped as usual.  So vruntime
> > can be much less than min_vruntime at class exit time, and it doesn't
> > matter, clipping on wakeup after re-entry takes care of it.. if that's
> > what you were thinking about.
> 
> For a sleep task which stay in sched_fair before it's waked:
> try_to_wake_up()
>   ttwu_activate()
>     activate_task()
>       enqueue_task_fair()
>         enqueue_entity()
>           place_entity()        <== clip vruntime
> 
> For a sleep task which promote to sched_rt when it's sleep:
> rt_mutex_setprio()
>   check_class_changed()
>     switch_from_fair()       <== vruntime -= min_vruntime
>       try_to_wake_up()
>         ...run then stay on rq
>         rt_mutex_setprio()
>           enqueue_task_fair()     <==vruntime += min_vruntime
> 
> The difference is that in the second case, place_entity() is not
> called, but wrt sched_fair, the task is a WAKEUP task.
> Then we place this task in sched_fair before where it should be.

D'oh.  You're right, he needs to be clipped before he leaves.

	-Mike

