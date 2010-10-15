Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab0JOUKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:10:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60512 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab0JOUKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:10:38 -0400
X-Authority-Analysis: v=1.1 cv=iGF3DqghDyT/uy4mV2LvOKNXCATMSjL+tOl9cucoGVk= c=1 sm=0 a=OLfFi2HvT14A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=HzHanZfdLyP9a52u5xMA:9 a=oz3_3wr0uYdbuxPCfjoA:7 a=3kXR_uAJh6mK7Wzw6E7Ydi4HxXYA:4 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=2f6wSYwRqYdYxr1E:21 a=mOiUcPVj5S2go8GS:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101015201036.445509790@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 15 Oct 2010 16:09:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 3/9] jump label: Fix module __init section race
References: <20101015200949.134732894@goodmis.org>
Content-Disposition: inline; filename=0003-jump-label-Fix-module-__init-section-race.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

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
-- 
1.7.1


