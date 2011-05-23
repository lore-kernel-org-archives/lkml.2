Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab1EWWNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:13:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:22207 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757761Ab1EWWNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:13:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,258,1304319600"; 
   d="scan'208";a="113261"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Ingo Molnar" <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        "Andi Kleen" <andi@firstfloor.org>, "Borislav Petkov" <bp@alien8.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
Subject: [RFC 4/9] MCE: Move ADDR/MISC reading code into common function
Date: Mon, 23 May 2011 15:13:37 -0700
Message-Id: <4ddadc1117164ccd94@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

Used for next patch.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index ee3b14e..f4924dc 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -525,6 +525,17 @@ static void mce_report_event(struct pt_regs *regs)
 #endif
 }
 
+/*
+ * Read ADDR and MISC registers.
+ */
+static void mce_read_aux(struct mce *m, int i)
+{
+	if (m->status & MCI_STATUS_MISCV)
+		m->misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
+	if (m->status & MCI_STATUS_ADDRV)
+		m->addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
+}
+
 DEFINE_PER_CPU(unsigned, mce_poll_count);
 
 /*
@@ -576,10 +587,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		    (m.status & (mce_ser ? MCI_STATUS_S : MCI_STATUS_UC)))
 			continue;
 
-		if (m.status & MCI_STATUS_MISCV)
-			m.misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
-		if (m.status & MCI_STATUS_ADDRV)
-			m.addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
+		mce_read_aux(&m, i);
 
 		if (!(flags & MCP_TIMESTAMP))
 			m.tsc = 0;
@@ -1023,10 +1031,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		if (severity == MCE_AR_SEVERITY)
 			kill_it = 1;
 
-		if (m.status & MCI_STATUS_MISCV)
-			m.misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
-		if (m.status & MCI_STATUS_ADDRV)
-			m.addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
+		mce_read_aux(&m, i);
 
 		/*
 		 * Action optional error. Queue address for later processing.
-- 
1.7.3.1

