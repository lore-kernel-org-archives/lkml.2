Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab1IZNx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 09:53:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:39518 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab1IZNxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 09:53:55 -0400
Subject: Re: [PATCH v5 3.1.0-rc4-tip 4/26]   uprobes: Define hooks for
 mmap/munmap.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 26 Sep 2011 15:53:11 +0200
In-Reply-To: <20110920120040.25326.63549.sendpatchset@srdronam.in.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
	 <20110920120040.25326.63549.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317045191.1763.22.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -static int match_uprobe(struct uprobe *l, struct uprobe *r)
> +static int match_uprobe(struct uprobe *l, struct uprobe *r, int *match_inode)
>  {
> +	/*
> +	 * if match_inode is non NULL then indicate if the
> +	 * inode atleast match.
> +	 */
> +	if (match_inode)
> +		*match_inode = 0;
> +
>  	if (l->inode < r->inode)
>  		return -1;
>  	if (l->inode > r->inode)
>  		return 1;
>  	else {
> +		if (match_inode)
> +			*match_inode = 1;
> +
>  		if (l->offset < r->offset)
>  			return -1;
>  
> @@ -75,16 +86,20 @@ static int match_uprobe(struct uprobe *l, struct uprobe *r)
>  	return 0;
>  }
>  
> -static struct uprobe *__find_uprobe(struct inode * inode, loff_t offset)
> +static struct uprobe *__find_uprobe(struct inode * inode, loff_t offset,
> +					struct rb_node **close_match)
>  {
>  	struct uprobe u = { .inode = inode, .offset = offset };
>  	struct rb_node *n = uprobes_tree.rb_node;
>  	struct uprobe *uprobe;
> -	int match;
> +	int match, match_inode;
>  
>  	while (n) {
>  		uprobe = rb_entry(n, struct uprobe, rb_node);
> -		match = match_uprobe(&u, uprobe);
> +		match = match_uprobe(&u, uprobe, &match_inode);
> +		if (close_match && match_inode)
> +			*close_match = n;

Because:

		if (close_match && uprobe->inode == inode)

Isn't good enough? Also, returning an rb_node just seems iffy.. 

>  		if (!match) {
>  			atomic_inc(&uprobe->ref);
>  			return uprobe;


Why not something like:


+static struct uprobe *__find_uprobe(struct inode * inode, loff_t offset,
					bool inode_only)
+{
        struct uprobe u = { .inode = inode, .offset = inode_only ? 0 : offset };
+       struct rb_node *n = uprobes_tree.rb_node;
+       struct uprobe *uprobe;
	struct uprobe *ret = NULL;
+       int match;
+
+       while (n) {
+               uprobe = rb_entry(n, struct uprobe, rb_node);
+               match = match_uprobe(&u, uprobe);
+               if (!match) {
			if (!inode_only)
	                       atomic_inc(&uprobe->ref);
+                       return uprobe;
+               }
		if (inode_only && uprobe->inode == inode)
			ret = uprobe;
+               if (match < 0)
+                       n = n->rb_left;
+               else
+                       n = n->rb_right;
+
+       }
        return ret;
+}


> +/*
> + * For a given inode, build a list of probes that need to be inserted.
> + */
> +static void build_probe_list(struct inode *inode, struct list_head *head)
> +{
> +	struct uprobe *uprobe;
> +	struct rb_node *n;
> +	unsigned long flags;
> +
> +	n = uprobes_tree.rb_node;
> +	spin_lock_irqsave(&uprobes_treelock, flags);
> +	uprobe = __find_uprobe(inode, 0, &n);


> +	/*
> +	 * If indeed there is a probe for the inode and with offset zero,
> +	 * then lets release its reference. (ref got thro __find_uprobe)
> +	 */
> +	if (uprobe)
> +		put_uprobe(uprobe);

The above would make this ^ unneeded.

	n = &uprobe->rb_node;

> +	for (; n; n = rb_next(n)) {
> +		uprobe = rb_entry(n, struct uprobe, rb_node);
> +		if (uprobe->inode != inode)
> +			break;
> +		list_add(&uprobe->pending_list, head);
> +		atomic_inc(&uprobe->ref);
> +	}
> +	spin_unlock_irqrestore(&uprobes_treelock, flags);
> +}

If this ever gets to be a latency issue (linear lookup under spinlock)
you can use a double lock (mutex+spinlock) and require that modification
acquires both but lookups can get away with either.

That way you can do the linear search using a mutex instead of the
spinlock.

> +
> +/*
> + * Called from mmap_region.
> + * called with mm->mmap_sem acquired.
> + *
> + * Return -ve no if we fail to insert probes and we cannot
> + * bail-out.
> + * Return 0 otherwise. i.e :
> + *	- successful insertion of probes
> + *	- (or) no possible probes to be inserted.
> + *	- (or) insertion of probes failed but we can bail-out.
> + */
> +int mmap_uprobe(struct vm_area_struct *vma)
> +{
> +	struct list_head tmp_list;
> +	struct uprobe *uprobe, *u;
> +	struct inode *inode;
> +	int ret = 0;
> +
> +	if (!valid_vma(vma))
> +		return ret;	/* Bail-out */
> +
> +	inode = igrab(vma->vm_file->f_mapping->host);
> +	if (!inode)
> +		return ret;
> +
> +	INIT_LIST_HEAD(&tmp_list);
> +	mutex_lock(&uprobes_mmap_mutex);
> +	build_probe_list(inode, &tmp_list);
> +	list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
> +		loff_t vaddr;
> +
> +		list_del(&uprobe->pending_list);
> +		if (!ret && uprobe->consumers) {
> +			vaddr = vma->vm_start + uprobe->offset;
> +			vaddr -= vma->vm_pgoff << PAGE_SHIFT;
> +			if (vaddr < vma->vm_start || vaddr >= vma->vm_end)
> +				continue;
> +			ret = install_breakpoint(vma->vm_mm, uprobe);
> +
> +			if (ret && (ret == -ESRCH || ret == -EEXIST))
> +				ret = 0;
> +		}
> +		put_uprobe(uprobe);
> +	}
> +
> +	mutex_unlock(&uprobes_mmap_mutex);
> +	iput(inode);
> +	return ret;
> +}
> +
> +static void dec_mm_uprobes_count(struct vm_area_struct *vma,
> +		struct inode *inode)
> +{
> +	struct uprobe *uprobe;
> +	struct rb_node *n;
> +	unsigned long flags;
> +
> +	n = uprobes_tree.rb_node;
> +	spin_lock_irqsave(&uprobes_treelock, flags);
> +	uprobe = __find_uprobe(inode, 0, &n);
> +
> +	/*
> +	 * If indeed there is a probe for the inode and with offset zero,
> +	 * then lets release its reference. (ref got thro __find_uprobe)
> +	 */
> +	if (uprobe)
> +		put_uprobe(uprobe);
> +	for (; n; n = rb_next(n)) {
> +		loff_t vaddr;
> +
> +		uprobe = rb_entry(n, struct uprobe, rb_node);
> +		if (uprobe->inode != inode)
> +			break;
> +		vaddr = vma->vm_start + uprobe->offset;
> +		vaddr -= vma->vm_pgoff << PAGE_SHIFT;
> +		if (vaddr < vma->vm_start || vaddr >= vma->vm_end)
> +			continue;
> +		atomic_dec(&vma->vm_mm->mm_uprobes_count);
> +	}
> +	spin_unlock_irqrestore(&uprobes_treelock, flags);
> +}
> +
> +/*
> + * Called in context of a munmap of a vma.
> + */
> +void munmap_uprobe(struct vm_area_struct *vma)
> +{
> +	struct inode *inode;
> +
> +	if (!valid_vma(vma))
> +		return;		/* Bail-out */
> +
> +	if (!atomic_read(&vma->vm_mm->mm_uprobes_count))
> +		return;
> +
> +	inode = igrab(vma->vm_file->f_mapping->host);
> +	if (!inode)
> +		return;
> +
> +	dec_mm_uprobes_count(vma, inode);
> +	iput(inode);
> +	return;
> +}

One has to wonder why mmap_uprobe() can be one function but
munmap_uprobe() cannot.
