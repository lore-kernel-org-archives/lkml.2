Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab1HSUkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 16:40:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab1HSUkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 16:40:05 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, ying.huang@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>, jason.wessel@windriver.com,
        Don Zickus <dzickus@redhat.com>
Subject: [RFC][PATCH 5/6] x86, nmi: track NMI usage stats
Date: Fri, 19 Aug 2011 16:37:45 -0400
Message-Id: <1313786266-9585-6-git-send-email-dzickus@redhat.com>
In-Reply-To: <1313786266-9585-1-git-send-email-dzickus@redhat.com>
References: <1313786266-9585-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the NMI handler are broken into lists, increment the appropriate
stats for each list.  This allows us to see what is going on when they
get printed out in the next patch.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/nmi.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 7d9287e..260a275 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -47,6 +47,15 @@ static struct nmi_desc nmi_desc[NMI_MAX] =
 
 };
 
+struct nmi_stats {
+	unsigned int normal;
+	unsigned int unknown;
+	unsigned int external;
+	unsigned int swallow;
+};
+
+static DEFINE_PER_CPU(struct nmi_stats, nmi_stats);
+
 static int ignore_nmis;
 
 int unknown_nmi_panic;
@@ -238,8 +247,13 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 	int handled;
 
 	handled = nmi_handle(NMI_UNKNOWN, regs);
-	if (handled) 
+	if (handled) {
+		__this_cpu_add(nmi_stats.unknown, handled);
 		return;
+	}
+
+	__this_cpu_add(nmi_stats.unknown, 1);
+
 #ifdef CONFIG_MCA
 	/*
 	 * Might actually be able to figure out what the guilty party
@@ -273,6 +287,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	 * NMI can not be detected/processed on other CPUs.
 	 */
 	handled = nmi_handle(NMI_LOCAL, regs);
+	__this_cpu_add(nmi_stats.normal, handled);
 	if (handled) {
 		/*
 		 * When handling multiple NMI events, we are not
@@ -312,12 +327,16 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		 */
 		reassert_nmi();
 #endif
+		__this_cpu_add(nmi_stats.external, 1);
 		raw_spin_unlock(&nmi_reason_lock);
 		return;
 	}
 	raw_spin_unlock(&nmi_reason_lock);
 
-	unknown_nmi_error(reason, regs);
+	if (!__this_cpu_read(swallow_nmi))
+		unknown_nmi_error(reason, regs);
+	else
+		__this_cpu_add(nmi_stats.swallow, 1);
 
 	__this_cpu_write(swallow_nmi, false);
 }
-- 
1.7.6

