Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab2LMWC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:02:59 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26643 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab2LMWCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:02:49 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v6 05/27] x86, 64bit: clear ident mapping when kernel is above 512G
Date: Thu, 13 Dec 2012 14:01:59 -0800
Message-Id: <1355436141-8668-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After following patch:
	x86, 64bit: Set extra ident mapping for whole kernel range

We have extra ident mapping for kernel that is loaded above 1G.

So need to clear extra pgd entry when kernel is loaded above 512g.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/head64.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 037df57..3ef9ce6 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -29,7 +29,17 @@
 static void __init zap_identity_mappings(void)
 {
 	pgd_t *pgd = pgd_offset_k(0UL);
+	unsigned long pa_text = __pa_symbol(_text);
+	unsigned long pa_end = __pa_symbol(_end);
+
 	pgd_clear(pgd);
+
+	/* When kernel is loaded above 512G */
+	if (pa_text >= PGDIR_SIZE)
+		pgd_clear(pgd + pgd_index(pa_text));
+	if (pa_end - 1 >= PGDIR_SIZE)
+		pgd_clear(pgd + pgd_index(pa_end - 1));
+
 	__flush_tlb_all();
 }
 
-- 
1.7.10.4

