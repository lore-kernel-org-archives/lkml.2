Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487Ab0FIVk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 17:40:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932599Ab0FIVkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 17:40:25 -0400
Date: Wed, 9 Jun 2010 17:39:45 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com, sam@ravnborg.org
Message-Id: <382f7818b6a8e63ff971743ee0c4820b364c7f2f.1276116186.git.jbaron@redhat.com>
In-Reply-To: <cover.1276116186.git.jbaron@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
Subject: [PATCH 13/13] jump label v9: add docs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add jump label docs as: Documentation/jump-label.txt

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 Documentation/jump-label.txt |  151 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 151 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/jump-label.txt

diff --git a/Documentation/jump-label.txt b/Documentation/jump-label.txt
new file mode 100644
index 0000000..843da59
--- /dev/null
+++ b/Documentation/jump-label.txt
@@ -0,0 +1,151 @@
+			Jump Label
+			----------
+
+By: Jason Baron <jbaron@redhat.com>
+
+
+1) motivation
+
+
+Currently, tracepoints are implemented using a conditional. The conditional
+check requires checking a global variable for each tracepoint. Although,
+the overhead of this check is small, it increases under memory pressure. As we
+increase the number of tracepoints in the kernel this may become more of an
+issue. In addition, tracepoints are often dormant (disabled), and provide no
+direct kernel functionality. Thus, it is highly desirable to reduce their
+impact as much as possible. Although tracepoints are the original motivation
+for this work, other kernel code paths should be able to make use of the jump
+label optimization.
+
+
+2) jump label description/usage
+
+
+gcc (v4.5) adds a new 'asm goto' statement that allows branching to a label.
+http://gcc.gnu.org/ml/gcc-patches/2009-07/msg01556.html
+
+Thus, this patch set introduces an architecture specific 'JUMP_LABEL()' macro as
+follows (x86):
+
+# define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
+
+# define JUMP_LABEL(key, label)					\
+	do {                                                    \
+		asm goto("1:"                                   \
+			JUMP_LABEL_INITIAL_NOP			\
+                        ".pushsection __jump_table,  \"a\" \n\t"\
+                        _ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
+                        ".popsection \n\t"                      \
+                        : :  "i" (key) :  : label);		\
+        } while (0)
+
+
+For architectures that have not yet introduced jump label support its simply:
+
+#define JUMP_LABEL(key, label)			\
+	if (unlikely(*key))			\
+		goto label;
+
+which then can be used as:
+
+	....
+        JUMP_LABEL(trace_name, trace_label, jump_enabled);
+        printk("not doing tracing\n");
+	return;
+trace_label:
+        printk("doing tracing: %d\n", file);
+	....
+
+The 'key' argument is thus a pointer to a conditional argument that can be used
+if the optimization is not enabled. Otherwise, this address serves as a unique
+key to identify the particular instance of the jump label.
+
+Thus, when tracing is disabled, we simply have a no-op followed by a jump around
+the dormant (disabled) tracing code. The 'JUMP_LABEL()' macro, produces a
+'jump_table' which has the following format:
+
+[instruction address] [jump target] [tracepoint key]
+
+Thus, to enable a tracepoint, we simply patch the 'instruction address' with
+a jump to the 'jump target'.
+
+The call to enable a jump label is: enable_jump_label(key); to disable:
+disable_jump_label(key);
+
+
+3) architecture interface
+
+
+There are a few functions and macros which arches must implement in order to
+take advantage of this optimization. As previously mentioned, if there is no
+architecture support we simply fall back to a traditional, load, test, and
+jump sequence.
+
+* add "HAVE_ARCH_JUMP_LABEL" to arch/<arch>/Kconfig to indicate support
+
+* #define JUMP_LABEL_NOP_SIZE, arch/x86/include/asm/jump_label.h
+
+* #define "JUMP_LABEL(tag, label, cond)", arch/x86/include/asm/jump_label.h
+
+* add: void arch_jump_label_transform(struct jump_entry *entry, enum jump_label_type type)
+				and
+       const u8 *arch_get_jump_label_nop(void)
+
+	see: arch/x86/kernel/jump_label.c
+
+* finally add a definition for "struct jump_entry".
+	see: arch/x86/include/asm/jump_label.h
+
+
+4) Jump label analysis (x86)
+
+
+I've tested the performance of using 'get_cycles()' calls around the
+tracepoint call sites. For an Intel Core 2 Quad cpu (in cycles, averages):
+
+		idle		after tbench run
+		----		----------------
+old code	 32		  88
+new code	  2		   4
+
+
+The performance improvement can be reproduced reliably on both Intel and AMD
+hardware.
+
+In terms of code analysis the current code for the disabled case is a 'cmpl'
+followed by a 'je' around the tracepoint code. so:
+
+cmpl - 83 3d 0e 77 87 00 00 - 7 bytes
+je   - 74 3e                - 2 bytes
+
+total of 9 instruction bytes.
+
+The new code is a 'nopl' followed by a 'jmp'. Thus:
+
+nopl - 0f 1f 44 00 00 - 5 bytes
+jmp  - eb 3e          - 2 bytes
+
+total of 7 instruction bytes.
+
+So, the new code also accounts for 2 less bytes in the instruction cache per tracepoint.
+
+The optimization depends on !CC_OPTIMIZE_FOR_SIZE. When CC_OPTIMIZE_FOR_SIZE is
+set, gcc does not always out of line the not taken label path in the same way
+that the "if unlikely()" paths are made out of line. Thus, with
+CC_OPTIMIZE_FOR_SIZE set, this optimization is not always optimal. This may be
+solved in subsequent gcc versions, that allow us to move labels out of line,
+while still optimizing for size. In the case of !CC_OPTIMIZE_FOR_SIZE this
+optimization is seen on high level benchmarks such as tbench where I can get
+~1-2% higher throughput. In addition we are within .5% of the performance of no
+tracepoints compiled in at all.
+
+
+5) Acknowledgments
+
+
+Thanks to Roland McGrath and Richard Henderson for helping come up with the
+initial 'asm goto' and jump label design.
+
+Thanks to Mathieu Desnoyers and H. Peter Anvin for calling attention to this
+issue, and outlining the requirements of a solution. Mathieu also implemened a
+solution in the form of the "Immediate Values" work.
-- 
1.7.1

