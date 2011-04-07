Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab1DGCFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:05:05 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:62993 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757012Ab1DGCFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:05:00 -0400
X-AuditID: 1209190d-b7c48ae000004826-9e-4d9d1bc553a8
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [RFT/PATCH v2 6/6] x86-64: Turn off -pg and turn on -foptimize-sibling-calls for vDSO
Date: Wed,  6 Apr 2011 22:04:03 -0400
Message-Id: <78b66387ae46799690413ea241053e4d592cf728.1302137785.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <cover.1302137785.git.luto@mit.edu>
References: <cover.1302137785.git.luto@mit.edu>
In-Reply-To: <cover.1302137785.git.luto@mit.edu>
References: <cover.1302137785.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsUixCmqrXtUeq6vwczVOhZ9V46yWxy59p3d
	4vKuOWwWWy41s1ps3jSV2eLHhsesDmwet9r+MHvM3/mR0WPnrLvsHptWdbJ5vDt3jt3j8ya5
	ALYoLpuU1JzMstQifbsErozZC74yFfzjrJg3ezFzA+MCji5GTg4JAROJttWPWCFsMYkL99az
	gdhCAvsYJab9E+hi5AKy1zNK/Dx8jxnCecok0bixHayDTUBFomPpA6YuRg4OEQEhiaV360Bq
	mAW2M0psWN7OAlIjLBAncab1IdhUFgFViRWXdzKB2LwCQRKfZ/UC2exAm+UkmgNBopwCBhIX
	v/xnhbhBX2Jy7zdGXOITGAUWMDKsYpRNya3SzU3MzClOTdYtTk7My0st0jXSy80s0UtNKd3E
	CA5VSd4djO8OKh1iFOBgVOLhjeuc4yvEmlhWXJl7iFGSg0lJlLdTYq6vEF9SfkplRmJxRnxR
	aU5q8SFGCQ5mJRFeJSGgHG9KYmVValE+TEqag0VJnHempLqvkEB6YklqdmpqQWoRTFaGg0NJ
	gjcBGJNCgkWp6akVaZk5JQhpJg5OkOE8QMMniIMMLy5IzC3OTIfIn2LU5fi/5dA+RiGWvPy8
	VClx3m9SQEUCIEUZpXlwc2Ap5hWjONBbwryBIOt4gOkJbtIroCVMQEsWnpsDsqQkESEl1cBY
	p5hwPHuj48aSl0bCBfXhZ5/nl81eFND6KfJn9N0FPqzflzDxxQnsule94eZD6cP610617BdJ
	d/p4WnXpto1t935vOppg9q9T4YDLLjHOwg//3a8aB7lXbnx9cXmM0mQf3YYXqmqqd6wm1H7d
	rBWcJFpV58u5re3Fqe056w55fMo61G60sapViaU4I9FQi7moOBEApyo+UgwDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vDSO isn't part of the kernel, so profiling and kernel
backtraces don't really matter.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/vdso/Makefile |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index a651861..bef0bc9 100644
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

