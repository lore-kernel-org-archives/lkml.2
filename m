Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab1F0Gz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 02:55:28 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33523 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195Ab1F0GyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 02:54:15 -0400
Date: Mon, 27 Jun 2011 12:15:02 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 7/22]  7: uprobes: mmap and fork hooks.
Message-ID: <20110627064502.GB24776@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110616130012.GL4952@linux.vnet.ibm.com>
 <1308248588.13240.267.camel@twins>
 <20110617045000.GM4952@linux.vnet.ibm.com>
 <1308297836.13240.380.camel@twins>
 <20110617090504.GN4952@linux.vnet.ibm.com>
 <1308303665.2355.11.camel@twins>
 <1308662243.26237.144.camel@twins>
 <20110622143906.GF16471@linux.vnet.ibm.com>
 <20110624020659.GA24776@linux.vnet.ibm.com>
 <1308901324.27849.7.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1308901324.27849.7.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 	mutex_lock(&mapping->i_mmap_mutex);
> > 	delete_uprobe(uprobe);
> > 	mutex_unlock(&mapping->i_mmap_mutex);
> > 
> > 	inode->uprobes_count--;
> > 	mutex_unlock(&inode->i_mutex);
> 
> Right, so this lonesome unlock got me puzzled for a while, I always find
> it best not to do asymmetric locking like this, keep the lock and unlock
> in the same function.
> 

Okay, will do.

> > }
> > 
> > int register_uprobe(...)
> > {
> > 	uprobe = alloc_uprobe(...);	// find or insert in tree
> > 
> > 	mutex_lock(&inode->i_mutex);	// sync with register/unregister
> > 	if (uprobe->consumers) {
> > 		add_consumer();
> > 		goto put_unlock;
> > 	}
> > 	add_consumer();
> > 	inode->uprobes_count++;
> > 	mutex_lock(&mapping->i_mmap_mutex);	//sync with mmap.
> > 	vma_prio_tree_foreach(..) {
> > 		// get mm ref, add to list blah blah
> > 	}
> > 
> > 	mutex_unlock(&mapping->i_mmap_mutex);
> > 	list_for_each_entry_safe() {
> > 		if (ret) {
> > 			// del from list etc..
> > 			//
> > 			continue;
> > 		}
> > 		down_read(mm->mmap_sem);
> > 		ret = install_breakpoint();
> > 		up_read(..);
> > 		// del from list etc..
> > 		//
> > 		if (ret && (ret == -ESRCH || ret == -EEXIST))
> > 			ret = 0;
> > 	}
> > 
> > 	if (ret)
> > 		_unregister_uprobe();
> > 
> >       put_unlock:
> > 	mutex_unlock(&inode->i_mutex);
> 
> You see, now this is a double unlock

hmm . .will correct this.

> 
> > 	put_uprobe(uprobe);
> > 	return ret;
> > }
> > 
> > void unregister_uprobe(...)
> > {
> > 	mutex_lock(&inode->i_mutex);	// sync with register/unregister
> > 	uprobe = find_uprobe();	// ref++
> > 	_unregister_uprobe();
> > 	mutex_unlock(&inode->i_mutex);
> 
> idem
> 
> > 	put_uprobe(uprobe);
> > }
> > 
> > int mmap_uprobe(struct vm_area_struct *vma)
> > {
> > 	struct list_head tmp_list;
> > 	struct uprobe *uprobe, *u;
> > 	struct mm_struct *mm;
> > 	struct inode *inode;
> > 	int ret = 0;
> > 
> > 	if (!valid_vma(vma))
> > 		return ret;	/* Bail-out */
> > 
> > 	mm = vma->vm_mm;
> > 	inode = vma->vm_file->f_mapping->host;
> > 	if (inode->uprobes_count)
> > 		return ret;
> > 	__iget(inode);
> > 
> > 	INIT_LIST_HEAD(&tmp_list);
> > 
> > 	mutex_lock(&mapping->i_mmap_mutex);
> > 	add_to_temp_list(vma, inode, &tmp_list);
> > 	list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
> > 		loff_t vaddr;
> > 
> > 		list_del(&uprobe->pending_list);
> > 		if (ret)
> > 			continue;
> > 
> > 		vaddr = vma->vm_start + uprobe->offset;
> > 		vaddr -= vma->vm_pgoff << PAGE_SHIFT;
> > 		ret = install_breakpoint(mm, uprobe, vaddr);
> 
> Right, so this is the problem, you cannot do allocations under
> i_mmap_mutex, however I think you can under i_mutex.

I didnt know that we cannot do allocations under i_mmap_mutex.
Why is this? 

I cant take i_mutex, because we would have already held
down_write(mmap_sem) here. 


> 
> > 		if (ret && (ret == -ESRCH || ret == -EEXIST))
> > 			ret = 0;
> > 	}
> > 
> > 	mutex_unlock(&mapping->i_mmap_mutex);
> > 	iput(inode);
> > 	return ret;
> > }
> > 
> > int munmap_uprobe(struct vm_area_struct *vma)
> > {
> > 	struct list_head tmp_list;
> > 	struct uprobe *uprobe, *u;
> > 	struct mm_struct *mm;
> > 	struct inode *inode;
> > 	int ret = 0;
> > 
> > 	if (!valid_vma(vma))
> > 		return ret;	/* Bail-out */
> > 
> > 	mm = vma->vm_mm;
> > 	inode = vma->vm_file->f_mapping->host;
> > 	if (inode->uprobes_count)
> > 		return ret;
> 
> Should that be !->uprobes_count?

Yes it should be !inode->uprobes_count.
(both here and in mmap_uprobe)

> 
> 

-- 
Thanks and Regards
Srikar
