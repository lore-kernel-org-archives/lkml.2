Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab0JOUMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:12:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60512 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab0JOUKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:10:38 -0400
X-Authority-Analysis: v=1.1 cv=iGF3DqghDyT/uy4mV2LvOKNXCATMSjL+tOl9cucoGVk= c=1 sm=0 a=zjs7BP8tTp0A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=mDV3o1hIAAAA:8 a=TMR5fcOTuICeo4l-83IA:9 a=vnpNu2tBCt_FiCwXCtIA:7 a=NNbQlZqvnG5fDZPwaNUK0jKf1qIA:4 a=GBvSOdkZNRUA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=URDtTcrx2Xm3WucL:21 a=i0HIfgW0vDbvz6L0:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101015201037.417454899@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 15 Oct 2010 16:09:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 7/9] jump label: Add docs
References: <20101015200949.134732894@goodmis.org>
Content-Disposition: inline; filename=0007-jump-label-Add-docs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Add jump label docs as: Documentation/jump-label.txt

Also, fix documentation spelling error in jump_label.c

Signed-off-by: Jason Baron <jbaron@redhat.com>
LKML-Reference: <9a71c059f86d432ea468728281a8e570556c8a38.1285965957.git.jbaron@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/jump-label.txt |  142 ++++++++++++++++++++++++++++++++++++++++++
 kernel/jump_label.c          |    2 +-
 2 files changed, 143 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/jump-label.txt

diff --git a/Documentation/jump-label.txt b/Documentation/jump-label.txt
new file mode 100644
index 0000000..d26df30
--- /dev/null
+++ b/Documentation/jump-label.txt
@@ -0,0 +1,142 @@
+			Jump Label
+			----------
+
+By: Jason Baron <jbaron@redhat.com>
+
+
+1) Motivation
+
+
+Currently, tracepoints are implemented using a conditional. The conditional
+check requires checking a global variable for each tracepoint. Although
+the overhead of this check is small, it increases when the memory cache comes
+under pressure (memory cache lines for these global variables may be shared
+with other memory accesses). As we increase the number of tracepoints in the
+kernel this overhead may become more of an issue. In addition, tracepoints are
+often dormant (disabled) and provide no direct kernel functionality. Thus, it
+is highly desirable to reduce their impact as much as possible. Although
+tracepoints are the original motivation for this work, other kernel code paths
+should be able to make use of the jump label optimization.
+
+
+2) Jump label description/usage
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
+For architectures that have not yet introduced jump label support it's simply:
+
+#define JUMP_LABEL(key, label)			\
+	if (unlikely(*key))			\
+		goto label;
+
+which then can be used as:
+
+	....
+        JUMP_LABEL(key, trace_label);
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
+the dormant (disabled) tracing code. The 'JUMP_LABEL()' macro produces a
+'jump_table', which has the following format:
+
+[instruction address] [jump target] [key]
+
+Thus, to enable a tracepoint, we simply patch the 'instruction address' with
+a jump to the 'jump target.'
+
+The calls to enable and disable a jump label are: enable_jump_label(key) and
+disable_jump_label(key).
+
+
+3) Architecture interface
+
+
+There are a few functions and macros that architectures must implement in order
+to take advantage of this optimization. As previously mentioned, if there is no
+architecture support, we simply fall back to a traditional, load, test, and
+jump sequence.
+
+* add "HAVE_ARCH_JUMP_LABEL" to arch/<arch>/Kconfig to indicate support
+
+* #define JUMP_LABEL_NOP_SIZE, arch/x86/include/asm/jump_label.h
+
+* #define "JUMP_LABEL(key, label)", arch/x86/include/asm/jump_label.h
+
+* void arch_jump_label_transform(struct jump_entry *entry, enum jump_label_type type)
+	see: arch/x86/kernel/jump_label.c
+
+* void arch_jump_label_text_poke_early(jump_label_t addr)
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
+In terms of code analysis, the current code for the disabled case is a 'cmpl'
+followed by a 'je' around the tracepoint code. So:
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
+
+5) Acknowledgements
+
+
+Thanks to Roland McGrath and Richard Henderson for helping come up with the
+initial 'asm goto' and jump label design.
+
+Thanks to Mathieu Desnoyers and H. Peter Anvin for calling attention to this
+issue, and outlining the requirements of a solution. Mathieu also implemented a
+solution in the form of the "Immediate Values" work.
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index b30ef81..ebae902 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -193,7 +193,7 @@ void jump_label_update(unsigned long key, enum jump_label_type type)
 			arch_jump_label_transform(iter, type);
 		iter++;
 	}
-	/* eanble/disable jump labels in modules */
+	/* enable/disable jump labels in modules */
 	hlist_for_each_entry(e_module, module_node, &(entry->modules),
 						hlist) {
 		count = e_module->nr_entries;
-- 
1.7.1


