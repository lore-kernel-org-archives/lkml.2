Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab2JBVdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:33:31 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:19989 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab2JBVd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:33:29 -0400
Message-ID: <1349213607.3141.57.camel@lorien2>
Subject: Re: kernel NULL pointer dereference at rb_erase+0x1a3/0x370
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Hugh Dickins <hughd@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 02 Oct 2012 15:33:27 -0600
In-Reply-To: <alpine.LSU.2.00.1210021317030.1700@eggly.anvils>
References: <1349200709.3141.30.camel@lorien2>
	 <alpine.LSU.2.00.1210021317030.1700@eggly.anvils>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 13:27 -0700, Hugh Dickins wrote:
> On Tue, 2 Oct 2012, Shuah Khan wrote:
> > I started seeing the following null pointer dereference on
> > a linux-next sept 21 git and still seeing it on linux-next 
> > Sep 27th git.
> > 
> > Can be reproduced easily. I have been able to reproduce every
> > time I do a complete build of a kernel on fresh checkout or
> > touch a header file that forces full build.
> > 
> > Related to lib/rbtree.c commits that went into September 21 perhaps.
> 
> That's a sensible suggestion, but I think probably not.
> 
> > I didn't get a chance to investigate this yet, thought I would share
> > just in case others have seen it.
> > 
> > 
> > [ 2219.660124] BUG: unable to handle kernel NULL pointer dereference at           (null)
> > [ 2219.660182] IP: [<ffffffff81323c93>] rb_erase+0x1a3/0x370
> > [ 2219.660209] PGD 73f2f067 PUD 67246067 PMD 0 
> > [ 2219.660235] Oops: 0000 [#1] SMP 
> > [ 2219.660632] CPU 0 
> > [ 2219.660644] Pid: 1660, comm: recordmcount Not tainted 3.6.0-rc6-next-20120921+ #4 Hewlett-Packard HP EliteBook 6930p/30DC
> > [ 2219.664007] Process recordmcount (pid: 1660, threadinfo ffff880073f30000, task ffff88002fe9ada0)
> > [ 2219.664007] Call Trace:
> > [ 2219.664007]  [<ffffffff8125af6e>] ext4_es_insert_extent+0x28e/0x2f0
> 
> ext4_es_insert_extent: this is probably something I posted a fix for on
> the 27th (copied below).  They're reworking that series more thoroughly,
> and it has for the moment dropped out of linux-next, so I expect you
> won't see this error at all with a newer next.  But you may want to
> continue with your Sep 27th tree, and try out this patch anyway...

Thanks for looking at both my null reference questions. In my case it is
easier to upgrade, will just do that.

-- Shuah
> 
> [PATCH next/mmotm] ext4: fix cache_es after merge_left
> 
> Kernel build with CONFIG_DEBUG_SLAB or CONFIG_SLUB_DEBUG slub_debug=FPZ
> gives me kernel BUG at fs/ext4/extents_status.c:142!  That's the
> BUG_ON(es->start + es->len < es->start) in extent_status_end() called
> from ext4_es_insert_extent().  tree->cache_es has been freed and poisoned.
> 
> This comes from when ext4_es_try_to_merge_left() merges es into leftward
> es1, but ext4_es_insert_extent()'s out then updates cache_es to the freed
> extent_status.  ext4_es_try_to_merge_right() does not pose a problem.
> 
> Change ext4_es_try_to_merge_left() to return whichever extent_status
> should be recorded in tree->cache_es.  Remove cache_es update from
> both of them, leaving that to ext4_es_insert_extent()'s out label.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
>  fs/ext4/extents_status.c |   15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> --- mmotm/fs/ext4/extents_status.c	2012-09-26 10:15:29.340071552 -0700
> +++ linux/fs/ext4/extents_status.c	2012-09-27 11:52:59.284937056 -0700
> @@ -244,24 +244,24 @@ static void ext4_es_free_extent(struct e
>  	kmem_cache_free(ext4_es_cachep, es);
>  }
>  
> -static void ext4_es_try_to_merge_left(struct ext4_es_tree *tree,
> -				      struct extent_status *es)
> +static struct extent_status *
> +ext4_es_try_to_merge_left(struct ext4_es_tree *tree, struct extent_status *es)
>  {
>  	struct extent_status *es1;
>  	struct rb_node *node;
>  
>  	node = rb_prev(&es->rb_node);
>  	if (!node)
> -		return;
> +		return es;
>  
>  	es1 = rb_entry(node, struct extent_status, rb_node);
>  	if (es->start == extent_status_end(es1) + 1) {
>  		es1->len += es->len;
>  		rb_erase(&es->rb_node, &tree->root);
> -		if (es == tree->cache_es)
> -			tree->cache_es = es1;
>  		ext4_es_free_extent(es);
> +		es = es1;	/* Caller will update tree->cache_es to this */
>  	}
> +	return es;
>  }
>  
>  static void ext4_es_try_to_merge_right(struct ext4_es_tree *tree,
> @@ -278,9 +278,8 @@ static void ext4_es_try_to_merge_right(s
>  	if (es1->start == extent_status_end(es) + 1) {
>  		es->len += es1->len;
>  		rb_erase(node, &tree->root);
> -		if (es1 == tree->cache_es)
> -			tree->cache_es = es;
>  		ext4_es_free_extent(es1);
> +		/* Caller will update tree->cache_es to es */
>  	}
>  }
>  
> @@ -318,7 +317,7 @@ int ext4_es_insert_extent(struct inode *
>  		es_debug("cached by [%u/%u)\n", es->start, es->len);
>  		es->start = offset;
>  		es->len += len;
> -		ext4_es_try_to_merge_left(tree, es);
> +		es = ext4_es_try_to_merge_left(tree, es);
>  		goto out;
>  	} else if (es && in_range(offset, es->start, es->len)) {
>  		es_debug("cached by [%u/%u)\n", es->start, es->len);


