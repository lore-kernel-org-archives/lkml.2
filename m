Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab0KPO1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:27:14 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:48035 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933096Ab0KPO1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:27:09 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+/Z8oWFqS/h1envW1I/tH6SB8iVlaiBRL8RN9hd8
	CfrBwThIVIA8yI
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Menage <menage@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Valdis.Kletnieks@vt.edu, Oleg Nesterov <oleg@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Daniel Lezcano <daniel.lezcano@free.fr>
In-Reply-To: <1289915998.2109.618.camel@laptop>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287487757.24189.40.camel@marge.simson.net>
	 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
	 <1287511983.7417.45.camel@marge.simson.net>
	 <1287514410.7368.10.camel@marge.simson.net>
	 <20101020025652.GB26822@elte.hu>
	 <1287648715.9021.20.camel@marge.simson.net>
	 <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins>
	 <20101021162924.GA3225@redhat.com>
	 <1288076838.11930.1.camel@marge.simson.net>
	 <1288078144.7478.9.camel@marge.simson.net>
	 <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
	 <1289489200.11397.21.camel@maggy.simson.net> <30291.1289860866@localhost>
	 <1289864780.14719.172.camel@maggy.simson.net>
	 <AANLkTikztvdgFucCUjZ+A5Je-LUKLknV5+aznVvL98oQ@mail.gmail.com>
	 <1289865870.14719.185.camel@maggy.simson.net>
	 <AANLkTik53N7HMyXMOEzh2Qr_4gg9eXSmXiT6TQ9gFC+h@mail.gmail.com>
	 <AANLkTikvcug2V70Uy7oGnO5vFZbS+DLvzP4wpysdU5uV@mail.gmail.com>
	 <1289915998.2109.618.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 07:26:53 -0700
Message-ID: <1289917613.5169.139.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 14:59 +0100, Peter Zijlstra wrote:
> On Mon, 2010-11-15 at 17:55 -0800, Paul Menage wrote:
> > On Mon, Nov 15, 2010 at 5:18 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > so sched_debug_show() is apparently calling cgroup_path() with a NULL
> > > cgroup. I think it's "print_task()" that is to blame, it does
> > >
> > >     cgroup_path(task_group(p)->css.cgroup, ..
> > >
> > > without checking whether there _is_ any css.cgroup.
> > 
> > Right - previously the returned task_group would be always associated
> > with a cgroup. Now, it may not be.
> > 
> > The original task_group() should be made accessible for anything that
> > wants a real cgroup in the scheduler hierarchy, and called from the
> > new task_group() function. Not sure what the best naming convention
> > would be, maybe task_group() and effective_task_group() ?
> 
> Right, that doesn't solve the full problem though.
> 
> /proc/sched_debug should show these automagic task_groups, its just that
> there's currently no way to properly name them, we can of course add
> something like a name field to the struct autogroup thing, but what do
> we fill it with? "autogroup-%d" and keep a sequence number for each
> autogroup?

I was considering exactly that for /proc/N/cgroup visibility.  Might get
thumped if I re-use that file though.

> Then the below task_group_path() thing can try the autogroup name scheme
> if it finds a NULL css.
> 
> Something like the below might avoid the explosion:
> 
> ---
>  kernel/sched_debug.c |   28 ++++++++++++++--------------
>  1 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
> index 2e1b0d1..9b5560f 100644
> --- a/kernel/sched_debug.c
> +++ b/kernel/sched_debug.c
> @@ -87,6 +87,19 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu,
>  }
>  #endif
>  
> +#if defined(CONFIG_CGROUP_SCHED) && \
> +	(defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED))
> +static void task_group_path(struct task_group *tg, char *buf, int buflen)
> +{
> +	/* may be NULL if the underlying cgroup isn't fully-created yet */
> +	if (!tg->css.cgroup) {
> +		buf[0] = '\0';
> +		return;
> +	}
> +	cgroup_path(tg->css.cgroup, buf, buflen);
> +}
> +#endif
> +
>  static void
>  print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
>  {
> @@ -115,7 +128,7 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
>  		char path[64];
>  
>  		rcu_read_lock();
> -		cgroup_path(task_group(p)->css.cgroup, path, sizeof(path));
> +		task_group_path(task_group(p), path, sizeof(path));
>  		rcu_read_unlock();
>  		SEQ_printf(m, " %s", path);
>  	}
> @@ -147,19 +160,6 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
>  	read_unlock_irqrestore(&tasklist_lock, flags);
>  }
>  
> -#if defined(CONFIG_CGROUP_SCHED) && \
> -	(defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED))
> -static void task_group_path(struct task_group *tg, char *buf, int buflen)
> -{
> -	/* may be NULL if the underlying cgroup isn't fully-created yet */
> -	if (!tg->css.cgroup) {
> -		buf[0] = '\0';
> -		return;
> -	}
> -	cgroup_path(tg->css.cgroup, buf, buflen);
> -}
> -#endif
> -
>  void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>  {
>  	s64 MIN_vruntime = -1, min_vruntime, max_vruntime = -1,
> 


