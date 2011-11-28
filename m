Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab1K1OYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:24:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44107 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab1K1OYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:24:05 -0500
Message-ID: <1322490213.2921.133.camel@twins>
Subject: Re: [PATCH v7 3.2-rc2 5/30] uprobes: copy of the original
 instruction.
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
Date: Mon, 28 Nov 2011 15:23:33 +0100
In-Reply-To: <20111118110733.10512.11835.sendpatchset@srdronam.in.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111118110733.10512.11835.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 16:37 +0530, Srikar Dronamraju wrote:
> +static int __copy_insn(struct address_space *mapping,
> +                       struct vm_area_struct *vma, char *insn,
> +                       unsigned long nbytes, unsigned long offset)
> +{
> +       struct file *filp = vma->vm_file;
> +       struct page *page;
> +       void *vaddr;
> +       unsigned long off1;
> +       unsigned long idx;
> +
> +       if (!filp)
> +               return -EINVAL;
> +
> +       idx = (unsigned long)(offset >> PAGE_CACHE_SHIFT);
> +       off1 = offset &= ~PAGE_MASK;
> +
> +       /*
> +        * Ensure that the page that has the original instruction is
> +        * populated and in page-cache.
> +        */
> +       page = read_mapping_page(mapping, idx, filp);
> +       if (IS_ERR(page))
> +               return -ENOMEM;
> +
> +       vaddr = kmap_atomic(page);
> +       memcpy(insn, vaddr + off1, nbytes);
> +       kunmap_atomic(vaddr);
> +       page_cache_release(page);
> +       return 0;
> +}
> +
> +static int copy_insn(struct uprobe *uprobe, struct vm_area_struct *vma,
> +                                       unsigned long addr)
> +{
> +       struct address_space *mapping;
> +       int bytes;
> +       unsigned long nbytes;
> +
> +       addr &= ~PAGE_MASK;
> +       nbytes = PAGE_SIZE - addr;
> +       mapping = uprobe->inode->i_mapping;
> +
> +       /* Instruction at end of binary; copy only available bytes */
> +       if (uprobe->offset + MAX_UINSN_BYTES > uprobe->inode->i_size)
> +               bytes = uprobe->inode->i_size - uprobe->offset;
> +       else
> +               bytes = MAX_UINSN_BYTES;
> +
> +       /* Instruction at the page-boundary; copy bytes in second page */
> +       if (nbytes < bytes) {
> +               if (__copy_insn(mapping, vma, uprobe->insn + nbytes,
> +                               bytes - nbytes, uprobe->offset + nbytes))
> +                       return -ENOMEM;

You just lost your possible -EINVAL return value.

> +
> +               bytes = nbytes;
> +       }
> +       return __copy_insn(mapping, vma, uprobe->insn, bytes, uprobe->offset);
> +} 
