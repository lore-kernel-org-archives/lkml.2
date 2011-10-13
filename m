Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab1JMAJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:09:03 -0400
Received: from claw.goop.org ([74.207.240.146]:47109 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab1JMAI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:08:56 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH RFC V4 06/10] jump_label: add arch_jump_label_transform_static() to optimise non-live code updates
Date: Wed, 12 Oct 2011 17:08:37 -0700
Message-Id: <16f652166605c973e9817177b6ba6a081e3e5b3f.1318464413.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1318464413.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1318464413.git.jeremy.fitzhardinge@citrix.com>
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
Acked-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/jump_label.h |    2 ++
 kernel/jump_label.c        |   18 +++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

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
index 059202d5..ff2028f 100644
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
@@ -135,8 +147,8 @@ static __init int jump_label_init(void)
 		struct jump_label_key *iterk;
 
 		iterk = (struct jump_label_key *)(unsigned long)iter->key;
-		arch_jump_label_transform(iter, jump_label_enabled(iterk) ?
-					  JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE);
+		arch_jump_label_transform_static(iter, jump_label_enabled(iterk) ?
+						 JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE);
 		if (iterk == key)
 			continue;
 
@@ -208,7 +220,7 @@ void jump_label_apply_nops(struct module *mod)
 		return;
 
 	for (iter = iter_start; iter < iter_stop; iter++)
-		arch_jump_label_transform(iter, JUMP_LABEL_DISABLE);
+		arch_jump_label_transform_static(iter, JUMP_LABEL_DISABLE);
 }
 
 static int jump_label_add_module(struct module *mod)
-- 
1.7.6.4

