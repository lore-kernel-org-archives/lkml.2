Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab1I2X05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:26:57 -0400
Received: from claw.goop.org ([74.207.240.146]:43183 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171Ab1I2X0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:26:51 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH RFC 5/8] mips/jump_label: add arch_jump_label_transform_early()
Date: Thu, 29 Sep 2011 16:26:35 -0700
Message-Id: <9f95a611c3b317f412f77ae06753752951afd38b.1317338254.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

This allows jump-label entries to be modified early, in a pre-SMP
environment.

XXX TODO: make sure idling CPUs flush their icaches before continuing
in case this modifies something that's adjacent to their init-idle loops.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: David Daney <david.daney@cavium.com>
---
 arch/mips/kernel/jump_label.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/mips/kernel/jump_label.c b/arch/mips/kernel/jump_label.c
index 6001610..ddc9a65 100644
--- a/arch/mips/kernel/jump_label.c
+++ b/arch/mips/kernel/jump_label.c
@@ -20,8 +20,8 @@
 
 #define J_RANGE_MASK ((1ul << 28) - 1)
 
-void arch_jump_label_transform(struct jump_entry *e,
-			       enum jump_label_type type)
+static void __jump_label_transform(struct jump_entry *e,
+				   enum jump_label_type type)
 {
 	union mips_instruction insn;
 	union mips_instruction *insn_p =
@@ -40,15 +40,28 @@ void arch_jump_label_transform(struct jump_entry *e,
 		insn.word = 0; /* nop */
 	}
 
-	get_online_cpus();
-	mutex_lock(&text_mutex);
 	*insn_p = insn;
 
 	flush_icache_range((unsigned long)insn_p,
 			   (unsigned long)insn_p + sizeof(*insn_p));
+}
+
+void arch_jump_label_transform(struct jump_entry *e,
+			       enum jump_label_type type)
+{
+	get_online_cpus();
+	mutex_lock(&text_mutex);
+
+	__jump_label_tranform(e, type);
 
 	mutex_unlock(&text_mutex);
 	put_online_cpus();
 }
 
+void __init arch_jump_label_transform_early(struct jump_entry *e,
+					    enum jump_label_type type)
+{
+	__jump_label_tranform(e, type);
+}
+
 #endif /* HAVE_JUMP_LABEL */
-- 
1.7.6.2

