Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab1K1Pa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:30:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59583 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab1K1PaZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:30:25 -0500
Message-ID: <1322494194.2921.147.camel@twins>
Subject: Re: [PATCH v7 3.2-rc2 3/30] uprobes: register/unregister probes.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>
Date: Mon, 28 Nov 2011 16:29:54 +0100
In-Reply-To: <20111118110713.10512.9461.sendpatchset@srdronam.in.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111118110713.10512.9461.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 16:37 +0530, Srikar Dronamraju wrote:
> +static void __unregister_uprobe(struct inode *inode, loff_t offset,
> +                                               struct uprobe *uprobe)
> +{
> +       struct list_head try_list;
> +       struct address_space *mapping;
> +       struct vma_info *vi, *tmpvi;
> +       struct vm_area_struct *vma;
> +       struct mm_struct *mm;
> +       loff_t vaddr;
> +
> +       mapping = inode->i_mapping;
> +       INIT_LIST_HEAD(&try_list);
> +       while ((vi = find_next_vma_info(&try_list, offset,
> +                                               mapping, false)) != NULL) {
> +               if (IS_ERR(vi))
> +                       break;

So what kind of half-assed state are we left in if we try an unregister
under memory pressure and how do we deal with that?

> +               mm = vi->mm;
> +               down_read(&mm->mmap_sem);
> +               vma = find_vma(mm, (unsigned long)vi->vaddr);
> +               if (!vma || !valid_vma(vma, false)) {
> +                       list_del(&vi->probe_list);
> +                       kfree(vi);
> +                       up_read(&mm->mmap_sem);
> +                       mmput(mm);
> +                       continue;
> +               }
> +               vaddr = vma->vm_start + offset;
> +               vaddr -= vma->vm_pgoff << PAGE_SHIFT;
> +               if (vma->vm_file->f_mapping->host != inode ||
> +                                               vaddr != vi->vaddr) {
> +                       list_del(&vi->probe_list);
> +                       kfree(vi);
> +                       up_read(&mm->mmap_sem);
> +                       mmput(mm);
> +                       continue;
> +               }
> +               remove_breakpoint(mm);
> +               up_read(&mm->mmap_sem);
> +               mmput(mm);
> +       }
> +
> +       list_for_each_entry_safe(vi, tmpvi, &try_list, probe_list) {
> +               list_del(&vi->probe_list);
> +               kfree(vi);
> +       }
> +       delete_uprobe(uprobe);
> +} 
