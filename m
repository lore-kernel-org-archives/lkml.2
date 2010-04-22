Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab0DVT7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:59:21 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42788 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757787Ab0DVT7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:59:15 -0400
Date: Thu, 22 Apr 2010 12:59:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>, Cedric Le Goater <clg@vnet.ibm.com>
Subject: Re: [PATCH 4/5] freezer cgroup: Fix an RCU warning in
 cgroup_freezing_or_frozen()
Message-ID: <20100422195911.GN2524@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BD016F4.8060108@cn.fujitsu.com>
 <4BD01768.2020606@cn.fujitsu.com>
 <1271939275.1776.345.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271939275.1776.345.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 02:27:55PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-04-22 at 17:31 +0800, Li Zefan wrote:
> > with CONFIG_PROVE_RCU, a warning can be triggered when we
> > resume from suspend:
> > 
> > ...
> > include/linux/cgroup.h:533 invoked rcu_dereference_check() without protection!
> > ...
> > 
> > task_freezer() calls task_subsys_state(), which needs to be
> > protected by rcu_read_lock or cgroup_mutex.
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > ---
> >  kernel/cgroup_freezer.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> > index 5038f4c..ac76983 100644
> > --- a/kernel/cgroup_freezer.c
> > +++ b/kernel/cgroup_freezer.c
> > @@ -53,6 +53,7 @@ int cgroup_freezing_or_frozen(struct task_struct *task)
> >  	struct freezer *freezer;
> >  	enum freezer_state state;
> >  
> > +	rcu_read_lock();
> >  	task_lock(task);
> >  	freezer = task_freezer(task);
> >  	if (!freezer->css.cgroup->parent)
> > @@ -60,6 +61,7 @@ int cgroup_freezing_or_frozen(struct task_struct *task)
> >  	else
> >  		state = freezer->state;
> >  	task_unlock(task);
> > +	rcu_read_unlock();
> >  
> >  	return (state == CGROUP_FREEZING) || (state == CGROUP_FROZEN);
> >  }
> 
> Hmm cgroup_attach_task() does hold task_lock() over setting
> tsk->cgroups, so doesn't that also pin the task to the cgroup and thus
> the cgroup itself?

So you are advocating for the rcu_dereference check including the
task lock, correct?

							Thanx, Paul
