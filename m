Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab1I2X1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:27:35 -0400
Received: from claw.goop.org ([74.207.240.146]:43218 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207Ab1I2X0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:26:55 -0400
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
Subject: [PATCH RFC 4/8] sparc/jump_label: add arch_jump_label_transform_early()
Date: Thu, 29 Sep 2011 16:26:34 -0700
Message-Id: <6b0e55538e91fd7663430a291a39c6ed048b2548.1317338254.git.jeremy.fitzhardinge@citrix.com>
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

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: David S. Miller <davem@davemloft.net>
---
 arch/sparc/kernel/jump_label.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/sparc/kernel/jump_label.c b/arch/sparc/kernel/jump_label.c
index ea2dafc..d3dad25 100644
--- a/arch/sparc/kernel/jump_label.c
+++ b/arch/sparc/kernel/jump_label.c
@@ -8,8 +8,8 @@
 
 #ifdef HAVE_JUMP_LABEL
 
-void arch_jump_label_transform(struct jump_entry *entry,
-			       enum jump_label_type type)
+static void __jump_label_transform(struct jump_entry *entry,
+				   enum jump_label_type type)
 {
 	u32 val;
 	u32 *insn = (u32 *) (unsigned long) entry->code;
@@ -28,20 +28,26 @@ void arch_jump_label_transform(struct jump_entry *entry,
 		val = 0x01000000;
 	}
 
-	get_online_cpus();
-	mutex_lock(&text_mutex);
 	*insn = val;
 	flushi(insn);
+}
+
+void arch_jump_label_transform(struct jump_entry *entry,
+			       enum jump_label_type type)
+{
+	get_online_cpus();
+	mutex_lock(&text_mutex);
+
+	__jump_label_transform(entry, type);
+
 	mutex_unlock(&text_mutex);
 	put_online_cpus();
 }
 
-void arch_jump_label_text_poke_early(jump_label_t addr)
+void __init arch_jump_label_transform_early(struct jump_entry *entry,
+					    enum jump_label_type type)
 {
-	u32 *insn_p = (u32 *) (unsigned long) addr;
-
-	*insn_p = 0x01000000;
-	flushi(insn_p);
+	__jump_label_transform(entry, type);
 }
 
 #endif
-- 
1.7.6.2

