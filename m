Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab2INQW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:22:59 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:49238 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2INQW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:22:57 -0400
Date: Fri, 14 Sep 2012 21:48:48 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] uprobes: uprobes_treelock should not disable irqs
Message-ID: <20120914161848.GC28033@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120819164008.GA25454@redhat.com>
 <20120819164037.GA25480@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120819164037.GA25480@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12091416-5140-0000-0000-000002139D80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-08-19 18:40:37]:

> Nobody plays with uprobes_tree/uprobes_treelock in interrupt context,
> no need to disable irqs.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |   21 ++++++++-------------
>  1 files changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 25c0d74..abe077e 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -413,11 +413,10 @@ static struct uprobe *__find_uprobe(struct inode *inode, loff_t offset)
>  static struct uprobe *find_uprobe(struct inode *inode, loff_t offset)
>  {
>  	struct uprobe *uprobe;
> -	unsigned long flags;
> 
> -	spin_lock_irqsave(&uprobes_treelock, flags);
> +	spin_lock(&uprobes_treelock);
>  	uprobe = __find_uprobe(inode, offset);
> -	spin_unlock_irqrestore(&uprobes_treelock, flags);
> +	spin_unlock(&uprobes_treelock);
> 
>  	return uprobe;
>  }
> @@ -464,12 +463,11 @@ static struct uprobe *__insert_uprobe(struct uprobe *uprobe)
>   */
>  static struct uprobe *insert_uprobe(struct uprobe *uprobe)
>  {
> -	unsigned long flags;
>  	struct uprobe *u;
> 
> -	spin_lock_irqsave(&uprobes_treelock, flags);
> +	spin_lock(&uprobes_treelock);
>  	u = __insert_uprobe(uprobe);
> -	spin_unlock_irqrestore(&uprobes_treelock, flags);
> +	spin_unlock(&uprobes_treelock);
> 
>  	/* For now assume that the instruction need not be single-stepped */
>  	uprobe->flags |= UPROBE_SKIP_SSTEP;
> @@ -707,11 +705,9 @@ remove_breakpoint(struct uprobe *uprobe, struct mm_struct *mm, unsigned long vad
>   */
>  static void delete_uprobe(struct uprobe *uprobe)
>  {
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&uprobes_treelock, flags);
> +	spin_lock(&uprobes_treelock);
>  	rb_erase(&uprobe->rb_node, &uprobes_tree);
> -	spin_unlock_irqrestore(&uprobes_treelock, flags);
> +	spin_unlock(&uprobes_treelock);
>  	iput(uprobe->inode);
>  	put_uprobe(uprobe);
>  	atomic_dec(&uprobe_events);
> @@ -969,7 +965,6 @@ static void build_probe_list(struct inode *inode,
>  				struct list_head *head)
>  {
>  	loff_t min, max;
> -	unsigned long flags;
>  	struct rb_node *n, *t;
>  	struct uprobe *u;
> 
> @@ -977,7 +972,7 @@ static void build_probe_list(struct inode *inode,
>  	min = vaddr_to_offset(vma, start);
>  	max = min + (end - start) - 1;
> 
> -	spin_lock_irqsave(&uprobes_treelock, flags);
> +	spin_lock(&uprobes_treelock);
>  	n = find_node_in_range(inode, min, max);
>  	if (n) {
>  		for (t = n; t; t = rb_prev(t)) {
> @@ -995,7 +990,7 @@ static void build_probe_list(struct inode *inode,
>  			atomic_inc(&u->ref);
>  		}
>  	}
> -	spin_unlock_irqrestore(&uprobes_treelock, flags);
> +	spin_unlock(&uprobes_treelock);
>  }
> 
>  /*
> -- 
> 1.5.5.1
> 

