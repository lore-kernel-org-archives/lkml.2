Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab2H0REt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:04:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34302 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab2H0REr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:04:47 -0400
Date: Mon, 27 Aug 2012 10:04:28 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-a2546fae01124fb8063747439300fcf39bac033a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andi@firstfloor.org, rostedt@goodmis.org, srostedt@redhat.com,
        mmarek@suse.cz, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mmarek@suse.cz, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20120807194059.392617243@goodmis.org>
References: <20120807194059.392617243@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace:
  Add -mfentry to Makefile on function tracer
Git-Commit-ID: a2546fae01124fb8063747439300fcf39bac033a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Aug 2012 10:04:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a2546fae01124fb8063747439300fcf39bac033a
Gitweb:     http://git.kernel.org/tip/a2546fae01124fb8063747439300fcf39bac033a
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 9 Feb 2011 13:15:59 -0500
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 23 Aug 2012 11:25:02 -0400

ftrace: Add -mfentry to Makefile on function tracer

Thanks to Andi Kleen, gcc 4.6.0 now supports -mfentry for x86
(and hopefully soon for other archs). What this does is to have
the function profiler start at the beginning of the function
instead of after the stack is set up. As plain -pg (mcount) is
called after the stack is set up, and in some cases can have issues
with the function graph tracer. It also requires frame pointers to
be enabled.

The -mfentry now calls __fentry__ at the beginning of the function.
This allows for compiling without frame pointers and even has the
ability to access parameters if needed.

If the architecture and the compiler both support -mfentry then
use that instead.

Link: http://lkml.kernel.org/r/20120807194059.392617243@goodmis.org

Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Makefile             |    6 +++++-
 kernel/trace/Kconfig |    5 +++++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index ddf5be9..e7ca93f 100644
--- a/Makefile
+++ b/Makefile
@@ -609,7 +609,11 @@ KBUILD_CFLAGS 	+= $(call cc-option, -femit-struct-debug-baseonly)
 endif
 
 ifdef CONFIG_FUNCTION_TRACER
-KBUILD_CFLAGS	+= -pg
+ifdef CONFIG_HAVE_FENTRY
+CC_USING_FENTRY	:= $(call cc-option, -mfentry -DCC_USING_FENTRY)
+endif
+KBUILD_CFLAGS	+= -pg $(CC_USING_FENTRY)
+KBUILD_AFLAGS	+= $(CC_USING_FENTRY)
 ifdef CONFIG_DYNAMIC_FTRACE
 	ifdef CONFIG_HAVE_C_RECORDMCOUNT
 		BUILD_C_RECORDMCOUNT := y
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 8c4c070..9301a0e 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -49,6 +49,11 @@ config HAVE_SYSCALL_TRACEPOINTS
 	help
 	  See Documentation/trace/ftrace-design.txt
 
+config HAVE_FENTRY
+	bool
+	help
+	  Arch supports the gcc options -pg with -mfentry
+
 config HAVE_C_RECORDMCOUNT
 	bool
 	help
