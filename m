Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab2BQQUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 11:20:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab2BQQUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 11:20:05 -0500
Date: Fri, 17 Feb 2012 11:19:58 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] blkcg: drop unnecessary RCU locking
Message-ID: <20120217161958.GB26620@redhat.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329431878-28300-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 02:37:51PM -0800, Tejun Heo wrote:
> Now that blkg additions / removals are always done under both q and
> blkcg locks, the only place RCU locking is used is blkg_lookup() for
> lockless lookup.  This patch drops unncessary RCU locking replacing it
> with plain blkcg / q locking as necessary.
> 
> * blkg_lookup_create() and blkiocg_pre_destroy() already perform
>   proper locking and don't need RCU.  Dropped.

But blkg_lookup_create() is called under rcu() to protect blkcg pointer.
And blkg_lookup() is also happening under same rcu read lock. So I think
you can't drop rcu from blkg_lookup_create().

>  {
>  	struct blkio_group *blkg, *new_blkg;
>  
> -	WARN_ON_ONCE(!rcu_read_lock_held());

Don't we want to be called with rcu lock held needed for blkg_lookup()?

>  	lockdep_assert_held(q->queue_lock);
>  
>  	/*

[..]
> @@ -581,11 +580,9 @@ struct blkio_group *blkg_lookup_create(struct blkio_cgroup *blkcg,
>  	 * allocation is fixed.
>  	 */
>  	spin_unlock_irq(q->queue_lock);
> -	rcu_read_unlock();
>  
>  	new_blkg = blkg_alloc(blkcg, q);
>  
> -	rcu_read_lock();
>  	spin_lock_irq(q->queue_lock);

blkg_alloc() might sleep here with rcu lock held?

Thanks
Vivek
