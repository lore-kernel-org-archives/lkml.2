Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab0CQHVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 03:21:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:60141 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab0CQHVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 03:21:46 -0400
Date: Wed, 17 Mar 2010 18:21:36 +1100
From: Neil Brown <neilb@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Sage Weil <sage@newdream.net>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20100317182136.0f2ab805@notabene.brown>
In-Reply-To: <20100317154145.bd9fca16.sfr@canb.auug.org.au>
References: <20100317154145.bd9fca16.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010 15:41:45 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Greg,
> 
> After merging the driver-core tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> fs/ceph/msgpool.c: In function 'ceph_msgpool_put':
> fs/ceph/msgpool.c:173: error: implicit declaration of function 'kref_set'
> 
> Caused by commit 10c5d9fdc9ba89606b34f01cbe6ea287abba7395 ("kref: remove
> kref_set") from the driver-core tree interacting with commit
> c2e552e76e2c6907ca50cd9a4b747a2e2e8c615e ("ceph: use kref for ceph_msg")
> from the ceph tree.
> 
> I applied the following patch for today (which may not be correct):

I would say this is correct.

The msg has seen it's last_put and is being placed in the pool of
free messages, so it needs to be in the same state that ceph_msg_new
(called in __fill_msgpool) leaves it in.
ceph_msg_new used kref_init, so ceph_msgpool_put should use kref_init too to
match.

It is a pity that this code cannot use mempool_t....
What if mempool_t were changed to only re-alloc the vector of pointers when
it grew, or when it shrank to less than 1/2 it's current size.  Would that
reduce the frequency of allocations enough for you to be comfortable with it? 
i.e. always make the vector a power-of-2 size (which is what is probably
allocated anyway) while the pool size might be less.
??

NeilBrown

> 
> [Sage, if this patch is correct, it should be applied to the ceph tree.]
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 17 Mar 2010 15:35:22 +1100
> Subject: [PATCH] ceph: update for removal of kref_set
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/ceph/msgpool.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ceph/msgpool.c b/fs/ceph/msgpool.c
> index ca3b44a..030297f 100644
> --- a/fs/ceph/msgpool.c
> +++ b/fs/ceph/msgpool.c
> @@ -170,7 +170,7 @@ void ceph_msgpool_put(struct ceph_msgpool *pool, struct ceph_msg *msg)
>  		msg->front.iov_len = pool->front_len;
>  		msg->hdr.front_len = cpu_to_le32(pool->front_len);
>  
> -		kref_set(&msg->kref, 1);  /* retake a single ref */
> +		kref_init(&msg->kref);  /* retake a single ref */
>  		list_add(&msg->list_head, &pool->msgs);
>  		pool->num++;
>  		dout("msgpool_put %p reclaim %p, now %d/%d\n", pool, msg,

