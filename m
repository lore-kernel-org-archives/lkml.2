Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab0FBHty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:49:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753403Ab0FBHtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:49:52 -0400
Date: Wed, 2 Jun 2010 00:45:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Brandon Philips <brandon@ifup.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module
 libcrc32c"
In-Reply-To: <201006021605.38817.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.1006020022000.8175@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <alpine.LFD.2.00.1006012039570.8175@i5.linux-foundation.org> <alpine.LFD.2.00.1006012137390.8175@i5.linux-foundation.org> <201006021605.38817.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jun 2010, Rusty Russell wrote:
> 
> Agreed.  Feel free to take a stab at it if you're bored.  Last I tried,
> there wasn't an obvious split point which actually reduced the size of the
> function.

I'd start from the trivial stuff. There's a fair amount of straight-line 
code that just makes the function hard to read just because you have to 
page up and down so far. Some of it is trivial to just create a helper 
function for. 

IOW, things like this.. Pure code movement to peel off some stuff.

No, this patch on its own doesn't really make anything easier to read, but 
a handful of these kinds of things might bring down what is currently an 
almost 500-line function (yeah, really) to the point where it could 
potentially be just fifty lines (most of which is just calling helper 
functions, and checking an error case).

At that point, it should be possible to see it in one (biggish) window, 
which would make it a _lot_ easier to follow the cleanup cases.

Does this make the function smaller in any _absolute_ sense? No. The patch 
has 6 added lines, because the whole function declaration, braces, empty 
lines, call site. And the code is obviously not going to be smaller. It 
would just be a bit more easy to get an overview of.

Worth it? I dunno. But currently that 'load_module()' thing does end up 
being the function from hell. Trying to figure out the nesting of the 
error cases was a matter of paging up-and-down and trying to remember what 
particular 'goto' target I was looking for. It _should_ be possible to do 
better.

		Linus

---
 kernel/module.c |  124 +++++++++++++++++++++++++++++--------------------------
 1 files changed, 65 insertions(+), 59 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index d4a55f1..165d97e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2106,6 +2106,70 @@ static inline void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
 }
 #endif
 
+static void find_module_sections(struct module *mod, Elf_Ehdr *hdr, Elf_Shdr *sechdrs, char *secstrings)
+{
+	mod->kp = section_objs(hdr, sechdrs, secstrings, "__param",
+			       sizeof(*mod->kp), &mod->num_kp);
+	mod->syms = section_objs(hdr, sechdrs, secstrings, "__ksymtab",
+				 sizeof(*mod->syms), &mod->num_syms);
+	mod->crcs = section_addr(hdr, sechdrs, secstrings, "__kcrctab");
+	mod->gpl_syms = section_objs(hdr, sechdrs, secstrings, "__ksymtab_gpl",
+				     sizeof(*mod->gpl_syms),
+				     &mod->num_gpl_syms);
+	mod->gpl_crcs = section_addr(hdr, sechdrs, secstrings, "__kcrctab_gpl");
+	mod->gpl_future_syms = section_objs(hdr, sechdrs, secstrings,
+					    "__ksymtab_gpl_future",
+					    sizeof(*mod->gpl_future_syms),
+					    &mod->num_gpl_future_syms);
+	mod->gpl_future_crcs = section_addr(hdr, sechdrs, secstrings,
+					    "__kcrctab_gpl_future");
+
+#ifdef CONFIG_UNUSED_SYMBOLS
+	mod->unused_syms = section_objs(hdr, sechdrs, secstrings,
+					"__ksymtab_unused",
+					sizeof(*mod->unused_syms),
+					&mod->num_unused_syms);
+	mod->unused_crcs = section_addr(hdr, sechdrs, secstrings,
+					"__kcrctab_unused");
+	mod->unused_gpl_syms = section_objs(hdr, sechdrs, secstrings,
+					    "__ksymtab_unused_gpl",
+					    sizeof(*mod->unused_gpl_syms),
+					    &mod->num_unused_gpl_syms);
+	mod->unused_gpl_crcs = section_addr(hdr, sechdrs, secstrings,
+					    "__kcrctab_unused_gpl");
+#endif
+#ifdef CONFIG_CONSTRUCTORS
+	mod->ctors = section_objs(hdr, sechdrs, secstrings, ".ctors",
+				  sizeof(*mod->ctors), &mod->num_ctors);
+#endif
+
+#ifdef CONFIG_TRACEPOINTS
+	mod->tracepoints = section_objs(hdr, sechdrs, secstrings,
+					"__tracepoints",
+					sizeof(*mod->tracepoints),
+					&mod->num_tracepoints);
+#endif
+#ifdef CONFIG_EVENT_TRACING
+	mod->trace_events = section_objs(hdr, sechdrs, secstrings,
+					 "_ftrace_events",
+					 sizeof(*mod->trace_events),
+					 &mod->num_trace_events);
+	/*
+	 * This section contains pointers to allocated objects in the trace
+	 * code and not scanning it leads to false positives.
+	 */
+	kmemleak_scan_area(mod->trace_events, sizeof(*mod->trace_events) *
+			   mod->num_trace_events, GFP_KERNEL);
+#endif
+#ifdef CONFIG_FTRACE_MCOUNT_RECORD
+	/* sechdrs[0].sh_size is always zero */
+	mod->ftrace_callsites = section_objs(hdr, sechdrs, secstrings,
+					     "__mcount_loc",
+					     sizeof(*mod->ftrace_callsites),
+					     &mod->num_ftrace_callsites);
+#endif
+}
+
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static noinline struct module *load_module(void __user *umod,
@@ -2365,66 +2429,8 @@ static noinline struct module *load_module(void __user *umod,
 
 	/* Now we've got everything in the final locations, we can
 	 * find optional sections. */
-	mod->kp = section_objs(hdr, sechdrs, secstrings, "__param",
-			       sizeof(*mod->kp), &mod->num_kp);
-	mod->syms = section_objs(hdr, sechdrs, secstrings, "__ksymtab",
-				 sizeof(*mod->syms), &mod->num_syms);
-	mod->crcs = section_addr(hdr, sechdrs, secstrings, "__kcrctab");
-	mod->gpl_syms = section_objs(hdr, sechdrs, secstrings, "__ksymtab_gpl",
-				     sizeof(*mod->gpl_syms),
-				     &mod->num_gpl_syms);
-	mod->gpl_crcs = section_addr(hdr, sechdrs, secstrings, "__kcrctab_gpl");
-	mod->gpl_future_syms = section_objs(hdr, sechdrs, secstrings,
-					    "__ksymtab_gpl_future",
-					    sizeof(*mod->gpl_future_syms),
-					    &mod->num_gpl_future_syms);
-	mod->gpl_future_crcs = section_addr(hdr, sechdrs, secstrings,
-					    "__kcrctab_gpl_future");
+	find_module_sections(mod, hdr, sechdrs, secstrings);
 
-#ifdef CONFIG_UNUSED_SYMBOLS
-	mod->unused_syms = section_objs(hdr, sechdrs, secstrings,
-					"__ksymtab_unused",
-					sizeof(*mod->unused_syms),
-					&mod->num_unused_syms);
-	mod->unused_crcs = section_addr(hdr, sechdrs, secstrings,
-					"__kcrctab_unused");
-	mod->unused_gpl_syms = section_objs(hdr, sechdrs, secstrings,
-					    "__ksymtab_unused_gpl",
-					    sizeof(*mod->unused_gpl_syms),
-					    &mod->num_unused_gpl_syms);
-	mod->unused_gpl_crcs = section_addr(hdr, sechdrs, secstrings,
-					    "__kcrctab_unused_gpl");
-#endif
-#ifdef CONFIG_CONSTRUCTORS
-	mod->ctors = section_objs(hdr, sechdrs, secstrings, ".ctors",
-				  sizeof(*mod->ctors), &mod->num_ctors);
-#endif
-
-#ifdef CONFIG_TRACEPOINTS
-	mod->tracepoints = section_objs(hdr, sechdrs, secstrings,
-					"__tracepoints",
-					sizeof(*mod->tracepoints),
-					&mod->num_tracepoints);
-#endif
-#ifdef CONFIG_EVENT_TRACING
-	mod->trace_events = section_objs(hdr, sechdrs, secstrings,
-					 "_ftrace_events",
-					 sizeof(*mod->trace_events),
-					 &mod->num_trace_events);
-	/*
-	 * This section contains pointers to allocated objects in the trace
-	 * code and not scanning it leads to false positives.
-	 */
-	kmemleak_scan_area(mod->trace_events, sizeof(*mod->trace_events) *
-			   mod->num_trace_events, GFP_KERNEL);
-#endif
-#ifdef CONFIG_FTRACE_MCOUNT_RECORD
-	/* sechdrs[0].sh_size is always zero */
-	mod->ftrace_callsites = section_objs(hdr, sechdrs, secstrings,
-					     "__mcount_loc",
-					     sizeof(*mod->ftrace_callsites),
-					     &mod->num_ftrace_callsites);
-#endif
 #ifdef CONFIG_MODVERSIONS
 	if ((mod->num_syms && !mod->crcs)
 	    || (mod->num_gpl_syms && !mod->gpl_crcs)
