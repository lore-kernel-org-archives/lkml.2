Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab1FPLRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:17:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:45139 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab1FPLRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:17:04 -0400
Date: Thu, 16 Jun 2011 11:16:54 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Message-ID: <tip-a17957cdec69acb9e26319618b95a810a936e637@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        seto.hidetoshi@jp.fujitsu.com, tony.luck@intel.com, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de, tony.luck@intel.com,
        borislav.petkov@amd.com
In-Reply-To: <4DEED61F.5010502@jp.fujitsu.com>
References: <4DEED61F.5010502@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:ras/core] x86, mce, severity: Cleanup severity table
Git-Commit-ID: a17957cdec69acb9e26319618b95a810a936e637
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Jun 2011 11:16:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a17957cdec69acb9e26319618b95a810a936e637
Gitweb:     http://git.kernel.org/tip/a17957cdec69acb9e26319618b95a810a936e637
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Wed, 8 Jun 2011 10:53:35 +0900
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Thu, 16 Jun 2011 12:09:42 +0200

x86, mce, severity: Cleanup severity table

The current format of an item in this table is:
  condition(param, ..., level, message [, condition2 ...])

So we have to check both an item's head and tail to find the conditions
which match the item.

Format them in a more straight forward manner:
  item(level, message, condition [, condition2 ...])

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/4DEED61F.5010502@jp.fujitsu.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce-severity.c |  127 +++++++++++++----------------
 1 files changed, 58 insertions(+), 69 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index eaf5a43..27e778e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -43,116 +43,105 @@ static struct severity {
 	unsigned char covered;
 	char *msg;
 } severities[] = {
-#define KERNEL .context = IN_KERNEL
-#define USER .context = IN_USER
-#define SER .ser = SER_REQUIRED
-#define NOSER .ser = NO_SER
-#define SEV(s) .sev = MCE_ ## s ## _SEVERITY
-#define BITCLR(x, s, m, r...) { .mask = x, .result = 0, SEV(s), .msg = m, ## r }
-#define BITSET(x, s, m, r...) { .mask = x, .result = x, SEV(s), .msg = m, ## r }
-#define MCGMASK(x, res, s, m, r...) \
-	{ .mcgmask = x, .mcgres = res, SEV(s), .msg = m, ## r }
-#define MASK(x, y, s, m, r...) \
-	{ .mask = x, .result = y, SEV(s), .msg = m, ## r }
+#define MCESEV(s, m, c...) { .sev = MCE_ ## s ## _SEVERITY, .msg = m, ## c }
+#define  KERNEL		.context = IN_KERNEL
+#define  USER		.context = IN_USER
+#define  SER		.ser = SER_REQUIRED
+#define  NOSER		.ser = NO_SER
+#define  BITCLR(x)	.mask = x, .result = 0
+#define  BITSET(x)	.mask = x, .result = x
+#define  MCGMASK(x, y)	.mcgmask = x, .mcgres = y
+#define  MASK(x, y)	.mask = x, .result = y
 #define MCI_UC_S (MCI_STATUS_UC|MCI_STATUS_S)
 #define MCI_UC_SAR (MCI_STATUS_UC|MCI_STATUS_S|MCI_STATUS_AR)
 #define MCACOD 0xffff
 
-	BITCLR(
-		MCI_STATUS_VAL,
-		NO, "Invalid"
+	MCESEV(
+		NO, "Invalid",
+		BITCLR(MCI_STATUS_VAL)
 		),
-	BITCLR(
-		MCI_STATUS_EN,
-		NO, "Not enabled"
+	MCESEV(
+		NO, "Not enabled",
+		BITCLR(MCI_STATUS_EN)
 		),
-	BITSET(
-		MCI_STATUS_PCC,
-		PANIC, "Processor context corrupt"
+	MCESEV(
+		PANIC, "Processor context corrupt",
+		BITSET(MCI_STATUS_PCC)
 		),
 	/* When MCIP is not set something is very confused */
-	MCGMASK(
-		MCG_STATUS_MCIP, 0,
-		PANIC, "MCIP not set in MCA handler"
+	MCESEV(
+		PANIC, "MCIP not set in MCA handler",
+		MCGMASK(MCG_STATUS_MCIP, 0)
 		),
 	/* Neither return not error IP -- no chance to recover -> PANIC */
-	MCGMASK(
-		MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0,
-		PANIC, "Neither restart nor error IP"
+	MCESEV(
+		PANIC, "Neither restart nor error IP",
+		MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0)
 		),
-	MCGMASK(
-		MCG_STATUS_RIPV, 0,
+	MCESEV(
 		PANIC, "In kernel and no restart IP",
-		KERNEL
+		KERNEL, MCGMASK(MCG_STATUS_RIPV, 0)
 		),
-	BITCLR(
-		MCI_STATUS_UC,
+	MCESEV(
 		KEEP, "Corrected error",
-		NOSER
+		NOSER, BITCLR(MCI_STATUS_UC)
 		),
 
 	/* ignore OVER for UCNA */
-	MASK(
-		MCI_UC_SAR, MCI_STATUS_UC,
+	MCESEV(
 		KEEP, "Uncorrected no action required",
-		SER
+		SER, MASK(MCI_UC_SAR, MCI_STATUS_UC)
 		),
-	MASK(
-		MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_UC|MCI_STATUS_AR,
+	MCESEV(
 		PANIC, "Illegal combination (UCNA with AR=1)",
-		SER
+		SER,
+		MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_UC|MCI_STATUS_AR)
 		),
-	MASK(
-		MCI_STATUS_S, 0,
+	MCESEV(
 		KEEP, "Non signalled machine check",
-		SER
+		SER, MASK(MCI_STATUS_S, 0)
 		),
 
 	/* AR add known MCACODs here */
-	MASK(
-		MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_OVER|MCI_UC_SAR,
+	MCESEV(
 		PANIC, "Action required with lost events",
-		SER
+		SER,
+		MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_OVER|MCI_UC_SAR)
 		),
-	MASK(
-		MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_SAR,
+	MCESEV(
 		PANIC, "Action required; unknown MCACOD",
-		SER
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_SAR)
 		),
 
 	/* known AO MCACODs: */
-	MASK(
-		MCI_UC_SAR|MCI_STATUS_OVER|0xfff0, MCI_UC_S|0xc0,
+	MCESEV(
 		AO, "Action optional: memory scrubbing error",
-		SER
+		SER, MASK(MCI_UC_SAR|MCI_STATUS_OVER|0xfff0, MCI_UC_S|0xc0)
 		),
-	MASK(
-		MCI_UC_SAR|MCI_STATUS_OVER|MCACOD, MCI_UC_S|0x17a,
+	MCESEV(
 		AO, "Action optional: last level cache writeback error",
-		SER
+		SER, MASK(MCI_UC_SAR|MCI_STATUS_OVER|MCACOD, MCI_UC_S|0x17a)
 		),
-
-	MASK(
-		MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S,
+	MCESEV(
 		SOME, "Action optional unknown MCACOD",
-		SER
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S)
 		),
-	MASK(
-		MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S|MCI_STATUS_OVER,
+	MCESEV(
 		SOME, "Action optional with lost events",
-		SER
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S|MCI_STATUS_OVER)
 		),
-	BITSET(
-		MCI_STATUS_UC|MCI_STATUS_OVER,
-		PANIC, "Overflowed uncorrected"
+
+	MCESEV(
+		PANIC, "Overflowed uncorrected",
+		BITSET(MCI_STATUS_UC|MCI_STATUS_OVER)
 		),
-	BITSET(
-		MCI_STATUS_UC,
-		UC, "Uncorrected"
+	MCESEV(
+		UC, "Uncorrected",
+		BITSET(MCI_STATUS_UC)
 		),
-	BITSET(
-		0,
-		SOME, "No match"
+	MCESEV(
+		SOME, "No match",
+		BITSET(0)
 		)	/* always matches. keep at end */
 };
 
