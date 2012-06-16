Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab2FPSIK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 14:08:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab2FPSIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 14:08:09 -0400
Date: Sat, 16 Jun 2012 20:05:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        peterz@infradead.org, Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH v2 1/2] uprobes: Pass probed vaddr to
	arch_uprobe_analyze_insn()
Message-ID: <20120616180555.GA13634@redhat.com>
References: <20120608093257.GG13409@in.ibm.com> <20120611161215.GA12116@redhat.com> <20120612165404.GB30555@linux.vnet.ibm.com> <20120612174305.GA16349@redhat.com> <20120613191519.GA14246@redhat.com> <20120614114514.GA12051@linux.vnet.ibm.com> <20120614181934.GA9424@redhat.com> <20120615123300.GA5748@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615123300.GA5748@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srikar,

To clarify: I am not arguing, I am asking because I know nothing about
asm/opcodes/etc.

On 06/15, Srikar Dronamraju wrote:
>
> > But this can't protect from the malicious user who does
> > mmap(64-bit-code, PROT_EXEC) from a 32-bit app, and this can confuse
> > uprobes even if that 32-bit app never tries to actually execute that
> > 64-bit-code.
> >
>
> So if we read just after we allocate uprobe struct but before
> probe insertion, then we dont need to check this for each process.
>
> So if the library was 64 bit mapped in 32 bit process and has a valid
> instruction for 64 bit, then we just check for valid 64 bit instructions
> and allow insertion of the breakpoint even in the 32 bit process.

And what happens if this insn is not valid from validate_insn_32bits()
pov and that 32-bit application tries to execute it? Or vice versa,
see below.

> Here is a very crude implementation of the same.
> Also this depends on read_mapping_page taking NULL as an valid argument
> for file. As a side-effect we can do away with UPROBE_COPY_INSN which
> was set and read at just one place.
>
> 1. Move the copy_insn to just after alloc_uprobe.
> 2. Assume that copy_insn can work without struct file
> ...
> 5. Move the analyze instruction to before the actual probe insertion.

OK, this is what I think we should do anyway (at least try to do).

> 3. Read the elfhdr for the file.
> 4. Pass the elfhdr to the arch specific analyze insn

This assumes that everything is elf. Why? An application is free to
create a file in any format and do mmap(PROT_EXEC).

But OK, probably we can restrict uprobe_register() to work only with
elf files which do not mix 32/64 bits.




My concern is, are you sure an evil user can't confuse uprobes and
do something bad?

Just to explain what I mean. For example, we certainly do not want
to allow to probe the "syscall" insn, at least with the current
implementation. So I assume that validate_insn_64bits("syscall")
must fail.

Are you sure that validate_insn_32bits("syscall") will fail too?

Of course, I am not asking about "syscall" in particular. In general,
suppose that, say, validate_insn_64bits() returns true. Are you sure
this insn can't do something different and harmful if it is executed
by __USER32_CS task?

Oleg.

