Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab2JZAg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:36:57 -0400
Received: from mail.kernel.org ([198.145.19.201]:53039 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab2JZAGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:06:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 38/42] sparc64: Like x86 we should check current->mm during perf backtrace generation.
Date: Thu, 25 Oct 2012 17:05:46 -0700
Message-Id: <20121026000128.625640160@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000124.790781113@linuxfoundation.org>
References: <20121026000124.790781113@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 08280e6c4c2e8049ac61d9e8e3536ec1df629c0d ]

If the MM is not active, only report the top-level PC.  Do not try to
access the address space.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/perf_event.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1428,8 +1428,6 @@ static void perf_callchain_user_64(struc
 {
 	unsigned long ufp;
 
-	perf_callchain_store(entry, regs->tpc);
-
 	ufp = regs->u_regs[UREG_I6] + STACK_BIAS;
 	do {
 		struct sparc_stackf *usf, sf;
@@ -1450,8 +1448,6 @@ static void perf_callchain_user_32(struc
 {
 	unsigned long ufp;
 
-	perf_callchain_store(entry, regs->tpc);
-
 	ufp = regs->u_regs[UREG_I6] & 0xffffffffUL;
 	do {
 		struct sparc_stackf32 *usf, sf;
@@ -1470,6 +1466,11 @@ static void perf_callchain_user_32(struc
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


