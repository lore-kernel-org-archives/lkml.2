Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab2BQQrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 11:47:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab2BQQry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 11:47:54 -0500
Date: Fri, 17 Feb 2012 11:47:49 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] blkcg: drop unnecessary RCU locking
Message-ID: <20120217164749.GC26620@redhat.com>
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

[..]
> * queue_lock coverage extended to cover @blkg usage in
>   blkio_policy_parse_and_set() and RCU dropped.  This means all config
>   update callbacks are now called under queue_lock.
> 

[..]
> @@ -1041,11 +1034,8 @@ static int blkio_policy_parse_and_set(char *buf, enum blkio_policy_id plid,
>  	if (!disk || part)
>  		goto out;
>  
> -	rcu_read_lock();
> -
>  	spin_lock_irq(disk->queue->queue_lock);
>  	blkg = blkg_lookup_create(blkcg, disk->queue, plid, false);
> -	spin_unlock_irq(disk->queue->queue_lock);
>  

So now in some cases we call blkg_lookup_create() with both queue and rcu
read lock held (cfq_lookup_create_cfqg()) and in this case hold only queue
lock. blkg_lookup_create() calls blkg_lookup() which expects a rcu_read_lock()
to be held and we will be travesing that list without rcu_read_lock()
held. Isn't that a problem? We might be examining a blkg belonging to
a different queue and it might be being freed parallely.

Or blkg destruction in this cgroup is serialized by cgroup_mutex() or
by something else in this policy parse and set path?

Thanks
Vivek
