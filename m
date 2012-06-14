Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab2FNSVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 14:21:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab2FNSVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 14:21:52 -0400
Date: Thu, 14 Jun 2012 20:19:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, lkml <linux-kernel@vger.kernel.org>,
        michael@ellerman.id.au, antonb@thinktux.localdomain,
        Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
        Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH v2 1/2] uprobes: Pass probed vaddr to
	arch_uprobe_analyze_insn()
Message-ID: <20120614181934.GA9424@redhat.com>
References: <20120608093257.GG13409@in.ibm.com> <20120611161215.GA12116@redhat.com> <20120612165404.GB30555@linux.vnet.ibm.com> <20120612174305.GA16349@redhat.com> <20120613191519.GA14246@redhat.com> <20120614114514.GA12051@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614114514.GA12051@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-06-13 21:15:19]:
>
> > For example. Suppose there is some instruction in /lib64/libc.so which
> > is valid for 64-bit, but not for 32-bit.
> >
> > Suppose that a 32-bit application does mmap("/lib64/libc.so", PROT_EXEC).
> >
>
> How correct is it to have a 32 bit binary link to a 64 bit binary/library?

No, I didn't mean this. I guess you misunderstood my point, see below.

> > Now. If vma_prio_tree_foreach() finds this 32-bit mm first, uprobe_register()
> > fails even if there are other 64-bit applications which could be traced.
> >
> > Or. uprobe_register() succeeds because it finds a 64-bit mm first, and
> > then that 32-bit application actually executes the invalid insn.
> >
> > We can move arch_uprobe_analyze_insn() outside of !UPROBE_COPY_INSN block.
> >
> > Or, perhaps, validate_insn_bits() should call both
> > validate_insn_32bits() and validate_insn_64bits(), and set the
> > UPROBE_VALID_IF_32 / UPROBE_VALID_IF_64 flags. install_breakpoint()
> > should do the additinal check before set_swbp() and verify that
> > .ia32_compat matches UPROBE_VALID_IF_*.
> >
>
> > What do you think?
> >
>
> Lets say we do find a 32 bit app and 64 bit app using the same library
> and the underlying instruction is valid for tracing in 64 bit and not 32
> bit. So when we are registering, and failed to insert a breakpoint  for
> the 32 bit app, should we just bail out or should we return a failure?

I do not really know, I tend to think we should not fail. But this is
another story...

Look. Suppose that a 32-bit app starts after uprobe_register() succeeds.
In this case we have no option, uprobe_mmap()->install_breakpoint()
should "silently" fail. Currently it doesn't, this is one of the reasons
why I think the validation logic is wrong.

And. if install_breakpoint() can fail later anyway (in this case), then
I think uprobe_register() should not fail.

But probably this needs more discussion.


> I would probably prefer to read the underlying file something similar to
> what exec does and based on the magic decipher if we should verify for
> 32 bit instructions or 64 bit instructions.

But this can't protect from the malicious user who does
mmap(64-bit-code, PROT_EXEC) from a 32-bit app, and this can confuse
uprobes even if that 32-bit app never tries to actually execute that
64-bit-code.

That is why I think we need the additional (and arch-dependant) check
before every set_swbp(), but arch_uprobe_analyze_insn/etc should not
depend on task/mm/vaddr/whatever.

Oleg.

