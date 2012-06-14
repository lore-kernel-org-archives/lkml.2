Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab2FNLti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:49:38 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55245 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612Ab2FNLtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:49:36 -0400
Date: Thu, 14 Jun 2012 17:15:14 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, lkml <linux-kernel@vger.kernel.org>,
        michael@ellerman.id.au, antonb@thinktux.localdomain,
        Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
        Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH v2 1/2] uprobes: Pass probed vaddr to
 arch_uprobe_analyze_insn()
Message-ID: <20120614114514.GA12051@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120608093257.GG13409@in.ibm.com>
 <20120611161215.GA12116@redhat.com>
 <20120612165404.GB30555@linux.vnet.ibm.com>
 <20120612174305.GA16349@redhat.com>
 <20120613191519.GA14246@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120613191519.GA14246@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061411-7606-0000-0000-0000011D87E9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-06-13 21:15:19]:

> On 06/12, Oleg Nesterov wrote:
> >
> > On 06/12, Srikar Dronamraju wrote:
> > > >
> > > > Note also that we should move this !UPROBE_COPY_INSN from
> > > > install_breakpoint() to somewhere near alloc_uprobe(). This code
> > > > is called only once, it looks a bit strange to use the "random" mm
> > > > (the first mm vma_prio_tree_foreach() finds) and its mapping to
> > > > verify the insn. In fact this is simply not correct and should be
> > > > fixed, note that on x86 arch_uprobe_analyze_insn() checks
> > >
> > > The reason we "delay" the copy_insn to the first insert is because
> > > we have to get access to mm. For archs like x86, we want to know if the
> > > executable is 32 bit or not
> >
> > Yes. And this is wrong afaics.
> >
> > Once again. This !UPROBE_COPY_INSN code is called only once, and it
> > uses the "random" mm. After that install_breakpoint() just calls
> > set_swbp(another_mm) while the insn can be invalid because
> > another_mm->ia32_compat != mm->ia32_compat.
> >
> > > So in effect, if we get access to
> > > struct file corresponding to the inode and if the inode corresponds to
> > > 32 bit executable file or 64 bit executable file during register, then
> > > we can move it around alloc_uprobe().
> >
> > I don't think this can work. I have another simple fix in mind, I'll
> > write another email later.
> 
> For example. Suppose there is some instruction in /lib64/libc.so which
> is valid for 64-bit, but not for 32-bit.
> 
> Suppose that a 32-bit application does mmap("/lib64/libc.so", PROT_EXEC).
> 

How correct is it to have a 32 bit binary link to a 64 bit binary/library?
what if the 64 bit binary/executable were to make a jump to a 64 bit
address? 


> Now. If vma_prio_tree_foreach() finds this 32-bit mm first, uprobe_register()
> fails even if there are other 64-bit applications which could be traced.
> 
> Or. uprobe_register() succeeds because it finds a 64-bit mm first, and
> then that 32-bit application actually executes the invalid insn.
> 
> We can move arch_uprobe_analyze_insn() outside of !UPROBE_COPY_INSN block.
> 
> Or, perhaps, validate_insn_bits() should call both
> validate_insn_32bits() and validate_insn_64bits(), and set the
> UPROBE_VALID_IF_32 / UPROBE_VALID_IF_64 flags. install_breakpoint()
> should do the additinal check before set_swbp() and verify that
> .ia32_compat matches UPROBE_VALID_IF_*.
> 

> What do you think?
> 

Lets say we do find a 32 bit app and 64 bit app using the same library
and the underlying instruction is valid for tracing in 64 bit and not 32
bit. So when we are registering, and failed to insert a breakpoint  for
the 32 bit app, should we just bail out or should we return a failure?

I would probably prefer to read the underlying file something similar to
what exec does and based on the magic decipher if we should verify for
32 bit instructions or 64 bit instructions.

I didnt find a good way to read the first few bytes just by looking at
the inode. So one option is to read the underlying file at the first
insertion (i.e similar to what we do now .. but instead of depending on
ia32_compat of a random mm, depend on the exec magic)

Better option would be read the underlying file at the register time and
return an error even without attempting an insert if the instruction
wasnt valid. But I am still ignorant on how to do this because we need a
struct file to do this.

-- 
Thanks and Regards
Srikar

