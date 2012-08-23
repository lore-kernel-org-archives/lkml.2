Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab2HWF6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 01:58:31 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54170 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab2HWF63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 01:58:29 -0400
Date: Thu, 23 Aug 2012 11:28:20 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: ppcdev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        peterz@infradead.org, oleg@redhat.com,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v4 2/2] powerpc: Uprobes port to powerpc
Message-ID: <20120823055820.GA14603@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20120822082205.GA29216@in.ibm.com> <20120822082708.GB29216@in.ibm.com> <1345696100.3338.21.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345696100.3338.21.camel@concordia>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082305-2356-0000-0000-000001843074
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 02:28:20PM +1000, Michael Ellerman wrote:
> On Wed, 2012-08-22 at 13:57 +0530, Ananth N Mavinakayanahalli wrote:
> > From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > 
> > This is the port of uprobes to powerpc. Usage is similar to x86.
> 
> Hi Ananth,
> 
> Excuse my ignorance of uprobes, some comments inline ...

Thanks for the review Michael!

> > [root@xxxx ~]# ./bin/perf probe -x /lib64/libc.so.6 malloc
> > Added new event:
> >   probe_libc:malloc    (on 0xb4860)
> > 
> > You can now use it in all perf tools, such as:
> > 
> > 	perf record -e probe_libc:malloc -aR sleep 1
> 
> Is there a test suite for any of this?

We don't have a formal testsuite yet, but the usual way of testing it is
to run kernbench while registering/unregistering a bunch of probes
periodically.

...

> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> > + *
> > + * Copyright (C) IBM Corporation, 2007-2012
> 
> The lawyers say we shouldn't use (C).

Will remove that.

> Is it really copyright IBM 2007-2012? Or is that because you copied
> another header?

The later. This is adapted from the x86 version.

> > +typedef unsigned int uprobe_opcode_t;
> 
> I'd prefer u32.

OK. Will change.

> It would be nice if someone could consolidate this with kprobe_opcode_t.

Thats on the TODO after the uprobes code stabilizes further.

I am wondering which file would be appropriate? We could either
consolidate a bunch of these into asm/kdebug.h or asm/ptrace.h. Any
preference/suggestion?

> > +#define MAX_UINSN_BYTES			4
> > +#define UPROBE_XOL_SLOT_BYTES		(MAX_UINSN_BYTES)
> > +
> > +#define UPROBE_SWBP_INSN		0x7fe00008
> 
> This is just "trap" ?

Yes. But since its referred to in arch agnostic code too, we'd have to alias
it thus.

> > +#define UPROBE_SWBP_INSN_SIZE		4 /* swbp insn size in bytes */
> > +
> > +#define IS_TW(instr)		(((instr) & 0xfc0007fe) == 0x7c000008)
> > +#define IS_TD(instr)		(((instr) & 0xfc0007fe) == 0x7c000088)
> > +#define IS_TDI(instr)		(((instr) & 0xfc000000) == 0x08000000)
> > +#define IS_TWI(instr)		(((instr) & 0xfc000000) == 0x0c000000)
> > +
> > +#define is_trap(instr)	(IS_TW(instr) || IS_TD(instr) || \
> > +			IS_TWI(instr) || IS_TDI(instr))
> 
> These seem to be duplicated in kprobes.h, can we consolidate them.

Yes, similar to the opcode_t types above.

> > +struct arch_uprobe {
> > +	u8	insn[MAX_UINSN_BYTES];
> > +};
> 
> Why not uprobe_opcode_t insn ?

I had a similar discussion with Srikar while doing the port, but he has
reasons for this...

...

> >  void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
> >  {
> > +	if (thread_info_flags & _TIF_UPROBE) {
> > +		clear_thread_flag(TIF_UPROBE);
> > +		uprobe_notify_resume(regs);
> > +	}
> 
> Presumably this ordering is crucial, ie. uprobes before signals.

Correct!

...

> > +#define UPROBE_TRAP_NR	UINT_MAX
> 
> In the comments below you talk about -1 a few times, but you actually
> mean UINT_MAX.

Correct. I will fix those references.

> > +/**
> > + * arch_uprobe_analyze_insn
> 
> Analyze what about the instruction?

Depends on the architecture. On x86, we need to verify if the address is
at an instruction boundary, and if the instruction can be probed at all.
On powerpc, we have an easier time. We just validate the address is
aligned at instruction boundary and flag if the instruction at the
address is a trap variant.

> > + * @mm: the probed address space.
> > + * @arch_uprobe: the probepoint information.
> > + * @addr: vaddr to probe.
> > + * Return 0 on success or a -ve number on error.
> > + */
> > +int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long addr)
> > +{
> > +	unsigned int insn;
> > +
> > +	if (addr & 0x03)
> > +		return -EINVAL;
> > +
> > +	memcpy(&insn, auprobe->insn, MAX_UINSN_BYTES);
> 
> We shouldn't need to use memcpy, we know it's a u32.

OK. Right now, its u8 insn[4], so I did this to be 'correct'. But I
agree we can just do an assignment.

> > +	if (is_trap(insn))
> > +		return -ENOTSUPP;
> 
> A comment saying why we can't handle this would be nice.

Will add.

> > +	return 0;
> > +}
> 
> 
> I am probably missing something, but why do we need to execute out of
> line?

I think Srikar answered that.

...

> > +/* callback routine for handling exceptions. */
> > +int arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data)
> > +{
> > +	struct die_args *args = data;
> > +	struct pt_regs *regs = args->regs;
> > +
> > +	/* We are only interested in userspace traps */
> > +	if (regs && !user_mode(regs))
> > +		return NOTIFY_DONE;
> 
> Do we ever get here with a NULL regs?

I don't think so. Its just a paranoid check. Do you prefer it to be
removed?

...

> > + * See if the instruction can be emulated.
> > + * Returns true if instruction was emulated, false otherwise.
> > + */
> > +bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
> > +{
> > +	int ret;
> > +	unsigned int insn;
> > +
> > +	memcpy(&insn, auprobe->insn, MAX_UINSN_BYTES);
> 
> Why memcpy?

Same as above - u8 insn[4].

> > +
> > +	/*
> > +	 * emulate_step() returns 1 if the insn was successfully emulated.
> > +	 * For all other cases, we need to single-step in hardware.
> > +	 */
> > +	ret = emulate_step(regs, insn);
> > +	if (ret > 0)
> > +		return true;
> 
> This actually emulates the instruction, ie. the contents of regs are
> changed based on the instruction.
> 
> That seems to differ vs x86, where arch_uprobe_skip_sstep() just checks
> the instruction and returns true/false. Is that because on x86 they are
> only returning true for nops? ie. there is no emulation to be done?
> 
> It's a little surprising that can_skip_sstep() actually emulates the
> instruction, but again that's not your fault.

We initially had a uprobe_emulate_step() callback which over many review
cycles has morphed into this.

Ananth

