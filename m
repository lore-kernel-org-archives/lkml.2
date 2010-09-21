Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754Ab0IUQVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:21:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab0IUQVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:21:12 -0400
Date: Tue, 21 Sep 2010 12:20:13 -0400
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, mhiramat@redhat.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com, mfm@muteddisk.com
Subject: Re: [PATCH 10/10] jump label v11: add docs
Message-ID: <20100921162013.GD2873@redhat.com>
References: <cover.1284733808.git.jbaron@redhat.com> <f75207ca500d2be85ec049624bc70b01c0183db2.1284733808.git.jbaron@redhat.com> <20100917160520.GA23262@Krystal> <1285021680.23122.706.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285021680.23122.706.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 06:28:00PM -0400, Steven Rostedt wrote:
> On Fri, 2010-09-17 at 12:05 -0400, Mathieu Desnoyers wrote:
> > * Jason Baron (jbaron@redhat.com) wrote:
> > > Add jump label docs as: Documentation/jump-label.txt
> > > 
> > > Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> Jason,
> 
> Could you post this patch again with any updates you want to take from
> Mathieu. No need to post the entire series, I'm pulling in the rest.
> Just this patch.
> 
> Thanks,
> 
> -- Steve
> 

Hi Steve,

here's a re-post of the documentation patch. I've incorporated Mathieu's
as well as Matt's feedback. Note that I've dropped the
'!CC_OPTIMIZE_FOR_SIZE' optimize for size paragraph.

thanks,

-Jason


Add jump label docs as: Documentation/jump-label.txt

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 Documentation/jump-label.txt |  142 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 142 insertions(+), 0 deletions(-)
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
-- 
1.7.1

