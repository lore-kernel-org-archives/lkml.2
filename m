Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab2DRSry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:47:54 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:43422 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab2DRSru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:47:50 -0400
Date: Wed, 18 Apr 2012 18:48:47 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Beiderman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        linux-security-module@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 16/43] userns: Simplify the user_namespace by making
 userns->creator a kuid.
Message-ID: <20120418184847.GA4984@mail.hallyn.com>
References: <m11unyn70b.fsf@fess.ebiederm.org>
 <1333862139-31737-16-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333862139-31737-16-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Beiderman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> - Transform userns->creator from a user_struct reference to a simple
>   kuid_t, kgid_t pair.
> 
>   In cap_capable this allows the check to see if we are the creator of
>   a namespace to become the classic suser style euid permission check.
> 
>   This allows us to remove the need for a struct cred in the mapping
>   functions and still be able to dispaly the user namespace creators
>   uid and gid as 0.
> 
> - Remove the now unnecessary delayed_work in free_user_ns.
> 
>   All that is left for free_user_ns to do is to call kmem_cache_free
>   and put_user_ns.  Those functions can be called in any context
>   so call them directly from free_user_ns removing the need for delayed work.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  include/linux/user_namespace.h |    4 ++--
>  kernel/user.c                  |    7 ++++---
>  kernel/user_namespace.c        |   39 ++++++++++++++++++---------------------
>  security/commoncap.c           |    5 +++--
>  4 files changed, 27 insertions(+), 28 deletions(-)
> 
> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> index d767508..8a391bd 100644
> --- a/include/linux/user_namespace.h
> +++ b/include/linux/user_namespace.h
> @@ -9,8 +9,8 @@
>  struct user_namespace {
>  	struct kref		kref;
>  	struct user_namespace	*parent;
> -	struct user_struct	*creator;
> -	struct work_struct	destroyer;
> +	kuid_t			owner;
> +	kgid_t			group;
>  };
>  
>  extern struct user_namespace init_user_ns;
> diff --git a/kernel/user.c b/kernel/user.c
> index 025077e..cff3856 100644
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -25,7 +25,8 @@ struct user_namespace init_user_ns = {
>  	.kref = {
>  		.refcount	= ATOMIC_INIT(3),
>  	},
> -	.creator = &root_user,
> +	.owner = GLOBAL_ROOT_UID,
> +	.group = GLOBAL_ROOT_GID,
>  };
>  EXPORT_SYMBOL_GPL(init_user_ns);
>  
> @@ -54,9 +55,9 @@ struct hlist_head uidhash_table[UIDHASH_SZ];
>   */
>  static DEFINE_SPINLOCK(uidhash_lock);
>  
> -/* root_user.__count is 2, 1 for init task cred, 1 for init_user_ns->user_ns */
> +/* root_user.__count is 1, for init task cred */
>  struct user_struct root_user = {
> -	.__count	= ATOMIC_INIT(2),
> +	.__count	= ATOMIC_INIT(1),
>  	.processes	= ATOMIC_INIT(1),
>  	.files		= ATOMIC_INIT(0),
>  	.sigpending	= ATOMIC_INIT(0),
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 898e973..f69741a 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -27,6 +27,16 @@ int create_user_ns(struct cred *new)
>  {
>  	struct user_namespace *ns, *parent_ns = new->user_ns;
>  	struct user_struct *root_user;
> +	kuid_t owner = make_kuid(new->user_ns, new->euid);
> +	kgid_t group = make_kgid(new->user_ns, new->egid);
> +
> +	/* The creator needs a mapping in the parent user namespace
> +	 * or else we won't be able to reasonably tell userspace who
> +	 * created a user_namespace.
> +	 */
> +	if (!kuid_has_mapping(parent_ns, owner) ||
> +	    !kgid_has_mapping(parent_ns, group))
> +		return -EPERM;
>  
>  	ns = kmem_cache_alloc(user_ns_cachep, GFP_KERNEL);
>  	if (!ns)
> @@ -43,7 +53,9 @@ int create_user_ns(struct cred *new)
>  
>  	/* set the new root user in the credentials under preparation */
>  	ns->parent = parent_ns;

I think in the past the creator cred pinned the ns->parent.  Do you now
need to explicitly pin ns->parent (and release it in free_user_ns())?

> -	ns->creator = new->user;
> +	ns->owner = owner;
> +	ns->group = group;
> +	free_uid(new->user);
>  	new->user = root_user;
>  	new->uid = new->euid = new->suid = new->fsuid = 0;
>  	new->gid = new->egid = new->sgid = new->fsgid = 0;
> @@ -69,29 +81,15 @@ int create_user_ns(struct cred *new)
>  	return 0;
>  }
>  
> -/*
> - * Deferred destructor for a user namespace.  This is required because
> - * free_user_ns() may be called with uidhash_lock held, but we need to call
> - * back to free_uid() which will want to take the lock again.
> - */
> -static void free_user_ns_work(struct work_struct *work)
> +void free_user_ns(struct kref *kref)
>  {
>  	struct user_namespace *parent, *ns =
> -		container_of(work, struct user_namespace, destroyer);
> +		container_of(kref, struct user_namespace, kref);
> +
>  	parent = ns->parent;
> -	free_uid(ns->creator);
>  	kmem_cache_free(user_ns_cachep, ns);
>  	put_user_ns(parent);
>  }
> -
> -void free_user_ns(struct kref *kref)
> -{
> -	struct user_namespace *ns =
> -		container_of(kref, struct user_namespace, kref);
> -
> -	INIT_WORK(&ns->destroyer, free_user_ns_work);
> -	schedule_work(&ns->destroyer);
> -}
>  EXPORT_SYMBOL(free_user_ns);
>  
>  uid_t user_ns_map_uid(struct user_namespace *to, const struct cred *cred, uid_t uid)
> @@ -101,12 +99,11 @@ uid_t user_ns_map_uid(struct user_namespace *to, const struct cred *cred, uid_t
>  	if (likely(to == cred->user_ns))
>  		return uid;
>  
> -
>  	/* Is cred->user the creator of the target user_ns
>  	 * or the creator of one of it's parents?
>  	 */
>  	for ( tmp = to; tmp != &init_user_ns; tmp = tmp->parent ) {
> -		if (cred->user == tmp->creator) {
> +		if (uid_eq(cred->user->uid, tmp->owner)) {
>  			return (uid_t)0;
>  		}
>  	}
> @@ -126,7 +123,7 @@ gid_t user_ns_map_gid(struct user_namespace *to, const struct cred *cred, gid_t
>  	 * or the creator of one of it's parents?
>  	 */
>  	for ( tmp = to; tmp != &init_user_ns; tmp = tmp->parent ) {
> -		if (cred->user == tmp->creator) {
> +		if (uid_eq(cred->user->uid, tmp->owner)) {
>  			return (gid_t)0;
>  		}
>  	}
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 435d074..f2399d8 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -76,8 +76,9 @@ int cap_capable(const struct cred *cred, struct user_namespace *targ_ns,
>  		int cap, int audit)
>  {
>  	for (;;) {
> -		/* The creator of the user namespace has all caps. */
> -		if (targ_ns != &init_user_ns && targ_ns->creator == cred->user)
> +		/* The owner of the user namespace has all caps. */
> +		if (targ_ns != &init_user_ns && uid_eq(targ_ns->owner,
> +						       make_kuid(cred->user_ns, cred->euid)))
>  			return 0;
>  
>  		/* Do we have the necessary capabilities? */
> -- 
> 1.7.2.5
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
