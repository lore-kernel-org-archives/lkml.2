Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab1BUN5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 08:57:49 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:39576 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab1BUN5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 08:57:48 -0500
Subject: [PATCH] module: remove 64 bit alignment padding from struct module
 with CONFIG_TRACE*
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Feb 2011 13:57:41 +0000
Message-ID: <1298296661.2084.6.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder struct module to remove 24 bytes of alignment padding on 64 bit
builds when the CONFIG_TRACE options are selected. This allows the
structure to fit into one fewer cache lines, and its size drops from 592
to 568 on x86_64.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

----
patch against v2.6.38-rc4
compiled and tested on x86_64

This change doesn't help in all combinations of selected CONFIGs but
will reduce the maximum size when all of them are set.

regards
Richard


diff --git a/include/linux/module.h b/include/linux/module.h
index 9bdf27c..738d22e 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -367,34 +367,35 @@ struct module
 	struct module_notes_attrs *notes_attrs;
 #endif
 
+	/* The command line arguments (may be mangled).  People like
+	   keeping pointers to this stuff */
+	char *args;
+
 #ifdef CONFIG_SMP
 	/* Per-cpu data. */
 	void __percpu *percpu;
 	unsigned int percpu_size;
 #endif
 
-	/* The command line arguments (may be mangled).  People like
-	   keeping pointers to this stuff */
-	char *args;
 #ifdef CONFIG_TRACEPOINTS
-	struct tracepoint * const *tracepoints_ptrs;
 	unsigned int num_tracepoints;
+	struct tracepoint * const *tracepoints_ptrs;
 #endif
 #ifdef HAVE_JUMP_LABEL
 	struct jump_entry *jump_entries;
 	unsigned int num_jump_entries;
 #endif
 #ifdef CONFIG_TRACING
-	const char **trace_bprintk_fmt_start;
 	unsigned int num_trace_bprintk_fmt;
+	const char **trace_bprintk_fmt_start;
 #endif
 #ifdef CONFIG_EVENT_TRACING
 	struct ftrace_event_call **trace_events;
 	unsigned int num_trace_events;
 #endif
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
-	unsigned long *ftrace_callsites;
 	unsigned int num_ftrace_callsites;
+	unsigned long *ftrace_callsites;
 #endif
 
 #ifdef CONFIG_MODULE_UNLOAD


