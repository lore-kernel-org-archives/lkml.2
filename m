Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1I0Luq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 07:50:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45258 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab1I0Lup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 07:50:45 -0400
Subject: Re: [PATCH v5 3.1.0-rc4-tip 18/26]   uprobes: slot allocation.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>
Date: Tue, 27 Sep 2011 13:49:37 +0200
In-Reply-To: <20110920120335.25326.50673.sendpatchset@srdronam.in.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
	 <20110920120335.25326.50673.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317124177.15383.46.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 17:33 +0530, Srikar Dronamraju wrote:
> +static int xol_add_vma(struct uprobes_xol_area *area)
> +{
> +       const struct cred *curr_cred;
> +       struct vm_area_struct *vma;
> +       struct mm_struct *mm;
> +       unsigned long addr;
> +       int ret = -ENOMEM;
> +
> +       mm = get_task_mm(current);
> +       if (!mm)
> +               return -ESRCH;
> +
> +       down_write(&mm->mmap_sem);
> +       if (mm->uprobes_xol_area) {
> +               ret = -EALREADY;
> +               goto fail;
> +       }
> +
> +       /*
> +        * Find the end of the top mapping and skip a page.
> +        * If there is no space for PAGE_SIZE above
> +        * that, mmap will ignore our address hint.
> +        *
> +        * override credentials otherwise anonymous memory might
> +        * not be granted execute permission when the selinux
> +        * security hooks have their way.
> +        */
> +       vma = rb_entry(rb_last(&mm->mm_rb), struct vm_area_struct, vm_rb);
> +       addr = vma->vm_end + PAGE_SIZE;
> +       curr_cred = override_creds(&init_cred);
> +       addr = do_mmap_pgoff(NULL, addr, PAGE_SIZE, PROT_EXEC, MAP_PRIVATE, 0);
> +       revert_creds(curr_cred);
> +
> +       if (addr & ~PAGE_MASK)
> +               goto fail;
> +       vma = find_vma(mm, addr);
> +
> +       /* Don't expand vma on mremap(). */
> +       vma->vm_flags |= VM_DONTEXPAND | VM_DONTCOPY;
> +       area->vaddr = vma->vm_start;
> +       if (get_user_pages(current, mm, area->vaddr, 1, 1, 1, &area->page,
> +                               &vma) > 0)
> +               ret = 0;
> +
> +fail:
> +       up_write(&mm->mmap_sem);
> +       mmput(mm);
> +       return ret;
> +} 

So is that the right way? I looked back to the previous discussion with
Eric and couldn't really make up my mind either way. The changelog is
entirely without detail and Eric isn't CC'ed.

What's the point of having these discussions if all traces of them
disappear on the next posting?
