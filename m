Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810Ab2KNPKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 10:10:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53771 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698Ab2KNPKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:10:33 -0500
Date: Wed, 14 Nov 2012 09:10:27 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Yama: add RCU to drop read locking
Message-ID: <20121114151027.GE21682@sergelap>
References: <20121114035815.GA29979@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114035815.GA29979@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (keescook@chromium.org):
> Stop using spinlocks in the read path. Add RCU list to handle the readers.

Looks good to me.  BTW, kfree_rcu is neat :)

Reviewed-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  security/yama/yama_lsm.c |   43 ++++++++++++++++++++-----------------------
>  1 file changed, 20 insertions(+), 23 deletions(-)
> 
> diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
> index b4c2984..17da6ca 100644
> --- a/security/yama/yama_lsm.c
> +++ b/security/yama/yama_lsm.c
> @@ -30,6 +30,7 @@ struct ptrace_relation {
>  	struct task_struct *tracer;
>  	struct task_struct *tracee;
>  	struct list_head node;
> +	struct rcu_head rcu;
>  };
>  
>  static LIST_HEAD(ptracer_relations);
> @@ -48,32 +49,29 @@ static DEFINE_SPINLOCK(ptracer_relations_lock);
>  static int yama_ptracer_add(struct task_struct *tracer,
>  			    struct task_struct *tracee)
>  {
> -	int rc = 0;
> -	struct ptrace_relation *added;
> -	struct ptrace_relation *entry, *relation = NULL;
> +	struct ptrace_relation *relation, *added;
>  
>  	added = kmalloc(sizeof(*added), GFP_KERNEL);
>  	if (!added)
>  		return -ENOMEM;
>  
> +	added->tracee = tracee;
> +	added->tracer = tracer;
> +
>  	spin_lock_bh(&ptracer_relations_lock);
> -	list_for_each_entry(entry, &ptracer_relations, node)
> -		if (entry->tracee == tracee) {
> -			relation = entry;
> -			break;
> +	list_for_each_entry_rcu(relation, &ptracer_relations, node) {
> +		if (relation->tracee == tracee) {
> +			list_replace_rcu(&relation->node, &added->node);
> +			kfree_rcu(relation, rcu);
> +			goto out;
>  		}
> -	if (!relation) {
> -		relation = added;
> -		relation->tracee = tracee;
> -		list_add(&relation->node, &ptracer_relations);
>  	}
> -	relation->tracer = tracer;
>  
> -	spin_unlock_bh(&ptracer_relations_lock);
> -	if (added != relation)
> -		kfree(added);
> +	list_add_rcu(&added->node, &ptracer_relations);
>  
> -	return rc;
> +out:
> +	spin_unlock_bh(&ptracer_relations_lock);
> +	return 0;
>  }
>  
>  /**
> @@ -84,15 +82,16 @@ static int yama_ptracer_add(struct task_struct *tracer,
>  static void yama_ptracer_del(struct task_struct *tracer,
>  			     struct task_struct *tracee)
>  {
> -	struct ptrace_relation *relation, *safe;
> +	struct ptrace_relation *relation;
>  
>  	spin_lock_bh(&ptracer_relations_lock);
> -	list_for_each_entry_safe(relation, safe, &ptracer_relations, node)
> +	list_for_each_entry_rcu(relation, &ptracer_relations, node) {
>  		if (relation->tracee == tracee ||
>  		    (tracer && relation->tracer == tracer)) {
> -			list_del(&relation->node);
> -			kfree(relation);
> +			list_del_rcu(&relation->node);
> +			kfree_rcu(relation, rcu);
>  		}
> +	}
>  	spin_unlock_bh(&ptracer_relations_lock);
>  }
>  
> @@ -217,11 +216,10 @@ static int ptracer_exception_found(struct task_struct *tracer,
>  	struct task_struct *parent = NULL;
>  	bool found = false;
>  
> -	spin_lock_bh(&ptracer_relations_lock);
>  	rcu_read_lock();
>  	if (!thread_group_leader(tracee))
>  		tracee = rcu_dereference(tracee->group_leader);
> -	list_for_each_entry(relation, &ptracer_relations, node)
> +	list_for_each_entry_rcu(relation, &ptracer_relations, node)
>  		if (relation->tracee == tracee) {
>  			parent = relation->tracer;
>  			found = true;
> @@ -231,7 +229,6 @@ static int ptracer_exception_found(struct task_struct *tracer,
>  	if (found && (parent == NULL || task_is_descendant(parent, tracer)))
>  		rc = 1;
>  	rcu_read_unlock();
> -	spin_unlock_bh(&ptracer_relations_lock);
>  
>  	return rc;
>  }
> -- 
> 1.7.9.5
> 
> -- 
> Kees Cook
> Chrome OS Security
