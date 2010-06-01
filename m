Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab0FAXq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 19:46:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754981Ab0FAXq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 19:46:58 -0400
Date: Tue, 1 Jun 2010 16:46:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: David Howells <dhowells@redhat.com>, davem@davemloft.net,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] fs: run emergency remount on dedicated workqueue
Message-Id: <20100601164603.39dfedf7.akpm@linux-foundation.org>
In-Reply-To: <4BFE4203.5010803@kernel.org>
References: <25328.1274886067@redhat.com>
	<4BFE4203.5010803@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 11:57:23 +0200
Tejun Heo <tj@kernel.org> wrote:

> Commit fa4b9074cd8428958c2adf9dc0c831f46e27c193 made s_umount depend
> on keventd;

For a while I thought you had the wrong commit ID, but I worked it out!

Please, always quote the patch title rather than a bare commit ID.  The
usual form is

    fa4b9074cd8428958c2adf9dc0c831f46e27c193 ("buffer: make
    invalidate_bdev() drain all percpu LRU add caches:)

The main reason for this is so that people can more reliably and simply
identify the patch within a different tree.  I think.

> however, emergency remount schedules works to keventd
> which grabs s_umount creating a circular dependency.  Run emergency
> remount on a separate workqueue to break it.
> 
> ...
>
> index 69688b1..1ada607 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -575,6 +575,11 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
>  	return 0;
>  }
> 
> +/*
> + * For emergency remount
> + */
> +static struct workqueue_struct *emergency_remount_wq;
> +
>  static void do_emergency_remount(struct work_struct *work)
>  {
>  	struct super_block *sb, *n;
> @@ -605,13 +610,25 @@ void emergency_remount(void)
>  {
>  	struct work_struct *work;
> 
> +	if (!emergency_remount_wq)
> +		return;
> +
>  	work = kmalloc(sizeof(*work), GFP_ATOMIC);
>  	if (work) {
>  		INIT_WORK(work, do_emergency_remount);
> -		schedule_work(work);
> +		queue_work(emergency_remount_wq, work);
>  	}
>  }
> 
> +static int __init emergency_remount_init(void)
> +{
> +	emergency_remount_wq = create_singlethread_workqueue("emerg-remount");
> +	if (!emergency_remount_wq)
> +		pr_warn("failed to create emergency remount workqueue\n");
> +	return 0;
> +}
> +subsys_initcall(emergency_remount_init);
> +
>  /*
>   * Unnamed block devices are dummy devices used by virtual
>   * filesystems which don't use real block-devices.  -- jrs

gaah.  Do we really want to add Yet Another Kernel Thread just for that
dopey sysrq-U thing?

I assume (coz you didn't tell us) that it generates a lockdep spew? 
Perhaps it'd be better to just suppress that somehow rather than this...

And if we _do_ end up adding a new kernel thread for this, maybe it
would be better to use that thread for lru_add_drain_all() rather than
within the dopey do_emergency_remount(), so as to reduce the likelihood
that we'll need to add even more kernel threads to solve the same
problem elsewhere?  But this would require a new kernel thread on each
CPU, grr.

Another possibility might be to change lru_add_drain_all() to use IPI
interrupts rather than schedule_on_each_cpu().  That would greatly
speed up lru_add_drain_all().  I don't recall why we did it that way
and I don't immediately see a reason not to.  A few things in core mm
would need to be changed from spin_lock_irq() to spin_lock_irqsave().

But I do have vague memories that there was a reason for it.

<It's a huge PITA locating the commit which initially added
lru_add_drain_all()>

<ten minutes later>

: tree 05d7615894131a368fc4943f641b11acdd2ae694
: parent e236a166b2bc437769a9b8b5d19186a3761bde48
: author Nick Piggin <npiggin@suse.de> Thu, 19 Jan 2006 09:42:27 -0800
: committer Linus Torvalds <torvalds@g5.osdl.org> Thu, 19 Jan 2006 11:20:17 -0800
: 
: [PATCH] mm: migration page refcounting fix
: 
: Migration code currently does not take a reference to target page
: properly, so between unlocking the pte and trying to take a new
: reference to the page with isolate_lru_page, anything could happen to
: it.
: 
: Fix this by holding the pte lock until we get a chance to elevate the
: refcount.
: 
: Other small cleanups while we're here.

It didn't tell us.

<looks in the linux-mm archives>

Nope, no rationale is provided there either.
