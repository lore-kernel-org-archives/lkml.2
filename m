Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab1LUTJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:09:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab1LUTJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:09:31 -0500
Date: Wed, 21 Dec 2011 14:09:14 -0500
From: Jason Baron <jbaron@redhat.com>
To: a.p.zijlstra@chello.nl
Cc: rostedt@goodmis.org, mathieu.desnoyers@efficios.com, hpa@zytor.com,
        mingo@elte.hu, davem@davemloft.net, ddaney.cavm@gmail.com,
        pjt@google.com, rth@redhat.com, linux-kernel@vger.kernel.org
Message-Id: <b33f44d9560af35d3ec371ede7cb92f6011f5bf5.1324493360.git.jbaron@redhat.com>
In-Reply-To: <cover.1324493360.git.jbaron@redhat.com>
References: <cover.1324493360.git.jbaron@redhat.com>
Subject: [PATCH 3/4] tracepoints: update to use new jump label API.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update tracepoints.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/tracepoint.h |    4 ++--
 kernel/tracepoint.c        |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index df0a779..d167ec2 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -143,7 +143,7 @@ static inline void tracepoint_synchronize_unregister(void)
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
-		if (static_branch(&__tracepoint_##name.key))		\
+		if (static_branch_def_false(&__tracepoint_##name.key))	\
 			__DO_TRACE(&__tracepoint_##name,		\
 				TP_PROTO(data_proto),			\
 				TP_ARGS(data_args),			\
@@ -176,7 +176,7 @@ static inline void tracepoint_synchronize_unregister(void)
 	__attribute__((section("__tracepoints_strings"))) = #name;	 \
 	struct tracepoint __tracepoint_##name				 \
 	__attribute__((section("__tracepoints"))) =			 \
-		{ __tpstrtab_##name, JUMP_LABEL_INIT, reg, unreg, NULL };\
+		{ __tpstrtab_##name, JUMP_LABEL_INIT_FALSE, reg, unreg, NULL };\
 	static struct tracepoint * const __tracepoint_ptr_##name __used	 \
 	__attribute__((section("__tracepoints_ptrs"))) =		 \
 		&__tracepoint_##name;
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index db110b8..bc7f0ea 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -256,9 +256,9 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 {
 	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
 
-	if (elem->regfunc && !jump_label_enabled(&elem->key) && active)
+	if (elem->regfunc && !jump_label_true(&elem->key) && active)
 		elem->regfunc();
-	else if (elem->unregfunc && jump_label_enabled(&elem->key) && !active)
+	else if (elem->unregfunc && jump_label_true(&elem->key) && !active)
 		elem->unregfunc();
 
 	/*
@@ -269,9 +269,9 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 	 * is used.
 	 */
 	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
-	if (active && !jump_label_enabled(&elem->key))
+	if (active && !jump_label_true(&elem->key))
 		jump_label_inc(&elem->key);
-	else if (!active && jump_label_enabled(&elem->key))
+	else if (!active && jump_label_true(&elem->key))
 		jump_label_dec(&elem->key);
 }
 
@@ -283,10 +283,10 @@ static void set_tracepoint(struct tracepoint_entry **entry,
  */
 static void disable_tracepoint(struct tracepoint *elem)
 {
-	if (elem->unregfunc && jump_label_enabled(&elem->key))
+	if (elem->unregfunc && jump_label_true(&elem->key))
 		elem->unregfunc();
 
-	if (jump_label_enabled(&elem->key))
+	if (jump_label_true(&elem->key))
 		jump_label_dec(&elem->key);
 	rcu_assign_pointer(elem->funcs, NULL);
 }
-- 
1.7.7.3

