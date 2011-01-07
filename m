Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1AGPgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:36:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:40819 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab1AGPgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:36:36 -0500
Date: Fri, 7 Jan 2011 15:35:18 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, ying.huang@intel.com, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, ying.huang@intel.com, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1294348732-15030-7-git-send-email-dzickus@redhat.com>
References: <1294348732-15030-7-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, NMI: Clean-up default_do_nmi()
Message-ID: <tip-f2fd43954abc058586e95d4eb91e7a5477070704@git.kernel.org>
Git-Commit-ID: f2fd43954abc058586e95d4eb91e7a5477070704
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 Jan 2011 15:35:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f2fd43954abc058586e95d4eb91e7a5477070704
Gitweb:     http://git.kernel.org/tip/f2fd43954abc058586e95d4eb91e7a5477070704
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Thu, 6 Jan 2011 16:18:52 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Jan 2011 15:08:53 +0100

x86, NMI: Clean-up default_do_nmi()

Just re-arrange the code a bit to make it easier to follow what is
going on.  Basically un-negating the if-statement and swapping the code
inside the if-statement with code outside.

No functional changes.

Originally-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1294348732-15030-7-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
