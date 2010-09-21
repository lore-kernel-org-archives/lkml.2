Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab0IUSk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 14:40:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27176 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab0IUSk6 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 21 Sep 2010 14:40:58 -0400
Date: Tue, 21 Sep 2010 14:39:43 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com
Subject: Re: [PATCH 10/10] jump label v11: add docs
Message-ID: <20100921183943.GC22088@dumpdata.com>
References: <cover.1284733808.git.jbaron@redhat.com>
 <f75207ca500d2be85ec049624bc70b01c0183db2.1284733808.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f75207ca500d2be85ec049624bc70b01c0183db2.1284733808.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 11:09:29AM -0400, Jason Baron wrote:
> Add jump label docs as: Documentation/jump-label.txt
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  Documentation/jump-label.txt |  148 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 148 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/jump-label.txt
> 
> diff --git a/Documentation/jump-label.txt b/Documentation/jump-label.txt
> new file mode 100644
> index 0000000..2e5cff6
> --- /dev/null
> +++ b/Documentation/jump-label.txt
> @@ -0,0 +1,148 @@
> +			Jump Label
> +			----------
> +
> +By: Jason Baron <jbaron@redhat.com>
> +
> +
> +1) motivation
> +
> +
> +Currently, tracepoints are implemented using a conditional. The conditional
> +check requires checking a global variable for each tracepoint. Although,
> +the overhead of this check is small, it increases under memory pressure. As we
> +increase the number of tracepoints in the kernel this may become more of an
> +issue. In addition, tracepoints are often dormant (disabled), and provide no
> +direct kernel functionality. Thus, it is highly desirable to reduce their
> +impact as much as possible. Although tracepoints are the original motivation
> +for this work, other kernel code paths should be able to make use of the jump
> +label optimization.
> +
> +
> +2) jump label description/usage
> +
> +
> +gcc (v4.5) adds a new 'asm goto' statement that allows branching to a label.
> +http://gcc.gnu.org/ml/gcc-patches/2009-07/msg01556.html
> +
> +Thus, this patch set introduces an architecture specific 'JUMP_LABEL()' macro as
> +follows (x86):
> +
> +# define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
> +
> +# define JUMP_LABEL(key, label)					\
> +	do {                                                    \
> +		asm goto("1:"                                   \
> +			JUMP_LABEL_INITIAL_NOP			\
> +                        ".pushsection __jump_table,  \"a\" \n\t"\
> +                        _ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
> +                        ".popsection \n\t"                      \
> +                        : :  "i" (key) :  : label);		\
> +        } while (0)
> +
> +
> +For architectures that have not yet introduced jump label support its simply:
> +
> +#define JUMP_LABEL(key, label)			\
> +	if (unlikely(*key))			\
> +		goto label;
> +
> +which then can be used as:
> +
> +	....
> +        JUMP_LABEL(trace_name, trace_label, jump_enabled);

No. That is three arguments. The macro only has two.

> +        printk("not doing tracing\n");
> +	return;
> +trace_label:
> +        printk("doing tracing: %d\n", file);
> +	....
> +
> +The 'key' argument is thus a pointer to a conditional argument that can be used
> +if the optimization is not enabled. Otherwise, this address serves as a unique
> +key to identify the particular instance of the jump label.
> +
> +Thus, when tracing is disabled, we simply have a no-op followed by a jump around
> +the dormant (disabled) tracing code. The 'JUMP_LABEL()' macro, produces a
> +'jump_table' which has the following format:
> +
> +[instruction address] [jump target] [tracepoint key]
> +
> +Thus, to enable a tracepoint, we simply patch the 'instruction address' with
> +a jump to the 'jump target'.
> +
> +The call to enable a jump label is: enable_jump_label(key); to disable:
> +disable_jump_label(key);
> +
> +
> +3) architecture interface
> +
> +
> +There are a few functions and macros which arches must implement in order to
> +take advantage of this optimization. As previously mentioned, if there is no
> +architecture support we simply fall back to a traditional, load, test, and
> +jump sequence.
> +
> +* add "HAVE_ARCH_JUMP_LABEL" to arch/<arch>/Kconfig to indicate support
> +
> +* #define JUMP_LABEL_NOP_SIZE, arch/x86/include/asm/jump_label.h
> +
> +* #define "JUMP_LABEL(key, label)", arch/x86/include/asm/jump_label.h
> +
> +* void arch_jump_label_transform(struct jump_entry *entry, enum jump_label_type type)
> +	see: arch/x86/kernel/jump_label.c
> +
> +* void arch_jump_label_text_poke_early(jump_label_t addr)
> +	see: arch/x86/kernel/jump_label.c
> +
> +* finally add a definition for "struct jump_entry".
> +	see: arch/x86/include/asm/jump_label.h
> +
> +
> +4) Jump label analysis (x86)
> +
> +
> +I've tested the performance of using 'get_cycles()' calls around the
> +tracepoint call sites. For an Intel Core 2 Quad cpu (in cycles, averages):
> +
> +		idle		after tbench run
> +		----		----------------
> +old code	 32		  88
> +new code	  2		   4
> +
> +
> +The performance improvement can be reproduced reliably on both Intel and AMD
> +hardware.
> +
> +In terms of code analysis the current code for the disabled case is a 'cmpl'
> +followed by a 'je' around the tracepoint code. so:
> +
> +cmpl - 83 3d 0e 77 87 00 00 - 7 bytes
> +je   - 74 3e                - 2 bytes
> +
> +total of 9 instruction bytes.
> +
> +The new code is a 'nopl' followed by a 'jmp'. Thus:
> +
> +nopl - 0f 1f 44 00 00 - 5 bytes
> +jmp  - eb 3e          - 2 bytes

Uh, not e9?
> +
> +total of 7 instruction bytes.
> +
> +So, the new code also accounts for 2 less bytes in the instruction cache per tracepoint.
> +
> +The optimization depends on !CC_OPTIMIZE_FOR_SIZE. When CC_OPTIMIZE_FOR_SIZE is
> +set, gcc does not always out of line the not taken label path in the same way
> +that the "if unlikely()" paths are made out of line. Thus, with
> +CC_OPTIMIZE_FOR_SIZE set, this optimization is not always optimal. This may be
> +solved in subsequent gcc versions, that allow us to move labels out of line,
> +while still optimizing for size.
> +
> +
> +5) Acknowledgments
> +
> +
> +Thanks to Roland McGrath and Richard Henderson for helping come up with the
> +initial 'asm goto' and jump label design.
> +
> +Thanks to Mathieu Desnoyers and H. Peter Anvin for calling attention to this
> +issue, and outlining the requirements of a solution. Mathieu also implemened a
> +solution in the form of the "Immediate Values" work.
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
