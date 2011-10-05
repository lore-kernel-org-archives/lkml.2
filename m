Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934328Ab1JESyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 14:54:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab1JESyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 14:54:32 -0400
Date: Wed, 5 Oct 2011 20:50:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 3/26]   Uprobes: register/unregister
	probes.
Message-ID: <20111005185008.GA8107@redhat.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20110920120022.25326.35868.sendpatchset@srdronam.in.ibm.com> <20111003124640.GA25811@redhat.com> <20111005170420.GB28250@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005170420.GB28250@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05, Srikar Dronamraju wrote:
>
> Agree. Infact I encountered this problem last week and had fixed it.
> In mycase, I had mapped the file read and write while trying to insert
> probes.
> The changed code looks like this
>
> 	if (!vma)
> 		return NULL;

This is unneeded, vma_prio_tree_foreach() stops when vma_prio_tree_next()
returns NULL. IOW, you can never see vma == NULL.

> 	if (!valid_vma(vma))
> 		continue;

Yes.

> > > +	mutex_lock(&inode->i_mutex);
> > > +	uprobe = alloc_uprobe(inode, offset);
> >
> > Looks like, alloc_uprobe() doesn't need ->i_mutex.
>
>
> Actually this was pointed out by you in the last review.
> https://lkml.org/lkml/2011/7/24/91

OOPS ;) may be deserves a comment...

> > > +void unregister_uprobe(struct inode *inode, loff_t offset,
> > > +				struct uprobe_consumer *consumer)
> > > +{
> > > +	struct uprobe *uprobe;
> > > +
> > > +	inode = igrab(inode);
> > > +	if (!inode || !consumer)
> > > +		return;
> > > +
> > > +	if (offset > inode->i_size)
> > > +		return;
> > > +
> > > +	uprobe = find_uprobe(inode, offset);
> > > +	if (!uprobe)
> > > +		return;
> > > +
> > > +	if (!del_consumer(uprobe, consumer)) {
> > > +		put_uprobe(uprobe);
> > > +		return;
> > > +	}
> > > +
> > > +	mutex_lock(&inode->i_mutex);
> > > +	if (!uprobe->consumers)
> > > +		__unregister_uprobe(inode, offset, uprobe);
> >
> > It seemes that del_consumer() should be done under ->i_mutex. If it
> > removes the last consumer, we can race with register_uprobe() which
> > takes ->i_mutex before us and does another __register_uprobe(), no?
>
> We should still be okay, because we check for the consumers before we
> do the actual unregister in form of __unregister_uprobe.
> since the consumer is again added by the time we get the lock, we dont
> do the actual unregistration and go as if del_consumer deleted one
> consumer but not the last.

Yes, but I meant in this case register_uprobe() does the unnecessary
__register_uprobe() because it sees ->consumers == NULL (add_consumer()
returns NULL).

I guess this is probably harmless because of is_bkpt_insn/-EEXIST
logic, but still.


Btw. __register_uprobe() does

		ret = install_breakpoint(mm, uprobe, vma, vi->vaddr);
		if (ret && (ret != -ESRCH || ret != -EEXIST)) {
			up_read(&mm->mmap_sem);
			mmput(mm);
			break;
		}
		ret = 0;
		up_read(&mm->mmap_sem);
		mmput(mm);

Yes, this is cosmetic, but why do we duplicate up_read/mmput ?

Up to you, but

		ret = install_breakpoint(mm, uprobe, vma, vi->vaddr);
		up_read(&mm->mmap_sem);
		mmput(mm);

		if (ret) {
			if (ret != -ESRCH && ret != -EEXIST)
				break;
			ret = 0;
		}

Looks a bit simpler.

Oh, wait. I just noticed that the original code does

	(ret != -ESRCH || ret != -EEXIST)

this expression is always true ;)

Oleg.

