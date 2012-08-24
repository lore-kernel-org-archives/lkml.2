Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab2HXBNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 21:13:36 -0400
Received: from ozlabs.org ([203.10.76.45]:49888 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756647Ab2HXBNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 21:13:20 -0400
Message-ID: <1345770803.13865.10.camel@concordia>
Subject: Re: [PATCH v4 2/2] powerpc: Uprobes port to powerpc
From: Michael Ellerman <michael@ellerman.id.au>
To: ananth@in.ibm.com
Cc: ppcdev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        peterz@infradead.org, oleg@redhat.com,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Date: Fri, 24 Aug 2012 11:13:23 +1000
In-Reply-To: <20120823055820.GA14603@in.ibm.com>
References: <20120822082205.GA29216@in.ibm.com>
	 <20120822082708.GB29216@in.ibm.com> <1345696100.3338.21.camel@concordia>
	 <20120823055820.GA14603@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 11:28 +0530, Ananth N Mavinakayanahalli wrote:
> On Thu, Aug 23, 2012 at 02:28:20PM +1000, Michael Ellerman wrote:
> > On Wed, 2012-08-22 at 13:57 +0530, Ananth N Mavinakayanahalli wrote:
> > > From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > > 
> > > This is the port of uprobes to powerpc. Usage is similar to x86.
> > 
> > Hi Ananth,
> > 
> > Excuse my ignorance of uprobes, some comments inline ...
> 
> Thanks for the review Michael!
> 
> > > [root@xxxx ~]# ./bin/perf probe -x /lib64/libc.so.6 malloc
> > > Added new event:
> > >   probe_libc:malloc    (on 0xb4860)
> > > 
> > > You can now use it in all perf tools, such as:
> > > 
> > > 	perf record -e probe_libc:malloc -aR sleep 1
> > 
> > Is there a test suite for any of this?
> 
> We don't have a formal testsuite yet, but the usual way of testing it is
> to run kernbench while registering/unregistering a bunch of probes
> periodically.

OK. Someone should put that on their TODO list, otherwise in a year or
two it'll be broken and we won't notice :)


> > It would be nice if someone could consolidate this with kprobe_opcode_t.
> 
> Thats on the TODO after the uprobes code stabilizes further.
> 
> I am wondering which file would be appropriate? We could either
> consolidate a bunch of these into asm/kdebug.h or asm/ptrace.h. Any
> preference/suggestion?

Add a new one :)

> > > +#define MAX_UINSN_BYTES			4
> > > +#define UPROBE_XOL_SLOT_BYTES		(MAX_UINSN_BYTES)
> > > +
> > > +#define UPROBE_SWBP_INSN		0x7fe00008
> > 
> > This is just "trap" ?
> 
> Yes. But since its referred to in arch agnostic code too, we'd have to alias
> it thus.

Yep I was just checking, I think it's probably worth a comment.

> > > +#define UPROBE_SWBP_INSN_SIZE		4 /* swbp insn size in bytes */
> > > +
> > > +#define IS_TW(instr)		(((instr) & 0xfc0007fe) == 0x7c000008)
> > > +#define IS_TD(instr)		(((instr) & 0xfc0007fe) == 0x7c000088)
> > > +#define IS_TDI(instr)		(((instr) & 0xfc000000) == 0x08000000)
> > > +#define IS_TWI(instr)		(((instr) & 0xfc000000) == 0x0c000000)
> > > +
> > > +#define is_trap(instr)	(IS_TW(instr) || IS_TD(instr) || \
> > > +			IS_TWI(instr) || IS_TDI(instr))
> > 
> > These seem to be duplicated in kprobes.h, can we consolidate them.
> 
> Yes, similar to the opcode_t types above.

Hmm, OK. Any reason you can't include kprobes.h to get those?

> > > +struct arch_uprobe {
> > > +	u8	insn[MAX_UINSN_BYTES];
> > > +};
> > 
> > Why not uprobe_opcode_t insn ?
> 
> I had a similar discussion with Srikar while doing the port, but he has
> reasons for this...

OK, will argue with him :D

> > > +/**
> > > + * arch_uprobe_analyze_insn
> > 
> > Analyze what about the instruction?
> 

+ /*

> Depends on the architecture. On x86, we need to verify if the address is
> at an instruction boundary, and if the instruction can be probed at all.
> On powerpc, we have an easier time. We just validate the address is
> aligned at instruction boundary and flag if the instruction at the
> address is a trap variant.

+ */

:)


> > > + * @mm: the probed address space.
> > > + * @arch_uprobe: the probepoint information.
> > > + * @addr: vaddr to probe.
> > > + * Return 0 on success or a -ve number on error.
> > > + */
> > > +int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long addr)
> > > +{
> > > +	unsigned int insn;
> > > +
> > > +	if (addr & 0x03)
> > > +		return -EINVAL;
> > > +
> > > +	memcpy(&insn, auprobe->insn, MAX_UINSN_BYTES);
> > 
> > We shouldn't need to use memcpy, we know it's a u32.
> 
> OK. Right now, its u8 insn[4], so I did this to be 'correct'. But I
> agree we can just do an assignment.

Yeah, at least in the arch code I think we should just use u32 and
assign directly.

> > > +/* callback routine for handling exceptions. */
> > > +int arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data)
> > > +{
> > > +	struct die_args *args = data;
> > > +	struct pt_regs *regs = args->regs;
> > > +
> > > +	/* We are only interested in userspace traps */
> > > +	if (regs && !user_mode(regs))
> > > +		return NOTIFY_DONE;
> > 
> > Do we ever get here with a NULL regs?
> 
> I don't think so. Its just a paranoid check. Do you prefer it to be
> removed?

Yeah. A NULL regs here is a kernel bug, so I think it's actually
preferable to crash than silently return.

cheers


