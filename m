Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab0FPEzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 00:55:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33078 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab0FPEzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 00:55:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Jun 2010 13:51:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       Oleg Nesterov <oleg@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] use find_lock_task_mm in memory cgroups oom v2
Message-Id: <20100616135109.75b21f7c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTikGcl8l8TvSWx2Ij7I5E-TVjGplRU5YfX0mTAG0@mail.gmail.com>
References: <20100615152450.f82c1f8c.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTinEEYWULLICKqBr4yX7GL01E4cq0jQSfuN8J6Jq@mail.gmail.com>
	<20100616090334.d27e0c4e.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikGcl8l8TvSWx2Ij7I5E-TVjGplRU5YfX0mTAG0@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010 10:12:20 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> On Wed, Jun 16, 2010 at 5:33 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Tue, 15 Jun 2010 18:59:25 +0900
> > Minchan Kim <minchan.kim@gmail.com> wrote:
> >
> >> > -/*
> >> > +/**
> >> > + * find_lock_task_mm - Checking a process which a task belongs to has valid mm
> >> > + * and return a locked task which has a valid pointer to mm.
> >> > + *
> >>
> >> This comment should have been another patch.
> >> BTW, below comment uses "subthread" word.
> >> Personally it's easy to understand function's goal to me. :)
> >>
> >> How about following as?
> >> Checking a process which has any subthread with vaild mm
> >> ....
> >>
> > Sure. thank you. v2 is here. I removed unnecessary parts.
> >
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> > When the OOM killer scans task, it check a task is under memcg or
> > not when it's called via memcg's context.
> >
> > But, as Oleg pointed out, a thread group leader may have NULL ->mm
> > and task_in_mem_cgroup() may do wrong decision. We have to use
> > find_lock_task_mm() in memcg as generic OOM-Killer does.
> >
> > Changelog:
> >  - removed unnecessary changes in comments.
> >
> 
> mm->owner solves the same problem, but unfortunately we have task
> based selection in OOM killer, so we need this patch. It is quite
> ironic that we find the mm from the task and then eventually the task
> back from mm->owner and then the mem cgroup. If we already know the mm
> from oom_kill.c, I think we can change the function to work off of
> that. mm->owner->cgroup..no?
> 

There is no function as for_each_mm(). There is only for_each_process().

And, generally, there is no way to get a task via mm_struct.
To send signal etc. we need task.
(mm_owner is an option but not always configured and there will be
 complicated problem as vfork() etc.)

I think oom_kill.c has to depend on thread, not mm, unfortunately.


Thanks,
-Kame

