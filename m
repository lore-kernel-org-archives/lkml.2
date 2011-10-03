Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab1JCAbt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 20:31:49 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:46810 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1JCAbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 20:31:44 -0400
Date: Mon, 3 Oct 2011 09:22:44 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrew Morton <akpm00@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        container ML <containers@lists.linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Miao Xie <miaox@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <htejun@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [BUGFIX] cgroup: create a workqueue for cgroup
Message-Id: <20111003092244.bcfde141.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20110930153049.6719a14e.akpm00@gmail.com>
References: <20110930165452.19c0fdf4.nishimura@mxp.nes.nec.co.jp>
	<20110930153049.6719a14e.akpm00@gmail.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Sep 2011 15:30:49 -0700
Andrew Morton <akpm00@gmail.com> wrote:

> On Fri, 30 Sep 2011 16:54:52 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > In commit:f90d4118, cpuset_wq, a separate workqueue for cpuset, was introduced
> > to avoid a dead lock against cgroup_mutex between async_rebuild_sched_domains()
> > and cgroup_tasks_write().
> > 
> > But check_for_release() has a similar problem:
> > 
> >   check_for_release()
> >     schedule_work(release_agent_work)
> >       cgroup_release_agent()
> >         mutex_lock(&cgroup_mutex)
> > 
> > And I actually see a lockup which seems to be caused by this problem
> > on 2.6.32-131.0.15.el6.x86_64.
> 
> Are you sure the bug is still present in current kernels?  Perhaps
> Tejun's workqueue changes magically made it go away.
> 
Not yet, but I'll check it.

> >
> > ...
> > --- a/include/linux/cgroup.h
> > +++ b/include/linux/cgroup.h
> > @@ -27,6 +27,8 @@ struct css_id;
> >  
> >  extern int cgroup_init_early(void);
> >  extern int cgroup_init(void);
> > +extern void cgroup_wq_init(void);
> > +extern void queue_cgroup_work(struct work_struct *work);
> >  extern void cgroup_lock(void);
> >  extern int cgroup_lock_is_held(void);
> >  extern bool cgroup_lock_live_group(struct cgroup *cgrp);
> 
> Can we spot the odd man out?
> 
> I shall rename queue_cgroup_work() to cgroup_queue_work().
> 
Thank you for fixing it.
I agree cgroup_queue_work() is a better name.

Thanks,
Daisuke Nishimura.
