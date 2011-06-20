Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab1FTWPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:15:40 -0400
Received: from claw.goop.org ([74.207.240.146]:53660 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755806Ab1FTWP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:15:28 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Xen Devel <Xen-devel@lists.xensource.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 14/15] xen/multicall: special-case singleton hypercalls
Date: Mon, 20 Jun 2011 15:15:10 -0700
Message-Id: <b50d7d433320f1b428697a79afbc98a2d114106d.1308607697.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Singleton calls seem to end up being pretty common, so just
directly call the hypercall rather than going via multicall.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/multicalls.c |   27 ++++++++++++++++++++++-----
 1 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/multicalls.c b/arch/x86/xen/multicalls.c
index b9b9811..eb022fd 100644
--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
@@ -55,6 +55,7 @@ DEFINE_PER_CPU(unsigned long, xen_mc_irq_flags);
 void xen_mc_flush(void)
 {
 	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
+	struct multicall_entry *mc;
 	int ret = 0;
 	unsigned long flags;
 	int i;
@@ -67,7 +68,24 @@ void xen_mc_flush(void)
 
 	trace_xen_mc_flush(b->mcidx, b->argidx, b->cbidx);
 
-	if (b->mcidx) {
+	switch (b->mcidx) {
+	case 0:
+		/* no-op */
+		BUG_ON(b->argidx != 0);
+		break;
+
+	case 1:
+		/* Singleton multicall - bypass multicall machinery
+		   and just do the call directly. */
+		mc = &b->entries[0];
+
+		mc->result = privcmd_call(mc->op,
+					  mc->args[0], mc->args[1], mc->args[2], 
+					  mc->args[3], mc->args[4]);
+		ret = mc->result < 0;
+		break;
+
+	default:
 #if MC_DEBUG
 		memcpy(b->debug, b->entries,
 		       b->mcidx * sizeof(struct multicall_entry));
@@ -94,11 +112,10 @@ void xen_mc_flush(void)
 			}
 		}
 #endif
+	}
 
-		b->mcidx = 0;
-		b->argidx = 0;
-	} else
-		BUG_ON(b->argidx != 0);
+	b->mcidx = 0;
+	b->argidx = 0;
 
 	for (i = 0; i < b->cbidx; i++) {
 		struct callback *cb = &b->callbacks[i];
-- 
1.7.5.4

