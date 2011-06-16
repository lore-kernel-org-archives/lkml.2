Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab1FPLUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:20:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:50338 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213Ab1FPLUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:20:08 -0400
Date: Thu, 16 Jun 2011 11:19:58 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Message-ID: <tip-559faa6be143b8aa7a07b12f618d29fbc1c8eb0d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        seto.hidetoshi@jp.fujitsu.com, tony.luck@intel.com, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de, tony.luck@intel.com,
        borislav.petkov@amd.com
In-Reply-To: <4DEED7A8.8020307@jp.fujitsu.com>
References: <4DEED7A8.8020307@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:ras/core] x86, mce: Cleanup mce_read()
Git-Commit-ID: 559faa6be143b8aa7a07b12f618d29fbc1c8eb0d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Jun 2011 11:19:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  559faa6be143b8aa7a07b12f618d29fbc1c8eb0d
Gitweb:     http://git.kernel.org/tip/559faa6be143b8aa7a07b12f618d29fbc1c8eb0d
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Wed, 8 Jun 2011 11:00:08 +0900
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Thu, 16 Jun 2011 12:10:13 +0200

x86, mce: Cleanup mce_read()

Use a temporary local variable m to simplify the code. No change in
logic.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/4DEED7A8.8020307@jp.fujitsu.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
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
 
