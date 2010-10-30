Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab0J3KkO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 06:40:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:48366 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab0J3KkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 06:40:12 -0400
Date: Sat, 30 Oct 2010 10:39:49 GMT
From: tip-bot for Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        masami.hiramatsu.pt@hitachi.com, mathieu.desnoyers@efficios.com,
        rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de
In-Reply-To: <c6f037b7598777668025ceedd9294212fd95fa34.1285965957.git.jbaron@redhat.com>
References: <c6f037b7598777668025ceedd9294212fd95fa34.1285965957.git.jbaron@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] jump label: Fix module __init section race
Message-ID: <tip-b842f8faf6c7dc2005c6a70631c1a91bac02f180@git.kernel.org>
Git-Commit-ID: b842f8faf6c7dc2005c6a70631c1a91bac02f180
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 30 Oct 2010 10:39:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b842f8faf6c7dc2005c6a70631c1a91bac02f180
Gitweb:     http://git.kernel.org/tip/b842f8faf6c7dc2005c6a70631c1a91bac02f180
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Fri, 1 Oct 2010 17:23:41 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 28 Oct 2010 09:17:02 -0400

jump label: Fix module __init section race

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

Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
LKML-Reference: <c6f037b7598777668025ceedd9294212fd95fa34.1285965957.git.jbaron@redhat.com>

[ Renamed remove_module_init() to remove_jump_label_module_init()
  as suggested by Masami Hiramatsu. ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/jump_label.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 7be868b..be9e105 100644
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
 
+static void remove_jump_label_module_init(struct module *mod)
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
+		remove_jump_label_module_init(mod);
+		mutex_unlock(&jump_label_mutex);
+		break;
 	}
 	return ret;
 }
