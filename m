Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031Ab1EBNqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 09:46:44 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54213 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757061Ab1EBNqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 09:46:42 -0400
Date: Mon, 2 May 2011 06:46:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: query: [PATCH 2/2] cgroup: Remove call to synchronize_rcu in
 cgroup_attach_task
Message-ID: <20110502134635.GB4197@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1302170153.12304.31.camel@marge.simson.net>
 <4DA50430.8020701@cn.fujitsu.com>
 <1302664313.7407.29.camel@marge.simson.net>
 <BANLkTikqvP90Etu=L24DPWbckrawM-6n=Q@mail.gmail.com>
 <1303136494.7542.20.camel@marge.simson.net>
 <1303983516.7460.5.camel@marge.simson.net>
 <1304080487.21536.16.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304080487.21536.16.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 02:34:47PM +0200, Mike Galbraith wrote:
> (ok crickets, keep the noise down please)
> 
> On Thu, 2011-04-28 at 11:38 +0200, Mike Galbraith wrote:
> 
> > The explosions are because the logic to snag rmdir() should anyone grab
> > a reference will let us zip right through and free a cgroup while
> > there's a destruction in flight.  Adding a cgrp->count check before
> > trying to cgroup_clear_css_refs() prevents the explosions, but that
> > leaves RCU grace periods still embedded in userspace.
> > 
> > So...
> > 
> > I bent up put_css_set() a bit to try to destroy synchronously on final
> > put if possible, so rmdir() will only be snagged if that fails.  The
> > thing seems to be working, so I'll show it.  Readers (beware) may notice
> > some gratuitous looking chicken scratches.  Just ignore those, and move
> > along smartly to the suggesting a much better way part, for surely one
> > must exist. 
> 
> Hi Self, (*howdy*)
> 
> You might try the below.  No weird gyrations to accomplish the same
> thing, and I see no slub debug gripes, no list debug gripes, nada.
> 
> Makes one wonder what these things do for a living.

If you are adding something to an RCU-protected data structure, then you do
not need synchronize_rcu().  But if you are removing something from
an RCU-protected data structure, then you really do need them.  If you
leave them out, you can see the following type of failure:

1.	CPU 0, running in an RCU read-side critical section, obtains
	a pointer to data item A.

2.	CPU 1 removes data item A from the structure.

3.	CPU 1 does not do a synchronize_rcu().  If CPU 1 had done a
	synchronize_rcu(), then it would have waited until CPU 0 had
	left its RCU read-side critical section, and thus until
	CPU 0 stopped using its pointer to data item A.  But there was
	no synchronize_rcu(), so CPU 0 is still looking at data item A.

4.	CPU 1 frees data item A.

This is very bad.  CPU 0 has a pointer into the freelist.  Worse yet,
some other CPU might allocate memory and get a pointer to data item A.
That CPU and CPU 0 would then have an interesting but short lived
disagreement about that memory's type.  Crash goes the kernel.

So please do not remove synchronize_rcu() calls unless you can prove
that it is safe to do so!

						Thanx, Paul

> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 25c7eb5..b8c64bf 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -826,13 +826,6 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
>  		struct cgroup *cgrp = dentry->d_fsdata;
>  		struct cgroup_subsys *ss;
>  		BUG_ON(!(cgroup_is_removed(cgrp)));
> -		/* It's possible for external users to be holding css
> -		 * reference counts on a cgroup; css_put() needs to
> -		 * be able to access the cgroup after decrementing
> -		 * the reference count in order to know if it needs to
> -		 * queue the cgroup to be handled by the release
> -		 * agent */
> -		synchronize_rcu();
> 
>  		mutex_lock(&cgroup_mutex);
>  		/*
> @@ -1822,7 +1815,6 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
>  			ss->attach(ss, cgrp, oldcgrp, tsk, false);
>  	}
>  	set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
> -	synchronize_rcu();
>  	put_css_set(cg);
> 
>  	/*
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
