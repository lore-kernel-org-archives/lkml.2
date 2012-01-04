Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab2ADQwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 11:52:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:42094 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2ADQwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 11:52:20 -0500
Message-ID: <1325695916.2697.5.camel@twins>
Subject: Re: [PATCH v8 3.2.0-rc5 1/9] uprobes: Install and remove
 breakpoints.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 04 Jan 2012 17:51:56 +0100
In-Reply-To: <20111216122808.2085.76986.sendpatchset@srdronam.in.ibm.com>
References: <20111216122756.2085.95791.sendpatchset@srdronam.in.ibm.com>
	 <20111216122808.2085.76986.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 17:58 +0530, Srikar Dronamraju wrote:
> +static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
> +{
> +       struct list_head try_list;
> +       struct vm_area_struct *vma;
> +       struct address_space *mapping;
> +       struct vma_info *vi, *tmpvi;
> +       struct mm_struct *mm;
> +       loff_t vaddr;
> +       int ret = 0;
> +
> +       mapping = uprobe->inode->i_mapping;
> +       INIT_LIST_HEAD(&try_list);
> +       while ((vi = find_next_vma_info(&try_list, uprobe->offset,
> +                                       mapping, is_register)) != NULL) {
> +               if (IS_ERR(vi)) {
> +                       ret = PTR_ERR(vi);
> +                       break;
> +               }
> +               mm = vi->mm;
> +               down_read(&mm->mmap_sem);
> +               vma = find_vma(mm, (unsigned long)vi->vaddr);
> +               if (!vma || !valid_vma(vma, is_register)) {
> +                       list_del(&vi->probe_list);
> +                       kfree(vi);
> +                       up_read(&mm->mmap_sem);
> +                       mmput(mm);
> +                       continue;
> +               }
> +               vaddr = vma_address(vma, uprobe->offset);
> +               if (vma->vm_file->f_mapping->host != uprobe->inode ||
> +                                               vaddr != vi->vaddr) {
> +                       list_del(&vi->probe_list);
> +                       kfree(vi);
> +                       up_read(&mm->mmap_sem);
> +                       mmput(mm);
> +                       continue;
> +               }
> +
> +               if (is_register)
> +                       ret = install_breakpoint(mm, uprobe, vma, vi->vaddr);
> +               else
> +                       remove_breakpoint(mm, uprobe, vi->vaddr);
> +
> +               up_read(&mm->mmap_sem);
> +               mmput(mm);
> +               if (is_register) {
> +                       if (ret && ret == -EEXIST)
> +                               ret = 0;
> +                       if (ret)
> +                               break;
> +               }

Since you init ret := 0 and remove_breakpoint doesn't change it, this
conditional on is_register is superfluous.

> +       }
> +       list_for_each_entry_safe(vi, tmpvi, &try_list, probe_list) {
> +               list_del(&vi->probe_list);
> +               kfree(vi);
> +       }
> +       return ret;
> +} 
