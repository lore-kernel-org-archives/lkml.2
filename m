Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169Ab1JDTSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:18:16 -0400
Received: from claw.goop.org ([74.207.240.146]:56728 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932539Ab1JDTSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:18:15 -0400
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
Subject: [PATCH RFC V3 3/8] jump_label: if a key has already been initialized, don't nop it out
Date: Tue,  4 Oct 2011 12:18:04 -0700
Message-Id: <6e43e15076e959d0f5ae7180bec2a197a05524e9.1317755691.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

If a key has been enabled before jump_label_init() is called, don't
nop it out.

This removes arch_jump_label_text_poke_early() (which can only nop
out a site) and uses arch_jump_label_transform() instead.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/linux/jump_label.h |    3 +--
 kernel/jump_label.c        |   20 ++++++++------------
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 1213e9d..12e804e 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -44,8 +44,7 @@ extern struct jump_entry __stop___jump_table[];
 extern void jump_label_lock(void);
 extern void jump_label_unlock(void);
 extern void arch_jump_label_transform(struct jump_entry *entry,
-				 enum jump_label_type type);
-extern void arch_jump_label_text_poke_early(jump_label_t addr);
+				      enum jump_label_type type);
 extern int jump_label_text_reserved(void *start, void *end);
 extern void jump_label_inc(struct jump_label_key *key);
 extern void jump_label_dec(struct jump_label_key *key);
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index a8ce450..059202d5 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -121,13 +121,6 @@ static void __jump_label_update(struct jump_label_key *key,
 	}
 }
 
-/*
- * Not all archs need this.
- */
-void __weak arch_jump_label_text_poke_early(jump_label_t addr)
-{
-}
-
 static __init int jump_label_init(void)
 {
 	struct jump_entry *iter_start = __start___jump_table;
@@ -139,12 +132,15 @@ static __init int jump_label_init(void)
 	jump_label_sort_entries(iter_start, iter_stop);
 
 	for (iter = iter_start; iter < iter_stop; iter++) {
-		arch_jump_label_text_poke_early(iter->code);
-		if (iter->key == (jump_label_t)(unsigned long)key)
+		struct jump_label_key *iterk;
+
+		iterk = (struct jump_label_key *)(unsigned long)iter->key;
+		arch_jump_label_transform(iter, jump_label_enabled(iterk) ?
+					  JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE);
+		if (iterk == key)
 			continue;
 
-		key = (struct jump_label_key *)(unsigned long)iter->key;
-		atomic_set(&key->enabled, 0);
+		key = iterk;
 		key->entries = iter;
 #ifdef CONFIG_MODULES
 		key->next = NULL;
@@ -212,7 +208,7 @@ void jump_label_apply_nops(struct module *mod)
 		return;
 
 	for (iter = iter_start; iter < iter_stop; iter++)
-		arch_jump_label_text_poke_early(iter->code);
+		arch_jump_label_transform(iter, JUMP_LABEL_DISABLE);
 }
 
 static int jump_label_add_module(struct module *mod)
-- 
1.7.6.4

