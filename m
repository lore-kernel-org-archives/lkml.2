Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030462Ab2HIOVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:21:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030188Ab2HIOVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:21:16 -0400
Date: Thu, 9 Aug 2012 16:17:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] uprobes: introduce MMF_HAS_UPROBES
Message-ID: <20120809141740.GA8509@redhat.com>
References: <20120808173659.GA13220@redhat.com> <20120808173747.GA13272@redhat.com> <20120809133251.GA26733@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120809133251.GA26733@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-08-08 19:37:47]:
>
> > Add the new MMF_HAS_UPROBES flag. It is set by install_breakpoint()
> > and it is copied by dup_mmap(), uprobe_pre_sstep_notifier() checks
> > it to avoid the slow path if the task was never probed. Perhaps it
> > makes sense to check it in valid_vma(is_register => false) as well.
> >
> > This needs the new dup_mmap()->uprobe_dup_mmap() hook. We can't use
> > uprobe_reset_state() or put MMF_HAS_UPROBES into MMF_INIT_MASK, we
> > need oldmm->mmap_sem to avoid the race with uprobe_register() or
> > mmap() from another thread.
> >
> > Currently we never clear this bit, it can be false-positive after
> > uprobe_unregister() or uprobe_munmap() or if dup_mmap() hits the
> > probed VM_DONTCOPY vma. But this is fine correctness-wise and has
> > no effect unless the task hits the non-uprobe breakpoint.
> >
>
> In which case, cant we just delete uprobe_munmap() altogether.

>From 0/7:

	The next series will teach uprobes to
	clear MMF_HAS_UPROBES, but perhaps we should simply remove
	uprobe_munmap() instead.

Yes, after this series uprobe_munmap() is nop, but see below.

> > @@ -1034,6 +1045,9 @@ void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned lon
> >  	if (!atomic_read(&vma->vm_mm->mm_users)) /* called by mmput() ? */
> >  		return;
> >
> > +	if (!test_bit(MMF_HAS_UPROBES, &vma->vm_mm->flags))
> > +		return;
> > +
>
> I am not sure whats the purpose of the above test
>
>
>
> >  	/* TODO: unmapping uprobe(s) will need more work */
>
> and I am unable to think what more we would want to do here.

The next series will add MMF_UPROBE_RECALC, this bits indicates that
MMF_HAS_UPROBES can be false-positive. uprobe_munmap() will roughly do

	if (find_node_in_range(start, end))
		set_bit(MMF_UPROBE_RECALC);

Once again, I am not sure we really need more complications, we will
discuss this later and decide. If we do not want them, we can kill
uprobe_munmap().

Just in case... uprobe_dup_mmap() is very simple but "sub-optimal".
We can improve this logic if we add uprobe_dup_vma() instead which
does

	if (test_bit(MMF_HAS_UPROBES))
		return;
	if (find_node_in_range(...))
		set_bit(MMF_HAS_UPROBES);

But again, it would be better to discuss this later.

Oleg.

