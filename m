Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab1EPQCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:02:11 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:62220 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756423Ab1EPQCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:02:06 -0400
X-AuditID: 12074425-b7b78ae000007e02-6f-4dd14a7f8ed5
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
Subject: [PATCH v4 6/6] x86-64: Turn off -pg and turn on -foptimize-sibling-calls for vDSO
Date: Mon, 16 May 2011 12:01:03 -0400
Message-Id: <bbeb3e482cd2e220c831ea95fd6378ee5c3da671.1305560561.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305560561.git.luto@mit.edu>
References: <cover.1305560561.git.luto@mit.edu>
In-Reply-To: <cover.1305560561.git.luto@mit.edu>
References: <cover.1305560561.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsUixG6nrlvvddHXYNpFPouLbRfZLPquHGW3
	OHLtO7vFxcZtLBZzzrewWOx7f5bN4vKuOWwWWy41s1ps3jSV2eJR31t2ix8bHrM6cHt0P/rE
	6HHlKYfHlpU3mTxutf1h9pi/8yOjx85Zd9k9Nq3qZPN4d+4cu8eJGb9ZPD5vkgvgiuKySUnN
	ySxLLdK3S+DKWN6/g7mggati5poTbA2Mizi6GDk5JARMJA6dXMYMYYtJXLi3nq2LkYtDSGAf
	o8THW4sYIZwNjBLbd2yEyjxjkvjQdZARpIVNQEWiY+kDpi5GDg4RASGJpXfrQGqYBdYyS+zr
	XswEUiMsECXx7fBfNhCbRUBV4taeu6wg9bwCQRLXf7JAbFaQuHJlHpjNKWAgsf3wFrCLhAT0
	JbrW/GfEJT6BUWABI8MqRtmU3Crd3MTMnOLUZN3i5MS8vNQiXQu93MwSvdSU0k2M4DhwUd3B
	OOGQ0iFGAQ5GJR5eBueLvkKsiWXFlbmHGCU5mJREeQ1cgUJ8SfkplRmJxRnxRaU5qcWHGCU4
	mJVEeM/UX/AV4k1JrKxKLcqHSUlzsCiJ886XVPcVEkhPLEnNTk0tSC2CycpwcChJ8CoD411I
	sCg1PbUiLTOnBCHNxMEJMpwHaDgPSA1vcUFibnFmOkT+FKMux+dHhw4wCrHk5eelSonzfvcE
	KhIAKcoozYObA0tfrxjFgd4S5mUBGcUDTH1wk14BLWECWrLqFMgHxSWJCCmpBsZVUgVaV3se
	dE4RXhLAHPgpv7zt6Mv/eX23vE/2rnwaZ7SkeqP2JvWY5R7Xw99P+mLb9sqe15fv646lsg93
	xQSK2OfFrdK1KjCPe5J2lOu2kdHr6vYTSgs8l3XK7XDK4TfZIRD41ia5+I9pYoWz19VZ8fcu
	fea/Fj33LqM0l8yrpK0/Xkiu+q3EUpyRaKjFXFScCACnnW8rOgMAAA==
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

