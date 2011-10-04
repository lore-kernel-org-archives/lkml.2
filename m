Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337Ab1JDTS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:18:59 -0400
Received: from claw.goop.org ([74.207.240.146]:56758 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933181Ab1JDTST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:18:19 -0400
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
Subject: [PATCH RFC V3 7/8] s390/jump-label: add arch_jump_label_transform_static()
Date: Tue,  4 Oct 2011 12:18:08 -0700
Message-Id: <e56a0ce188082e88e9706b85560dcaa1e411eb11.1317755691.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

This allows jump-label entries to be cheaply updated on code which is
not yet live.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jan Glauber <jang@linux.vnet.ibm.com>
---
 arch/s390/kernel/jump_label.c |   51 +++++++++++++++++++++++++----------------
 1 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/arch/s390/kernel/jump_label.c b/arch/s390/kernel/jump_label.c
index 44cc06b..b987ab2 100644
--- a/arch/s390/kernel/jump_label.c
+++ b/arch/s390/kernel/jump_label.c
@@ -18,26 +18,15 @@ struct insn {
 } __packed;
 
 struct insn_args {
-	unsigned long *target;
-	struct insn *insn;
-	ssize_t size;
+	struct jump_entry *entry;
+	enum jump_label_type type;
 };
 
-static int __arch_jump_label_transform(void *data)
+static void __jump_label_transform(struct jump_entry *entry,
+				   enum jump_label_type type)
 {
-	struct insn_args *args = data;
-	int rc;
-
-	rc = probe_kernel_write(args->target, args->insn, args->size);
-	WARN_ON_ONCE(rc < 0);
-	return 0;
-}
-
-void arch_jump_label_transform(struct jump_entry *entry,
-			       enum jump_label_type type)
-{
-	struct insn_args args;
 	struct insn insn;
+	int rc;
 
 	if (type == JUMP_LABEL_ENABLE) {
 		/* brcl 15,offset */
@@ -49,11 +38,33 @@ void arch_jump_label_transform(struct jump_entry *entry,
 		insn.offset = 0;
 	}
 
-	args.target = (void *) entry->code;
-	args.insn = &insn;
-	args.size = JUMP_LABEL_NOP_SIZE;
+	rc = probe_kernel_write((void *)entry->code, &insn, JUMP_LABEL_NOP_SIZE);
+	WARN_ON_ONCE(rc < 0);
+}
 
-	stop_machine(__arch_jump_label_transform, &args, NULL);
+static int __sm_arch_jump_label_transform(void *data)
+{
+	struct insn_args *args = data;
+
+	__jump_label_transform(args->entry, args->type);
+	return 0;
+}
+
+void arch_jump_label_transform(struct jump_entry *entry,
+			       enum jump_label_type type)
+{
+	struct insn_args args;
+
+	args.entry = entry;
+	args.type = type;
+
+	stop_machine(__sm_arch_jump_label_transform, &args, NULL);
+}
+
+void arch_jump_label_transform_static(struct jump_entry *entry,
+				      enum jump_label_type type)
+{
+	__jump_label_transform(entry, type);
 }
 
 #endif
-- 
1.7.6.4

