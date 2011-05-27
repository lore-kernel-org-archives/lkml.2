Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217Ab1E0EFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 00:05:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49660 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab1E0EFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 00:05:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDF22FA.4020406@jp.fujitsu.com>
Date: Fri, 27 May 2011 13:05:14 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 03/12] mce-severity: cleanup severity table
References: <4DDF21DE.9040705@jp.fujitsu.com>
In-Reply-To: <4DDF21DE.9040705@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current format of item in this table is:
  condition(param, ..., level, message [, condition2 ...])

So we have to check both of head and tail of the item to know
conditions to match the item.

Make them in straight forward form:
  item(level, message, condition [, condition2 ...])

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce-severity.c |  127 +++++++++++++----------------
 1 files changed, 58 insertions(+), 69 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index eaf5a43..b797913 100644
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
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|0xfff0, MCI_UC_S|0xc0)
 		),
-	MASK(
-		MCI_UC_SAR|MCI_STATUS_OVER|MCACOD, MCI_UC_S|0x17a,
+	MCESEV(
 		AO, "Action optional: last level cache writeback error",
-		SER
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD, MCI_UC_S|0x17a)
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
+		BITSET(MCI_STATUS_OVER|MCI_STATUS_UC)
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
 
-- 
1.7.1


