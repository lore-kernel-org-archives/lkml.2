Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030716Ab2GLSzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 14:55:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35443 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab2GLSzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 14:55:05 -0400
Date: Thu, 12 Jul 2012 13:54:52 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Doug Ledford <dledford@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [RFC, PATCH] CLONE_NEWIPC and exit_group()
Message-ID: <20120712185452.GA24342@sergelap>
References: <20120626120425.GA10275@otc-wbsnb-06>
 <20120710085034.GA24645@otc-wbsnb-06>
 <20120711152422.a1f07bd5.akpm@linux-foundation.org>
 <20120712150702.GA1897@otc-wbsnb-06>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120712150702.GA1897@otc-wbsnb-06>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kirill A. Shutemov (kirill.shutemov@linux.intel.com):
> On Wed, Jul 11, 2012 at 03:24:22PM -0700, Andrew Morton wrote:
> > Am I reading that right?  1000 forks take 33 seconds, with basically
> > all of it just sitting there asleep?  This look quite terrible - what
> > causes this?
> 
> It seems free_nsproxy() + synchronize_rcu() are too heavy to be in
> exit_group() path. Patch below helps: 8s -> ~0.5s for me.

And sys time goes down by that much too, or only user time?

Given that, with user namespaces, it'll soon be possible for users who
are unprivileged toward the host to be able to create and destroy
namespaces, if the patch ends up making it easy for a user to consume a
bunch of system time and not have it accounted at all to himself, then
I think we should keep it as is.

> I'll prepare cleaner patch later if the approach is good enough.
> 
> Also, I noticed that put_nsproxy() calls free_nsproxy() without
> synchronize_rcu(). It looks wrong.
> 
> diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
> index cc37a55..1d26be7 100644
> --- a/include/linux/nsproxy.h
> +++ b/include/linux/nsproxy.h
> @@ -24,6 +24,7 @@ struct fs_struct;
>   */
>  struct nsproxy {
>  	atomic_t count;
> +	struct work_struct free_nsproxy_work;
>  	struct uts_namespace *uts_ns;
>  	struct ipc_namespace *ipc_ns;
>  	struct mnt_namespace *mnt_ns;
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index b576f7f..63618cc 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -41,13 +41,17 @@ struct nsproxy init_nsproxy = {
>  #endif
>  };
>  
> +static void free_nsproxy_synced(struct work_struct *work);
> +
>  static inline struct nsproxy *create_nsproxy(void)
>  {
>  	struct nsproxy *nsproxy;
>  
>  	nsproxy = kmem_cache_alloc(nsproxy_cachep, GFP_KERNEL);
> -	if (nsproxy)
> +	if (nsproxy) {
>  		atomic_set(&nsproxy->count, 1);
> +		INIT_WORK(&nsproxy->free_nsproxy_work, free_nsproxy_synced);
> +	}
>  	return nsproxy;
>  }
>  
> @@ -178,6 +182,23 @@ void free_nsproxy(struct nsproxy *ns)
>  	kmem_cache_free(nsproxy_cachep, ns);
>  }
>  
> +static void free_nsproxy_synced(struct work_struct *work)
> +{
> +	struct nsproxy *ns = container_of(work, struct nsproxy,
> +			free_nsproxy_work);
> +
> +	/*
> +	 * wait for others to get what they want from this nsproxy.
> +	 *
> +	 * cannot release this nsproxy via the call_rcu() since
> +	 * put_mnt_ns() will want to sleep
> +	 */
> +	synchronize_rcu();
> +
> +	free_nsproxy(ns);
> +}
> +
> +
>  /*
>   * Called from unshare. Unshare all the namespaces part of nsproxy.
>   * On success, returns the new nsproxy.
> @@ -215,16 +236,8 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
>  
>  	rcu_assign_pointer(p->nsproxy, new);
>  
> -	if (ns && atomic_dec_and_test(&ns->count)) {
> -		/*
> -		 * wait for others to get what they want from this nsproxy.
> -		 *
> -		 * cannot release this nsproxy via the call_rcu() since
> -		 * put_mnt_ns() will want to sleep
> -		 */
> -		synchronize_rcu();
> -		free_nsproxy(ns);
> -	}
> +	if (ns && atomic_dec_and_test(&ns->count))
> +		schedule_work(&ns->free_nsproxy_work);
>  }
>  
>  void exit_task_namespaces(struct task_struct *p)
> -- 
>  Kirill A. Shutemov


