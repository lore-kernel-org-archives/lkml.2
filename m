Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab2IUTpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:45:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:27797 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411Ab2IUTnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:43:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,464,1344236400"; 
   d="scan'208";a="225202020"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 10/11] x86, smap: A page fault due to SMAP is an oops
Date: Fri, 21 Sep 2012 12:43:14 -0700
Message-Id: <1348256595-29119-11-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

If we get a page fault due to SMAP, trigger an oops rather than
spinning forever.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/fault.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 76dcd9d..f2fb75d 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -995,6 +995,17 @@ static int fault_in_kernel_space(unsigned long address)
 	return address >= TASK_SIZE_MAX;
 }
 
+static inline bool smap_violation(int error_code, struct pt_regs *regs)
+{
+	if (error_code & PF_USER)
+		return false;
+
+	if (!user_mode_vm(regs) && (regs->flags & X86_EFLAGS_AC))
+		return false;
+
+	return true;
+}
+
 /*
  * This routine handles page faults.  It determines the address,
  * and the problem, and then passes it off to one of the appropriate
@@ -1088,6 +1099,13 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	if (unlikely(error_code & PF_RSVD))
 		pgtable_bad(regs, error_code, address);
 
+	if (static_cpu_has(X86_FEATURE_SMAP)) {
+		if (unlikely(smap_violation(error_code, regs))) {
+			bad_area_nosemaphore(regs, error_code, address);
+			return;
+		}
+	}
+
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 
 	/*
-- 
1.7.6.5

