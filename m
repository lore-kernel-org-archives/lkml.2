Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab0K3Qlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:41:53 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:35397 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751528Ab0K3Qlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:41:52 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19H8W9YUOdHxa3uF02qHudugfCOBurrQIQfTruSsB
	zfCERc2Duj//Vs
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Turner <pjt@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101130141320.GA22588@elte.hu>
References: <20101128201851.GA20555@elte.hu>
	 <1291031593.32004.19.camel@laptop>
	 <AANLkTimQ2Kp2=um9ip7J2=-joskmz4P-0b_SrexFbTh0@mail.gmail.com>
	 <1291052268.32004.171.camel@laptop>
	 <1291057565.20709.2.camel@marge.simson.net>
	 <20101129192033.GA18372@elte.hu>
	 <AANLkTi=jra_M+F9OKj31uS6EMu+ZkPT++GSrNd_bgXSy@mail.gmail.com>
	 <1291090455.7550.7.camel@marge.simson.net>
	 <AANLkTi=YDHyRcP5NSdVDRMW0_oj1L85aLzGV9hFGw1FN@mail.gmail.com>
	 <1291123083.28239.18.camel@marge.simson.net>
	 <20101130141320.GA22588@elte.hu>
Content-Type: text/plain
Date: Tue, 30 Nov 2010 17:41:46 +0100
Message-Id: <1291135306.28239.38.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 15:13 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Mon, 2010-11-29 at 20:23 -0800, Paul Turner wrote:
> > 
> > > I've left some machines running tip + fix above + autogroup to see if
> > > anything else emerges.  Hasn't crashed yet, I'll leave it going
> > > overnight.
> > 
> > Thanks.  Below is the hopefully final version against tip.  The last I
> > sent contained a couple remnants.
> 
> Note, I removed this chunk:
> 
> >  kernel/sched_debug.c                |   29 ++--
> 
> > Index: linux-2.6/kernel/sched_debug.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched_debug.c
> > +++ linux-2.6/kernel/sched_debug.c
> > @@ -87,6 +87,20 @@ static void print_cfs_group_stats(struct
> >  }
> >  #endif
> >  
> > +#if defined(CONFIG_CGROUP_SCHED) && \
> > +	(defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED))
> > +static void task_group_path(struct task_group *tg, char *buf, int buflen)
> > +{
> > +	/* may be NULL if the underlying cgroup isn't fully-created yet */
> > +	if (!tg->css.cgroup) {
> > +		if (!autogroup_path(tg, buf, buflen))
> > +			buf[0] = '\0';
> > +		return;
> > +	}
> > +	cgroup_path(tg->css.cgroup, buf, buflen);
> > +}
> > +#endif
> > +
> >  static void
> >  print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
> >  {
> > @@ -115,7 +129,7 @@ print_task(struct seq_file *m, struct rq
> >  		char path[64];
> >  
> >  		rcu_read_lock();
> > -		cgroup_path(task_group(p)->css.cgroup, path, sizeof(path));
> > +		task_group_path(task_group(p), path, sizeof(path));
> >  		rcu_read_unlock();
> >  		SEQ_printf(m, " %s", path);
> >  	}
> > @@ -147,19 +161,6 @@ static void print_rq(struct seq_file *m,
> >  	read_unlock_irqrestore(&tasklist_lock, flags);
> >  }
> >  
> > -#if defined(CONFIG_CGROUP_SCHED) && \
> > -	(defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED))
> > -static void task_group_path(struct task_group *tg, char *buf, int buflen)
> > -{
> > -	/* may be NULL if the underlying cgroup isn't fully-created yet */
> > -	if (!tg->css.cgroup) {
> > -		buf[0] = '\0';
> > -		return;
> > -	}
> > -	cgroup_path(tg->css.cgroup, buf, buflen);
> > -}
> > -#endif
> > -
> >  void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
> >  {
> >  	s64 MIN_vruntime = -1, min_vruntime, max_vruntime = -1,
> 
> Because it didn't build (for obvious reasons - the CONFIG conditions dont match up), 
> but more importantly it's quite ugly. Some existing 'path' variables are 64 byte, 
> some are 128 byte - so there's pre-existing damage - i removed it all.

Won't removing that hunk bring back oops if you cat /proc/sched_debug?

cfs_rq[0]:/autogroup-88
  .exec_clock                    : 0.228697
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 0.819879
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -22925903.100800

> Could we do this debugging code in a bit saner way please? (as a delta patch on top 
> of the -tip that i'll push out in the next hour or so.)

Guess I'll try.

	-Mike



