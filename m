Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab0JAVYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 17:24:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab0JAVYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 17:24:17 -0400
Date: Fri, 1 Oct 2010 17:23:41 -0400
From: Jason Baron <jbaron@redhat.com>
To: rostedt@goodmis.org, mingo@elte.hu
Cc: mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, ddaney@caviumnetworks.com,
        linux-kernel@vger.kernel.org
Message-Id: <c6f037b7598777668025ceedd9294212fd95fa34.1285965957.git.jbaron@redhat.com>
In-Reply-To: <cover.1285965957.git.jbaron@redhat.com>
References: <cover.1285965957.git.jbaron@redhat.com>
Subject: [PATCH 1/5] jump label: fix module __init section race
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jump label uses is_module_text_address() to ensure that the module
__init sections are valid before updating them. However, between the
check for a valid module __init section and the subsequent jump
label update, the module's __init section could be freed out from under
us.

We fix this potential race by adding a notifier callback to the
MODULE_STATE_LIVE state. This notifier is called *after* the __init
section has been run but before it is going to be freed. In the
callback, the jump label code zeros the key value for any __init jump
code within the module, and we add a check for a non-zero key value when
we update jump labels. In this way we require no additional data
structures.

Thanks to Mathieu Desnoyers for pointing out this race condition.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/jump_label.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 7be868b..e2fad92 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -168,7 +168,8 @@ void jump_label_update(unsigned long key, enum jump_label_type type)
 			count = e_module->nr_entries;
 			iter = e_module->table;
 			while (count--) {
-				if (kernel_text_address(iter->code))
+				if (iter->key &&
+						kernel_text_address(iter->code))
 					arch_jump_label_transform(iter, type);
 				iter++;
 			}
@@ -366,6 +367,39 @@ static void remove_jump_label_module(struct module *mod)
 	}
 }
 
+static void remove_module_init(struct module *mod)
+{
+	struct hlist_head *head;
+	struct hlist_node *node, *node_next, *module_node, *module_node_next;
+	struct jump_label_entry *e;
+	struct jump_label_module_entry *e_module;
+	struct jump_entry *iter;
+	int i, count;
+
+	/* if the module doesn't have jump label entries, just return */
+	if (!mod->num_jump_entries)
+		return;
+
+	for (i = 0; i < JUMP_LABEL_TABLE_SIZE; i++) {
+		head = &jump_label_table[i];
+		hlist_for_each_entry_safe(e, node, node_next, head, hlist) {
+			hlist_for_each_entry_safe(e_module, module_node,
+						  module_node_next,
+						  &(e->modules), hlist) {
+				if (e_module->mod != mod)
+					continue;
+				count = e_module->nr_entries;
+				iter = e_module->table;
+				while (count--) {
+					if (within_module_init(iter->code, mod))
+						iter->key = 0;
+					iter++;
+				}
+			}
+		}
+	}
+}
+
 static int
 jump_label_module_notify(struct notifier_block *self, unsigned long val,
 			 void *data)
@@ -386,6 +420,11 @@ jump_label_module_notify(struct notifier_block *self, unsigned long val,
 		remove_jump_label_module(mod);
 		mutex_unlock(&jump_label_mutex);
 		break;
+	case MODULE_STATE_LIVE:
+		mutex_lock(&jump_label_mutex);
+		remove_module_init(mod);
+		mutex_unlock(&jump_label_mutex);
+		break;
 	}
 	return ret;
 }
-- 
1.7.1

