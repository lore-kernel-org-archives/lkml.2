Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305Ab1JDTSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:18:44 -0400
Received: from claw.goop.org ([74.207.240.146]:56758 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908Ab1JDTSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:18:21 -0400
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
Subject: [PATCH RFC V3 8/8] x86/jump_label: add arch_jump_label_transform_static()
Date: Tue,  4 Oct 2011 12:18:09 -0700
Message-Id: <a41a06725b61aa91dcd5606e18a159d3b44cf6ba.1317755691.git.jeremy.fitzhardinge@citrix.com>
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
Cc: Jason Baron <jbaron@redhat.com>
---
 arch/x86/kernel/jump_label.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 2ad0298..ea9d5f2f 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -24,8 +24,9 @@ union jump_code_union {
 	} __attribute__((packed));
 };
 
-void arch_jump_label_transform(struct jump_entry *entry,
-			       enum jump_label_type type)
+static void __jump_label_transform(struct jump_entry *entry,
+				   enum jump_label_type type,
+				   void *(*poker)(void *, const void *, size_t))
 {
 	union jump_code_union code;
 
@@ -35,11 +36,24 @@ void arch_jump_label_transform(struct jump_entry *entry,
 				(entry->code + JUMP_LABEL_NOP_SIZE);
 	} else
 		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
+
+	(*poker)((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
+}
+
+void arch_jump_label_transform(struct jump_entry *entry,
+			       enum jump_label_type type)
+{
 	get_online_cpus();
 	mutex_lock(&text_mutex);
-	text_poke_smp((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
+	__jump_label_transform(entry, type, text_poke_smp);
 	mutex_unlock(&text_mutex);
 	put_online_cpus();
 }
 
+void arch_jump_label_transform_static(struct jump_entry *entry,
+				      enum jump_label_type type)
+{
+	__jump_label_transform(entry, type, text_poke_early);
+}
+
 #endif
-- 
1.7.6.4

