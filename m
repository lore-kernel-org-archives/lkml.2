Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab2LMPGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:06:20 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43716 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982Ab2LMPGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:06:16 -0500
Date: Thu, 13 Dec 2012 20:00:44 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] uprobes: Kill uprobe->copy_mutex
Message-ID: <20121213143044.GE3902@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121124180213.GA30963@redhat.com>
 <20121124180236.GA30993@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121124180236.GA30993@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121315-9360-0000-0000-00000DE46104
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-11-24 19:02:36]:

> Now that ->register_rwsem is safe under ->mmap_sem we can kill
> ->copy_mutex and abuse down_write(&uprobe->consumer_rwsem).
> 
> This makes prepare_uprobe() even more ugly, but we should kill
> it anyway.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>


Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 97c3874..1e047f8 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -91,7 +91,6 @@ struct uprobe {
>  	atomic_t		ref;
>  	struct rw_semaphore	register_rwsem;
>  	struct rw_semaphore	consumer_rwsem;
> -	struct mutex		copy_mutex;	/* TODO: kill me and UPROBE_COPY_INSN */
>  	struct list_head	pending_list;
>  	struct uprobe_consumer	*consumers;
>  	struct inode		*inode;		/* Also hold a ref to inode */
> @@ -450,7 +449,6 @@ static struct uprobe *alloc_uprobe(struct inode *inode, loff_t offset)
>  	uprobe->offset = offset;
>  	init_rwsem(&uprobe->register_rwsem);
>  	init_rwsem(&uprobe->consumer_rwsem);
> -	mutex_init(&uprobe->copy_mutex);
>  	/* For now assume that the instruction need not be single-stepped */
>  	__set_bit(UPROBE_SKIP_SSTEP, &uprobe->flags);
> 
> @@ -578,7 +576,8 @@ static int prepare_uprobe(struct uprobe *uprobe, struct file *file,
>  	if (test_bit(UPROBE_COPY_INSN, &uprobe->flags))
>  		return ret;
> 
> -	mutex_lock(&uprobe->copy_mutex);
> +	/* TODO: move this into _register, until then we abuse this sem. */
> +	down_write(&uprobe->consumer_rwsem);
>  	if (test_bit(UPROBE_COPY_INSN, &uprobe->flags))
>  		goto out;
> 
> @@ -602,7 +601,7 @@ static int prepare_uprobe(struct uprobe *uprobe, struct file *file,
>  	set_bit(UPROBE_COPY_INSN, &uprobe->flags);
> 
>   out:
> -	mutex_unlock(&uprobe->copy_mutex);
> +	up_write(&uprobe->consumer_rwsem);
> 
>  	return ret;
>  }
> -- 
> 1.5.5.1
> 

