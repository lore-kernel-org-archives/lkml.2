Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab1FHCAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 22:00:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49881 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1FHCAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 22:00:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DEED7A8.8020307@jp.fujitsu.com>
Date: Wed, 08 Jun 2011 11:00:08 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@gmail.com>
Subject: [PATCH 10/12] x86, mce: cleanup mce_read
References: <4DEED509.1040504@jp.fujitsu.com>
In-Reply-To: <4DEED509.1040504@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use temporary local m to make code simple.
No change in logic.

v2:
  use m for struct mce

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index f3f648c..54360e8 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1537,19 +1537,18 @@ static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 	do {
 		for (i = prev; i < next; i++) {
 			unsigned long start = jiffies;
+			struct mce *m = &mcelog.entry[i];
 
-			while (!mcelog.entry[i].finished) {
+			while (!m->finished) {
 				if (time_after_eq(jiffies, start + 2)) {
-					memset(mcelog.entry + i, 0,
-					       sizeof(struct mce));
+					memset(m, 0, sizeof(*m));
 					goto timeout;
 				}
 				cpu_relax();
 			}
 			smp_rmb();
-			err |= copy_to_user(buf, mcelog.entry + i,
-					    sizeof(struct mce));
-			buf += sizeof(struct mce);
+			err |= copy_to_user(buf, m, sizeof(*m));
+			buf += sizeof(*m);
 timeout:
 			;
 		}
@@ -1569,13 +1568,13 @@ timeout:
 	on_each_cpu(collect_tscs, cpu_tsc, 1);
 
 	for (i = next; i < MCE_LOG_LEN; i++) {
-		if (mcelog.entry[i].finished &&
-		    mcelog.entry[i].tsc < cpu_tsc[mcelog.entry[i].cpu]) {
-			err |= copy_to_user(buf, mcelog.entry+i,
-					    sizeof(struct mce));
+		struct mce *m = &mcelog.entry[i];
+
+		if (m->finished && m->tsc < cpu_tsc[m->cpu]) {
+			err |= copy_to_user(buf, m, sizeof(*m));
 			smp_rmb();
-			buf += sizeof(struct mce);
-			memset(&mcelog.entry[i], 0, sizeof(struct mce));
+			buf += sizeof(*m);
+			memset(m, 0, sizeof(*m));
 		}
 	}
 
-- 
1.7.1


