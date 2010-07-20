Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154Ab0GTXTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 19:19:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42859 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655Ab0GTXTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 19:19:46 -0400
X-Authority-Analysis: v=1.1 cv=kjawQlkT3vujM0lFy4b69hWxQTW3SR1XdVtFii1ut0g= c=1 sm=0 a=9EqqMJltFOkA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=7gkXJVJtAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=tK5Uc55__jqkC-baTJMA:9 a=r35oolPpt3YQkuA5YpoA:7 a=78ckj2HLtX5BtaYkeidddgExbhYA:4 a=PUjeQqilurYA:10 a=JmBWkid0h3cA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL][v2.6.35] tracing: Properly align linker defined
 symbols
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Zeev Tarantov <zeev.tarantov@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 20 Jul 2010 19:19:44 -0400
Message-ID: <1279667984.4818.21.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Linus did like this patch better. My original patch seemed to fix the
problem, but this is probably a more robust fix.

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


Sam Ravnborg (1):
      tracing: Properly align linker defined symbols

----
 include/asm-generic/vmlinux.lds.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)
---------------------------
commit 07fca0e57fca925032526349f4370f97ed580cc9
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Sat Jul 10 08:35:00 2010 +0200

    tracing: Properly align linker defined symbols
    
    We define a number of symbols in the linker scipt like this:
    
        __start_syscalls_metadata = .;
        *(__syscalls_metadata)
    
    But we do not know the alignment of "." when we assign
    the __start_syscalls_metadata symbol.
    gcc started to uses bigger alignment for structs (32 bytes),
    so we saw situations where the linker due to alignment
    constraints increased the value of "." after the symbol assignment.
    
    This resulted in boot fails.
    
    Fix this by forcing a 32 byte alignment of "." before the
    assignment.
    
    This patch introduces the forced alignment for
    ftrace_events and syscalls_metadata.
    It may be required in more places.
    
    Reported-by: Zeev Tarantov <zeev.tarantov@gmail.com>
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
    LKML-Reference: <20100710063459.GA14596@merkur.ravnborg.org>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 48c5299..4b5902a 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -63,6 +63,12 @@
 /* Align . to a 8 byte boundary equals to maximum function alignment. */
 #define ALIGN_FUNCTION()  . = ALIGN(8)
 
+/*
+ * Align to a 32 byte boundary equal to the
+ * alignment gcc 4.5 uses for a struct
+ */
+#define STRUCT_ALIGN() . = ALIGN(32)
+
 /* The actual configuration determine if the init/exit sections
  * are handled as text/data or they can be discarded (which
  * often happens at runtime)
@@ -166,7 +172,11 @@
 	LIKELY_PROFILE()		       				\
 	BRANCH_PROFILE()						\
 	TRACE_PRINTKS()							\
+									\
+	STRUCT_ALIGN();							\
 	FTRACE_EVENTS()							\
+									\
+	STRUCT_ALIGN();							\
 	TRACE_SYSCALLS()
 
 /*


