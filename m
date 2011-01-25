Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab1AYMPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:15:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51253 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab1AYMPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:15:19 -0500
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 8/20]  8: uprobes: mmap and fork
 hooks.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20101216095848.23751.73144.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095848.23751.73144.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 Jan 2011 13:15:39 +0100
Message-ID: <1295957739.28776.717.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 15:28 +0530, Srikar Dronamraju wrote:
> +void uprobe_mmap(struct vm_area_struct *vma)
> +{
> +       struct list_head tmp_list;
> +       struct uprobe *uprobe, *u;
> +       struct mm_struct *mm;
> +       struct inode *inode;
> +
> +       if (!valid_vma(vma))
> +               return;
> +
> +       INIT_LIST_HEAD(&tmp_list);
> +
> +       /*
> +        * The vma was just allocated and this routine gets called
> +        * while holding write lock for mmap_sem.  Function called
> +        * in context of a thread that has a reference to mm.
> +        * Hence no need to take a reference to mm
> +        */
> +       mm = vma->vm_mm;
> +       up_write(&mm->mmap_sem);

Are you very very sure its a good thing to simply drop the mmap_sem
here? Also, why?

> +       mutex_lock(&uprobes_mutex);
> +
> +       inode = vma->vm_file->f_mapping->host;

Since you just dropped the mmap_sem, what's keeping that vma from going
away?

> +       add_to_temp_list(vma, inode, &tmp_list);
> +
> +       list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
> +               mm->uprobes_vaddr = vma->vm_start + uprobe->offset;
> +               install_uprobe(mm, uprobe);
> +               list_del(&uprobe->pending_list);
> +       }
> +       mutex_unlock(&uprobes_mutex);
> +       down_write(&mm->mmap_sem);
> +} 


