Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab2FNWrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 18:47:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15195 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab2FNWrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 18:47:31 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=hQlCdkBRFk4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=gNcOBdI-9ui-iY9un5oA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339714048.13377.246.camel@gandalf.stny.rr.com>
Subject: [PATCH][GIT PULL][v3.5] ftrace: Make all inline tags also include
 notrace
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <wfg@linux.intel.com>
Date: Thu, 14 Jun 2012 18:47:28 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: 0e326ac2529387468a0c7923f573e16399a031ce


Steven Rostedt (1):
      ftrace: Make all inline tags also include notrace

----
 include/linux/compiler-gcc.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)
---------------------------
commit 0e326ac2529387468a0c7923f573e16399a031ce
Author: Steven Rostedt <rostedt@goodmis.org>
Date:   Thu Jun 14 10:54:28 2012 -0400

    ftrace: Make all inline tags also include notrace
    
    Commit 5963e317b1 ftrace/x86: Do not change stacks in DEBUG when calling lockdep
    prevented lockdep calls from the int3 breakpoint handler from reseting the
    stack if a function that was called was in the process of being converted
    for tracing and had a breakpoint on it. The idea is, before calling
    the lockdep code, do a load_idt() to the special IDT that kept the breakpoint
    stack from reseting. This worked well as a quick fix for this kernel
    release, until a certain config caused a lockup in the function tracer
    start up tests.
    
    Investigating it, I found that the load_idt that was used to prevent
    the int3 from changing stacks was itself being traced!
    
    Even though the config had CONFIG_OPTIMIZE_INLINING disabled, and
    all 'inline' tags were set to always inline, there were still cases that
    it did not inline! This was caused by CONFIG_PARAVIRT_GUEST, where it
    would add a pointer to the native_load_idt() which made that function
    to be traced.
    
    Commit 45959ee7 ftrace: Do not function trace inlined functions
    only touched the 'inline' tags when CONFIG_OPMITIZE_INLINING was enabled.
    PARAVIRT_GUEST shows that this was not enough and we need to also
    mark always_inline with notrace as well.
    
    Reported-by: Fengguang Wu <wfg@linux.intel.com>
    Tested-by: Fengguang Wu <wfg@linux.intel.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index e5834aa..6a6d7ae 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -47,9 +47,9 @@
  */
 #if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
     !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)
-# define inline		inline		__attribute__((always_inline))
-# define __inline__	__inline__	__attribute__((always_inline))
-# define __inline	__inline	__attribute__((always_inline))
+# define inline		inline		__attribute__((always_inline)) notrace
+# define __inline__	__inline__	__attribute__((always_inline)) notrace
+# define __inline	__inline	__attribute__((always_inline)) notrace
 #else
 /* A lot of inline functions can cause havoc with function tracing */
 # define inline		inline		notrace


