Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277Ab1EARoZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 13:44:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:41947 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425Ab1EARoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 13:44:23 -0400
Date: Sun, 1 May 2011 17:44:02 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-2be19102b71c1a45d37fec50303791daa1a06869@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110501171204.GO29280@htj.dyndns.org>
References: <20110501171204.GO29280@htj.dyndns.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, NUMA: Fix empty memblk detection in numa_cleanup_meminfo()
Git-Commit-ID: 2be19102b71c1a45d37fec50303791daa1a06869
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 01 May 2011 17:44:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2be19102b71c1a45d37fec50303791daa1a06869
Gitweb:     http://git.kernel.org/tip/2be19102b71c1a45d37fec50303791daa1a06869
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sun, 1 May 2011 19:12:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 1 May 2011 19:15:11 +0200

x86, NUMA: Fix empty memblk detection in numa_cleanup_meminfo()

numa_cleanup_meminfo() trims each memblk between low (0) and
high (max_pfn) limits and discards empty ones.  However, the
emptiness detection incorrectly used equality test.  If the
start of a memblk is higher than max_pfn, it is empty but fails
the equality test and doesn't get discarded.

The condition triggers when max_pfn is lower than start of a
NUMA node and results in memory misconfiguration - leading to
WARN_ON()s and other funnies.  The bug was discovered in devel
branch where 32bit too uses this code path for NUMA init.  If a
node is above the addressing limit, max_pfn ends up lower than
the node triggering this problem.

The failure hasn't been observed on x86-64 but is still possible
with broken hardware e820/NUMA info.  As the fix is very low
risk, it would be better to apply it even for 64bit.

Fix it by using >= instead of ==.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
[ Extracted the actual fix from the original patch and rewrote patch description. ]
Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/20110501171204.GO29280@htj.dyndns.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/numa_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index e8c00cc..85b52fc 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -306,7 +306,7 @@ int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 		bi->end = min(bi->end, high);
 
 		/* and there's no empty block */
-		if (bi->start == bi->end) {
+		if (bi->start >= bi->end) {
 			numa_remove_memblk_from(i--, mi);
 			continue;
 		}
