Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1GNDbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 23:31:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60363 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab1GNDbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 23:31:08 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=GjF7Uxbut14A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=GBDZ3trVsI8cmn03-1cA:9 a=z9FxbM3_H_X7ZgARLI8A:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [RFA][PATCH] trace/mm: Remove kmem.h from slab_def.h
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 13 Jul 2011 23:31:05 -0400
Message-ID: <1310614265.27864.16.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ RFA - Request for Acks ]

Having event headers in other headers can cause the necessary macro
magic to break. For example, if we have in some C file:

#define CREATE_TRACE_POINTS
#include <trace/events/foo.h>

But then in trace/events/foo.h, for some reason it needs to include
linux/slab.h. Which includes linux/slab_def.h which happens to include
the trace/events/kmem.h, and causes the TRACE_EVENT() macros in that
file to be processed, then all hell breaks loose.

To avoid this problem, it is better to just include trace/events/kmem.h
in the C files that need it. It is already included in most of them,
only mm/slab.c also needed to include it.

I tested this with ktest running 10 randconfigs each with SLAB, SLUB,
and SLOB enabled (for a total of 30 randconfig builds). With 30
successful builds, this change should not be an issue. SLUB and SLOB
have it already done.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 83203ae..d12c70a 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -15,8 +15,6 @@
 #include <asm/cache.h>		/* kmalloc_sizes.h needs L1_CACHE_BYTES */
 #include <linux/compiler.h>
 
-#include <trace/events/kmem.h>
-
 /*
  * Enforce a minimum alignment for the kmalloc caches.
  * Usually, the kmalloc caches are cache_line_size() aligned, except when
diff --git a/mm/slab.c b/mm/slab.c
index d96e223..e4bd1ec 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -121,6 +121,8 @@
 #include	<asm/tlbflush.h>
 #include	<asm/page.h>
 
+#include	<trace/events/kmem.h>
+
 /*
  * DEBUG	- 1 for kmem_cache_create() to honour; SLAB_RED_ZONE & SLAB_POISON.
  *		  0 for faster, smaller code (especially in the critical paths).


