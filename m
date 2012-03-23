Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030247Ab2CWR7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 13:59:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964928Ab2CWR7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 13:59:37 -0400
Date: Fri, 23 Mar 2012 18:51:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Q: cgroup: Questions about possible issues in cgroup locking
Message-ID: <20120323175157.GA20675@redhat.com>
References: <20120112003102.GB9511@google.com> <20120112170728.GA25717@redhat.com> <20120112175725.GD9511@google.com> <20120113152010.GA19215@redhat.com> <20120113182750.GD18166@google.com> <20120114173648.GA32543@redhat.com> <20120118231742.GS18166@google.com> <20120119154522.GA14058@redhat.com> <20120320193414.GA21277@redhat.com> <20120321185955.GK27051@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321185955.GK27051@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21, Mandeep Singh Baines wrote:
>
> Oleg Nesterov (oleg@redhat.com) wrote:
> > +/*
> > + * rcu-safe, but should start at ->group_leader.
> > + * thread_group_leader(g) protects against the race with exec which
> > + * removes the leader from list.
> > + * smp_rmb() pairs with implicit mb() implied by unlock + lock in
> > + * de_thread()->release_task() path.
> > + */
> > +#define while_each_thread_rcu(g, t)				\
> > +	while ((t = next_thread(t)) != g &&			\
> > +		({ smp_rmb(); thread_group_leader(g); }))
> > +
>
> Couldn't you miss the exec_thread if:
>
> t = exec_thread && !thread_group_leader(g)

Yes, we already discussed this, iirc.

I was going to write that this is fine, but then I changed my mind.
Indeed, it is not good while_each_thread_rcu() can miss the new leader.

> Could we change do_prlimit()? Especially since its slow path.

But do_prlimit() is correct. It sees the unhashed task under tasklist,
task->group_leader should be correct.

> I really like you're earlier solution (ignoring barrier):
>
> #define while_each_thread(g, t) \
> 	while (t->group_leader == g->group_leader && (t = next_thread(t)) != g)

The problem is "ignoring barrier and races".

OK, I'll try to think again.

Oleg.

