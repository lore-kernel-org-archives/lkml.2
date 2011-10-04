Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203Ab1JDTSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:18:22 -0400
Received: from claw.goop.org ([74.207.240.146]:56758 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932539Ab1JDTSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:18:20 -0400
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
Subject: [PATCH RFC V3 6/8] jump_label: add arch_jump_label_transform_static() to optimise non-live code updates
Date: Tue,  4 Oct 2011 12:18:07 -0700
Message-Id: <d2218e435a2f5649210edb41b9ba5ccdbd0b8fd6.1317755691.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

When updating a newly loaded module, the code is definitely not yet
executing on any processor, so it can be updated with no need for any
heavyweight synchronization.

This patch adds arch_jump_label_static() which is implemented as
arch_jump_label_transform() by default, but architectures can override
it if it avoids, say, a call to stop_machine().

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/linux/jump_label.h |    2 ++
 kernel/jump_label.c        |   14 +++++++++++++-
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 12e804e..56594e4 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -45,6 +45,8 @@ extern void jump_label_lock(void);
 extern void jump_label_unlock(void);
 extern void arch_jump_label_transform(struct jump_entry *entry,
 				      enum jump_label_type type);
+extern void arch_jump_label_transform_static(struct jump_entry *entry,
+					     enum jump_label_type type);
 extern int jump_label_text_reserved(void *start, void *end);
 extern void jump_label_inc(struct jump_label_key *key);
 extern void jump_label_dec(struct jump_label_key *key);
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 059202d5..f0a9bef 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -104,6 +104,18 @@ static int __jump_label_text_reserved(struct jump_entry *iter_start,
 	return 0;
 }
 
+/* 
+ * Update code which is definitely not currently executing.
+ * Architectures which need heavyweight synchronization to modify
+ * running code can override this to make the non-live update case
+ * cheaper.
+ */
+void __weak arch_jump_label_transform_static(struct jump_entry *entry,
+					    enum jump_label_type type)
+{
+	arch_jump_label_transform(entry, type);	
+}
+
 static void __jump_label_update(struct jump_label_key *key,
 				struct jump_entry *entry,
 				struct jump_entry *stop, int enable)
@@ -208,7 +220,7 @@ void jump_label_apply_nops(struct module *mod)
 		return;
 
 	for (iter = iter_start; iter < iter_stop; iter++)
-		arch_jump_label_transform(iter, JUMP_LABEL_DISABLE);
+		arch_jump_label_transform_static(iter, JUMP_LABEL_DISABLE);
 }
 
 static int jump_label_add_module(struct module *mod)
-- 
1.7.6.4

