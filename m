Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab0EJAVw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 20:21:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34212 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab0EJAVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 20:21:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 10 May 2010 09:17:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH tip/core/urgent 08/10] memcg: css_id() must be called
 under rcu_read_lock()
Message-Id: <20100510091726.f9a0642f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100507121138.cc37dbe4.akpm@linux-foundation.org>
References: <20100503185253.GA17672@linux.vnet.ibm.com>
	<1272912799-17859-8-git-send-email-paulmck@linux.vnet.ibm.com>
	<20100507121138.cc37dbe4.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 May 2010 12:11:38 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon,  3 May 2010 11:53:17 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > This patch fixes task_in_mem_cgroup(), mem_cgroup_uncharge_swapcache(),
> > mem_cgroup_move_swap_account(), and is_target_pte_for_mc() to protect
> > calls to css_id().  An additional RCU lockdep splat was reported for
> > memcg_oom_wake_function(), however, this function is not yet in
> > mainline as of 2.6.34-rc5.
> > 
> > ...
> >
> > index f4ede99..e06490d 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -811,10 +811,12 @@ int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
> >  	 * enabled in "curr" and "curr" is a child of "mem" in *cgroup*
> >  	 * hierarchy(even if use_hierarchy is disabled in "mem").
> >  	 */
> > +	rcu_read_lock();
> >  	if (mem->use_hierarchy)
> >  		ret = css_is_ancestor(&curr->css, &mem->css);
> >  	else
> >  		ret = (curr == mem);
> > +	rcu_read_unlock();
> >  	css_put(&curr->css);
> >  	return ret;
> >  }
> 
> The above hunk seems to be locking around css_is_ancestor(), not
> css_id() as the changelog states.
> 

Hmm. I'll move rcu_xxx to cgroup.c::css_is_ancestor().
(But .....because we have css's reference count, rcu_read_lock isn't
 necessary...lock-check founds it as bug but this was intentional.)



> > @@ -2312,7 +2314,9 @@ mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
> >  
> >  	/* record memcg information */
> >  	if (do_swap_account && swapout && memcg) {
> > +		rcu_read_lock();
> >  		swap_cgroup_record(ent, css_id(&memcg->css));
> > +		rcu_read_unlock();
> >  		mem_cgroup_get(memcg);
> >  	}
> >  	if (swapout && memcg)
> 
> That makes some sense - the lock is held across the call and the use of
> the result of the call.
> 
> 
> > @@ -2369,8 +2373,10 @@ static int mem_cgroup_move_swap_account(swp_entry_t entry,
> >  {
> >  	unsigned short old_id, new_id;
> >  
> > +	rcu_read_lock();
> >  	old_id = css_id(&from->css);
> >  	new_id = css_id(&to->css);
> > +	rcu_read_unlock();
> >  
> >  	if (swap_cgroup_cmpxchg(entry, old_id, new_id) == old_id) {
> >  		mem_cgroup_swap_statistics(from, false);
> 
> This doesn't make sense.  We take the lock, read the values, drop the
> lock and then use the now-possibly-wrong values.
> 
will fix.

> > @@ -4038,11 +4044,16 @@ static int is_target_pte_for_mc(struct vm_area_struct *vma,
> >  			put_page(page);
> >  	}
> >  	/* throught */
> > -	if (ent.val && do_swap_account && !ret &&
> > -			css_id(&mc.from->css) == lookup_swap_cgroup(ent)) {
> > -		ret = MC_TARGET_SWAP;
> > -		if (target)
> > -			target->ent = ent;
> > +	if (ent.val && do_swap_account && !ret) {
> > +		unsigned short id;
> 
> Please put a newline between end-of-locals and start-of-code.
> 
will fix.

> > +		rcu_read_lock();
> > +		id = css_id(&mc.from->css);
> > +		rcu_read_unlock();
> > +		if (id == lookup_swap_cgroup(ent)) {
> > +			ret = MC_TARGET_SWAP;
> > +			if (target)
> > +				target->ent = ent;
> > +		}
> 
> Again, when we use `id', the lock has been dropped.  The value which
> css_id() returned might no longer be correct.
> 
> 
will fix. 

> 
> The merge of this patch caused rejections in -mm's
> memcg-clean-up-move-charge.patch (at least).  It may have caused more,
> I haven't checked yet.  The code I have here now does:
> 
> 	if (ent.val && !ret) {
> 		unsigned short id;
> 
> 		rcu_read_lock();
> 		id = css_id(&mc.from->css);
> 		rcu_read_unlock();
> 		if (id == lookup_swap_cgroup(ent)) {
> 			ret = MC_TARGET_SWAP;
> 			if (target)
> 				target->ent = ent;
> 		}
> 	}
> 
> however I suspect it would be saner to do
> 
> 	if (ent.val && !ret) {
> 		rcu_read_lock();
> 		if (css_id(&mc.from->css) == lookup_swap_cgroup(ent)) {
> 			ret = MC_TARGET_SWAP;
> 			if (target)
> 				target->ent = ent;
> 		}
> 		rcu_read_unlock();
> 	}
> 

I'll prepare for -rc6 patch and for -mm patch.


> However this still doesn't make a lot of sense because three nanoseonds
> after we've done rcu_read_unlock(), the value of
> 
> 	css_id(&mc.from->css) == lookup_swap_cgroup(ent)
> 
> might have changed.  So I'd ask the memcg guys to have a more serious
> think about all of this please.  I get the feeling that the original
> patch just splattered rcu_read_lock() around the place to silence a
> runtime warning without digging into what the code is really supposed
> to be doing.
> 
In most case, they are intentional and we have reference count of css.

I can think of

	- css_id_rcu()  .... use rcu_dereference().
	- css_id()	... don't use rcu_dereference().

But this seems crazy.



> The mem_cgroup_move_swap_account() would benefit from some attention
> also please.

ok, I'll rewrite. If I find that I can't avoid rejection to -mm, I'll make
a patch for -rc6 to do minimal fixes. And add a patch for fixining remaining
things to -mm.

Thanks,
-Kame


