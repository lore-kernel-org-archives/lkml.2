Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab1FNMIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:08:35 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37276 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab1FNMIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:08:34 -0400
Date: Tue, 14 Jun 2011 17:30:23 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 4/22]  4: Uprobes: register/unregister
 probes.
Message-ID: <20110614120023.GB4952@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607125900.28590.16071.sendpatchset@localhost6.localdomain6>
 <20110613195701.GA14656@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110613195701.GA14656@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2011-06-13 21:57:01]:

> On 06/07, Srikar Dronamraju wrote:
> >
> > +int register_uprobe(struct inode *inode, loff_t offset,
> > +				struct uprobe_consumer *consumer)
> > +{
> > +	struct prio_tree_iter iter;
> > +	struct list_head try_list, success_list;
> > +	struct address_space *mapping;
> > +	struct mm_struct *mm, *tmpmm;
> > +	struct vm_area_struct *vma;
> > +	struct uprobe *uprobe;
> > +	int ret = -1;
> > +
> > +	if (!inode || !consumer || consumer->next)
> > +		return -EINVAL;
> > +
> > +	if (offset > inode->i_size)
> > +		return -EINVAL;
> > +
> > +	uprobe = alloc_uprobe(inode, offset);
> > +	if (!uprobe)
> > +		return -ENOMEM;
> > +
> > +	INIT_LIST_HEAD(&try_list);
> > +	INIT_LIST_HEAD(&success_list);
> > +	mapping = inode->i_mapping;
> > +
> > +	mutex_lock(&uprobes_mutex);
> > +	if (uprobe->consumers) {
> > +		ret = 0;
> > +		goto consumers_add;
> > +	}
> > +
> > +	mutex_lock(&mapping->i_mmap_mutex);
> > +	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, 0) {
> 
> I didn't actually read this patch yet, but this looks suspicious.
> Why begin == end == 0? Doesn't this mean we are ignoring the mappings
> with vm_pgoff != 0 ?
> 
> Perhaps this should be offset >> PAGE_SIZE?
> 

Okay, 
I guess you meant something like this.

	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {

where pgoff == offset >> PAGE_SIZE
Right?

-- 
Thanks and Regards
Srikar
