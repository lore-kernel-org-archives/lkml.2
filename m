Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab2GINls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:41:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab2GINlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:41:47 -0400
Date: Mon, 9 Jul 2012 15:39:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: teach build_probe_list() to consider the range
Message-ID: <20120709133904.GA8277@redhat.com>
References: <20120709133510.GA8269@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120709133510.GA8269@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09, Oleg Nesterov wrote:
>
> Currently build_probe_list() builds the list of all uprobes attached
> to the given inode, and the caller should filter out those who don't
> fall into the [start,end) range, this is sub-optimal.
>
> This patch turns find_least_offset_node() into find_node_in_range()
> which returns the first node inside the [min,max] range, and changes
> build_probe_list() to use this node as a starting point for rb_prev()
> and rb_next() to find all other nodes the caller needs. The resulting
> list is no longer sorted but we do not care.
>
> This can speed up both build_probe_list() and the callers, but there
> is another reason to introduce find_node_in_range(). It can be used
> to figure out whether the given vma has uprobes or not, this will be
> needed soon.

I guess it is not easy to read this patch without applying, I am sending
the code to simplify the review.
----------------------------------------------------------------------

static struct rb_node *
find_node_in_range(struct inode *inode, loff_t min, loff_t max)
{
	struct rb_node *n = uprobes_tree.rb_node;

	while (n) {
		struct uprobe *u = rb_entry(n, struct uprobe, rb_node);

		if (inode < u->inode) {
			n = n->rb_left;
		} else if (inode > u->inode) {
			n = n->rb_right;
		} else {
			if (max < u->offset)
				n = n->rb_left;
			else if (min > u->offset)
				n = n->rb_right;
			else
				break;
		}
	}

	return n;
}

/*
 * For a given range in vma, build a list of probes that need to be inserted.
 */
static void build_probe_list(struct inode *inode,
				struct vm_area_struct *vma,
				unsigned long start, unsigned long end,
				struct list_head *head)
{
	loff_t min, max;
	unsigned long flags;
	struct rb_node *n, *t;
	struct uprobe *u;

	INIT_LIST_HEAD(head);
	min = ((loff_t)vma->vm_pgoff << PAGE_SHIFT) + start - vma->vm_start;
	max = min + (end - start) - 1;

	spin_lock_irqsave(&uprobes_treelock, flags);
	n = find_node_in_range(inode, min, max);
	if (n) {
		for (t = n; t; t = rb_prev(t)) {
			u = rb_entry(t, struct uprobe, rb_node);
			if (u->inode != inode || u->offset < min)
				break;
			list_add(&u->pending_list, head);
			atomic_inc(&u->ref);
		}
		for (t = n; (t = rb_next(t)); ) {
			u = rb_entry(t, struct uprobe, rb_node);
			if (u->inode != inode || u->offset > max)
				break;
			list_add(&u->pending_list, head);
			atomic_inc(&u->ref);
		}
	}
	spin_unlock_irqrestore(&uprobes_treelock, flags);
}

