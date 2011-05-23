Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab1EWNdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:33:15 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:52535 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754947Ab1EWNdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:33:11 -0400
X-AuditID: 1209190c-b7c65ae00000117c-07-4dda621ed9d6
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@amd64.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v5 6/8] x86-64: Turn off -pg and turn on -foptimize-sibling-calls for vDSO
Date: Mon, 23 May 2011 09:31:29 -0400
Message-Id: <23087b738c037342abb53f2f07b9bef89ceaeea3.1306156808.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306156808.git.luto@mit.edu>
References: <cover.1306156808.git.luto@mit.edu>
In-Reply-To: <cover.1306156808.git.luto@mit.edu>
References: <cover.1306156808.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsUixCmqrSuXdMvXYPIbQYuLbRfZLPquHGW3
	OHLtO7vFxcZtLBZzzrewWOx7f5bN4vKuOWwWWy41s1ps3jSV2eJR31t2ix8bHrM6cHt0P/rE
	6HHlKYfHlpU3mTxutf1h9pi/8yOjx85Zd9k9Nq3qZPN4d+4cu8eJGb9ZPD5vkgvgiuKySUnN
	ySxLLdK3S+DKWN6/g7mggati5poTbA2Mizi6GDk5JARMJJ6e2MAOYYtJXLi3nq2LkYtDSGAf
	o8T9DVOhnA2MEptOdUA5z5gkzu5bC9bCJqAi0bH0AVMXIweHiICQxNK7dSA1zAJrmSX2dS9m
	AqkRFoiSOHxkGiuIzSKgKrHz3CNGkHpegSCJviUVEJsVJK5cmccCYnMKGEjM330SzBYS0JeY
	dHQpTvEJjAILGBlWMcqm5Fbp5iZm5hSnJusWJyfm5aUW6Rrq5WaW6KWmlG5iBMeBJM8OxjcH
	lQ4xCnAwKvHwLtK86SvEmlhWXJl7iFGSg0lJlNcl/pavEF9SfkplRmJxRnxRaU5q8SFGCQ5m
	JRHeBu0bvkK8KYmVValF+TApaQ4WJXHeGZLqvkIC6YklqdmpqQWpRTBZGQ4OJQneRYlAQwWL
	UtNTK9Iyc0oQ0kwcnCDDeYCG94LU8BYXJOYWZ6ZD5E8x6nJMvf37AKMQS15+XqqUOG8cSJEA
	SFFGaR7cHFj6esUoDvSWMO9EkCoeYOqDm/QKaAkT0BKJvzdBlpQkIqSkGhiz3zw9eH8Dz5bX
	ahH2y40FwsR2WX51qDdIKjk1b43AjVeVUi5eM5p/5p8Q/ymetvWV2a43e5KzZlyI61i5kCff
	Yk2lXbXFoidym3l8fCwTpv5sYv8oH5khd/KhcPO+24V1538mNUQ0M/i2rNmvuLzppFdt283q
	rG6NYEnn2RUaWo+YCpXWT1BiKc5INNRiLipOBAChiYwkOgMAAA==
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
1.7.5.1

