Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab2BCTlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 14:41:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab2BCTlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 14:41:10 -0500
Date: Fri, 3 Feb 2012 14:41:05 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 11/11] blkcg: unify blkg's for blkcg policies
Message-ID: <20120203194105.GA12616@redhat.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-12-git-send-email-tj@kernel.org>
 <20120202003730.GC19837@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202003730.GC19837@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 04:37:30PM -0800, Tejun Heo wrote:
> Currently, blkg is per cgroup-queue-policy combination.  This is
> unnatural and leads to various convolutions in partially used
> duplicate fields in blkg, config / stat access, and general management
> of blkgs.
> 
> This patch make blkg's per cgroup-queue and let them serve all
> policies.  blkgs are now created and destroyed by blkcg core proper.
> This will allow further consolidation of common management logic into
> blkcg core and API with better defined semantics and layering.
> 
> As a transitional step to untangle blkg management, elvswitch and
> policy [de]registration, all blkgs except the root blkg are being shot
> down during elvswitch and bypass.  This patch adds blkg_root_update()
> to update root blkg in place on policy change.  This is hacky and racy
> but should be good enough as interim step until we get locking
> simplified and switch over to proper in-place update for all blkgs.

- So we don't shoot down root group over elevator switch and policy
  changes because we are not sure if we will be able to alloc new
  group? It is not like elevator where we don't free the old one till
  we have made sure that new one is allocated and initialized properly.

- I am assuming that we will change  blkg_destroy_all() later to also
  take policy as argument and only destroy policy data of respective
  policy and not the whole group. (Well I guess we can destroy the whole
  group if it was only policy on the group). 


[..]
>  static struct blkio_group *blkg_alloc(struct blkio_cgroup *blkcg,
> -				      struct request_queue *q,
> -				      struct blkio_policy_type *pol)
> +				      struct request_queue *q)

Comment before this function still mentions "pol" as function argument.


[..]
> @@ -776,43 +786,49 @@ blkiocg_reset_stats(struct cgroup *cgrou
>  #endif
>  
>  	blkcg = cgroup_to_blkio_cgroup(cgroup);
> +	spin_lock(&blkio_list_lock);
>  	spin_lock_irq(&blkcg->lock);

Isn't blkcg lock enough to protect against policy registration/deregistration.
A policy can not add/delete a group to cgroup list without blkcg list. 

Thanks
Vivek
