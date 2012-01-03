Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab2ACUUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 15:20:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:47369 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab2ACUUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 15:20:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102811118"
Message-Id: <67cd488cb9841efb1cdd963f078448aadfea2ffc.1325620195.git.tony.luck@intel.com>
In-Reply-To: <cover.1325620195.git.tony.luck@intel.com>
References: <cover.1325620195.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Tue, 3 Jan 2012 11:48:04 -0800
Subject: [PATCH 6/6] x86/mce: Recognise machine check bank signature for data path error
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Action required data path signature is defined in table 15-19 of SDM:

+-----------------------------------------------------------------------------+
| SRAR Error | Valid | OVER | UC | EN | MISCV | ADDRV | PCC | S | AR | MCACOD |
| Data Load  |     1 |    0 |  1 |  1 |     1 |     1 |   0 | 1 |  1 |  0x134 |
+-----------------------------------------------------------------------------+

Recognise this, and pass MCE_AR_SEVERITY code back to do_machine_check() if
we have the action handler configured (CONFIG_MEMORY_FAILURE=y)

Acked-by: Borislav Petkov <bp@amd64.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index 7395d5f..f6c92f9 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -54,6 +54,7 @@ static struct severity {
 #define  MASK(x, y)	.mask = x, .result = y
 #define MCI_UC_S (MCI_STATUS_UC|MCI_STATUS_S)
 #define MCI_UC_SAR (MCI_STATUS_UC|MCI_STATUS_S|MCI_STATUS_AR)
+#define	MCI_ADDR (MCI_STATUS_ADDRV|MCI_STATUS_MISCV)
 #define MCACOD 0xffff
 
 	MCESEV(
@@ -102,11 +103,24 @@ static struct severity {
 		SER, BITCLR(MCI_STATUS_S)
 		),
 
-	/* AR add known MCACODs here */
 	MCESEV(
 		PANIC, "Action required with lost events",
 		SER, BITSET(MCI_STATUS_OVER|MCI_UC_SAR)
 		),
+
+	/* known AR MCACODs: */
+#ifdef	CONFIG_MEMORY_FAILURE
+	MCESEV(
+		KEEP, "HT thread notices Action required: data load error",
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|0x0134),
+		MCGMASK(MCG_STATUS_EIPV, 0)
+		),
+	MCESEV(
+		AR, "Action required: data load error",
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|0x0134),
+		USER
+		),
+#endif
 	MCESEV(
 		PANIC, "Action required: unknown MCACOD",
 		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_SAR)
-- 
1.7.3.1

