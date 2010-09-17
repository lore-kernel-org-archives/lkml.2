Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab0IQQFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 12:05:25 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:52262 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854Ab0IQQFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 12:05:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAE8uk0xGGN6i/2dsb2JhbACiI3LDJYJwglAEhQI
Date: Fri, 17 Sep 2010 12:05:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
        tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Subject: Re: [PATCH 10/10] jump label v11: add docs
Message-ID: <20100917160520.GA23262@Krystal>
References: <cover.1284733808.git.jbaron@redhat.com> <f75207ca500d2be85ec049624bc70b01c0183db2.1284733808.git.jbaron@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <f75207ca500d2be85ec049624bc70b01c0183db2.1284733808.git.jbaron@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:56:55 up 163 days,  1:47,  2 users,  load average: 0.24, 0.39,
	0.22
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
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

You might want to start your titles with capital letters (small nit).

> +
> +
> +Currently, tracepoints are implemented using a conditional. The conditional
> +check requires checking a global variable for each tracepoint. Although,
> +the overhead of this check is small, it increases under memory pressure. As we

I wonder if it would be worthwhile to spell out the difference between
"memory pressure" in terms of memory bandwidth (which is what we care
about here) and in terms of "memory space available". I just don't want
people to get mixed up between the two when they read this text. What we
care a lot about here is just memory bandwidth, which is impacted by
cache pressure.

> +increase the number of tracepoints in the kernel this may become more of an
> +issue. In addition, tracepoints are often dormant (disabled), and provide no
> +direct kernel functionality. Thus, it is highly desirable to reduce their
> +impact as much as possible. Although tracepoints are the original motivation
> +for this work, other kernel code paths should be able to make use of the jump
> +label optimization.
> +
> +
> +2) jump label description/usage

Start with capital letter here too.

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

cap.

> +
> +
> +There are a few functions and macros which arches must implement in order to

arches -> architectures

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

Acknowledgements (seems to be the usual way to spell it in
Documentation/).

> +
> +
> +Thanks to Roland McGrath and Richard Henderson for helping come up with the
> +initial 'asm goto' and jump label design.
> +
> +Thanks to Mathieu Desnoyers and H. Peter Anvin for calling attention to this
> +issue, and outlining the requirements of a solution. Mathieu also implemened a

implemened -> implemented

Thanks!

Mathieu

> +solution in the form of the "Immediate Values" work.
> -- 
> 1.7.1
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
