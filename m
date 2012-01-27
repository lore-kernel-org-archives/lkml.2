Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab2A0AVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 19:21:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:51641 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab2A0AVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 19:21:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="111171418"
Message-Id: <08dda402d60a721ac94e79efd7646b332be3e3b2.1327622761.git.tony.luck@intel.com>
In-Reply-To: <20120126182842.GA8630@elte.hu>
From: Tony Luck <tony.luck@intel.com>
Date: Thu, 26 Jan 2012 16:02:22 -0800
Subject: [PATCH] x86/mce: Replace hard coded hex constants with symbolic defines
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magic constants like 0x0134 in code just invite questions on
where they come from, what they mean, can they be changed?

Provide #defines for the architecturally defined MCACOD values
with a reference to the Intel Software Developers manual which
describes them.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Ingo: You said "ok up to 100 cols or so" ... this goes to 103.
If this is OK, you can either apply it from here on top of the
x86/mce branch in tip - or I can push it to the ras tree and
send you another pull.

 arch/x86/kernel/cpu/mcheck/mce-severity.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index f6c92f9..0c82091 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -56,6 +56,12 @@ static struct severity {
 #define MCI_UC_SAR (MCI_STATUS_UC|MCI_STATUS_S|MCI_STATUS_AR)
 #define	MCI_ADDR (MCI_STATUS_ADDRV|MCI_STATUS_MISCV)
 #define MCACOD 0xffff
+/* Architecturally defined codes from SDM Vol. 3B Chapter 15 */
+#define MCACOD_SCRUB	0x00C0	/* 0xC0-0xCF Memory Scrubbing */
+#define MCACOD_SCRUBMSK	0xfff0
+#define MCACOD_L3WB	0x017A	/* L3 Explicit Writeback */
+#define MCACOD_DATA	0x0134	/* Data Load */
+#define MCACOD_INSTR	0x0150	/* Instruction Fetch */
 
 	MCESEV(
 		NO, "Invalid",
@@ -112,12 +118,12 @@ static struct severity {
 #ifdef	CONFIG_MEMORY_FAILURE
 	MCESEV(
 		KEEP, "HT thread notices Action required: data load error",
-		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|0x0134),
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
 		MCGMASK(MCG_STATUS_EIPV, 0)
 		),
 	MCESEV(
 		AR, "Action required: data load error",
-		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|0x0134),
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
 		USER
 		),
 #endif
@@ -129,11 +135,11 @@ static struct severity {
 	/* known AO MCACODs: */
 	MCESEV(
 		AO, "Action optional: memory scrubbing error",
-		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|0xfff0, MCI_UC_S|0x00c0)
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD_SCRUBMSK, MCI_UC_S|MCACOD_SCRUB)
 		),
 	MCESEV(
 		AO, "Action optional: last level cache writeback error",
-		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD, MCI_UC_S|0x017a)
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD, MCI_UC_S|MCACOD_L3WB)
 		),
 	MCESEV(
 		SOME, "Action optional: unknown MCACOD",
-- 
1.7.9.rc2.1.g69204

