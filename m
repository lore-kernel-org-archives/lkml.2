Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab2IXPyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:54:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43175 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab2IXPyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:54:44 -0400
Date: Mon, 24 Sep 2012 16:54:39 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
Cc: linux@arm.linux.org.uk, catalin.marinas@arm.com, linus.walleij@linaro.org,
        will.deacon@arm.com, grant.likely@secretlab.ca,
        paul.gortmaker@windriver.com, vincent.guittot@linaro.org,
        nico@linaro.org, davidb@codeaurora.org, plagnioj@jcrosoft.com,
        arnd@arndb.de, marc.zyngier@arm.com, rob.herring@calxeda.com,
        vitalya@ti.com, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, rmallon@gmail.com,
        frank.rowand@am.sony.com, sjg@chromium.org, sboyd@codeaurora.org,
        linux-kernel@vger.kernel.org, rabin@rab.in,
        hsweeten@visionengravers.com, tj@kernel.org
Subject: Re: [PATCH v3 RESEND 01/17] ARM: add mechanism for late code patching
Message-ID: <20120924155439.GC2122@linaro.org>
References: <1348242975-19184-1-git-send-email-cyril@ti.com>
 <1348242975-19184-2-git-send-email-cyril@ti.com>
 <20120924120637.GB2122@linaro.org>
 <506072FE.2020506@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506072FE.2020506@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 10:49:34AM -0400, Cyril Chemparathy wrote:
> Hi Dave,
> 
> Thanks for the detailed review...
> 
> On 9/24/2012 8:06 AM, Dave Martin wrote:
> >On Fri, Sep 21, 2012 at 11:55:59AM -0400, Cyril Chemparathy wrote:
> >>The original phys_to_virt/virt_to_phys patching implementation relied on early
> >>patching prior to MMU initialization.  On PAE systems running out of >4G
> >>address space, this would have entailed an additional round of patching after
> >>switching over to the high address space.
> >>
> >>The approach implemented here conceptually extends the original PHYS_OFFSET
> >>patching implementation with the introduction of "early" patch stubs.  Early
> >>patch code is required to be functional out of the box, even before the patch
> >>is applied.  This is implemented by inserting functional (but inefficient)
> >>load code into the .runtime.patch.code init section.  Having functional code
> >>out of the box then allows us to defer the init time patch application until
> >>later in the init sequence.
> >
> >There are currently a few different patching mechanisms in the kernel, and
> >it would be good if we could collect more of them under some common
> >framework.
> >
> 
> That would be great!  I could use some pointers here.  I've looked
> at the kprobes code, and there doesn't appear to be much of an
> intersection there...

Well, I think we shouldn't try it for now.  I think kprobes is
doing something different enough that it doesn't necessarily make
sense to unify that.

If your patches are useful as-is, we shouldn't worry about adding
features until later.

> >For example, it might be possible to do the SMP-on-UP fixups using the same
> >framework you propose.  Best not to attempt that yet, though.
> >
> 
> ... and I've looked at the ALT_SMP/ALT_UP stuff as well.  The
> problem here appears to be that ALT_SMP is needed way early in boot
> - up in head.S assembly-land.

Indeed, this would need some thought.  Again, this is just a "maybe".
No need to try it right now.

> 
> The third place is probably the jump label mechanism.  That may be a
> fit with some work, but I'm not sure yet.
> 
> >Overall, this looks well thought out and useful, though it looks like it
> >has a few issues that need attention.
> >
> >Comments below.
> >
> >Cheers
> >---Dave
> >
> [...]
> >>Note: the obtuse use of stringified symbols in patch_stub() and
> >>early_patch_stub() is intentional.  Theoretically this should have been
> >>accomplished with formal operands passed into the asm block, but this requires
> >>the use of the 'c' modifier for instantiating the long (e.g. .long %c0).
> >>However, the 'c' modifier has been found to ICE certain versions of GCC, and
> >>therefore we resort to stringified symbols here.
> >
> >You might find that the "n" constraint works.  The explanation in the
> >GCC docs is pretty incomprehensible, but at least it exists.
> >
> >__stringify hacks are not uncommon anyway though, so it's not a problem
> >either way.
> >
> 
> The stringify hack is nasty, and I'd like to get rid of it if I could...
> 
> I looked up constraints.md, and couldn't find "n" defined as a
> constraint.  For that matter, I couldn't find "n" being handled as a
> modifier in arm_print_operand() either.  BTW, I'm looking at GCC 4.6
> for these.
> 
> Could you please point me to the doc in question that lists this
> constraint/modifier?  Is this specific to newer (or older) versions
> of GCC.

See the "Simple Constraints" section in the GCC docs.

However, it looks like "n" only works for operands which really do
evaluate to constant integers.  It doesn't work for expressions based
on symbols:

	void g(int);
        asm(".long %0" :: "n" (g));

tst.c:6:2: warning: asm operand 0 probably doesn't match constraints
tst.c:6:2: error: impossible constraint in 'asm'


So scratch that suggestion...  the __stringify() method looks better.

> 
> [...]
> >>+#define early_patch_stub(type, code, pad, patch_data, ...)		\
> >>+	__asm__("@ patch stub\n"					\
> >>+		"1:\n"							\
> >>+		"	b	6f\n"					\
> >>+		"	.fill	" __stringify(pad) ", 1, 0\n"		\
> >
> >What is the pad argument for?  It never seems to be set to anything other
> >than 0 in your series.
> >
> 
> The pad argument is used when we need more than one 32-bit
> instruction slot in the straight line (post patch) code path.
> Please look at patch 05/17 of the series (ARM: LPAE: support 64-bit
> virt_to_phys patching). When we patch 64-bit virt_to_phys(), we need
> that extra slot to fill up the upper 32-bits of the result.

I see -- it looks like I missed that.

I guess this is probably OK, given that for every instruction-sized
bit of padding, there should be a corresponding patch data definition
in the same asm block which increases GCC's guess about the size of
the asm at least enough to avoid fixup problems.

Used like this, there should probably be no problem.

> >The compiler uses a pretty dumb heuristic to guess the size of asms:
> >4 * (number of ; or \n in the string)
> >
> >Directives that the compiler can't predict the size of are not safe if
> >they output into any segment that the compiler uses.  .fill/.skip are
> >obvious candidates, but macro expansions, .rept, .irp etc. can cause
> >these problems too.
> >
> >For example:
> >
> >	void g(int);
> >	void f(void)
> >	{
> >		g(0xd00dfeed);
> >		asm(".skip 0x1000");
> >	}
> >
> >If you try building this with gcc -marm -Os for example:
> >
> >/tmp/ccXYm1uP.s: Assembler messages:
> >/tmp/ccXYm1uP.s:21: Error: bad immediate value for offset (4100)
> >
> >...because the assembler assumes that it can dump a literal at the end
> >of the function and reference it from the g() callsite.
> >
> >
> >It may be that you have some intended future use for pad (such as
> >pasting one instruction sequence in place of another possibly
> >differently-sized sequence at fixup time), in which case this might
> >require a bit more thought.
> >
> 
> Good point.  Thanks.
> 
> I'm not sure if this helps, but I don't think pad should be used to
> insert more than a couple of instruction words into the code.

A directive which inserts <= 4 bytes is safe.  Anything else is not
safe (unless GCC overestimates the size of the asm for other reasons).

As I explain above, I now think we are actually OK in this case.

> >>+		"2:\n"							\
> >>+		"	.pushsection .runtime.patch.table, \"a\"\n"	\
> >>+		"3:\n"							\
> >>+		"	.word 1b\n"					\
> >>+		"	.hword (" __stringify(type) ")\n"		\
> >>+		"	.byte (2b-1b)\n"				\
> >>+		"	.byte (5f-4f)\n"				\
> >>+		"4:\n"							\
> >>+		patch_data						\
> >>+		"	.align\n"					\
> >>+		"5:\n"							\
> >>+		"	.popsection\n"					\
> >>+		"	.pushsection .runtime.patch.code, \"ax\"\n"	\
> >
> >I have a vague feeling that this should have .text in the name somewhere,
> >since it is code that gets executed in place.
> >
> 
> Fair enough.  Will change to .runtime.patch.text instead.
> 
> >>+		"6:\n"							\
> >>+		code							\
> >>+		"	b 2b\n"						\
> >
> >.ltorg
> >
> >(See [1] below.)
> >
> >>+		"	.popsection\n"					\
> >>+		__VA_ARGS__)
> >>+
> >>+/* constant used to force encoding */
> >>+#define __IMM8		(0x81 << 24)
> >>+
> >>+/*
> >>+ * patch_imm8() - init-time specialized binary operation (imm8 operand)
> >>+ *		  This effectively does: to = from "insn" sym,
> >>+ *		  where the value of sym is fixed at init-time, and is patched
> >
> >If I've understood correctly, then this description is a bit misleading.
> >sym is not an absolute operand, but rather *(sym + ofs) is a
> >variable containing the fixup operand.
> >
> 
> Correct.  I'll clarify in the text.
> 
> >>+ *		  in as an immediate operand.  This value must be
> >>+ *		  representible as an 8-bit quantity with an optional
> >>+ *		  rotation.
> >>+ *
> >>+ *		  The stub code produced by this variant is non-functional
> >>+ *		  prior to patching.  Use early_patch_imm8() if you need the
> >>+ *		  code to be functional early on in the init sequence.
> >>+ */
> >>+#define patch_imm8(_insn, _to, _from, _sym, _ofs)			\
> >
> >Why are the _sym and _ofs parameters separate?  Nothing in your series
> >seems to requre _sym to be a symbol or _ofs to be a number; and nothing
> >passes _ofs != 0, but anyway I don't see why the caller can't add those
> >two values together in the macro argument.
> >
> 
> I could (should) really get rid of ofs.  This is a hold over from
> earlier versions of the patch, where we were using the ofs to point
> to the upper 32-bits of the phys_offset ( = 4 for LE, 0 for BE).
> 
> I will clean this up in the next rev.  Thanks.

Ah, OK.  Removing that extra argument should make things clearer.

> 
> >>+	patch_stub(							\
> >>+		/* type */						\
> >>+			PATCH_IMM8,					\
> >>+		/* code */						\
> >>+			_insn "	%[to], %[from], %[imm]\n",		\
> >>+		/* patch_data */					\
> >>+			".long " __stringify(_sym + _ofs) "\n"		\
> >
> >If _sym or _ofs is a complex expression, the + may mis-bind.  If the
> >_ofs parameter is needed at all, it would probably be a good idea to
> >have parentheses around _sym and _ofs.
> >
> 
> I'm guessing this doesn't apply once we get rid of ofs?

Sure, no problem.

> >>+			_insn "	%[to], %[from], %[imm]\n",		\
> >>+		/* operands */						\
> >>+			: [to]	 "=r" (_to)				\
> >>+			: [from] "r"  (_from),				\
> >>+			  [imm]	 "I"  (__IMM8),				\
> >>+				 "i"  (&(_sym))				\
> >>+			: "cc")
> >>+
> >>+/*
> >>+ * patch_imm8_mov() - same as patch_imm8(), but for mov/mvn instructions
> >>+ */
> >>+#define patch_imm8_mov(_insn, _to, _sym, _ofs)				\
> >>+	patch_stub(							\
> >>+		/* type */						\
> >>+			PATCH_IMM8,					\
> >>+		/* code */						\
> >>+			_insn "	%[to], %[imm]\n",			\
> >>+		/* patch_data */					\
> >>+			".long " __stringify(_sym + _ofs) "\n"		\
> >>+			_insn "	%[to], %[imm]\n",			\
> >>+		/* operands */						\
> >>+			: [to]	"=r" (_to)				\
> >>+			: [imm]	"I"  (__IMM8),				\
> >>+				"i"  (&(_sym))				\
> >>+			: "cc")
> >>+
> >>+/*
> >>+ * early_patch_imm8() - early functional variant of patch_imm8() above.  The
> >>+ *			same restrictions on the constant apply here.  This
> >>+ *			version emits workable (albeit inefficient) code at
> >>+ *			compile-time, and therefore functions even prior to
> >>+ *			patch application.
> >>+ */
> >>+#define early_patch_imm8(_insn, _to, _from, _sym, _ofs)			\
> >>+do {									\
> >>+	unsigned long __tmp;						\
> >>+	early_patch_stub(						\
> >>+		/* type */						\
> >>+			PATCH_IMM8,					\
> >>+		/* code */						\
> >>+			"ldr	%[tmp], =" __stringify(_sym + _ofs) "\n"\
> >
> >This would not be OK if assembled into the .text section, for the reasons
> >described above.  (The compiler doesn't know about the extra data word
> >injected by the ldr= pseudo-instruction.)
> >
> >early_patch_stub puts <code> into a custom section, so that's OK.
> >
> >However, there's still nothing to ensure that the literal word is in
> >range of the load.  That can be fixed with an .ltorg to dump out the
> >literal(s) right after the branch following <code> in early_patch_stub.
> >
> >>+			"ldr	%[tmp], [%[tmp]]\n"			\
> >>+			_insn "	%[to], %[from], %[tmp]\n",		\
> >>+		/* pad */						\
> >>+			0,						\
> >>+		/* patch_data */					\
> >>+			".long " __stringify(_sym + _ofs) "\n"		\
> >>+			_insn "	%[to], %[from], %[imm]\n",		\
> >>+		/* operands */						\
> >>+			: [to]	 "=r"  (_to),				\
> >>+			  [tmp]	 "=&r" (__tmp)				\
> >>+			: [from] "r"   (_from),				\
> >>+			  [imm]	 "I"   (__IMM8),			\
> >>+				 "i"   (&(_sym))			\
> >>+			: "cc");					\
> >
> >Should we have "cc" here?
> >
> >Since this macro is only used with a single instruction _insn, there
> >would be no way to make use of a condition set by that instruction.
> >
> >Therefore, flag-setting instructions don't really make any sense here,
> >and "cc" could be removed.
> >
> >If so, it could make sense for the apply_patch_imm8() implementation
> >to check for and reject flag-setting encodings.
> >
> 
> That makes sense.  I've modified the do_patch_imm8() functions to
> explicitly check for attempts to set condition codes, and removed
> the "cc".

OK, cool.

> 
> [...]
> >>diff --git a/arch/arm/kernel/runtime-patch.c b/arch/arm/kernel/runtime-patch.c
> >>new file mode 100644
> >>index 0000000..28a6367
> >>--- /dev/null
> >>+++ b/arch/arm/kernel/runtime-patch.c
> [...]
> >>+static inline void flush_icache_insn(void *insn_ptr, int bytes)
> >>+{
> >>+	unsigned long insn_addr = (unsigned long)insn_ptr;
> >>+	flush_icache_range(insn_addr, insn_addr + bytes - 1);
> >>+}
> >
> >This function appears unused.
> >
> 
> Indeed.  This function should have been removed.  Thanks.
> 
> >Do we actually do the cache flushing anywhere?
> >
> 
> Yes, in __patch_text().

OK, fine.

> 
> [...]
> >>+static int do_patch_imm8(u32 insn, u32 imm, u32 *ninsn)
> >>+{
> [...]
> >>+	*ninsn  = insn & ~(BIT(26) | 0x7 << 12 | 0xff);
> >>+	*ninsn |= (rot >> 3) << 26;	/* field "i" */
> >>+	*ninsn |= (rot & 0x7) << 12;	/* field "imm3" */
> >>+	*ninsn |= val;
> >
> >You need to convert this back to memory order.  If fixups might be
> >applied while the MMU is off, misaligned 32-bit accesses will fail.
> >It's better to store the two halfwords separately:
> >
> >	__opcode_to_mem_thumb16(__opcode_thumb32_first(foo))
> >	__opcode_to_mem_thumb16(__opcode_thumb32_second(foo))
> >
> >If the MMU is on, you can use __opcode_to_mem_thumb32(foo) and do
> >a possibly misaligned store, though.
> >
> >This may be a good idea even if the MMU is on, because fixup is a
> >once-only process and we don't expect a meaningful performance
> >impact from that, especially when caching is enabled.  But splitting
> >the access may also make it easier to reuse the framework in
> >situations where the cache and MMU are off.
> >
> >Because of all this, I suggest you don't repeatedly modify *ninsn.
> >Preparing the value and then writing it (or each half) once is probably
> >cleaner.
> >
> [...]
> >>+static int do_patch_imm8(u32 insn, u32 imm, u32 *ninsn)
> [...]
> >>+	/* patch in new immediate and rotation */
> >>+	*ninsn = (insn & ~0xfff) | (rot << 8) | val;
> >
> >You need __opcode_to_mem_arm() to convert this back to memory order.
> >
> 
> The do_patch_imm8() functions do not write to the instruction.  The
> ninsn pointer here is not a pointer to the instruction that is being
> patched, it is simply a pointer used to return a value to the caller
> (apply_patch_imm8()).
> 
> The instruction is written in apply_patch_imm8():
> 
> 	u32 ninsn;
> 	...
> 	err = do_patch_imm8(info->insn, *info->imm, &ninsn);
> 	if (err)
> 		return err;
> 	__patch_text(insn_ptr, ninsn);
> 
> Here the __patch_text() call converts the instruction and performs
> the actual write.  If I read this correctly, the __patch_text() code
> takes care of the splitting up thumb2 instructions as you've
> indicated.

OK, I think you're right.  I had vague memories about __patch_text(),
but I missed its use here (I was too busy searching for "flush"...)

This makes the do_patch_imm8() functions a bit weird though, because
they accept input in memory order but generate output in canonical
order.

That could be avoided by having an #ifdef in apply_patch_imm8() to
choose the correct conversion for the input, but that would be a bit
ugly.  Maybe just add a comment somewhere to clarify the different in
byte order, and the reason for it: this would make the code easier to
understand.

> 
> [...]
> >>+int runtime_patch(const void *table, unsigned size)
> >
> >Minor nits: the type-unsafety could be dealt with outside this function;
> >table could be struct patch_info const *.
> >
> >Also, why do we not just pass end to this function instead of subtracting
> >the table base and then adding it back again?
> >
> 
> In addition to the internal usage within runtime-patch.c, this
> function is called from module.c.  In the module load case, the base
> + size form is more convenient.
> 
> Second, based on Nico's comments about keeping the namespace clean,
> I've now moved the structure definitions to runtime-patch.c.  These
> types are no longer exposed, and so we have to keep them opaque in
> this interface.

OK, fair enough.  Those were very minor nits anyway.

[...]

Cheers
---Dave
