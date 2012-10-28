Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab2J1XwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:52:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41754 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756229Ab2J1X05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:26:57 -0400
Message-Id: <20121028231540.741718836@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:15:48 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 012/105] sparc64: Like x86 we should check current->mm during  perf backtrace generation.
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 08280e6c4c2e8049ac61d9e8e3536ec1df629c0d ]

If the MM is not active, only report the top-level PC.  Do not try to
access the address space.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sparc/kernel/perf_event.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 614da62..5331ae1 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1422,8 +1422,6 @@ static void perf_callchain_user_64(struct perf_callchain_entry *entry,
 {
 	unsigned long ufp;
 
-	perf_callchain_store(entry, regs->tpc);
-
 	ufp = regs->u_regs[UREG_I6] + STACK_BIAS;
 	do {
 		struct sparc_stackf *usf, sf;
@@ -1444,8 +1442,6 @@ static void perf_callchain_user_32(struct perf_callchain_entry *entry,
 {
 	unsigned long ufp;
 
-	perf_callchain_store(entry, regs->tpc);
-
 	ufp = regs->u_regs[UREG_I6] & 0xffffffffUL;
 	do {
 		struct sparc_stackf32 *usf, sf;
@@ -1464,6 +1460,11 @@ static void perf_callchain_user_32(struct perf_callchain_entry *entry,
 void
 perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 {
+	perf_callchain_store(entry, regs->tpc);
+
+	if (!current->mm)
+		return;
+
 	flushw_user();
 	if (test_thread_flag(TIF_32BIT))
 		perf_callchain_user_32(entry, regs);


