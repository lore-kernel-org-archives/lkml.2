Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab1I2X1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:27:51 -0400
Received: from claw.goop.org ([74.207.240.146]:43211 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200Ab1I2X0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:26:54 -0400
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
Subject: [PATCH RFC 2/8] jump_label: if a key has already been initialized, don't nop it out
Date: Thu, 29 Sep 2011 16:26:32 -0700
Message-Id: <9305c40efff18a742f1446fa8013af3ed72b01ce.1317338254.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

If a key has been enabled before jump_label_init() is called, don't
nop it out.

This replaces arch_jump_label_text_poke_early() (which can only nop
out a site) with arch_jump_label_transform_early(), which is functionally
equivalent to arch_jump_label_transform().

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/linux/jump_label.h |    3 ++-
 kernel/jump_label.c        |   17 +++++++++++------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 1213e9d..c8fb1b3 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -45,7 +45,8 @@ extern void jump_label_lock(void);
 extern void jump_label_unlock(void);
 extern void arch_jump_label_transform(struct jump_entry *entry,
 				 enum jump_label_type type);
-extern void arch_jump_label_text_poke_early(jump_label_t addr);
+extern void arch_jump_label_transform_early(struct jump_entry *entry,
+				 enum jump_label_type type);
 extern int jump_label_text_reserved(void *start, void *end);
 extern void jump_label_inc(struct jump_label_key *key);
 extern void jump_label_dec(struct jump_label_key *key);
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index a8ce450..54e8e2d 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -124,8 +124,10 @@ static void __jump_label_update(struct jump_label_key *key,
 /*
  * Not all archs need this.
  */
-void __weak arch_jump_label_text_poke_early(jump_label_t addr)
+void __weak arch_jump_label_transform_early(struct jump_entry *entry,
+					    enum jump_label_type type)
 {
+	arch_jump_label_transform(entry, type);	
 }
 
 static __init int jump_label_init(void)
@@ -139,12 +141,15 @@ static __init int jump_label_init(void)
 	jump_label_sort_entries(iter_start, iter_stop);
 
 	for (iter = iter_start; iter < iter_stop; iter++) {
-		arch_jump_label_text_poke_early(iter->code);
-		if (iter->key == (jump_label_t)(unsigned long)key)
+		struct jump_label_key *iterk;
+
+		iterk = (struct jump_label_key *)(unsigned long)iter->key;
+		arch_jump_label_transform_early(iter, jump_label_enabled(iterk) ?
+						JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE);
+		if (iterk == key)
 			continue;
 
-		key = (struct jump_label_key *)(unsigned long)iter->key;
-		atomic_set(&key->enabled, 0);
+		key = iterk;
 		key->entries = iter;
 #ifdef CONFIG_MODULES
 		key->next = NULL;
@@ -212,7 +217,7 @@ void jump_label_apply_nops(struct module *mod)
 		return;
 
 	for (iter = iter_start; iter < iter_stop; iter++)
-		arch_jump_label_text_poke_early(iter->code);
+		arch_jump_label_transform(iter, JUMP_LABEL_DISABLE);
 }
 
 static int jump_label_add_module(struct module *mod)
-- 
1.7.6.2

