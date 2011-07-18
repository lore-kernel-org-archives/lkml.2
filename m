Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1GROZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 10:25:06 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56283 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1GROZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 10:25:04 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: EDAC devel <linux-edac@vger.kernel.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/2] x86, MCE: Use notifier chain only for MCE decoding
Date: Mon, 18 Jul 2011 16:24:45 +0200
Message-Id: <1310999086-30870-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1310999086-30870-1-git-send-email-bp@amd64.org>
References: <1310999086-30870-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Drop the edac_mce custom hook in favor of the generic notifier
mechanism. Also, do not log the error to mcelog if the notified agent
was able to decode it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 08363b0..019786a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -144,23 +144,20 @@ static struct mce_log mcelog = {
 void mce_log(struct mce *mce)
 {
 	unsigned next, entry;
+	int ret = 0;
 
 	/* Emit the trace record: */
 	trace_mce_record(mce);
 
+	ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, mce);
+	if (ret == NOTIFY_STOP)
+		return;
+
 	mce->finished = 0;
 	wmb();
 	for (;;) {
 		entry = rcu_dereference_check_mce(mcelog.next);
 		for (;;) {
-			/*
-			 * If edac_mce is enabled, it will check the error type
-			 * and will process it, if it is a known error.
-			 * Otherwise, the error will be sent through mcelog
-			 * interface
-			 */
-			if (edac_mce_parse(mce))
-				return;
 
 			/*
 			 * When the buffer fills up discard new entries.
@@ -551,10 +548,8 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		 * Don't get the IP here because it's unlikely to
 		 * have anything to do with the actual error location.
 		 */
-		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce) {
+		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce)
 			mce_log(&m);
-			atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, &m);
-		}
 
 		/*
 		 * Clear state for this bank.
-- 
1.7.4.rc2

