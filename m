Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab2IUUGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:06:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50937 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533Ab2IUUGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:06:20 -0400
Date: Fri, 21 Sep 2012 13:06:09 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-40d3cd6695014bf3c44e2ca66b610b18acaf923d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1348256595-29119-11-git-send-email-hpa@linux.intel.com>
References: <1348256595-29119-11-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/smap] x86, smap: A page fault due to SMAP is an oops
Git-Commit-ID: 40d3cd6695014bf3c44e2ca66b610b18acaf923d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 21 Sep 2012 13:06:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  40d3cd6695014bf3c44e2ca66b610b18acaf923d
Gitweb:     http://git.kernel.org/tip/40d3cd6695014bf3c44e2ca66b610b18acaf923d
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 21 Sep 2012 12:43:14 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 21 Sep 2012 12:45:27 -0700

x86, smap: A page fault due to SMAP is an oops

If we get a page fault due to SMAP, trigger an oops rather than
spinning forever.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1348256595-29119-11-git-send-email-hpa@linux.intel.com
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
