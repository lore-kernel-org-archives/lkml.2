Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1AFVUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:20:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906Ab1AFVTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:19:40 -0500
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        gorcunov@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 6/6] x86, NMI: Clean-up default_do_nmi()
Date: Thu,  6 Jan 2011 16:18:52 -0500
Message-Id: <1294348732-15030-7-git-send-email-dzickus@redhat.com>
In-Reply-To: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
References: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just re-arrange the code a bit to make it easier to follow what is
going on.  Basically un-negating the if-statement and swapping the code
inside the if-statement with code outside.

No functional changes.

Originally-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/traps.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 613b3d2..b9b6716 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -410,26 +410,24 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	raw_spin_lock(&nmi_reason_lock);
 	reason = get_nmi_reason();
 
-	if (!(reason & NMI_REASON_MASK)) {
+	if (reason & NMI_REASON_MASK) {
+		if (reason & NMI_REASON_SERR)
+			pci_serr_error(reason, regs);
+		else if (reason & NMI_REASON_IOCHK)
+			io_check_error(reason, regs);
+#ifdef CONFIG_X86_32
+		/*
+		 * Reassert NMI in case it became active
+		 * meanwhile as it's edge-triggered:
+		 */
+		reassert_nmi();
+#endif
 		raw_spin_unlock(&nmi_reason_lock);
-		unknown_nmi_error(reason, regs);
-
 		return;
 	}
-
-	/* AK: following checks seem to be broken on modern chipsets. FIXME */
-	if (reason & NMI_REASON_SERR)
-		pci_serr_error(reason, regs);
-	if (reason & NMI_REASON_IOCHK)
-		io_check_error(reason, regs);
-#ifdef CONFIG_X86_32
-	/*
-	 * Reassert NMI in case it became active meanwhile
-	 * as it's edge-triggered:
-	 */
-	reassert_nmi();
-#endif
 	raw_spin_unlock(&nmi_reason_lock);
+
+	unknown_nmi_error(reason, regs);
 }
 
 dotraplinkage notrace __kprobes void
-- 
1.7.3.4

