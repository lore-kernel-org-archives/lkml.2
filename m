Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab1GHPsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 11:48:42 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54446 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab1GHPsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 11:48:40 -0400
Date: Fri, 8 Jul 2011 08:48:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Cleanup PATCH] rcu: Do not use rcu_read_lock_held when
 calling rcu_dereference_check
Message-ID: <20110708154829.GS6014@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110708135739.GB12834@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708135739.GB12834@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 03:57:39PM +0200, Michal Hocko wrote:
> Hi Paul,
> I guess that this falls down to your area because the code, even though
> it touches multiple areas, is RCU specific. Let me know if I should
> break it into smaller pieces or that I should push it through other
> trees.
> 
> git grep -n -A3 "\<rcu_dereference_.*check" doesn't show any other
> variants to be "affected".

Hello, Michal,

Good catch, thank you!!!

Could you please break this up by maintainer?

I have already queued your changes to Documentation/RCU/lockdep.txt with
your Signed-off-by (probably for 3.1), so please don't worry about those.

							Thanx, Paul

> The patch is based on the current Linus tree (f1bb20a8).
> ---
> >From ae2bf11a3057bb10b69667d117bca6668ba644cb Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Fri, 8 Jul 2011 14:39:41 +0200
> Subject: [PATCH] rcu: Do not use rcu_read_lock_held when calling
>  rcu_dereference_check
> 
> Since ca5ecddf (rcu: define __rcu address space modifier for sparse)
> rcu_dereference_check use rcu_read_lock_held as a part of condition
> automatically so callers do not have to do that as well.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  Documentation/RCU/lockdep.txt      |    6 ++----
>  include/linux/cgroup.h             |    1 -
>  include/linux/cred.h               |    1 -
>  include/linux/fdtable.h            |    1 -
>  include/linux/rtnetlink.h          |    3 +--
>  include/net/sock.h                 |    3 +--
>  kernel/cgroup.c                    |    8 ++------
>  kernel/exit.c                      |    1 -
>  kernel/pid.c                       |    1 -
>  kernel/rcutorture.c                |    2 --
>  kernel/sched.c                     |    1 -
>  net/mac80211/sta_info.c            |    4 ----
>  net/netlabel/netlabel_domainhash.c |    3 +--
>  net/netlabel/netlabel_unlabeled.c  |    3 +--
>  security/keys/keyring.c            |    1 -
>  15 files changed, 8 insertions(+), 31 deletions(-)
> 
> diff --git a/Documentation/RCU/lockdep.txt b/Documentation/RCU/lockdep.txt
> index d7a49b2..fc5820a 100644
> --- a/Documentation/RCU/lockdep.txt
> +++ b/Documentation/RCU/lockdep.txt
> @@ -48,13 +48,11 @@ checking of rcu_dereference() primitives:
>  		value of the pointer itself, for example, against NULL.
> 
>  The rcu_dereference_check() check expression can be any boolean
> -expression, but would normally include one of the rcu_read_lock_held()
> -family of functions and a lockdep expression.  However, any boolean
> -expression can be used.  For a moderately ornate example, consider
> +expression, but would normally include a lockdep expression. However, any
> +boolean expression can be used.  For a moderately ornate example, consider
>  the following:
> 
>  	file = rcu_dereference_check(fdt->fd[fd],
> -				     rcu_read_lock_held() ||
>  				     lockdep_is_held(&files->file_lock) ||
>  				     atomic_read(&files->count) == 1);
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index ab4ac0c..da7e4bc 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -539,7 +539,6 @@ static inline struct cgroup_subsys_state *cgroup_subsys_state(
>   */
>  #define task_subsys_state_check(task, subsys_id, __c)			\
>  	rcu_dereference_check(task->cgroups->subsys[subsys_id],		\
> -			      rcu_read_lock_held() ||			\
>  			      lockdep_is_held(&task->alloc_lock) ||	\
>  			      cgroup_lock_is_held() || (__c))
> 
> diff --git a/include/linux/cred.h b/include/linux/cred.h
> index 8260799..f240f2f 100644
> --- a/include/linux/cred.h
> +++ b/include/linux/cred.h
> @@ -284,7 +284,6 @@ static inline void put_cred(const struct cred *_cred)
>  	({								\
>  		const struct task_struct *__t = (task);			\
>  		rcu_dereference_check(__t->real_cred,			\
> -				      rcu_read_lock_held() ||		\
>  				      task_is_dead(__t));		\
>  	})
> 
> diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
> index 133c0ba..df7e3cf 100644
> --- a/include/linux/fdtable.h
> +++ b/include/linux/fdtable.h
> @@ -60,7 +60,6 @@ struct files_struct {
> 
>  #define rcu_dereference_check_fdtable(files, fdtfd) \
>  	(rcu_dereference_check((fdtfd), \
> -			       rcu_read_lock_held() || \
>  			       lockdep_is_held(&(files)->file_lock) || \
>  			       atomic_read(&(files)->count) == 1 || \
>  			       rcu_my_thread_group_empty()))
> diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
> index bbad657..27576aa 100644
> --- a/include/linux/rtnetlink.h
> +++ b/include/linux/rtnetlink.h
> @@ -758,8 +758,7 @@ extern int lockdep_rtnl_is_held(void);
>   * or RTNL. Note : Please prefer rtnl_dereference() or rcu_dereference()
>   */
>  #define rcu_dereference_rtnl(p)					\
> -	rcu_dereference_check(p, rcu_read_lock_held() ||	\
> -				 lockdep_rtnl_is_held())
> +	rcu_dereference_check(p, lockdep_rtnl_is_held())
> 
>  /**
>   * rtnl_dereference - fetch RCU pointer when updates are prevented by RTNL
> diff --git a/include/net/sock.h b/include/net/sock.h
> index c0b938c..d5b65c1 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1301,8 +1301,7 @@ extern unsigned long sock_i_ino(struct sock *sk);
>  static inline struct dst_entry *
>  __sk_dst_get(struct sock *sk)
>  {
> -	return rcu_dereference_check(sk->sk_dst_cache, rcu_read_lock_held() ||
> -						       sock_owned_by_user(sk) ||
> +	return rcu_dereference_check(sk->sk_dst_cache, sock_owned_by_user(sk) ||
>  						       lockdep_is_held(&sk->sk_lock.slock));
>  }
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 2731d11..5ae71d6 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1697,7 +1697,6 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
>  {
>  	char *start;
>  	struct dentry *dentry = rcu_dereference_check(cgrp->dentry,
> -						      rcu_read_lock_held() ||
>  						      cgroup_lock_is_held());
> 
>  	if (!dentry || cgrp == dummytop) {
> @@ -1723,7 +1722,6 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
>  			break;
> 
>  		dentry = rcu_dereference_check(cgrp->dentry,
> -					       rcu_read_lock_held() ||
>  					       cgroup_lock_is_held());
>  		if (!cgrp->parent)
>  			continue;
> @@ -4813,8 +4811,7 @@ unsigned short css_id(struct cgroup_subsys_state *css)
>  	 * on this or this is under rcu_read_lock(). Once css->id is allocated,
>  	 * it's unchanged until freed.
>  	 */
> -	cssid = rcu_dereference_check(css->id,
> -			rcu_read_lock_held() || atomic_read(&css->refcnt));
> +	cssid = rcu_dereference_check(css->id, atomic_read(&css->refcnt));
> 
>  	if (cssid)
>  		return cssid->id;
> @@ -4826,8 +4823,7 @@ unsigned short css_depth(struct cgroup_subsys_state *css)
>  {
>  	struct css_id *cssid;
> 
> -	cssid = rcu_dereference_check(css->id,
> -			rcu_read_lock_held() || atomic_read(&css->refcnt));
> +	cssid = rcu_dereference_check(css->id, atomic_read(&css->refcnt));
> 
>  	if (cssid)
>  		return cssid->depth;
> diff --git a/kernel/exit.c b/kernel/exit.c
> index f2b321b..14c9b63 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -85,7 +85,6 @@ static void __exit_signal(struct task_struct *tsk)
>  	struct tty_struct *uninitialized_var(tty);
> 
>  	sighand = rcu_dereference_check(tsk->sighand,
> -					rcu_read_lock_held() ||
>  					lockdep_tasklist_lock_is_held());
>  	spin_lock(&sighand->siglock);
> 
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 57a8346..e432057 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -405,7 +405,6 @@ struct task_struct *pid_task(struct pid *pid, enum pid_type type)
>  	if (pid) {
>  		struct hlist_node *first;
>  		first = rcu_dereference_check(hlist_first_rcu(&pid->tasks[type]),
> -					      rcu_read_lock_held() ||
>  					      lockdep_tasklist_lock_is_held());
>  		if (first)
>  			result = hlist_entry(first, struct task_struct, pids[(type)].node);
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index 2e138db..ced7210 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -941,7 +941,6 @@ static void rcu_torture_timer(unsigned long unused)
>  	idx = cur_ops->readlock();
>  	completed = cur_ops->completed();
>  	p = rcu_dereference_check(rcu_torture_current,
> -				  rcu_read_lock_held() ||
>  				  rcu_read_lock_bh_held() ||
>  				  rcu_read_lock_sched_held() ||
>  				  srcu_read_lock_held(&srcu_ctl));
> @@ -1002,7 +1001,6 @@ rcu_torture_reader(void *arg)
>  		idx = cur_ops->readlock();
>  		completed = cur_ops->completed();
>  		p = rcu_dereference_check(rcu_torture_current,
> -					  rcu_read_lock_held() ||
>  					  rcu_read_lock_bh_held() ||
>  					  rcu_read_lock_sched_held() ||
>  					  srcu_read_lock_held(&srcu_ctl));
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 9769c75..ad8ab90 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -581,7 +581,6 @@ static inline int cpu_of(struct rq *rq)
> 
>  #define rcu_dereference_check_sched_domain(p) \
>  	rcu_dereference_check((p), \
> -			      rcu_read_lock_held() || \
>  			      lockdep_is_held(&sched_domains_mutex))
> 
>  /*
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index b83870b..3db78b6 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -97,7 +97,6 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
>  	struct sta_info *sta;
> 
>  	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
> -				    rcu_read_lock_held() ||
>  				    lockdep_is_held(&local->sta_lock) ||
>  				    lockdep_is_held(&local->sta_mtx));
>  	while (sta) {
> @@ -105,7 +104,6 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
>  		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
>  			break;
>  		sta = rcu_dereference_check(sta->hnext,
> -					    rcu_read_lock_held() ||
>  					    lockdep_is_held(&local->sta_lock) ||
>  					    lockdep_is_held(&local->sta_mtx));
>  	}
> @@ -123,7 +121,6 @@ struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
>  	struct sta_info *sta;
> 
>  	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
> -				    rcu_read_lock_held() ||
>  				    lockdep_is_held(&local->sta_lock) ||
>  				    lockdep_is_held(&local->sta_mtx));
>  	while (sta) {
> @@ -132,7 +129,6 @@ struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
>  		    memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
>  			break;
>  		sta = rcu_dereference_check(sta->hnext,
> -					    rcu_read_lock_held() ||
>  					    lockdep_is_held(&local->sta_lock) ||
>  					    lockdep_is_held(&local->sta_mtx));
>  	}
> diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
> index de0d8e4..2aa975e 100644
> --- a/net/netlabel/netlabel_domainhash.c
> +++ b/net/netlabel/netlabel_domainhash.c
> @@ -55,8 +55,7 @@ struct netlbl_domhsh_tbl {
>   * should be okay */
>  static DEFINE_SPINLOCK(netlbl_domhsh_lock);
>  #define netlbl_domhsh_rcu_deref(p) \
> -	rcu_dereference_check(p, rcu_read_lock_held() || \
> -				 lockdep_is_held(&netlbl_domhsh_lock))
> +	rcu_dereference_check(p, lockdep_is_held(&netlbl_domhsh_lock))
>  static struct netlbl_domhsh_tbl *netlbl_domhsh = NULL;
>  static struct netlbl_dom_map *netlbl_domhsh_def = NULL;
> 
> diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
> index 9c38658..3de3768 100644
> --- a/net/netlabel/netlabel_unlabeled.c
> +++ b/net/netlabel/netlabel_unlabeled.c
> @@ -116,8 +116,7 @@ struct netlbl_unlhsh_walk_arg {
>   * hash table should be okay */
>  static DEFINE_SPINLOCK(netlbl_unlhsh_lock);
>  #define netlbl_unlhsh_rcu_deref(p) \
> -	rcu_dereference_check(p, rcu_read_lock_held() || \
> -				 lockdep_is_held(&netlbl_unlhsh_lock))
> +	rcu_dereference_check(p, lockdep_is_held(&netlbl_unlhsh_lock))
>  static struct netlbl_unlhsh_tbl *netlbl_unlhsh = NULL;
>  static struct netlbl_unlhsh_iface *netlbl_unlhsh_def = NULL;
> 
> diff --git a/security/keys/keyring.c b/security/keys/keyring.c
> index a06ffab..30e242f 100644
> --- a/security/keys/keyring.c
> +++ b/security/keys/keyring.c
> @@ -155,7 +155,6 @@ static void keyring_destroy(struct key *keyring)
>  	}
> 
>  	klist = rcu_dereference_check(keyring->payload.subscriptions,
> -				      rcu_read_lock_held() ||
>  				      atomic_read(&keyring->usage) == 0);
>  	if (klist) {
>  		for (loop = klist->nkeys - 1; loop >= 0; loop--)
> -- 
> 1.7.5.4
> 
> -- 
> Michal Hocko
> SUSE Labs
> SUSE LINUX s.r.o.
> Lihovarska 1060/12
> 190 00 Praha 9    
> Czech Republic
