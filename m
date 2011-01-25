Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1AYMPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:15:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:35327 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab1AYMPf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:15:35 -0500
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 5/20]  5: Uprobes:
 register/unregister probes.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20101216095817.23751.76989.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095817.23751.76989.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 Jan 2011 13:15:44 +0100
Message-ID: <1295957744.28776.722.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 15:28 +0530, Srikar Dronamraju wrote:
> +/* Returns 0 if it can install one probe */
> +int register_uprobe(struct inode *inode, unsigned long offset,
> +                               struct uprobe_consumer *consumer)
> +{
> +       struct prio_tree_iter iter;
> +       struct list_head tmp_list;
> +       struct address_space *mapping;
> +       struct mm_struct *mm, *tmpmm;
> +       struct vm_area_struct *vma;
> +       struct uprobe *uprobe;
> +       int ret = -1;
> +
> +       if (!inode || !consumer || consumer->next)
> +               return -EINVAL;
> +       uprobe = uprobes_add(inode, offset);
> +       INIT_LIST_HEAD(&tmp_list);
> +
> +       mapping = inode->i_mapping;
> +
> +       mutex_lock(&uprobes_mutex);
> +       if (uprobe->consumers) {
> +               ret = 0;
> +               goto consumers_add;
> +       }
> +
> +       spin_lock(&mapping->i_mmap_lock);
> +       vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, 0, 0) {
> +               if (!atomic_inc_not_zero(&vma->vm_mm->mm_users))
> +                       continue;
> +
> +               mm = vma->vm_mm;
> +               if (!valid_vma(vma)) {
> +                       mmput(mm);
> +                       continue;
> +               }
> +
> +               list_add(&mm->uprobes_list, &tmp_list);
> +               mm->uprobes_vaddr = vma->vm_start + offset;
> +       }
> +       spin_unlock(&mapping->i_mmap_lock);

Both this and unregister are racy, what is to say:
 - the vma didn't get removed from the mm
 - no new matching vma got added

> +       if (list_empty(&tmp_list)) {
> +               ret = 0;
> +               goto consumers_add;
> +       }
> +       list_for_each_entry_safe(mm, tmpmm, &tmp_list, uprobes_list) {
> +               if (!install_uprobe(mm, uprobe))
> +                       ret = 0;
> +               list_del(&mm->uprobes_list);
> +               mmput(mm);
> +       }
> +
> +consumers_add:
> +       add_consumer(uprobe, consumer);
> +       mutex_unlock(&uprobes_mutex);
> +       put_uprobe(uprobe);
> +       return ret;
> +}
> + 
