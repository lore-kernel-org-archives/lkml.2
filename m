Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab2IYOXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:23:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab2IYOXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:23:51 -0400
Date: Tue, 25 Sep 2012 16:20:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] uprobes: Restrict valid_vma(false) to skip
	VM_SHARED
Message-ID: <20120925142021.GB9987@redhat.com>
References: <20120916175210.GA32337@redhat.com> <20120916175248.GA32373@redhat.com> <20120925090509.GC18334@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925090509.GC18334@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-09-16 19:52:48]:
>
> > This can also
> > speedup uprobe_munmap() and uprobe_unregister().
> >
>
> I didnt get how it speeds up uprobe_munmap() and uprobe_unregister()?

Say, uprobe_unregister()->..->build_map_info() can skip VM_SHARED vma
early and avoid the unnecessary remove_breakpoint/get_user_pages.

The same for munmap(), no need to do vma_has_uprobes/etc if we know
that this vma can't have uprobes because valid_vma(true) is not
possible.

> > Note: even after this patch _unregister can confuse the probed
> > application if it does mprotect(PROT_WRITE) after _register and
> > installs "int3", but this is hardly possible to avoid and this
> > doesn't differ from gdb case.
>
> Again I didnt quite understand how unregister can confuse the probed
> application.

Because set_orig_insn() can never know if this "int3" was set by us
(by register) or by gdb or application itself.

But I agree, the text above looks confusing, I just wanted to remind
that this patch can't solve all problems like this.

But at least with this patch it is not possible to confuse the app
which tries to _modify_ ->vm_file via mmap.


In the long term it would be nice to avoid these problems somehow,
but this is not easy. Say, perhaps we can mark the page installed
by uprobes as OWNED-BY-KERNEL-DONT-COW and offload set_swbp() to
page fault.

Or, simpler, perhaps uprobe_register() can remove VM_MAYWRITE,
but this affects the whole vma and it is not clear how _unregister
can restore this flag correctly.

But this is off-topic.

> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Thanks!

Oleg.

