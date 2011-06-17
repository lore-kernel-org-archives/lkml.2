Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540Ab1FQIvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:51:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34616 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab1FQIvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:51:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DFB1568.2090808@jp.fujitsu.com>
Date: Fri, 17 Jun 2011 17:50:48 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>
Subject: [PATCH 8/8] x86, mce, edac: call edac_mce_parse() once per a record
References: <4DFB1242.90404@jp.fujitsu.com>
In-Reply-To: <4DFB1242.90404@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to keep it in the cmpxchg loop.
(The loop continues until mcelog acquires buffer to save the record)

And use do-while for the loop here.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bc8a02c..f1d8ce1 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -148,21 +148,21 @@ void mce_log(struct mce *mce)
 	/* Emit the trace record: */
 	trace_mce_record(mce);
 
+	/*
+	 * If edac_mce is enabled, it will check the error type and will
+	 * process it, if it is a known error.
+	 * Otherwise, the error will be sent through mcelog interface.
+	 */
+	if (edac_mce_parse(mce))
+		return;
+
 	mce->finished = 0;
 	wmb();
-	for (;;) {
+
+	do {
 		entry = rcu_dereference_check_mce(mcelog.next);
 		for (;;) {
 			/*
-			 * If edac_mce is enabled, it will check the error type
-			 * and will process it, if it is a known error.
-			 * Otherwise, the error will be sent through mcelog
-			 * interface
-			 */
-			if (edac_mce_parse(mce))
-				return;
-
-			/*
 			 * When the buffer fills up discard new entries.
 			 * Assume that the earlier errors are the more
 			 * interesting ones:
@@ -181,10 +181,10 @@ void mce_log(struct mce *mce)
 		}
 		smp_rmb();
 		next = entry + 1;
-		if (cmpxchg(&mcelog.next, entry, next) == entry)
-			break;
-	}
+	} while (cmpxchg(&mcelog.next, entry, next) != entry);
+
 	memcpy(mcelog.entry + entry, mce, sizeof(struct mce));
+
 	wmb();
 	mcelog.entry[entry].finished = 1;
 	wmb();
-- 
1.7.1


