Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab1E0ELw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 00:11:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52826 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab1E0ELv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 00:11:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDF2476.1010903@jp.fujitsu.com>
Date: Fri, 27 May 2011 13:11:34 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 10/12] x86, mce: cleanup mce_read
References: <4DDF21DE.9040705@jp.fujitsu.com>
In-Reply-To: <4DDF21DE.9040705@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use temporary local entry to make code simple.
No change in logic.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 9fe9e6e..4ba4040 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1533,18 +1533,17 @@ static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 	do {
 		for (i = prev; i < next; i++) {
 			unsigned long start = jiffies;
+			struct mce *entry = &mcelog.entry[i];
 
-			while (!mcelog.entry[i].finished) {
+			while (!entry->finished) {
 				if (time_after_eq(jiffies, start + 2)) {
-					memset(mcelog.entry + i, 0,
-					       sizeof(struct mce));
+					memset(entry, 0, sizeof(struct mce));
 					goto timeout;
 				}
 				cpu_relax();
 			}
 			smp_rmb();
-			err |= copy_to_user(buf, mcelog.entry + i,
-					    sizeof(struct mce));
+			err |= copy_to_user(buf, entry, sizeof(struct mce));
 			buf += sizeof(struct mce);
 timeout:
 			;
@@ -1565,13 +1564,13 @@ timeout:
 	on_each_cpu(collect_tscs, cpu_tsc, 1);
 
 	for (i = next; i < MCE_LOG_LEN; i++) {
-		if (mcelog.entry[i].finished &&
-		    mcelog.entry[i].tsc < cpu_tsc[mcelog.entry[i].cpu]) {
-			err |= copy_to_user(buf, mcelog.entry+i,
-					    sizeof(struct mce));
+		struct mce *entry = &mcelog.entry[i];
+
+		if (entry->finished && entry->tsc < cpu_tsc[entry->cpu]) {
+			err |= copy_to_user(buf, entry, sizeof(struct mce));
 			smp_rmb();
 			buf += sizeof(struct mce);
-			memset(&mcelog.entry[i], 0, sizeof(struct mce));
+			memset(entry, 0, sizeof(struct mce));
 		}
 	}
 
-- 
1.7.1


