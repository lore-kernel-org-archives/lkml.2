Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934845Ab1JEPQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 11:16:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934812Ab1JEPQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 11:16:29 -0400
Date: Wed, 5 Oct 2011 17:11:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 5/26]   Uprobes: copy of the original
	instruction.
Message-ID: <20111005151111.GA28694@redhat.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20110920120057.25326.63780.sendpatchset@srdronam.in.ibm.com> <20111003162905.GA3752@redhat.com> <20111005105243.GA806@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005105243.GA806@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srikar, warning.

I am going to discuss the things I do not really understand ;)
Hopefully someone will correct me if I am wrong.

On 10/05, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2011-10-03 18:29:05]:
>
> > > +	page_cache_sync_readahead(mapping, &filp->f_ra, filp, idx, 1);
> >
> > This schedules the i/o,
> >
> > > +	page = grab_cache_page(mapping, idx);
> >
> > This finds/locks the page in the page-cache,
> >
> > > +	if (!page)
> > > +		return -ENOMEM;
> > > +
> > > +	vaddr = kmap_atomic(page);
> > > +	memcpy(insn, vaddr + off1, nbytes);
> >
> > What if this page is not PageUptodate() ?
>
> Since we do a synchronous read ahead, I thought the page would be
> populated and upto date.

What does this "synchronous" actually mean?

First of all, page_cache_sync_readahead() can simply return. Or
__do_page_cache_readahead() can "skip" the page if it is already in the
page cache.

IOW, we do not even know if ->readpage() was called. But even if it was
called, afaics (in general) the page will be unlocked and marked Uptodate
when I/O completes, not when ->readpage() returns.

> would these two lines after grab_cache_page help?
>
> 	if (!PageUptodate(page))
> 		mapping->a_ops->readpage(filp, page);

This doesn't look right. At least you need lock_page().

Anyway. Why you can't simply use read_mapping_page() or even kernel_read() ?

But the real question is:

> > But I am starting to think I simply do not understand this change.
> > To the point, I do not underestand why do we need copy_insn() at all.
> > We are going to replace this page, can't we save/analyze ->insn later
> > when we copy the content of the old page? Most probably I missed
> > something simple...

Could you please explain?

> > But this should not be possible, no? How it can map this vaddr above
> > TASK_SIZE ?
> >
> > get_user_pages(tsk => NULL) is fine. Why else do we need mm->owner ?
>
> >
> > Probably used by the next patches... Say, is_32bit_app(tsk). This
> > can use mm->context.ia32_compat (hopefully will be replaced with
> > MMF_COMPAT).
> >
>
> We used the tsk struct for checking if the application was 32 bit and
> for calling get_user_pages. Since we can pass NULL to get_user_pages and
> since we can use mm->context.ia32_compat or MMF_COMPAT, I will remove
> get_mm_owner, that way we dont need to be dependent on CONFIG_MM_OWNER.

Great!

Oleg.

