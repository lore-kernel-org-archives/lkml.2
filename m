Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab1LIUI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 15:08:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46288 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab1LIUIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 15:08:24 -0500
Date: Fri, 9 Dec 2011 12:08:09 -0800
From: tip-bot for Petr Holasek <pholasek@redhat.com>
Message-ID: <tip-54eed6cb16ec315565aaaf8e34252ca253a68b7b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@redhat.com, pholasek@redhat.com,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        rientjes@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, pholasek@redhat.com,
        anton@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        rientjes@google.com, mingo@elte.hu
In-Reply-To: <20111208121640.GA2229@dhcp-27-244.brq.redhat.com>
References: <20111208121640.GA2229@dhcp-27-244.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/numa: Add constraints check for nid parameters
Git-Commit-ID: 54eed6cb16ec315565aaaf8e34252ca253a68b7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Dec 2011 12:08:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54eed6cb16ec315565aaaf8e34252ca253a68b7b
Gitweb:     http://git.kernel.org/tip/54eed6cb16ec315565aaaf8e34252ca253a68b7b
Author:     Petr Holasek <pholasek@redhat.com>
AuthorDate: Thu, 8 Dec 2011 13:16:41 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 9 Dec 2011 08:03:34 +0100

x86/numa: Add constraints check for nid parameters

This patch adds constraint checks to the numa_set_distance()
function.

When the check triggers (this should not happen normally) it
emits a warning and avoids a store to a negative index in
numa_distance[] array - i.e. avoids memory corruption.

Negative ids can be passed when the pxm-to-nids mapping is not
properly filled while parsing the SRAT.

Signed-off-by: Petr Holasek <pholasek@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Anton Arapov <anton@redhat.com>
Link: http://lkml.kernel.org/r/20111208121640.GA2229@dhcp-27-244.brq.redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/numa.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index fbeaaf4..cdc0054 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -430,8 +430,9 @@ static int __init numa_alloc_distance(void)
  * calls are ignored until the distance table is reset with
  * numa_reset_distance().
  *
- * If @from or @to is higher than the highest known node at the time of
- * table creation or @distance doesn't make sense, the call is ignored.
+ * If @from or @to is higher than the highest known node or lower than zero
+ * at the time of table creation or @distance doesn't make sense, the call
+ * is ignored.
  * This is to allow simplification of specific NUMA config implementations.
  */
 void __init numa_set_distance(int from, int to, int distance)
@@ -439,8 +440,9 @@ void __init numa_set_distance(int from, int to, int distance)
 	if (!numa_distance && numa_alloc_distance() < 0)
 		return;
 
-	if (from >= numa_distance_cnt || to >= numa_distance_cnt) {
-		printk_once(KERN_DEBUG "NUMA: Debug: distance out of bound, from=%d to=%d distance=%d\n",
+	if (from >= numa_distance_cnt || to >= numa_distance_cnt ||
+			from < 0 || to < 0) {
+		pr_warn_once("NUMA: Warning: node ids are out of bound, from=%d to=%d distance=%d\n",
 			    from, to, distance);
 		return;
 	}
