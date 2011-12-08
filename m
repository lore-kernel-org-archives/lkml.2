Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab1LHOJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 09:09:11 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43614 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab1LHOJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 09:09:09 -0500
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, X86-ML <x86@kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/2] x86, MCE: Drain mcelog buffer
Date: Thu,  8 Dec 2011 15:08:52 +0100
Message-Id: <1323353332-5671-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1323353332-5671-1-git-send-email-bp@amd64.org>
References: <1323353332-5671-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a function which drains whatever MCEs were logged in already during
boot and before the decoder chains were registered.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   39 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index c3c66ac..5be2464 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -189,9 +189,48 @@ void mce_log(struct mce *mce)
 	set_bit(0, &mce_need_notify);
 }
 
+static void drain_mcelog_buffer(void)
+{
+	unsigned int next, i, prev = 0;
+
+	next = rcu_dereference_check_mce(mcelog.next);
+
+	do {
+		struct mce *m;
+
+		/* drain what was logged during boot */
+		for (i = prev; i < next; i++) {
+			unsigned long start = jiffies;
+			unsigned retries = 1;
+
+			m = &mcelog.entry[i];
+
+			while (!m->finished) {
+				if (time_after_eq(jiffies, start + 2*retries))
+					retries++;
+
+				cpu_relax();
+
+				if (!m->finished && retries >= 4) {
+					pr_err("MCE: skipping error being logged currently!\n");
+					break;
+				}
+			}
+			smp_rmb();
+			atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
+		}
+
+		memset(mcelog.entry + prev, 0, (next - prev) * sizeof(*m));
+		prev = next;
+		next = cmpxchg(&mcelog.next, prev, 0);
+	} while (next != prev);
+}
+
+
 void mce_register_decode_chain(struct notifier_block *nb)
 {
 	atomic_notifier_chain_register(&x86_mce_decoder_chain, nb);
+	drain_mcelog_buffer();
 }
 EXPORT_SYMBOL_GPL(mce_register_decode_chain);
 
-- 
1.7.8.rc0

