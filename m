Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952Ab0J2Pxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 11:53:39 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:24520 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab0J2Pxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 11:53:37 -0400
X-IronPort-AV: E=Sophos;i="4.58,260,1286164800"; 
   d="scan'208";a="120275689"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86/32: treat all pfns as low in dump_pagetable before max_low_pfn is set
Date: Fri, 29 Oct 2010 16:53:32 +0100
Message-Id: <1288367612-23829-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 29 Oct 2010 15:53:36.0826 (UTC) FILETIME=[72A789A0:01CB7781]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we end up calling dump_pagetable before max_low_pfn is set then
currently we always stop after pdpt since low_pfn(...) is always false.

If we are calling dump_pagetable this early then I think it is
reasonably safe to assume all PFNs are low.

In any case if things are going so badly wrong so early on then we
might as well struggle on and print as much of the page table as
possible.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/mm/fault.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 7d90ceb..7a2afc7 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -306,7 +306,7 @@ check_v8086_mode(struct pt_regs *regs, unsigned long address,
 
 static bool low_pfn(unsigned long pfn)
 {
-	return pfn < max_low_pfn;
+	return !max_low_pfn || pfn < max_low_pfn;
 }
 
 static void dump_pagetable(unsigned long address)
-- 
1.5.6.5

