Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab1C1PHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:07:44 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:58461 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754328Ab1C1PHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:07:42 -0400
X-AuditID: 12074422-b7ccdae000003dab-7e-4d90a4400dd9
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 6/6] x86-64: Turn off -pg and turn on -foptimize-sibling-calls for vDSO
Date: Mon, 28 Mar 2011 11:06:46 -0400
Message-Id: <72a7cb0d5ec0acfb1e9c008e0a5ccb8fa078803a.1301324270.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <cover.1301324270.git.luto@mit.edu>
References: <cover.1301324270.git.luto@mit.edu>
In-Reply-To: <cover.1301324270.git.luto@mit.edu>
References: <cover.1301324270.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsUixG6nouuwZIKvwaNVMhZ9V46yW7Sunc9u
	cXnXHDaLzZumMlv82PCY1YHVY+esu+wem1Z1snm8O3eO3ePctT5mj8+b5AJYo7hsUlJzMstS
	i/TtErgy3recYS44zFVxfMd79gbGGxxdjJwcEgImEvN/72GBsMUkLtxbzwZiCwnsY5TY8V24
	i5ELyN7AKLHxRicThPOMSWLBpClMIFVsAioSHUsfANkcHCICQhJL79aB1DALTGKUeDmjlx2k
	RlggXOLXmg9g9SwCqhKz29+DbeMVCJKYv28JkM0OtFlOojkQJMopYCDRefoqC8hEIQF9iY/n
	7HEIT2AUWMDIsIpRNiW3Sjc3MTOnODVZtzg5MS8vtUjXVC83s0QvNaV0EyM4JF2UdjD+PKh0
	iFGAg1GJh/d3eL+vEGtiWXFl7iFGSQ4mJVHeZ4sm+ArxJeWnVGYkFmfEF5XmpBYfYpTgYFYS
	4T3UCJTjTUmsrEotyodJSXOwKInzzpFU9xUSSE8sSc1OTS1ILYLJynBwKEnwJi0GahQsSk1P
	rUjLzClBSDNxcIIM5wEaDlbDW1yQmFucmQ6RP8WoKCXOawiSEABJZJTmwfXCUsYrRnGgV4R5
	I0CqeIDpBq77FdBgJqDBgUpgg0sSEVJSDYwTJ3PfrNnGtOYOm9PSz3riCdZS4Ur3G84H2/Du
	eberJvDP4zkWrYl/M7ZXLWk3FA/w4FuixBPw5l71+bWRT6TV5Hlq8sxftTMvLl7R+3ViuXw7
	Y9pcSfNwSfn8zNylO1rYDMtL7CRfy/FmH8gp73MvXOBrdCrg5cTzNcn3Q/7t+veqWvXONCWW
	4oxEQy3mouJEAGTWw5P0AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vDSO isn't part of the kernel, so profiling and kernel
backtraces don't really matter.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---

This might need a cc-option check for -foptimize-sibling-calls.

 arch/x86/vdso/Makefile |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index b6552b1..7b6df84 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -37,11 +37,24 @@ $(obj)/%.so: OBJCOPYFLAGS := -S
 $(obj)/%.so: $(obj)/%.so.dbg FORCE
 	$(call if_changed,objcopy)
 
+#
+# Don't omit frame pointers for ease of userspace debugging, but do
+# optimize sibling calls.
+#
 CFL := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64 \
-       $(filter -g%,$(KBUILD_CFLAGS)) $(call cc-option, -fno-stack-protector)
+       $(filter -g%,$(KBUILD_CFLAGS)) $(call cc-option, -fno-stack-protector) \
+       -fno-omit-frame-pointer -foptimize-sibling-calls
 
 $(vobjs): KBUILD_CFLAGS += $(CFL)
 
+#
+# vDSO code runs in userspace and -pg doesn't help with profiling anyway.
+#
+CFLAGS_REMOVE_vdso-note.o = -pg
+CFLAGS_REMOVE_vclock_gettime.o = -pg
+CFLAGS_REMOVE_vgetcpu.o = -pg
+CFLAGS_REMOVE_vvar.o = -pg
+
 targets += vdso-syms.lds
 obj-$(VDSO64-y)			+= vdso-syms.lds
 
-- 
1.7.4

